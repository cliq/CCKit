//
//  CCTableSection.m
//  Brickstr
//
//  Created by Leonardo Lobato on 3/19/13.
//  Copyright (c) 2013 Brickstr. All rights reserved.
//

#import "CCTableSection.h"

@implementation CCTableSection

- (NSUInteger)rowCount;
{
    return self.rows.count;
}

- (id)rowAtIndex:(NSUInteger)index;
{
    if (index<self.rowCount) {
        return [self.rows objectAtIndex:index];
    } else {
        return nil;
    }
}

- (void)addRow:(id)row;
{
    if (!row) {
        return;
    }
    
    if (!self.rows) {
        self.rows = [[NSMutableArray alloc] init];
    }
    
    [self.rows addObject:row];
}
@end
