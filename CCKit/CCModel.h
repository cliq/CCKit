//
//  CCModel.h
//  CCKit
//
//  Created by Leonardo Lobato on 12/2/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCModelDelegate.h"

@protocol CCModel <NSObject>

@property (nonatomic, readonly) NSMutableArray *delegates; // CCModelDelegate

- (BOOL)isLoaded;
- (BOOL)isLoading;
- (BOOL)isLoadingMore;
- (BOOL)isOutdated;

- (void)loadMore:(BOOL)more;
- (void)cancel;

- (void)reset; // Clear parameters and response

// TODO: support if needed later
// - (void)invalidate:(BOOL)erase;

@end

@interface CCModel : NSObject <CCModel>

// Notify delegates:
- (void)didStartLoad;
- (void)didFinishLoad;
- (void)didFailLoadWithError:(NSError*)error;
- (void)didCancelLoad;
- (void)didChange;
- (void)beginUpdates;
- (void)endUpdates;
- (void)didUpdateObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths;
- (void)didInsertObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths;
- (void)didDeleteObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths;

@end

// TODO: declare protected methods on separate header
@interface CCModel (Protected)

- (void)delegatePerformSelector:(SEL)selector withObject:(id)object1;
- (void)delegatePerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2;
- (void)delegatePerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3;

@end
