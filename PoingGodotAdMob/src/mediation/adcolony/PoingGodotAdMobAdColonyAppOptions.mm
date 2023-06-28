//
//  PoingGodotAdMobAdColonyAppOptions.m
//  adcolony
//
//  Created by Gustavo Maciel on 27/06/23.
//

#import "PoingGodotAdMobAdColonyAppOptions.h"
#import <Foundation/Foundation.h>

PoingGodotAdMobAdColonyAppOptions *PoingGodotAdMobAdColonyAppOptions::instance = NULL;
AdColonyAppOptions *PoingGodotAdMobAdColonyAppOptions::options = NULL;

PoingGodotAdMobAdColonyAppOptions::PoingGodotAdMobAdColonyAppOptions() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
    options = GADMediationAdapterAdColony.appOptions;
}

PoingGodotAdMobAdColonyAppOptions::~PoingGodotAdMobAdColonyAppOptions() {
    if (instance == this) {
        instance = NULL;
        options = NULL;
    }
}

PoingGodotAdMobAdColonyAppOptions *PoingGodotAdMobAdColonyAppOptions::get_singleton() {
    return instance;
};

static NSString *GetType(const String &type){
    if (type == "CCPA")
        return ADC_CCPA;
    if (type == "GDPR")
        return ADC_GDPR;
    return @"";
}

void PoingGodotAdMobAdColonyAppOptions::set_privacy_framework_required(const String &type, bool required) {
    [options setPrivacyFrameworkOfType:GetType(type) isRequired:required];
}

bool PoingGodotAdMobAdColonyAppOptions::get_privacy_framework_required(const String &type) {
    return [options getPrivacyFrameworkRequiredForType:GetType(type)];
}

void PoingGodotAdMobAdColonyAppOptions::set_privacy_consent_string(const String &type, const String &consent_string) {
    NSString *ns_consent_string = [NSString stringWithCString:consent_string.utf8().get_data() encoding: NSUTF8StringEncoding];

    [options setPrivacyConsentString:ns_consent_string forType:GetType(type)];
}

String PoingGodotAdMobAdColonyAppOptions::get_privacy_consent_string(const String &type) {
    return [[options getPrivacyConsentStringForType:GetType(type)] UTF8String];
}

void PoingGodotAdMobAdColonyAppOptions::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_privacy_framework_required"), &PoingGodotAdMobAdColonyAppOptions::set_privacy_framework_required);
    ClassDB::bind_method(D_METHOD("get_privacy_framework_required"), &PoingGodotAdMobAdColonyAppOptions::get_privacy_framework_required);
    
    ClassDB::bind_method(D_METHOD("set_privacy_consent_string"), &PoingGodotAdMobAdColonyAppOptions::set_privacy_consent_string);
    ClassDB::bind_method(D_METHOD("get_privacy_consent_string"), &PoingGodotAdMobAdColonyAppOptions::get_privacy_consent_string);
};
