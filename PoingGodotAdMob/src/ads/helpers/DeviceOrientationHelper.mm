//
//  DeviceOrientationHelper.m
//  ads
//
//  Created by Gustavo Maciel on 19/07/23.
//

#import "DeviceOrientationHelper.h"

@implementation DeviceOrientationHelper

+ (UIInterfaceOrientation)getDeviceOrientation {
    UIInterfaceOrientation orientation;
    
    if (@available(iOS 13.0, *)) {
        UIWindowScene *currentScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
        orientation = currentScene.interfaceOrientation;
    } else {
        orientation = [UIApplication sharedApplication].statusBarOrientation;
    }
    
    return orientation;
}

@end
