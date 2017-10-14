//
//  NSDictionary+APIAddition.m
//  Template
//
//  Created by Raj Kumar Sharma on 04/03/17.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "NSDictionary+APIAddition.h"

@implementation NSDictionary (APIAddition)

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> NullChecker >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

- (id)objectForKeyNotNull:(id)key expectedObj:(id)obj {
    
    id object = [self objectForKey:key];
    
    // checking if in case object is nil

   	if (object == nil || object == [NSNull null])
        return obj;
    
    // checking if in case object if of string type and we are getting nil inside quotes
   	if ([object isKindOfClass:[NSString class]]){
        if ([object isEqualToString:@"<null>"]||[object isEqualToString:@"(null)"]) {
            return obj;
        }
    }
    
    if ([object isKindOfClass:[NSNumber class]]) {
        CFNumberType numberType = CFNumberGetType((CFNumberRef)object);
        if (numberType == kCFNumberFloatType || numberType == kCFNumberDoubleType || numberType == kCFNumberFloat32Type || numberType == kCFNumberFloat64Type) {
            return [NSString stringWithFormat:@"%f",[object floatValue]];
            
        } else {
            return [NSString stringWithFormat:@"%ld",(long)[object integerValue]];
            
        }
    }    

    if ([obj isKindOfClass:[NSArray class]] && ![object isKindOfClass:[NSArray class]]) {
        return obj;
    }
    
    return object;
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> JSONCategories >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

+ (id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData {
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result ;
}

- (NSData*)toNSData {
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    
    if (error != nil) return nil;
    return result;
}

- (NSString *)toJsonString {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

@end
