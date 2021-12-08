//
//  Rewarded.h
//  Rewarded
//
//  Created by Gustavo Maciel on 24/01/21.
//

#import "app_delegate.h"
#import "view_controller.h"
#include "os_iphone.h"
#include "object.h"
#include "../main/admob.h"

@class Rewarded;


@interface Rewarded: NSObject <GADFullScreenContentDelegate> {
    GADRewardedAd *rewarded;
    bool initialized;
    bool loaded;
    NSString *adUnitId;
    ViewController *rootController;
}

- (instancetype)init;
- (void)load_rewarded: (NSString*) ad_unit_id;
- (void)show_rewarded;
- (bool)get_is_rewarded_loaded;

@end
