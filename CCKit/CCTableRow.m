//
//  CCTableRow.m
//  Brickstr
//
//  Created by Leonardo Lobato on 14/08/13.
//  Copyright (c) 2013 Brickstr. All rights reserved.
//

#import "CCTableRow.h"

@implementation CCTableRow

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ %@",
            [super description], self.title];
}

+ (CCTableRow *)rowWithTitle:(NSString *)title;
{
    return [self rowWithTitle:title target:nil action:NULL];
}

+ (CCTableRow *)rowWithTitle:(NSString *)title target:(id)target action:(SEL)action;
{
    CCTableRow *row = [[CCTableRow alloc] init];
    row.title = title;
    row.target = target;
    row.action = action;
    return row;
}

@end
