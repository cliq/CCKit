//
//  AFModelDelegate.h
//  AFKit
//
//  Created by Leonardo Lobato on 12/2/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFModel;

@protocol AFModelDelegate <NSObject>

@optional

- (void)modelDidStartLoad:(id<AFModel>)model;
- (void)modelDidFinishLoad:(id<AFModel>)model;
- (void)model:(id<AFModel>)model didFailLoadWithError:(NSError*)error;
- (void)modelDidCancelLoad:(id<AFModel>)model;

- (void)modelDidChange:(id<AFModel>)model;
- (void)model:(id<AFModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)model:(id<AFModel>)model didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)model:(id<AFModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

- (void)modelDidBeginUpdates:(id<AFModel>)model;
- (void)modelDidEndUpdates:(id<AFModel>)model;

@end
