//
//  AFModel.h
//  AFKit
//
//  Created by Leonardo Lobato on 12/2/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFModelDelegate.h"

@protocol AFModel <NSObject>

@property (nonatomic, readonly) NSMutableArray *delegates; // AFModelDelegate

- (BOOL)isLoaded;
- (BOOL)isLoading;
- (BOOL)isLoadingMore;
- (BOOL)isOutdated;

- (void)load;
- (void)loadMore;
- (void)cancel;

// TODO: support if needed later
// - (void)invalidate:(BOOL)erase;

@end

@interface AFModel : NSObject <AFModel>

// Notify delegates:
- (void)didStartLoad;
- (void)didFinishLoad;
- (void)didFailLoadWithError:(NSError*)error;
- (void)didCancelLoad;
- (void)didChange;
- (void)beginUpdates;
- (void)endUpdates;
- (void)didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end

// TODO: declare protected methods on separate header
@interface AFModel (Protected)

- (void)delegatePerformSelector:(SEL)selector withObject:(id)object1;
- (void)delegatePerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2;
- (void)delegatePerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3;

@end