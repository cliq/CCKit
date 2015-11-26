//
//  CCDevice.m
//  CCKit
//
//  Created by Leonardo Lobato on 26/11/15.
//  Copyright (c) 2015 Cliq Consulting. All rights reserved.
//

#import "CCDevice.h"

@implementation CCDevice

+ (CCDeviceScreenSize)screenSize;
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat maxDimension = MAX(screenSize.width, screenSize.height);
    if (maxDimension>=736.0f) {
        // iPhone 6+
        return CCDeviceScreenSizeiPhone6Plus;
    } else if (maxDimension>=667.0f) {
        // iPhone 6
        return CCDeviceScreenSizeiPhone6;
    } else if (maxDimension>=568.0f) {
        // iPhone 5
        return CCDeviceScreenSizeiPhone5;
    } else if (maxDimension<=480.0f) {
        // iPhone 4
        return CCDeviceScreenSizeiPhone4;
    }
    return CCDeviceScreenSizeUnknownSmall;
}

@end
