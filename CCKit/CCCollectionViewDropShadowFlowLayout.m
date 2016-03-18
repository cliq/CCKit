//
//  CCCollectionViewDropShadowFlowLayout.m
//  CCKit
//
//  Created by Glenn Marcus on 12/12/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import "CCCollectionViewDropShadowFlowLayout.h"

#import "CCDropShadowDecorationView.h"

@implementation CCCollectionViewDropShadowFlowLayout

- (void)prepareLayout;
{
    [self registerClass:[CCDropShadowDecorationView class] forDecorationViewOfKind:[CCDropShadowDecorationView kind]];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *baseLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *layoutAttributes = [baseLayoutAttributes mutableCopy];
    
    for (UICollectionViewLayoutAttributes *thisLayoutItem in baseLayoutAttributes) {
        if (thisLayoutItem.representedElementCategory == UICollectionElementCategoryCell) {
            // For each cell, create a drop shadow
            UICollectionViewLayoutAttributes *dropShadowAttributes = [self layoutAttributesForDecorationViewOfKind:[CCDropShadowDecorationView kind] atIndexPath:thisLayoutItem.indexPath];
            [layoutAttributes addObject:dropShadowAttributes];
        }
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *dropShadowAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];

    // Set the drop shadow frame to be the same as the cell frame
    dropShadowAttributes.frame = cellAttributes.frame;
    // Place the drop shadow behind the cell
    dropShadowAttributes.zIndex = -1;

    return dropShadowAttributes;
}

@end
