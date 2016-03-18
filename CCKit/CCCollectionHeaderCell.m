//
//  CCCollectionHeaderCell.m
//  CCKit
//
//  Created by Glenn Marcus on 10/17/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import "CCCollectionHeaderCell.h"

@implementation CCCollectionHeaderCell

+ (NSString *)kind;
{
    return UICollectionElementKindSectionHeader;
}

+ (NSString*)reuseID;
{
    return NSStringFromClass(self);
}


@end
