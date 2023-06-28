//
//  AdColony.m
//  AdColony
//
//  Created by Gustavo Maciel on 23/06/23.
//
#import "PoingGodotAdMobAdColonyModule.h"
#include "PoingGodotAdMobAdColonyAppOptions.h"

#import <Foundation/Foundation.h>
#include "core/config/engine.h"
#include "core/version.h"

PoingGodotAdMobAdColonyAppOptions *poing_godot_admob_adcolony_app_options;

void register_poing_godot_admob_adcolony_types() {
    poing_godot_admob_adcolony_app_options = memnew(PoingGodotAdMobAdColonyAppOptions);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobAdColonyAppOptions", poing_godot_admob_adcolony_app_options));
}

void unregister_poing_godot_admob_adcolony_types() {
    if (poing_godot_admob_adcolony_app_options) {
        memdelete(poing_godot_admob_adcolony_app_options);
    }
}
