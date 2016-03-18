//
//  CCCollectionViewPagedLayout.h
//  Coolmath
//
//  Created by Glenn Marcus on 12/7/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCollectionViewFlowLayoutAligned.h"

@interface CCCollectionViewPagedLayout : CCCollectionViewFlowLayoutAligned
@property (nonatomic, strong) NSIndexPath *focusedIndexPath;
@end


// Provide a similiarly named protocol for consistency
@protocol CCCollectionViewDelegatePagedLayout <UICollectionViewDelegateFlowLayoutAligned>
- (void)collectionView:(UICollectionView *)collectionView didChangeFocusedItemAtIndexPath:(NSIndexPath *)indexPath;
@end