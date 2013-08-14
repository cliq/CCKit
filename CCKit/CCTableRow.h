//
//  CCTableRow.h
//  Brickstr
//
//  Created by Leonardo Lobato on 14/08/13.
//  Copyright (c) 2013 Brickstr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTableRow : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id<NSObject> target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, strong) id userInfo;

+ (CCTableRow *)rowWithTitle:(NSString *)title;
+ (CCTableRow *)rowWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
