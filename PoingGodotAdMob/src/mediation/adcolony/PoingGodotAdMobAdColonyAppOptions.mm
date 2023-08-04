// MIT License
//
// Copyright (c) 2023-present Poing Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

void PoingGodotAdMobAdColonyAppOptions::set_user_id(const String &user_id) {
    NSString *ns_user_id_string = [NSString stringWithCString:user_id.utf8().get_data() encoding: NSUTF8StringEncoding];

    [options setUserID:ns_user_id_string];
}

String PoingGodotAdMobAdColonyAppOptions::get_user_id() {
    return [[options userID] UTF8String];
}

void PoingGodotAdMobAdColonyAppOptions::set_test_mode(bool enabled) {
    [options setTestMode:enabled];
}

bool PoingGodotAdMobAdColonyAppOptions::get_test_mode() {
    return [options testMode];
}

void PoingGodotAdMobAdColonyAppOptions::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_privacy_framework_required"), &PoingGodotAdMobAdColonyAppOptions::set_privacy_framework_required);
    ClassDB::bind_method(D_METHOD("get_privacy_framework_required"), &PoingGodotAdMobAdColonyAppOptions::get_privacy_framework_required);
    
    ClassDB::bind_method(D_METHOD("set_privacy_consent_string"), &PoingGodotAdMobAdColonyAppOptions::set_privacy_consent_string);
    ClassDB::bind_method(D_METHOD("get_privacy_consent_string"), &PoingGodotAdMobAdColonyAppOptions::get_privacy_consent_string);
    
    ClassDB::bind_method(D_METHOD("set_user_id"), &PoingGodotAdMobAdColonyAppOptions::set_user_id);
    ClassDB::bind_method(D_METHOD("get_user_id"), &PoingGodotAdMobAdColonyAppOptions::get_user_id);
    
    ClassDB::bind_method(D_METHOD("set_test_mode"), &PoingGodotAdMobAdColonyAppOptions::set_test_mode);
    ClassDB::bind_method(D_METHOD("get_test_mode"), &PoingGodotAdMobAdColonyAppOptions::get_test_mode);
};
