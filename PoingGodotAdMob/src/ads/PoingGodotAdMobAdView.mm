//
//  PoingGodotAdMobAdView.m
//  ads
//
//  Created by Gustavo Maciel on 18/07/23.
//

#import "PoingGodotAdMobAdView.h"
#import "converters/GodotDictionaryToObject.h"

PoingGodotAdMobAdView *PoingGodotAdMobAdView::instance = NULL;
std::vector<Banner*> banners;

PoingGodotAdMobAdView::PoingGodotAdMobAdView() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobAdView::~PoingGodotAdMobAdView() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobAdView *PoingGodotAdMobAdView::get_singleton() {
    return instance;
};


int PoingGodotAdMobAdView::create(Dictionary adViewDictionary) {
    NSLog(@"create banner");

    Banner *banner = [[Banner alloc] initWithUID:(int)banners.size() adViewDictionary:adViewDictionary];
    banners.push_back(banner);

    return [banner.UID intValue];
}

void PoingGodotAdMobAdView::load_ad(int uid, Dictionary adRequestDictionary, PackedStringArray keywords) {
    NSLog(@"load_ad banner");
    GADRequest *adRequest = [GodotDictionaryToObject convertDictionaryToGADRequest:adRequestDictionary withKeywords:keywords];

    if (is_vector_banner_valid(uid)){
        Banner* banner = banners.at(uid);
        if (banner) {
            [banner loadAd];
        }
    }
}

void PoingGodotAdMobAdView::destroy(int uid) {
    if (is_vector_banner_valid(uid)){
        Banner* banner = banners.at(uid);
        if (banner) {
            [banner destroy];
            banners.at(uid) = nullptr;
        }
    }
}

void PoingGodotAdMobAdView::hide(int uid) {
    if (is_vector_banner_valid(uid)){
        Banner* banner = banners.at(uid);
        if (banner) {
            [banner hide];
        }
    }
}

void PoingGodotAdMobAdView::show(int uid) {
    NSLog(@"show banner");
    if (is_vector_banner_valid(uid)){
        Banner* banner = banners.at(uid);
        if (banner) {
            [banner show];
        }
    }
}

int PoingGodotAdMobAdView::get_width(int uid) {
    NSLog(@"get_width banner");

    if (is_vector_banner_valid(uid)){
        Banner* banner = banners.at(uid);
        if (banner) {
            return [banner getWidth];
        }
    }
    return -1;
}

int PoingGodotAdMobAdView::get_height(int uid) {
    NSLog(@"get_height banner");
    if (is_vector_banner_valid(uid)){
        Banner* banner = banners.at(uid);
        if (banner) {
            return [banner getHeight];
        }
    }
    return -1;
}

int PoingGodotAdMobAdView::get_width_in_pixels(int uid) {
    NSLog(@"get_width_in_pixels banner");
    if (is_vector_banner_valid(uid)){
        Banner* banner = banners.at(uid);
        if (banner) {
            return [banner getWidthInPixels];
        }
    }
    return -1;
}

int PoingGodotAdMobAdView::get_height_in_pixels(int uid) {
    NSLog(@"get_height_in_pixels banner");
    if (is_vector_banner_valid(uid)){
        Banner* banner = banners.at(uid);
        if (banner) {
            return [banner getHeightInPixels];
        }
    }
    return -1;
}

void PoingGodotAdMobAdView::_bind_methods() {
    ClassDB::bind_method(D_METHOD("create"),                &PoingGodotAdMobAdView::create);
    ClassDB::bind_method(D_METHOD("load_ad"),               &PoingGodotAdMobAdView::load_ad);
    ClassDB::bind_method(D_METHOD("destroy"),               &PoingGodotAdMobAdView::destroy);
    ClassDB::bind_method(D_METHOD("hide"),                  &PoingGodotAdMobAdView::hide);
    ClassDB::bind_method(D_METHOD("show"),                  &PoingGodotAdMobAdView::show);
    ClassDB::bind_method(D_METHOD("get_width"),             &PoingGodotAdMobAdView::get_width);
    ClassDB::bind_method(D_METHOD("get_height"),            &PoingGodotAdMobAdView::get_height);
    ClassDB::bind_method(D_METHOD("get_width_in_pixels"),   &PoingGodotAdMobAdView::get_width_in_pixels);
    ClassDB::bind_method(D_METHOD("get_height_in_pixels"),  &PoingGodotAdMobAdView::get_height_in_pixels);
    
    ADD_SIGNAL(MethodInfo("on_ad_clicked",          PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_ad_closed",           PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_ad_failed_to_load",   PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "loadAdErrorDictionary")));
    ADD_SIGNAL(MethodInfo("on_ad_impression",       PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_ad_loaded",           PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_ad_opened",           PropertyInfo(Variant::INT, "UID")));
};


bool PoingGodotAdMobAdView::is_vector_banner_valid(int uid){
    return banners.size() > 0 && uid >= 0 && uid < banners.size() && banners.at(uid) != nullptr;
}
