// MIT License
//
// Copyright (c) 2023 Poing Studios
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

#import <Foundation/Foundation.h>
#include "poing_godot_admob.h"

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
        Dictionary dictionary = [JavaObjectToGodotDictionary convertGADInitializationStatusToDictionary:status];
        emit_signal("on_initialization_complete", dictionary);
    }];
}

void PoingGodotAdMob::_bind_methods() {
    ADD_SIGNAL(MethodInfo("on_initialization_complete", PropertyInfo(Variant::DICTIONARY, "initialization_status_dictionary")));

	ClassDB::bind_method(D_METHOD("initialize"), &PoingGodotAdMob::initialize);
};
