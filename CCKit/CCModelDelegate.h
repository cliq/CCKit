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
- (void)model:(id<CCModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)model:(id<CCModel>)model didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)model:(id<CCModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

- (void)modelDidBeginUpdates:(id<CCModel>)model;
- (void)modelDidEndUpdates:(id<CCModel>)model;

@end
