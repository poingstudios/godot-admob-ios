//
//  Banner.h
//  ads
//
//  Created by Gustavo Maciel on 18/07/23.
//

#ifndef Banner_h
#define Banner_h
#import "../PoingGodotAdMobAdView.h"
#import "app_delegate.h"

@import GoogleMobileAds;

@interface Banner : NSObject <GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) NSNumber *UID;
@property (nonatomic, strong) NSNumber *adPosition;
@property (nonatomic) BOOL isHidden;
@property (nonatomic, strong) ViewController *rootController;

- (instancetype)initWithUID:(int)UID adViewDictionary:(Dictionary)adViewDictionary;
- (void)loadAd;
- (void)destroy;
- (void)hide;
- (void)show;
- (int)getWidth;
- (int)getHeight;
- (int)getWidthInPixels;
- (int)getHeightInPixels;

@end

#endif /* Banner_h */
