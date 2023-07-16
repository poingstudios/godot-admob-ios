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
    ClassDB::bind_method(D_METHOD("test"), &PoingGodotAdMob::test);
};
