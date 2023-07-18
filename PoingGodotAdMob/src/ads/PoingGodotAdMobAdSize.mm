//
//  PoingGodotAdMobAdSize.m
//  ads
//
//  Created by Gustavo Maciel on 17/07/23.
//

#import <Foundation/Foundation.h>
#import "PoingGodotAdMobAdSize.h"
#import "converters/ObjectToGodotDictionary.h"

PoingGodotAdMobAdSize *PoingGodotAdMobAdSize::instance = NULL;

static const int FULL_WIDTH = -1;

PoingGodotAdMobAdSize::PoingGodotAdMobAdSize() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;

}

PoingGodotAdMobAdSize::~PoingGodotAdMobAdSize() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobAdSize *PoingGodotAdMobAdSize::get_singleton() {
    return instance;
};

Dictionary PoingGodotAdMobAdSize::getCurrentOrientationAnchoredAdaptiveBannerAdSize(int width) {
    NSLog(@"calling getCurrentOrientationAnchoredAdaptiveBannerAdSize");
    int currentWidth = (width == FULL_WIDTH) ? getAdWidth() : width;
    NSLog(@"currentWidth: %i", currentWidth);

    GADAdSize adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(currentWidth);
    Dictionary dictionary = [ObjectToGodotDictionary convertGADAdSizeToDictionary:adSize];

    return dictionary;
}

void PoingGodotAdMobAdSize::_bind_methods() {
    ClassDB::bind_method(D_METHOD("getCurrentOrientationAnchoredAdaptiveBannerAdSize"), &PoingGodotAdMobAdSize::getCurrentOrientationAnchoredAdaptiveBannerAdSize);
};


CGFloat PoingGodotAdMobAdSize::getAdWidth() {
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    CGRect frame = rootView.frame;

    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = rootView.safeAreaInsets;
        frame = UIEdgeInsetsInsetRect(frame, safeAreaInsets);
    }
    
    return frame.size.width;
}
