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

#import "PoingGodotAdMobConsentForm.h"

@implementation PoingGodotAdMobConsentForm
- (instancetype)initWithUID:(int)UID umpConsentForm:(UMPConsentForm* )umpConsentForm{
    if ((self = [super init])) {
        self.UID = [NSNumber numberWithInt:UID];
        self.umpConsentForm = umpConsentForm;
    }
    return self;
}

- (void)show {
    if (self.umpConsentForm){
        UIViewController *rootViewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
        [self.umpConsentForm presentFromViewController:rootViewController completionHandler:^(NSError * _Nullable error) {
            NSLog(@"show ump consent form");
            Dictionary formErrorDictionary;
            if (error){
                NSLog(@"Error while Present UMP Consent Form");
                formErrorDictionary = [ObjectToGodotDictionary convertNSErrorToDictionaryAsFormError:error];
            }
            NSLog(@"sending signal on_consent_form_dismissed %i", [self.UID intValue]);

            PoingGodotAdMobUserMessagingPlatform::get_singleton()->emit_signal("on_consent_form_dismissed", [self.UID intValue], formErrorDictionary);
        }];
    }
}


@end
