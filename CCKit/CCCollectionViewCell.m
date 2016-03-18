//
//  CCCollectionViewCell.m
//  CCKit
//
//  Created by Glenn Marcus on 10/17/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import "CCCollectionViewCell.h"

@implementation CCCollectionViewCell

+ (NSString*)reuseID;
{
    return NSStringFromClass(self);
}

// Autolayout bug
// http://stackoverflow.com/a/25820173
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

@end
