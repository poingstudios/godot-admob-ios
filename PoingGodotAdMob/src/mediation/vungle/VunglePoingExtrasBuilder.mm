// MIT License
//
// Copyright (c) 2023-present Poing Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
