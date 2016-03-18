//
//  CCDropShadowDecorationView.m
//  CCKit
//
//  Created by Glenn Marcus on 12/12/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import "CCDropShadowDecorationView.h"
#import "CCDefines.h"

@implementation CCDropShadowDecorationView

+ (NSString *)kind
{
    return @"CCDropShadowDecorationView";
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.75f;
        self.layer.shadowOffset = CC_IDIOM_IPHONE ? (CGSize){0,3} : (CGSize){0,7};
        self.layer.shadowRadius = CC_IDIOM_IPHONE ? 3 : 7;
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes;
{
    // Resize the shadow
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:layoutAttributes.bounds cornerRadius:self.layer.cornerRadius] CGPath];
}

@end
