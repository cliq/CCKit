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

@property (nonatomic, strong) id userInfo;

@property (nonatomic, assign, getter = isCollapsible) BOOL collapsible;
@property (nonatomic, assign, getter = isCollapsed) BOOL collapsed;


- (void)addRow:(id)row;
- (void)removeRow:(id)row;
- (id)rowAtIndex:(NSUInteger)index;

@end
