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

+ (Dictionary)convertNSErrorToDictionaryAsAdError:(NSError *)nsError{
    Dictionary dictionary;
    
    dictionary["code"] = (int) nsError.code;
    dictionary["domain"] = [nsError.domain UTF8String];
    dictionary["message"] = [nsError.localizedDescription UTF8String];
    dictionary["cause"] = (nsError.userInfo[NSUnderlyingErrorKey]) ? [ObjectToGodotDictionary convertNSErrorToDictionaryAsAdError:nsError.userInfo[NSUnderlyingErrorKey]] : Dictionary();
    
    return dictionary;
}

+ (Dictionary)convertNSErrorToDictionaryAsLoadAdError:(NSError *)nsError{
    Dictionary dictionary;
    
    dictionary = [ObjectToGodotDictionary convertNSErrorToDictionaryAsAdError:nsError];
    GADResponseInfo *responseInfo = nsError.userInfo[GADErrorUserInfoKeyResponseInfo];
    dictionary["response_info"] = (responseInfo) ? [ObjectToGodotDictionary convertResponseInfoToDictionary:responseInfo] : Dictionary();

    return dictionary;
}

+ (Dictionary)convertResponseInfoToDictionary:(GADResponseInfo *)responseInfo{
    Dictionary dictionary;

    dictionary["loaded_adapter_response_info"] = [ObjectToGodotDictionary convertLoadedAdapterResponseInfoToDictionary:responseInfo.loadedAdNetworkResponseInfo];
    dictionary["adapter_responses"] = [ObjectToGodotDictionary convertAdapterResponsesToDictionary:responseInfo.adNetworkInfoArray];
    dictionary["response_extras"] = [ObjectToGodotDictionary convertBundleNSDictionaryToDictionary:responseInfo.extrasDictionary];
    dictionary["mediation_adapter_class_name"] = responseInfo.adNetworkClassName ? [responseInfo.adNetworkClassName UTF8String] : "";
    dictionary["response_id"] = responseInfo.responseIdentifier ? [responseInfo.responseIdentifier UTF8String] : "";

    return dictionary;
}

+ (Dictionary)convertLoadedAdapterResponseInfoToDictionary:(GADAdNetworkResponseInfo *)loadedAdapterResponseInfo{
    Dictionary dictionary;
    
    dictionary["adapter_class_name"] = loadedAdapterResponseInfo.adNetworkClassName.UTF8String;
    dictionary["ad_source_id"] = loadedAdapterResponseInfo.adSourceID.UTF8String;
    dictionary["ad_source_name"] = loadedAdapterResponseInfo.adSourceName.UTF8String;
    dictionary["ad_source_instance_id"] = loadedAdapterResponseInfo.adSourceInstanceID.UTF8String;
    dictionary["ad_source_instance_name"] = loadedAdapterResponseInfo.adSourceInstanceName.UTF8String;
    dictionary["ad_unit_mapping"] = [ObjectToGodotDictionary convertBundleNSDictionaryToDictionary:loadedAdapterResponseInfo.adUnitMapping];
    dictionary["ad_error"] = loadedAdapterResponseInfo.error ? [ObjectToGodotDictionary convertNSErrorToDictionaryAsAdError:loadedAdapterResponseInfo.error] : Dictionary();
    dictionary["latency_millis"] = loadedAdapterResponseInfo.latency;
    
    return dictionary;
}


+ (Dictionary)convertAdapterResponsesToDictionary:(NSArray<GADAdNetworkResponseInfo *> *)adapterResponses {
    Dictionary dictionary;

    for (int i = 0; i < adapterResponses.count; i++) {
        GADAdNetworkResponseInfo *responseInfo = [adapterResponses objectAtIndex:i];
        dictionary[i] = [ObjectToGodotDictionary convertBundleNSDictionaryToDictionary:responseInfo.adUnitMapping];
    }
    
    return dictionary;
}

+ (Dictionary)convertBundleNSDictionaryToDictionary:(NSDictionary *)bundleNSDictionary {
    Dictionary dictionary;

    for (NSString *key in [bundleNSDictionary allKeys]) {
        NSString *value = [bundleNSDictionary objectForKey:key];
        dictionary[key.UTF8String] = (value) ? [value UTF8String] : "";
    }

    return dictionary;
}


@end
