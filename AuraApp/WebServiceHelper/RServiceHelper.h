//
//  RServiceHelper.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 28/04/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GET = 0,
    POST = 1,
    DELETE = 2,
    PUT = 3
    
} MethodType;

@interface RServiceHelper : NSObject

+ (void)request:(NSDictionary *)parameterDict apiName:(NSString *)name method:(MethodType)methodType showHud:(BOOL)showHud completionBlock:(void (^)(id result, NSError *error))handler;

//@@@ mediaArray contains the all media file info in below format
/*[
 {
     "data" : "nsdata",
     "fileType" : "image",
     "keyAtServerSide" : "thumbnail",
 },
 {
     "data" : "nsdata",
     "fileType" : "video",
     "keyAtServerSide" : "video",
 }
 ]*/

//@@@ fileType will be treated as image as by default
//@@@ keyAtServerSide is the key for which your server is accepting the media
//@@@ No need to keyAtServerSide in parameterDict

+ (void)multiPart:(NSDictionary *)parameterDict apiName:(NSString *)name media:(NSArray *)mediaArray showHud:(BOOL)showHud isUsingFilePath:(BOOL)isUsingFilePath completionBlock:(void (^)(id result, NSError *error))handler;

//@@@ can be used from other classes for different functionality
// e.g. FB, G+ login etc;
// Note that the single instance is shwing and hiding the hud. Manage for your requremnets by creating new one of MBProgressHud
+ (void)progressHud:(BOOL)status;
+ (void)openFBSDKAppInviteDialog:(NSString *)promotionCode;

@end

