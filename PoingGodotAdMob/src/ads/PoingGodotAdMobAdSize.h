//
//  PoingGodotAdMobAdSize.h
//  ads
//
//  Created by Gustavo Maciel on 17/07/23.
//

#ifndef PoingGodotAdMobAdSize_h
#define PoingGodotAdMobAdSize_h

#include "core/object/class_db.h"
#import "view_controller.h"

@import GoogleMobileAds;

class PoingGodotAdMobAdSize : public Object {

    GDCLASS(PoingGodotAdMobAdSize, Object);

    static PoingGodotAdMobAdSize *instance;
    static void _bind_methods();

public:
    Dictionary getCurrentOrientationAnchoredAdaptiveBannerAdSize(int width);
    Dictionary getPortraitAnchoredAdaptiveBannerAdSize(int width);
    Dictionary getLandscapeAnchoredAdaptiveBannerAdSize(int width);
    Dictionary getSmartBannerAdSize();

    static PoingGodotAdMobAdSize *get_singleton();

    PoingGodotAdMobAdSize();
    ~PoingGodotAdMobAdSize();
private:
    CGFloat getAdWidth();
};


#endif /* PoingGodotAdMobAdSize_h */
