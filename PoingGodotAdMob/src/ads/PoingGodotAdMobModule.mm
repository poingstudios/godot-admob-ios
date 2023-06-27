//
//  PoingGodotAdMobModule.m
//  Ads
//
//  Created by Gustavo Maciel on 23/06/23.
//

#import <Foundation/Foundation.h>

#import "PoingGodotAdMobModule.h"
#include "PoingGodotAdMob.h"
#include "core/config/engine.h"
#include "core/version.h"

PoingGodotAdMob *poing_godot_admob;

void register_poing_godot_admob_types() {
    poing_godot_admob = memnew(PoingGodotAdMob);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMob", poing_godot_admob));
}

void unregister_poing_godot_admob_types() {
    if (poing_godot_admob) {
        memdelete(poing_godot_admob);
    }
}
