//
//  CCCollectionViewFlowLayoutAligned.m
//  CCKit
//
//  Created by Glenn Marcus on 4/30/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import "CCCollectionViewFlowLayoutAligned.h"


// Category for UICollectionViewLayoutAttributes to do alignment
@interface UICollectionViewLayoutAttributes (Aligned)
- (void)leftAlignFrameWithOffset:(CGFloat)offset;
- (void)rightAlignFrameOnWidth:(CGFloat)width offset:(CGFloat)offset;
@end

@implementation UICollectionViewLayoutAttributes (Aligned)
- (void)leftAlignFrameWithOffset:(CGFloat)offset;
{
    CGRect frame = self.frame;
    frame.origin.x = offset;
    self.frame = frame;
}
- (void)rightAlignFrameOnWidth:(CGFloat)width offset:(CGFloat)offset;
{
    CGRect frame = self.frame;
    frame.origin.x = width - frame.size.width - offset;
    self.frame = frame;
}
- (void)growFrameToHeight:(CGFloat)height;
{
    CGFloat oldHeight = self.bounds.size.height;
    CGFloat heightDelta = height - oldHeight;
    if (heightDelta) {
        CGRect frame = self.frame;
        frame.origin.y -= (heightDelta / 2.0f);
        frame.size.height += heightDelta;
        self.frame = frame;
    }
}
@end


@interface CCCollectionViewFlowLayoutAligned ()

@end

@implementation CCCollectionViewFlowLayoutAligned

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hAlignment = UIFlowLayoutAlignHorizontalNatural;
        self.vAlignment = UIFlowLayoutAlignVerticalNatural;
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
{
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        if (nil == attributes.representedElementKind) {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    // Get the current attributes for the requested item cell
    UICollectionViewLayoutAttributes *currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect currentItemFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(0,
                                              currentItemFrame.origin.y+(currentItemFrame.size.height/2.0f),
                                              self.collectionView.frame.size.width,
                                              1.0f);
    
    // Get all the row item attributes from UICollectionViewFlowLayout super class
    NSArray *rowItemsAttributes = [super layoutAttributesForElementsInRect:strecthedCurrentFrame];
    // Sort them based on indexPath.item from lowest to highest
    NSArray *sortedItemsAttributes = [rowItemsAttributes sortedArrayUsingComparator: ^(UICollectionViewLayoutAttributes *obj1, UICollectionViewLayoutAttributes *obj2) {
        if (obj1.indexPath.item > obj2.indexPath.item) return (NSComparisonResult)NSOrderedDescending;
        if (obj1.indexPath.item < obj2.indexPath.item) return (NSComparisonResult)NSOrderedAscending;
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // Get the widths and count of all items in the row
    CGFloat rowItemsContentWidth = 0.0f;
    CGFloat maxItemWidth = 0.0f;
    CGFloat maxItemHeight = 0.0f;
    NSInteger rowItemsCount = 0;
    for (UICollectionViewLayoutAttributes *attributes in sortedItemsAttributes) {
        if (nil == attributes.representedElementKind) {
            if (attributes.size.width > maxItemWidth)
                maxItemWidth = attributes.size.width;
            if (attributes.size.height > maxItemHeight)
                maxItemHeight = attributes.size.height;
            rowItemsContentWidth += attributes.size.width;
            rowItemsCount++;
        }
    }
    
    if (self.resizeCellstoMaximumItemHeightPerRow) {
        for (UICollectionViewLayoutAttributes *attributes in sortedItemsAttributes) {
            if (nil == attributes.representedElementKind) {
                // Resize height to meet max item height per row
                [attributes growFrameToHeight:maxItemHeight];
            }
        }
    }
    
    if (self.hAlignment == UIFlowLayoutAlignHorizontalLeft) {
        //
        // Distribute items to the left
        //
        CGFloat offset = self.sectionInset.left;   // Start distributing respecting the section Inset
        for (UICollectionViewLayoutAttributes* attributes in sortedItemsAttributes) {
            if (nil == attributes.representedElementKind) {
                // left align to the current offset
                [attributes leftAlignFrameWithOffset:offset];
                
                if (attributes.indexPath.item == indexPath.item) {
                    // We placed the current item, we are done
                    return attributes;
                } else {
                    // Calculate new offset and continue to next item
                    offset += attributes.frame.size.width + self.minimumInteritemSpacing;
                }
            }
        }
    }

    if (self.hAlignment == UIFlowLayoutAlignHorizontalRight) {
        //
        // Distribute items to the right
        //
        CGFloat offset = self.sectionInset.right;   // Start distributing respecting the section Inset
        for (UICollectionViewLayoutAttributes* attributes in [sortedItemsAttributes reverseObjectEnumerator]) {
            if (nil == attributes.representedElementKind) {
                // right align for the full width of the row, minus the offset
                [attributes rightAlignFrameOnWidth:self.collectionView.bounds.size.width offset:offset];
                
                if (attributes.indexPath.item == indexPath.item) {
                    // We placed the current item, we are done
                    return attributes;
                } else {
                    // Calculate new offset and continue to next item
                    offset += attributes.frame.size.width + self.minimumInteritemSpacing;
                }
            }
        }
    }
    
    if (self.hAlignment == UIFlowLayoutAlignHorizontalCenter) {
        //
        // Distribute items out from the center
        //
        
        // Get the widths of the inter item spacing and add to the row content width
        CGFloat rowItemsPaddingWidth = self.minimumInteritemSpacing * (rowItemsCount - 1);
        rowItemsContentWidth += rowItemsPaddingWidth;

        // We will center all row items as a single group (ignoring the section insets)
        CGFloat xOffset = floorf((self.collectionView.bounds.size.width - rowItemsContentWidth) / 2.0f);
        for (UICollectionViewLayoutAttributes *attributes in sortedItemsAttributes) {
            if (nil == attributes.representedElementKind) {
                // Left align to the xOffset
                [attributes leftAlignFrameWithOffset:xOffset];

                if (attributes.indexPath.item == indexPath.item) {
                    return attributes;
                }
                // Adjust offset to include current item width and inter item spacing
                xOffset += attributes.size.width + self.minimumInteritemSpacing;
            }
        }
        
    }
    
    // Default to base flow layout (do not adjust cell horizontal layout)
    for (UICollectionViewLayoutAttributes *attributes in sortedItemsAttributes) {
        if (nil == attributes.representedElementKind) {
            if (attributes.indexPath.item == indexPath.item) {
                return attributes;
            }
        }
    }
    
   return currentItemAttributes;
}

@end


