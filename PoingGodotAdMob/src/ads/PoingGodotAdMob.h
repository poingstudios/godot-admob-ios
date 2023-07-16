//
//  PoingGodotAdMob.h
//  PoingGodotAdMob
//
//  Created by Gustavo Maciel on 22/06/23.
//
#ifndef POING_GODOT_ADMOB_H
#define POING_GODOT_ADMOB_H

#include "core/object/class_db.h"
#include "core/version.h"
@import GoogleMobileAds;


class PoingGodotAdMob : public Object {

    GDCLASS(PoingGodotAdMob, Object);

    static PoingGodotAdMob *instance;
    static void _bind_methods();

public:
    void initialize();
    void set_request_configuration(Dictionary requestConfigurationDictionary, PackedStringArray testDeviceIds);
    Dictionary get_initialization_status();
    
    void test(Dictionary dictionary);
    static PoingGodotAdMob *get_singleton();

    PoingGodotAdMob();
    ~PoingGodotAdMob();
};

#endif
