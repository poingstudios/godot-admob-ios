//
//  Vungle.m
//  Vungle
//
//  Created by Gustavo Maciel on 22/06/23.
//

#import "VunglePoingExtrasBuilder.h"
#import <VungleAdapter/VungleAdNetworkExtras.h>

@implementation VunglePoingExtrasBuilder

NSString *const ALL_PLACEMENTS_KEY = @"ALL_PLACEMENTS_KEY";
NSString *const USER_ID_KEY = @"USER_ID_KEY";
NSString *const SOUND_ENABLED_KEY = @"SOUND_ENABLED_KEY";

- (id<GADAdNetworkExtras>)buildExtras:(NSDictionary<NSString *, NSString *> *)extras {
    NSString *placements = extras[ALL_PLACEMENTS_KEY];
    if (!placements) {
        return nil;
    }
    VungleAdNetworkExtras *vungleExtras = [[VungleAdNetworkExtras alloc] init];
    vungleExtras.allPlacements = [placements componentsSeparatedByString:@","];

    NSString *soundEnabled = extras[SOUND_ENABLED_KEY];
    if (soundEnabled) {
        vungleExtras.muted = ![soundEnabled boolValue];
    }

    NSString *userId = extras[USER_ID_KEY];
    if (userId) {
        vungleExtras.userId = userId;
    }

    return vungleExtras;
}

@end
