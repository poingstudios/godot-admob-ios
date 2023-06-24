//
//  Core.h
//  Core
//
//  Created by Gustavo Maciel on 22/06/23.
//
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@protocol AdNetworkExtras <NSObject>
- (id<GADAdNetworkExtras>)buildExtras:(NSDictionary<NSString *, NSString *> *)extras;
@end

