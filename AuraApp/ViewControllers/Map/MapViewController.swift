//
//  MapViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 21/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate{
   
    @IBOutlet weak var mapView: MKMapView!
   
    var destinationLat = Double()
    var destinationLong = Double()
    var address : String = ""

    var friendIdString : String = ""
    var friendName : String = ""
    
    //MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callApiShowLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Helper Method
  
    func initialMethod() {
        
        mapView.delegate = self
    
        if destinationLat != 0.0 && destinationLong != 0.0 {

            let sourceLocation = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.title = address as String
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            self.mapView.showAnnotations([sourceAnnotation], animated: true )
            self.zoomToFitMapAnnotations()
       
        } else {
            
            _ = AlertController.alert("", message:  "Your friend " + self.friendName + " has not shared his/her location.")

        }
        
    }
    
    func zoomToFitMapAnnotations() {
        
        let span = MKCoordinateSpanMake(5, 5)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong), span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "map_icon1")
        }
        
        return annotationView
    }
    
    
    //MARK: - UIButton Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Web Api Method
    
    func callApiShowLocation() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId,
                         KFriendId : friendIdString]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KViewLocation, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                    let reponseDict = response.validatedValue("data", expected: [String:AnyObject]() as AnyObject) as? Dictionary<String,AnyObject>
  
                        if ((reponseDict?.count) != 0) {
                        
                        self.destinationLat = reponseDict?.validatedValue("lat", expected: Double() as AnyObject) as! Double
                        self.destinationLong = reponseDict?.validatedValue("lng", expected: Double() as AnyObject) as! Double
                        self.address = reponseDict?.validatedValue("address", expected: "" as AnyObject) as! String
                       
                        self.initialMethod()

                        }
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
}
