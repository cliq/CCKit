//
//  CCGroupModel.m
//  missinglink
//
//  Created by Leonardo Lobato on 04/12/13.
//  Copyright (c) 2013 Fanatee. All rights reserved.
//

#import "CCGroupModel.h"

@interface CCGroupModel ()

@property (nonatomic, strong) NSMutableArray *modelsLoading;

@property (nonatomic, assign) BOOL isLoadingModels;
@property (nonatomic, assign) BOOL notifiedLoadingStarted;

@property (nonatomic, strong) NSMutableArray *modelsWhichFinishedLoading; // CCModel *
@property (nonatomic, strong) NSMutableArray *modelsWhichFailedLoading; // CCModel *
@property (nonatomic, strong) NSMutableArray *modelsWhichCanceledLoading; // CCModel *
@property (nonatomic, strong, readwrite) NSMutableArray *modelsWhichFailedLoadingErrors; // NSError *

@end

@implementation CCGroupModel

@synthesize models = _models;

- (id)init
{
    self = [super init];
    if (self) {
        self.modelsLoading = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

- (void)setModels:(NSArray *)models;
{
    if (_models!=models) {
        for (CCModel *model in _models) {
            [model.delegates removeObject:self];
        }
        
        _models = models;
        
        for (CCModel *model in _models) {
            if (![model.delegates containsObject:self]) {
                [model.delegates addObject:self];
            }
        }
    }
}

#pragma mark - CCModel

#pragma mark Properties

- (BOOL)isLoaded;
{
    // To return YES, all models must be loaded
    
    BOOL isLoaded = YES;
    for (CCModel *model in self.models) {
        isLoaded = isLoaded && model.isLoaded;
    }
    return isLoaded;
}

- (BOOL)isLoading;
{
    // To return YES, any model must be loading
    
    BOOL isLoading = NO;
    for (CCModel *model in self.models) {
        isLoading = isLoading || model.isLoading;
    }
    return isLoading;
}

- (BOOL)isLoadingMore;
{
    // To return YES, any model must be loading more

    BOOL isLoading = NO;
    for (CCModel *model in self.models) {
        isLoading = isLoading || model.isLoading;
    }
    return isLoading;
}

- (BOOL)isOutdated;
{
    // To return YES, any model must be outdated

    BOOL isOutdated = NO;
    for (CCModel *model in self.models) {
        isOutdated = isOutdated || model.isOutdated;
    }
    return isOutdated;
}

#pragma mark Methods

- (void)loadMore:(BOOL)more;
{
    if (self.isLoadingModels) {
        CCDebug(@"Group model is already loading.");
        return;
    }
    
    NSMutableArray *modelsToLoad = [NSMutableArray arrayWithCapacity:self.models.count];
    for (CCModel *model in self.models) {
        if (model.isOutdated || !model.isLoaded) {
            [modelsToLoad addObject:modelsToLoad];
        }
    }
    [self.modelsLoading removeAllObjects];
    [self.modelsLoading addObjectsFromArray:modelsToLoad];
    
    self.notifiedLoadingStarted = NO;
    self.modelsWhichFinishedLoading = nil;
    self.modelsWhichFailedLoading = nil;
    self.modelsWhichCanceledLoading = nil;
    self.modelsWhichFailedLoadingErrors = nil;
    self.isLoadingModels = YES;
    for (CCModel *model in modelsToLoad) {
        [model loadMore:more];
    }
}

- (void)cancel;
{
    for (CCModel *model in self.models) {
        if (model.isLoading) {
            [model cancel];
        }
    }
}

- (void)reset;
{
    // TODO: which models must be reset when this is called?
}

#pragma mark - CCModelDelegate

- (BOOL)isDoneLoading;
{
    BOOL done = YES;
    for (CCModel *model in self.modelsLoading) {
        if (model.isLoading) {
            done = NO;
            break;
        }
    }
    
    return done;
}

- (void)notifyDelegatesIfDone;
{
    if (![self isDoneLoading]) {
        return;
    }

    // If at least one finished loading, didFinishLoad
    // If none finished loading but at least one failed to load, didFailLoadWithError:
    // If none failed loading but at least one was canceled, didCancelLoad.
    
    if (self.modelsWhichFinishedLoading.count>0) {
        [self didFinishLoad];
    } else if (self.modelsWhichFailedLoading.count>0) {
        NSError *error = nil; // TODO: setup error
        [self didFailLoadWithError:error];
    } else if (self.modelsWhichCanceledLoading.count>0) {
        [self didCancelLoad];
    }
}


- (void)modelDidStartLoad:(id<CCModel>)model;
{
    if (![self.modelsLoading containsObject:model]) {
        return;
    }
    
    if (!self.notifiedLoadingStarted) {
        self.notifiedLoadingStarted = YES;
        [self didStartLoad];
    }
}

- (void)modelDidFinishLoad:(id<CCModel>)model;
{
    if (![self.modelsLoading containsObject:model]) {
        return;
    }
    
    [self.modelsWhichFinishedLoading addObject:model];
    [self.modelsLoading removeObject:model];
    [self notifyDelegatesIfDone];
}

- (void)model:(id<CCModel>)model didFailLoadWithError:(NSError*)error;
{
    if (![self.modelsLoading containsObject:model]) {
        return;
    }
    
    if (error) {
        [self.modelsWhichFailedLoadingErrors addObject:error];
    }

    [self.modelsWhichFailedLoading addObject:model];
    [self.modelsLoading removeObject:model];
    [self notifyDelegatesIfDone];
}

- (void)modelDidCancelLoad:(id<CCModel>)model;
{
    if ([self isDoneLoading]) {
        [self didFinishLoad];
    }

    [self.modelsWhichCanceledLoading addObject:model];
    [self.modelsLoading removeObject:model];
    [self notifyDelegatesIfDone];
}

@end
