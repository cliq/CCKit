//
//  CCModelDelegate.h
//  CCKit
//
//  Created by Leonardo Lobato on 12/2/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCModel;

@protocol CCModelDelegate <NSObject>

@optional

- (void)modelDidStartLoad:(id<CCModel>)model;
- (void)modelDidFinishLoad:(id<CCModel>)model;
- (void)model:(id<CCModel>)model didFailLoadWithError:(NSError*)error;
- (void)modelDidCancelLoad:(id<CCModel>)model;

- (void)modelDidChange:(id<CCModel>)model;
- (void)model:(id<CCModel>)model didUpdateObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths;
- (void)model:(id<CCModel>)model didInsertObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths;
- (void)model:(id<CCModel>)model didDeleteObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths;

- (void)modelDidBeginUpdates:(id<CCModel>)model;
- (void)modelDidEndUpdates:(id<CCModel>)model;

@end
