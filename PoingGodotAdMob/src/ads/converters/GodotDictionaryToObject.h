//
//  GodotDictionaryToObject.h
//  ads
//
//  Created by Gustavo Maciel on 18/07/23.
//

#ifndef GodotDictionaryToObject_h
#define GodotDictionaryToObject_h

#import <Foundation/Foundation.h>
#include "core/object/class_db.h"
@import GoogleMobileAds;

@class GADInitializationStatus;

@interface GodotDictionaryToObject : NSObject

+ (GADAdSize)convertDictionaryToGADAdSize:(Dictionary)adSizeDictionary;
+ (GADRequest *)convertDictionaryToGADRequest:(Dictionary)adRequestDictionary withKeywords:(PackedStringArray)keywords;
+ (NSDictionary *)convertDictionaryToNSDictionary:(Dictionary)extrasParameters;

@end

#endif /* GodotDictionaryToObject_h */
