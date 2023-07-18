//
//  ObjectToGodotDictionary.m
//  ads
//
//  Created by Gustavo Maciel on 16/07/23.
//

#import "ObjectToGodotDictionary.h"

@implementation ObjectToGodotDictionary

+ (Dictionary)convertGADAdapterStatusToDictionary:(GADAdapterStatus *)adapterStatus {
    Dictionary dictionary;

    dictionary["latency"] = adapterStatus.latency;
    dictionary["initializationState"] = (int)adapterStatus.state;
    dictionary["description"] = [adapterStatus.description UTF8String];

    return dictionary;
    
}

+ (Dictionary)convertGADInitializationStatusToDictionary:(GADInitializationStatus *)status {
    Dictionary dictionary;
    NSDictionary<NSString *, GADAdapterStatus *> *statusMap = status.adapterStatusesByClassName;
    for (NSString *adapterClass in statusMap) {
        Dictionary adapterStatusDictionary = [ObjectToGodotDictionary convertGADAdapterStatusToDictionary:status.adapterStatusesByClassName[adapterClass]];
        dictionary[[adapterClass UTF8String]] = adapterStatusDictionary;
    }

    return dictionary;
}
+ (Dictionary)convertGADAdSizeToDictionary:(GADAdSize)adSize {
    Dictionary dictionary;
    
    dictionary["width"] = adSize.size.width;
    dictionary["height"] = adSize.size.height;
     
    return dictionary;
}

@end
