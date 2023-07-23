//
//  PoingGodotAdMobAdView.h
//  ads
//
//  Created by Gustavo Maciel on 18/07/23.
//

#ifndef PoingGodotAdMobAdView_h
#define PoingGodotAdMobAdView_h

#include "core/object/class_db.h"
#import <Foundation/Foundation.h>
#import "view_controller.h"
#import "adformats/Banner.h"
#include <vector>


@import GoogleMobileAds;

class PoingGodotAdMobAdView : public Object {

    GDCLASS(PoingGodotAdMobAdView, Object);

    static PoingGodotAdMobAdView *instance;
    static void _bind_methods();

public:
    int create(Dictionary adViewDictionary);
    void load_ad(int uid, Dictionary adRequestDictionary, PackedStringArray keywords);
    void destroy(int uid);
    void hide(int uid);
    void show(int uid);
    int get_width(int uid);
    int get_height(int uid);
    int get_width_in_pixels(int uid);
    int get_height_in_pixels(int uid);

    static PoingGodotAdMobAdView *get_singleton();

    PoingGodotAdMobAdView();
    ~PoingGodotAdMobAdView();
private:
    bool is_vector_banner_valid(int uid);
};


#endif /* PoingGodotAdMobAdView_h */
