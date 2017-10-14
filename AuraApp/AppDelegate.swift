//
//  AppDelegate.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/10/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//


/*
 
 FCM:
 email: applicationaura@gmail.com
 Password: aura1234
 
 */

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps
import UserNotifications
import Firebase
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,FIRMessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var navController = UINavigationController()
    let locationManager = CLLocationManager()
    var currentLatitude = CLLocationDegrees()
    var currentLongitude = CLLocationDegrees()
    var isReachable = false
    
    private var reachability:Reachability!;
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //>>>>>>>>>>>>>>>>>>>>> Set initial controller >>>>>>>>>>>>>>>>>>>>>//
        setInitialController()
        
        //>>>>>>>>>>>>>>>>>>>>> Location update >>>>>>>>>>>>>>>>>>>>>//
        startLocationUpdating()
        
        //>>>>>>>>>>>>>>>>>>>>>  Set rechability >>>>>>>>>>>>>>>>>>>>>>>//
        setupReachability()
        
        //>>>>>>>>>>>>>>>>>>>>> Google Place Key>>>>>>>>>>>>>>>>>>>>>>>//
        GMSPlacesClient.provideAPIKey("AIzaSyDJfhnjTYpAgd_jtj16VJna9R8HGlNsWBw")
        
        //>>>>>>>>>>>>>>>>>>>>> Google Map Key>>>>>>>>>>>>>>>>>>>>>>>//
        GMSServices.provideAPIKey("AIzaSyDJfhnjTYpAgd_jtj16VJna9R8HGlNsWBw")
        
        //>>>>>>>>>>>>>>>>>>>>> Configure Firebase>>>>>>>>>>>>>>>>>>>>>>>//
        FIRApp.configure()
        
        //>>>>>>>>>>>>>>>>>>>>> Push notification>>>>>>>>>>>>>>>>>>>>>>>//
        setPushNotificationMethod(application: application)
        
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification), name: NSNotification.Name.firInstanceIDTokenRefresh , object: nil)
        
        //self.printFonts()
        
        return true
    }
    
    func setInitialController() {
        
        if UserDefaults.standard.value(forKey: pUserId) != nil {
            
            let homeVC = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
            
            self.navController = UINavigationController(rootViewController: homeVC)
            self.navController.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = self.navController
            
            let vc = TabBarViewController()
            self.navController.pushViewController(vc, animated: false)
       
        } else {
            let homeVC = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
            
            self.navController = UINavigationController(rootViewController: homeVC)
            self.navController.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = self.navController
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
        }
        
    }
    
    func setPushNotificationMethod(application:UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            FIRMessaging.messaging().remoteMessageDelegate = self

        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    
    /*
     func printFonts() {
     let fontFamilyNames = UIFont.familyNames
     for familyName in fontFamilyNames {
     print("Font Family Name = [\(familyName)]")
     let names = UIFont.fontNames(forFamilyName: familyName )
     print("Font Names = [\(names)]")
     }
     }
     */
    
    func logOut() {
    
        UserDefaults.standard.removeObject(forKey: pUserId)
        self.setInitialController()
    }
    
    func startLocationUpdating() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func stopLocationUpdating() -> Void {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
       self.currentLatitude = (location?.coordinate.latitude)!
        currentLongitude = (location?.coordinate.longitude)!
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        
        print(error.localizedDescription)
    }
    
    //SetUp Reachability
    fileprivate func setupReachability() {
        
        // Allocate a reachability object
        
        let reach = Reachability.forInternetConnection()
        self.isReachable = (reach?.isReachable())!
        
        // Set the blocks
        
        reach?.reachableBlock = { (reachability) in
            
            DispatchQueue.main.async(execute: {
                self.isReachable = true
                self.checkForReachability(reachability: reachability!)
                
                print(UserDefaults.standard.integer(forKey: pAppNetworkMode))
                
            })
        }
        
        reach?.unreachableBlock = { (reachability) in
            
            DispatchQueue.main.async(execute: {
                self.isReachable = false
                self.checkForReachability(reachability: reachability!)
                
            })
        }
        
        reach?.startNotifier()
        checkForReachability(reachability: reach!)
    }
    
    func checkForReachability(reachability:Reachability) {
        
        if (reachability.currentReachabilityStatus() == NotReachable) {
            UserDefaults.standard.set(0, forKey: pAppNetworkMode)
            UserDefaults.standard.synchronize()
            
            logInfo("Not Reachable")
            
        } else if (reachability.currentReachabilityStatus() == ReachableViaWiFi) {
            UserDefaults.standard.set(1, forKey: pAppNetworkMode)
            UserDefaults.standard.synchronize()
            
            logInfo("Reachable via Wifi")
            
        } else {
            UserDefaults.standard.set(2, forKey: pAppNetworkMode)
            UserDefaults.standard.synchronize()
            
            logInfo("Reachable via Cellular")
        }
    }
    
    // MARK:- UINotification Method
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var deviceTokenString = ""
        for i in 0..<deviceToken.count {
            deviceTokenString = deviceTokenString + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type:FIRInstanceIDAPNSTokenType.unknown)
    }
    
    //MARK: - InvokingPushNotification when APN active and not active
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        logInfo("APNs registration failed: \(error)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        logInfo("noti refresh tocken")
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            logInfo("noti InstanceID token: \(refreshedToken)")
            defaults.set( refreshedToken, forKey: pToken)
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                logInfo("noti Unable to connect with FCM. \(String(describing: error))")
            } else {
                logInfo("noti Connected to FCM.")
            }
        }
    }
    
    func messaging(_ messaging: FIRMessaging, didRefreshRegistrationToken fcmToken: String) {
        logInfo("Firebase registration token: \(fcmToken)")
        
        let NewdeviceToken = fcmToken
        UserDefaults.standard.set(NewdeviceToken, forKey: pToken)
        connectToFcm()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
   
        let dict = userInfo as NSDictionary
        _ = AlertController.alert("", message: "\(dict)")

        var strType : String = ""
        strType = userInfo.validatedValue("notification_type", expected: "" as AnyObject) as! String
        
        handlePushNotification(dict: userInfo, strType: strType)

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
  
        let dict = userInfo as NSDictionary
        _ = AlertController.alert("", message: "\(dict)")
        
        var strType : String = ""
        strType = userInfo.validatedValue("notification_type", expected: "" as AnyObject) as! String

        handlePushNotification(dict: userInfo, strType: strType)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // Receive data message on iOS 10 devices.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        
         let dict = remoteMessage.appData as NSDictionary
         _ = AlertController.alert("", message: "\(dict)")
        
        var notificationDict = remoteMessage.appData

        if let strType = notificationDict["notification_type"] as? String {
            
            if (UIApplication.shared.applicationState == .active) {
    
                if (strType == "Chat" && navController.visibleViewController is ChatViewController) {
                    
                    let recieverIdString = notificationDict["sender_id"] as! String
                    
                        //refresh chat screen only if message recieved is from the same user we are chatting with
                        
                        if UserDefaults.standard.value(forKey: pChatId) as! String ==  recieverIdString {
                            
                            NotificationCenter.default.post(name: Notification.Name("onChatScreen"), object:nil)
                            
                    }
                    
                } else {
                    // refresh notification screen
                    if APPDELEGATE.navController.visibleViewController is NotificationsViewController {
                        
                        // Post notification
                        NotificationCenter.default.post(name: Notification.Name("refreshNotification"), object: nil)
                        
                    }
                }
            }
        }
        
    }
    
    // Receive displayed notifications for iOS 10 devices.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        let dict = userInfo as NSDictionary
        _ = AlertController.alert("", message: "\(dict)")

        if let strType = userInfo["notification_type"] as? String {
            
            //stop banner/alert when app is in fore ground
            if (strType == "Chat" ) {
                
                let recieverIdString = userInfo["sender_id"] as! String
                if UserDefaults.standard.value(forKey: pChatId) as? String ==  recieverIdString {
      
                } else {
                    completionHandler([.alert, .badge, .sound]);
                }
                
            } else {
                completionHandler([.alert, .badge, .sound]);
            }
            
            if (UIApplication.shared.applicationState == .active) {
                
                if (strType == "Chat") {
                    
                    let recieverIdString = userInfo["sender_id"] as! String
                    
                    if APPDELEGATE.navController.visibleViewController is ChatViewController {
                        
                        //refresh chat screen only if message recieved is from the same user we are chatting with
                        if UserDefaults.standard.value(forKey: pChatId) as! String ==  recieverIdString {
                            
                            NotificationCenter.default.post(name: Notification.Name("onChatScreen"), object:nil)
                            
                        }
                    }
                } else {
                        // navigate to notification screen
                        if APPDELEGATE.navController.visibleViewController is NotificationsViewController {
                            
                            // Post notification
                            NotificationCenter.default.post(name: Notification.Name("refreshNotification"), object: nil)
                            
                        }
                    }
            }
            
        } else {
            
            completionHandler([.alert, .badge, .sound]);

        }
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                         withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let userInfo = response.notification.request.content.userInfo

        let dict = userInfo as NSDictionary
        _ = AlertController.alert("", message: "\(dict)")

        var strType : String = ""
        strType = userInfo.validatedValue("notification_type", expected: "" as AnyObject) as! String

        handlePushNotification(dict: userInfo, strType: strType)
        
    }

    func handlePushNotification(dict : [AnyHashable : Any] , strType: String) {
        
            if (strType == "Chat") {
                
                let recieverIdString = dict["sender_id"] as! String

                if APPDELEGATE.navController.visibleViewController is ChatViewController {
                    
                    //refresh chat screen only if message recieved is from the same user we are chatting with
                    if UserDefaults.standard.value(forKey: pChatId) as! String ==  recieverIdString {
                        
                        NotificationCenter.default.post(name: Notification.Name("onChatScreen"), object:nil)
                        
                    } else {
                     
                        // present chat screen
                        
                        let chatVC = ChatViewController()
                        chatVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        chatVC.contactId = recieverIdString
                        chatVC.isFromPush = true
                        navController.present(chatVC, animated: false, completion: nil)
                    }
                    
                } else {

                    // present chat screen
                    
                    let chatVC = ChatViewController()
                    chatVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    chatVC.contactId = recieverIdString
                    chatVC.isFromPush = true
                    navController.present(chatVC, animated: false, completion: nil)
                    
                }
                
            } else {
                
                // navigate to notification screen
                if APPDELEGATE.navController.visibleViewController is NotificationsViewController {
                    
                    // Post notification
                    NotificationCenter.default.post(name: Notification.Name("refreshNotification"), object: nil)
                    
                } else {
                    // navigate to notification list screen
                    
                    for controller in APPDELEGATE.navController.viewControllers {
                        
                        if controller is TabBarViewController {
                            
                            APPDELEGATE.navController.popToViewController(controller, animated: false)
                            
                            // Post notification
                            NotificationCenter.default.post(name: Notification.Name("pushNotificationScreen"), object: nil)
                            
                        }
                    }
                }
            }
    }
}
