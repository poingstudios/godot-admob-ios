//
//  Rewarded.mm
//  Rewarded
//
//  Created by Gustavo Maciel on 24/01/21.
//

#import "Rewarded.h"

@implementation Rewarded

- (instancetype)init{
    if ((self = [super init])) {
        initialized = true;
        loaded = false;
        rootController = (ViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    }
    return self;
}


- (void) load_rewarded:(NSString*) ad_unit_id {
    NSLog(@"Calling load_rewarded");
    
    if (!initialized || loaded) {
        return;
    }
    else{
        NSLog(@"rewarded will load with the id");
        NSLog(@"%@", ad_unit_id);
    }
        
    GADRequest *request = [GADRequest request];
    [GADRewardedAd
         loadWithAdUnitID:ad_unit_id
                  request:request
        completionHandler:^(GADRewardedAd *ad, NSError *error) {
          if (error) {
              NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
              NSLog(@"error while creating reward");
              AdMob::get_singleton()->emit_signal("rewarded_ad_failed_to_load", (int) error.code);

            return;
          }
          else{
              NSLog(@"reward successfully loaded");
              AdMob::get_singleton()->emit_signal("rewarded_ad_loaded");
              self->loaded = true;
          }
        self->rewarded = ad;
        self->rewarded.fullScreenContentDelegate = self;
        }
     ];
    
}

- (void) show_rewarded {
    if (!initialized) {
        return;
    }
    
    if (rewarded) {
        [rewarded presentFromRootViewController:rootController userDidEarnRewardHandler:^{
            GADAdReward *rewardAd = self->rewarded.adReward;
            NSLog(@"rewardedAd:userDidEarnReward:");
            NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
                                       rewardAd.type, [rewardAd.amount doubleValue]];
            NSLog(@"%@", rewardMessage);

            AdMob::get_singleton()->emit_signal("user_earned_rewarded", [rewardAd.type UTF8String], rewardAd.amount.doubleValue);

          }];

        AdMob::get_singleton()->emit_signal("rewarded_ad_opened");

        OSIPhone::get_singleton()->on_focus_out();
    } else {
        NSLog(@"reward ad wasn't ready");
    }
}

- (bool) get_is_rewarded_loaded {
    return loaded;
}
/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"rewardedAd:didFailToPresentWithError");
    AdMob::get_singleton()->emit_signal("rewarded_ad_failed_to_show", (int) error.code);

}


/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad did dismiss full screen content.");
    loaded = false;
    
    AdMob::get_singleton()->emit_signal("rewarded_ad_closed");
    OSIPhone::get_singleton()->on_focus_in();
}



@end
