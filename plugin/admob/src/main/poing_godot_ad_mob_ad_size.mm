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
#include "poing_godot_ad_mob_ad_size.h"

PoingGodotAdMobAdSize *PoingGodotAdMobAdSize::instance = NULL;

PoingGodotAdMobAdSize::PoingGodotAdMobAdSize() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
    // NSLog(@"initialize admob");
}

PoingGodotAdMobAdSize::~PoingGodotAdMobAdSize() {
    if (instance == this) {
        instance = NULL;
    }
    // NSLog(@"deinitialize admob");
}

PoingGodotAdMobAdSize *PoingGodotAdMobAdSize::get_singleton() {
    return instance;
};

void PoingGodotAdMobAdSize::initialize() {
    NSLog(@"initialize new admob");
}

void PoingGodotAdMobAdSize::_bind_methods() {
	ClassDB::bind_method(D_METHOD("initialize"), &PoingGodotAdMobAdSize::initialize);
};
