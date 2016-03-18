//
//  CCInsetLabel.m
//  CCKit
//
//  Created by Glenn Marcus on 12/12/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import "CCInsetLabel.h"

@implementation CCInsetLabel

- (void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
