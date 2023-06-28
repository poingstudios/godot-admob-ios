//
//  PoingGodotAdMobAdColonyAppOptions.h
//  adcolony
//
//  Created by Gustavo Maciel on 27/06/23.
//

#ifndef PoingGodotAdMobAdColonyAppOptions_h
#define PoingGodotAdMobAdColonyAppOptions_h
#import <AdColonyAdapter/AdColonyAdapter.h>
#include "core/object/class_db.h"
#include "core/version.h"

class PoingGodotAdMobAdColonyAppOptions : public Object {

    GDCLASS(PoingGodotAdMobAdColonyAppOptions, Object);

    static PoingGodotAdMobAdColonyAppOptions *instance;
    static void _bind_methods();

public:
    void set_privacy_framework_required(const String &type, bool required);
    bool get_privacy_framework_required(const String &type);

    void set_privacy_consent_string(const String &type, const String &consent_string);
    String get_privacy_consent_string(const String &type);

    static PoingGodotAdMobAdColonyAppOptions *get_singleton();

    PoingGodotAdMobAdColonyAppOptions();
    ~PoingGodotAdMobAdColonyAppOptions();
private:
    static AdColonyAppOptions *options;
};


#endif /* PoingGodotAdMobAdColonyAppOptions_h */
