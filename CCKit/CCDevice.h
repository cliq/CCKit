//
//  CCDevice.h
//  CCKit
//
//  Created by Leonardo Lobato on 26/11/15.
//  Copyright (c) 2015 Cliq Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CCDeviceScreenSize) {
    CCDeviceScreenSizeUnknownSmall,
    CCDeviceScreenSizeiPhone4, // 3.5"
    CCDeviceScreenSizeiPhone5, // 4"
    CCDeviceScreenSizeiPhone6, // 4.7"
    CCDeviceScreenSizeiPhone6Plus, // 5.5"
};

@interface CCDevice : NSObject

+ (CCDeviceScreenSize)screenSize;

@end
