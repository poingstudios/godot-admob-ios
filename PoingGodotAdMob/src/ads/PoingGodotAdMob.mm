//
//  PoingGodotAdMob.m
//  PoingGodotAdMob
//
//  Created by Gustavo Maciel on 22/06/23.
//

#import "PoingGodotAdMob.h"
#import "../core/AdNetworkExtras.h"
#import "converters/ObjectToGodotDictionary.h"
#import <Foundation/Foundation.h>

PoingGodotAdMob *PoingGodotAdMob::instance = NULL;

PoingGodotAdMob::PoingGodotAdMob() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMob::~PoingGodotAdMob() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMob *PoingGodotAdMob::get_singleton() {
    return instance;
};

void PoingGodotAdMob::initialize() {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus *_Nonnull status)
    {
        Dictionary dictionary = [ObjectToGodotDictionary convertGADInitializationStatusToDictionary:status];
        emit_signal("on_initialization_complete", dictionary);
    }];
}
void PoingGodotAdMob::set_request_configuration(Dictionary requestConfigurationDictionary, PackedStringArray testDeviceIds) {
    String maxAdContentRating = requestConfigurationDictionary["max_ad_content_rating"];
    int tagForChildDirectedTreatment = requestConfigurationDictionary["tag_for_child_directed_treatment"];
    int tagForUnderAgeOfConsent = requestConfigurationDictionary["tag_for_under_age_of_consent"];
    
    GADRequestConfiguration *requestConfiguration = [GADMobileAds sharedInstance].requestConfiguration;

    NSLog(@"MaxAdContentRating: %@", [NSString stringWithUTF8String:maxAdContentRating.utf8().get_data()]);
    requestConfiguration.maxAdContentRating = [NSString stringWithUTF8String:maxAdContentRating.utf8().get_data()];
    if (tagForChildDirectedTreatment == 1) {
        NSLog(@"tagForChildDirectedTreatment: true");
        [requestConfiguration tagForChildDirectedTreatment:true];
    } else if (tagForChildDirectedTreatment == 0) {
        NSLog(@"tagForChildDirectedTreatment: false");
        [requestConfiguration tagForChildDirectedTreatment:false];
    }
    
    if (tagForUnderAgeOfConsent == 1){
        NSLog(@"tagForUnderAgeOfConsent: true");
        [requestConfiguration tagForUnderAgeOfConsent: true];
    } else if (tagForUnderAgeOfConsent == 0){
        NSLog(@"tagForUnderAgeOfConsent: false");
        [requestConfiguration tagForUnderAgeOfConsent:false];
    }
        
    NSMutableArray<NSString *> *testDeviceIdsArray = [NSMutableArray arrayWithCapacity:testDeviceIds.size()];
    for (String deviceId : testDeviceIds) {
        NSLog(@"testDeviceIdsArray: %@", [NSString stringWithUTF8String:deviceId.utf8().get_data()]);
        [testDeviceIdsArray addObject:[NSString stringWithUTF8String:deviceId.utf8().get_data()]];
    }
    NSLog(@"all ok 1");
    requestConfiguration.testDeviceIdentifiers = testDeviceIdsArray;
    NSLog(@"all ok 2");
}

Dictionary PoingGodotAdMob::get_initialization_status() {
    return [ObjectToGodotDictionary convertGADInitializationStatusToDictionary: [GADMobileAds sharedInstance].initializationStatus];
}

void PoingGodotAdMob::test(Dictionary dictionary) {
    NSLog(@"TRYING TO GET EXTRA CLASS");
    id<AdNetworkExtras> extra = [[NSClassFromString(@"AdColonyExtrasBuilder") alloc] init];
   
    Dictionary dic;
    NSLog(@"TRYING TO buildExtras EXTRA CLASS");
    [extra buildExtras:dic];
    
    BOOL has = dictionary.has("mediation_extras");
    NSString *boolString = has ? @"HAS YES" : @"HAS NO";

}


void PoingGodotAdMob::_bind_methods() {
    ADD_SIGNAL(MethodInfo("on_initialization_complete", PropertyInfo(Variant::DICTIONARY, "initialization_status_dictionary")));

    ClassDB::bind_method(D_METHOD("initialize"), &PoingGodotAdMob::initialize);
    ClassDB::bind_method(D_METHOD("set_request_configuration"), &PoingGodotAdMob::set_request_configuration);
    ClassDB::bind_method(D_METHOD("get_initialization_status"), &PoingGodotAdMob::get_initialization_status);
    ClassDB::bind_method(D_METHOD("test"), &PoingGodotAdMob::test);
};
