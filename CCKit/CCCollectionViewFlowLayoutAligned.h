//
//  CCCollectionViewFlowLayoutAligned.h
//  CCKit
//
//  Created by Glenn Marcus on 4/30/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIFlowLayoutAlignHorizontal) {
    UIFlowLayoutAlignHorizontalNatural,
    UIFlowLayoutAlignHorizontalLeft,
    UIFlowLayoutAlignHorizontalRight,
    UIFlowLayoutAlignHorizontalCenter
};

typedef NS_ENUM(NSUInteger, UIFlowLayoutAlignVertical) {
    UIFlowLayoutAlignVerticalNatural,
    UIFlowLayoutAlignVerticalTop,
    UIFlowLayoutAlignVerticalBottom,
    UIFlowLayoutAlignVerticalCenter
};

@interface CCCollectionViewFlowLayoutAligned : UICollectionViewFlowLayout
@property (nonatomic, assign) UIFlowLayoutAlignHorizontal hAlignment;  // Defaults to Natural
@property (nonatomic, assign) UIFlowLayoutAlignVertical vAlignment; // Defaults to Natural
@property (nonatomic, assign) BOOL resizeCellstoMaximumItemHeightPerRow;
@end

// Provide a similiarly named protocol for consistency
@protocol UICollectionViewDelegateFlowLayoutAligned <UICollectionViewDelegateFlowLayout>

@end
