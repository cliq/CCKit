//
//  CCCollectionViewPagedLayout.m
//  Coolmath
//
//  Created by Glenn Marcus on 12/7/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import "CCCollectionViewPagedLayout.h"

@interface CCCollectionViewPagedLayout ()
@end

@implementation CCCollectionViewPagedLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        if (nil == attributes.representedElementKind) {
            // Cells

            // Calculate the distance to displayed center
            CGFloat itemCenterDistanceToViewCenter = fabs(attributes.center.x - CGRectGetMidX(self.collectionView.bounds));
            
            if (itemCenterDistanceToViewCenter == 0) {
                // This item is now the focused item

                NSIndexPath *oldFocusedIndexPath = self.focusedIndexPath;
                self.focusedIndexPath = [attributes.indexPath copy];

                BOOL notifyFocusChanged = NO;
                if (oldFocusedIndexPath) {
                    // If the focused item indexPath changed, notify the delegate
                    if ([self.focusedIndexPath compare:oldFocusedIndexPath] != NSOrderedSame) {
                        notifyFocusChanged = YES;
                    }
                } else {
                    // First time we are setting the focused item, notify the delegate
                    notifyFocusChanged = YES;
                }
                
                if (notifyFocusChanged) {
                    // Notify delegate there is a new focused item
                    if (self.collectionView.delegate && ([self.collectionView.delegate respondsToSelector:@selector(collectionView:didChangeFocusedItemAtIndexPath:)])) {
                        id delegate = self.collectionView.delegate;
                        [delegate collectionView:self.collectionView didChangeFocusedItemAtIndexPath:self.focusedIndexPath];
                    }
                }
                
            }
        }
    }
    return attributesToReturn;
}

// https://gist.github.com/mmick66/9812223
// Best so far, but does not handle centering items on rotation
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGSize collectionViewSize = self.collectionView.bounds.size;
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width * 0.5f;
    
    CGRect proposedRect = self.collectionView.bounds;
    
    // Comment out if you want the collectionview simply stop at the center of an item while scrolling freely
    //proposedRect = CGRectMake(proposedContentOffset.x, 0.0, collectionViewSize.width, collectionViewSize.height);
    
    UICollectionViewLayoutAttributes* candidateAttributes;
    for (UICollectionViewLayoutAttributes* attributes in [self layoutAttributesForElementsInRect:proposedRect])
    {
        
        // == Skip comparison with non-cell items (headers and footers) == //
        if (attributes.representedElementCategory != UICollectionElementCategoryCell)
        {
            continue;
        }
        
        // == First time in the loop == //
        if(!candidateAttributes)
        {
            candidateAttributes = attributes;
            continue;
        }
        
        if (fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes.center.x - proposedContentOffsetCenterX))
        {
            candidateAttributes = attributes;
        }
    }
    
    return CGPointMake(candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f, proposedContentOffset.y);
    
}


@end
