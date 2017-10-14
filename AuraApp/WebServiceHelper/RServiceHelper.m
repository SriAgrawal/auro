//
//  RServiceHelper.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 28/04/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "RServiceHelper.h"
#import "NSDictionary+APIAddition.h"
#import "MBProgressHUD.h"

@import MobileCoreServices;

//TODO:- Support for progress indicator for no hud, hud with disabel interface, hud with enable interface

//@@@@@@@@@@@@@@@@@@@@@ Service Helper Constants @@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
static double timeoutInterval = 45.0;

// Staging
static NSString *baseURL = @"http://ec2-52-74-218-145.ap-southeast-1.compute.amazonaws.com:9000/";


//static NSString *baseURL = @"http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/Aloki/website/api/";

// Production

//@@@@@@@@@@@@@@@@@@@@@ Request formation @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@interface RApiRequest : NSMutableURLRequest

- (void)performWithCompletionBlock:(void (^)(id result, NSError *error))block;
- (void)addBasicAuth;

@end

@implementation RApiRequest

- (void)performWithCompletionBlock:(void (^)(id result, NSError *error))block {
    
    //@@@@@@@@@@@@@@ Check for connection
//    if (![APPDELEGATE isReachable]) {
//        [RServiceHelper progressHud:NO];
//
//        NSDictionary *errorDetails = @{NSLocalizedDescriptionKey : @"Unable to connect network. Please check your internet connection."};
//        NSError *error = [NSError errorWithDomain:@"Connection Error!" code:1009 userInfo:errorDetails];
//        block(nil,error);
//        
//        return;
//    }
    
    //@@@@@@@@@@@@@@ Setup session
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:self completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [RServiceHelper progressHud:NO];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger responseCode = [httpResponse statusCode];
        
        //NSDictionary *responseHeader = [httpResponse allHeaderFields];
        
        //logInfo("\n\n Response Code >>>>>> \n%ld",responseCode);
        //logInfo("\n\n Response Header >>>>>> \n%@",responseHeader);
        
        id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
        //logInfo("\n\n result >>>>>> \n%@",result);

            if (error != nil) {
                //logInfo(@"\n\n error  >>>>>>  %@",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (block) {
                        block(nil, error);
                    }
                });
            } else {
                
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                //logInfo("\n\nResponse String>>>> \n%@",responseString);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (block) {
                        
                        if (result == nil) {
                            
#warning Update message on client release or before going live
                            //NSString *errorMessage = [NSString stringWithFormat:@"Seems invalid response in api: /%@ \n\n %@", httpResponse.URL.absoluteString, responseString];
                            NSString *errorMessage = @"Server is not responding.";

                            NSDictionary *errorDetails = @{NSLocalizedDescriptionKey : errorMessage};
                            NSError *error = [NSError errorWithDomain:@"Server Error!" code:9999 userInfo:errorDetails];

                            block(nil, error);
                        } else {
                            block(result, nil);
                        }
                    }
                });
            }
    }];
    
    [dataTask resume];
}

@end

//@@@@@@@@@@@@@@@@@@@@@ Service Helper @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@class RApiRequest;
@interface RServiceHelper()
@end

@implementation RServiceHelper

#pragma mark - Public methods

+ (void)request:(NSDictionary *)parameterDict apiName:(NSString *)name method:(MethodType)methodType showHud:(BOOL)showHud completionBlock:(void (^)(id result, NSError *error))handler {
    
    NSURL *requestURL = [self requestURL:parameterDict apiName:name method:methodType];
    
    RApiRequest *request = [RApiRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:[self methodName:methodType]];
    [request setTimeoutInterval:timeoutInterval];
    
    if (methodType == POST || methodType == PUT) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }

    [request setHTTPBody:[self body:parameterDict method:methodType]];
    
    
    if (showHud) {
        [self progressHud:YES];
    }
    
   // logInfo(@"\n\n Request URL  >>>>>>  %@",requestURL);
    //logInfo(@"\n\n Request Parameters  >>>>>>  %@",[parameterDict toJsonString]);
    //logInfo(@"\n\n Request Header  >>>>>>  %@",request.allHTTPHeaderFields);

    [request performWithCompletionBlock:^(id result, NSError *error) {
        handler(result, error);
    }];
}

+ (void)multiPart:(NSDictionary *)parameterDict apiName:(NSString *)name media:(NSArray *)mediaArray showHud:(BOOL)showHud isUsingFilePath:(BOOL)isUsingFilePath completionBlock:(void (^)(id result, NSError *error))handler  {
    
    NSMutableString *urlString = [NSMutableString stringWithString:baseURL];
    
    
    [urlString appendFormat:@"%@",name];
    
    RApiRequest *request = [RApiRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [RServiceHelper generateBoundaryString];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    if (isUsingFilePath) {
        //logInfo(@"\n\n mediaArray  >>>>>>  %@",mediaArray);
        
        [request setHTTPBody:[RServiceHelper createBodyWithBoundary:boundary parameters:parameterDict paths:mediaArray]];
    } else {
        [request setHTTPBody:[RServiceHelper createBodyWithBoundary:boundary parameters:parameterDict media:mediaArray]];
    }
    
    //logInfo(@"\n\n Request URL  >>>>>>  %@",urlString);
    //NSLog(@"\n\n Request Parameters  >>>>>>  %@",[parameterDict toJsonString]);
    //logInfo(@"\n\n Media array  >>>>>>  %@",mediaArray);
    //logInfo(@"\n\n Request Header  >>>>>>  %@",request.allHTTPHeaderFields);

    if (showHud) {
        [self progressHud:YES];
    }
    
    [request performWithCompletionBlock:^(id result, NSError *error) {
        handler(result, error);
    }];
}

+ (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

+ (NSData *)createBodyWithBoundary:(NSString *)boundary parameters:(NSDictionary *)parameters media:(NSArray *)mediaArray {

    NSMutableData *httpBody = [NSMutableData data];

    //@@@@@@ add params (all params are strings)

    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];

    //@@@@@@ add image data

    for (NSDictionary *dictionary in mediaArray) {

        NSString *fileType = [dictionary valueForKey:@"fileType"];

        NSString *filename  = [NSString stringWithFormat:@"%@_%@",[self currentTimeStampString],@"image.png"];
        NSData   *data      = [dictionary valueForKey:@"data"];
        NSString *mimetype  = [self mimeTypeForData:data];
        NSString *fieldName = [dictionary valueForKey:@"keyAtServerSide"];

        if ([fileType isEqualToString:@"video"]) {
            filename  = [NSString stringWithFormat:@"%@_%@",[self currentTimeStampString],@"video.mp4"];
            mimetype = @"video/mp4";
        } else if ([fileType isEqualToString:@"audio"]) {
            filename  = [NSString stringWithFormat:@"%@_%@",[self currentTimeStampString],@"audio.m4a"];
            mimetype = @"audio/m4a";
        }

        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];


    return httpBody;
}

+ (NSData *)createBodyWithBoundary:(NSString *)boundary parameters:(NSDictionary *)parameters paths:(NSArray *)paths {
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n",parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add file data
    
    for (NSDictionary *dictionary in paths) {
        
        NSString *path = [dictionary valueForKey:@"filePath"];
        
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        
       // NSLog(@"mimetype>>   %@",mimetype);
        
        if ([mimetype isEqualToString:@"audio/x-m4a"]) {
            mimetype = @"audio/m4a";
        }
        
       // NSLog(@"mimetype>>   %@",mimetype);

        
        NSString *fieldName = [dictionary valueForKey:@"keyAtServerSide"];

        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

+ (NSString *)mimeTypeForData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        case 0x25:
            return @"application/pdf";
            break;
        case 0xD0:
            return @"application/vnd";
            break;
        case 0x46:
            return @"text/plain";
            break;
        default:
            return @"application/octet-stream";
    }
    return nil;
}

+ (NSString *)mimeTypeForPath:(NSString *)path {
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

#pragma mark - Private methods

+ (NSString *)methodName:(MethodType)methodType {
    
    switch (methodType) {
        case GET: return @"GET";
        case POST: return @"POST";
        case DELETE: return @"DELETE";
        case PUT: return @"PUT";
    }
}

+ (NSData *)body:(NSDictionary *)parameterDict method:(MethodType)methodType {
    
    switch (methodType) {
        case GET: return [NSData data];
        case POST: return [parameterDict toNSData];
        case DELETE: return [NSData data];
        case PUT: return [parameterDict toNSData];
    }
}

+ (NSURL *)formattedURL:(NSDictionary *)parameterDict apiName:(NSString *)name {
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", baseURL, name];
    
    BOOL isFirst = YES;
    
    for (NSString *key in [parameterDict allKeys]) {
        
        id object = parameterDict[key];
        if ([object isKindOfClass:[NSArray class]]) {
            
            for (id eachObject in object) {
                
                [urlString appendString:[NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                isFirst = NO;
            }
        } else {
            [urlString appendString:[NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
        }
        
        isFirst = NO;
    }
    
    //NSString *encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];

    return [NSURL URLWithString:encodedString];
}

+ (NSURL *)requestURL:(NSDictionary *)parameterDict apiName:(NSString *)name method:(MethodType)methodType {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL, name];
    
    switch (methodType) {
            
        case GET: return [self formattedURL:parameterDict apiName:name];
            
        case POST:return [NSURL URLWithString:urlString];
            
        default: return [NSURL URLWithString:urlString];
    }
}

+ (NSString *)currentTimeStampString {
    NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",timeInSeconds];
}

+ (void)progressHud:(BOOL)status {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        MBProgressHUD *hud = [MBProgressHUD HUDForView:[APPDELEGATE window]];
//        
//        if (status) {
//            if (hud == nil) {
//                hud = [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] animated:YES];
//            }
//            [hud.bezelView.layer setCornerRadius:8.0];
//            //[hud.bezelView setColor:RGBCOLOR(0, 0, 0, 0.8)];
//
//            [hud.bezelView setColor:separatorLightGrayColor];
//
//            [hud setMargin:12];
//            //[hud.bezelView.activityIndicatorView setColor:[UIColor whiteColor]];
//            
//            
//        } else {
//            [hud hideAnimated:true afterDelay:0.1];
//        }
//    });
}

//@@@@@@@@@@@@@@@@@@@@@ Take a reference if you are uploading in background

/*- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)dataTask.response;
    NSInteger responseCode = [httpResponse statusCode];
    
    logInfo("\n\n Response Code >>>>>> \n%ld",responseCode);
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
    
    logInfo("\n\nResponse String>>>> \n%@",responseString);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"%@ failed: %@", task.originalRequest.URL, error);
    } else {
        NSLog(@"didCompleteWithError: %@", task);
    }
    
    //    NSMutableData *responseData = self.responsesData[@(task.taskIdentifier)];
    //
    //    if (responseData) {
    //        // my response is JSON; I don't know what yours is, though this handles both
    //
    //        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    //        if (response) {
    //            NSLog(@"response = %@", response);
    //        } else {
    //            NSLog(@"responseData = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    //        }
    //
    //        [self.responsesData removeObjectForKey:@(task.taskIdentifier)];
    //    } else {
    //        NSLog(@"responseData is nil");
    //    }
}*/

@end


//@@@@@@@@@@@@@@@@@@@@@ Standard response code @@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 
/* http://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
 
 if status == 400 { description = "Bad Request" }
 
 if status == 401 { description = "Unauthorized" }
 
 if status == 402 { description = "Payment Required" }
 
 if status == 403 { description = "Forbidden" }
 
 if status == 404 { description = "Not Found" }
 
 if status == 405 { description = "Method Not Allowed" }
 
 if status == 406 { description = "Not Acceptable" }
 
 if status == 407 { description = "Proxy Authentication Required" }
 
 if status == 408 { description = "Request Timeout" }
 
 if status == 409 { description = "Conflict" }
 
 if status == 410 { description = "Gone" }
 
 if status == 411 { description = "Length Required" }
 
 if status == 412 { description = "Precondition Failed" }
 
 if status == 413 { description = "Payload Too Large" }
 
 if status == 414 { description = "URI Too Long" }
 
 if status == 415 { description = "Unsupported Media Type" }
 
 if status == 416 { description = "Requested Range Not Satisfiable" }
 
 if status == 417 { description = "Expectation Failed" }
 
 if status == 422 { description = "Unprocessable Entity" }
 
 if status == 423 { description = "Locked" }
 
 if status == 424 { description = "Failed Dependency" }
 
 if status == 425 { description = "Unassigned" }
 
 if status == 426 { description = "Upgrade Required" }
 
 if status == 427 { description = "Unassigned" }
 
 if status == 428 { description = "Precondition Required" }
 
 if status == 429 { description = "Too Many Requests" }
 
 if status == 430 { description = "Unassigned" }
 
 if status == 431 { description = "Request Header Fields Too Large" }
 
 if status == 432 { description = "Unassigned" }
 
 if status == 500 { description = "Internal Server Error" }
 
 if status == 501 { description = "Not Implemented" }
 
 if status == 502 { description = "Bad Gateway" }
 
 if status == 503 { description = "Service Unavailable" }
 
 if status == 504 { description = "Gateway Timeout" }
 
 if status == 505 { description = "HTTP Version Not Supported" }
 
 if status == 506 { description = "Variant Also Negotiates" }
 
 if status == 507 { description = "Insufficient Storage" }
 
 if status == 508 { description = "Loop Detected" }
 
 if status == 509 { description = "Unassigned" }
 
 if status == 510 { description = "Not Extended" }
 
 if status == 511 { description = "Network Authentication Required" }
 
 */
