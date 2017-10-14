//
//  NSDictionary+APIAddition.h
//  Template
//
//  Created by Raj Kumar Sharma on 04/03/17.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (APIAddition)

- (id)objectForKeyNotNull:(id)key expectedObj:(id)obj;

+ (id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData;

- (NSData*)toNSData;
- (NSString *)toJsonString;

@end
