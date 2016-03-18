//
//  CCCollectionFooterCell.m
//  CCKit
//
//  Created by Glenn Marcus on 10/20/14.
//  Copyright (c) 2014 Cliq Consulting. All rights reserved.
//

#import "CCCollectionFooterCell.h"

@implementation CCCollectionFooterCell

+ (NSString *)kind;
{
    return UICollectionElementKindSectionFooter;
}

+ (NSString*)reuseID;
{
    return NSStringFromClass(self);
}

@end
