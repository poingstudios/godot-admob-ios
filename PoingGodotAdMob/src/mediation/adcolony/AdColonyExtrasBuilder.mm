//
//  AdColonyExtrasBuilder.m
//  adcolony
//
//  Created by Gustavo Maciel on 28/06/23.
//

#import "AdColonyExtrasBuilder.h"
#import <AdColonyAdapter/GADMAdapterAdColonyExtras.h>

@implementation AdColonyExtrasBuilder

NSString *const ShowPrePopupKey = @"show_pre_popup";
NSString *const ShowPostPopupKey = @"show_post_popup";

- (id<GADAdNetworkExtras>)buildExtras:(Dictionary) extras {
    NSLog(@"ON AD COLONY BUILD EXTRAS");
    GADMAdapterAdColonyExtras *adColonyExtras = [[GADMAdapterAdColonyExtras alloc] init];
    
    String StringShowPrePopupKey = extras[ShowPrePopupKey];
    NSString *showPrePopup = [NSString stringWithUTF8String:StringShowPrePopupKey.utf8().get_data()];
    if (showPrePopup) {
        adColonyExtras.showPrePopup = showPrePopup.boolValue;
    }

    String StringShowPostPopup = extras[ShowPostPopupKey];
    NSString *showPostPopup = [NSString stringWithUTF8String:StringShowPostPopup.utf8().get_data()];
    if (showPostPopup) {
        adColonyExtras.showPostPopup = showPostPopup.boolValue;
    }
    NSLog(@"RETURN ADCOLONY EXTRAS");

    return adColonyExtras;
}

@end
