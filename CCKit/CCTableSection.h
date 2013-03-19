//
//  CCTableSection.h
//  Brickstr
//
//  Created by Leonardo Lobato on 3/19/13.
//  Copyright (c) 2013 Brickstr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTableSection : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *rows;

@property (nonatomic, readonly) NSUInteger rowCount;

- (void)addRow:(id)row;
- (id)rowAtIndex:(NSUInteger)index;

@end
