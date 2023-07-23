//
//  PoingGodotAdMobModule.m
//  Ads
//
//  Created by Gustavo Maciel on 23/06/23.
//

#import <Foundation/Foundation.h>

#import "PoingGodotAdMobModule.h"
#include "PoingGodotAdMob.h"
#include "PoingGodotAdMobAdSize.h"
#include "PoingGodotAdMobAdView.h"

#include "core/config/engine.h"
#include "core/version.h"

PoingGodotAdMob *poing_godot_admob;
PoingGodotAdMobAdSize *poing_godot_admob_ad_size;
PoingGodotAdMobAdView *poing_godot_admob_ad_view;

void register_poing_godot_admob_ads_types() {
    poing_godot_admob = memnew(PoingGodotAdMob);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMob", poing_godot_admob));
    
    poing_godot_admob_ad_size = memnew(PoingGodotAdMobAdSize);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobAdSize", poing_godot_admob_ad_size));

    poing_godot_admob_ad_view = memnew(PoingGodotAdMobAdView);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobAdView", poing_godot_admob_ad_view));
}

void unregister_poing_godot_admob_ads_types() {
    if (poing_godot_admob) {
        memdelete(poing_godot_admob);
    }
    if (poing_godot_admob_ad_size) {
        memdelete(poing_godot_admob_ad_size);
    }
    if (poing_godot_admob_ad_view) {
        memdelete(poing_godot_admob_ad_view);
    }
}
