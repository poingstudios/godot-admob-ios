//
//  ObjectToGodotDictionary.h
//  ads
//
//  Created by Gustavo Maciel on 16/07/23.
//

#ifndef ObjectToGodotDictionary_h
#define ObjectToGodotDictionary_h

#import <Foundation/Foundation.h>
#include "core/object/class_db.h"
@import GoogleMobileAds;

@class GADInitializationStatus;

@interface ObjectToGodotDictionary : NSObject

+ (Dictionary)convertGADInitializationStatusToDictionary:(GADInitializationStatus *)status;
+ (Dictionary)convertGADAdapterStatusToDictionary:(GADAdapterStatus *)adapterStatus ;

@end

#endif /* ObjectToGodotDictionary_h */
