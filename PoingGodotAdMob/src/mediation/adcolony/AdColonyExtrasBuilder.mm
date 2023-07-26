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
