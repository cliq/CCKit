//
//  AFModelViewController.m
//  AFKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "AFModelViewController.h"

@interface AFModelViewController (Protected)
- (id<AFModel>)newInterstitialModel;
@end

@implementation AFModelViewController

@synthesize model = _model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _flags.isViewInvalid = YES;
    }
    return self;
}

- (void)dealloc;
{
    [self.model.delegates removeObject:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark Private


- (void)resetViewStates {
    if (_flags.isShowingLoading) {
        [self showLoading:NO];
        _flags.isShowingLoading = NO;
    }
    if (_flags.isShowingModel) {
        [self showModel:NO];
        _flags.isShowingModel = NO;
    }
    if (_flags.isShowingError) {
        [self showError:NO];
        _flags.isShowingError = NO;
    }
    if (_flags.isShowingEmpty) {
        [self showEmpty:NO];
        _flags.isShowingEmpty = NO;
    }
}


- (void)updateViewStates {
    if (_flags.isModelDidRefreshInvalid) {
        [self didRefreshModel];
        _flags.isModelDidRefreshInvalid = NO;
    }
    if (_flags.isModelWillLoadInvalid) {
        [self willLoadModel];
        _flags.isModelWillLoadInvalid = NO;
    }
    if (_flags.isModelDidLoadInvalid) {
        [self didLoadModel:_flags.isModelDidLoadFirstTimeInvalid];
        _flags.isModelDidLoadInvalid = NO;
        _flags.isModelDidLoadFirstTimeInvalid = NO;
        _flags.isShowingModel = NO;
    }
    
    BOOL showModel = NO, showLoading = NO, showError = NO, showEmpty = NO;
    
    if (_model.isLoaded || ![self shouldLoad]) {
        if ([self canShowModel]) {
            showModel = !_flags.isShowingModel;
            _flags.isShowingModel = YES;
            
        } else {
            if (_flags.isShowingModel) {
                [self showModel:NO];
                _flags.isShowingModel = NO;
            }
        }
        
    } else {
        if (_flags.isShowingModel) {
            [self showModel:NO];
            _flags.isShowingModel = NO;
        }
    }
    
    if (_model.isLoading) {
        showLoading = !_flags.isShowingLoading;
        _flags.isShowingLoading = YES;
        
    } else {
        if (_flags.isShowingLoading) {
            [self showLoading:NO];
            _flags.isShowingLoading = NO;
        }
    }
    
    if (_modelError) {
        showError = !_flags.isShowingError;
        _flags.isShowingError = YES;
        
    } else {
        if (_flags.isShowingError) {
            [self showError:NO];
            _flags.isShowingError = NO;
        }
    }
    
    if (!_flags.isShowingLoading && !_flags.isShowingModel && !_flags.isShowingError) {
        showEmpty = !_flags.isShowingEmpty;
        _flags.isShowingEmpty = YES;
        
    } else {
        if (_flags.isShowingEmpty) {
            [self showEmpty:NO];
            _flags.isShowingEmpty = NO;
        }
    }
    
    if (showModel) {
        [self showModel:YES];
        [self didShowModel:_flags.isModelDidShowFirstTimeInvalid];
        _flags.isModelDidShowFirstTimeInvalid = NO;
    }
    if (showEmpty) {
        [self showEmpty:YES];
    }
    if (showError) {
        [self showError:YES];
    }
    if (showLoading) {
        [self showLoading:YES];
    }
}


#pragma mark -
#pragma mark UIViewController


- (void)viewWillAppear:(BOOL)animated {
    _isViewAppearing = YES;
    _hasViewAppeared = YES;
    
    [self updateView];
    
    [super viewWillAppear:animated];
}

// TODO: fix isViewAppearing and hasViewAppeared naming
//- (void)viewDidAppear:(BOOL)animated;
//{
//    _isViewAppearing = NO;
//    
//    [super viewDidAppear:animated];
//}


- (void)didReceiveMemoryWarning {
    if (_hasViewAppeared && !_isViewAppearing) {
        [super didReceiveMemoryWarning];
        [self resetViewStates];
        [self refresh];
        
    } else {
        [super didReceiveMemoryWarning];
    }
}

#pragma mark - Public

- (id<AFModel>)model {
    if (!_model) {
        _model = [self newModel];
    }
    return _model;
}


- (void)setModel:(id<AFModel>)model {
    if (_model != model) {
        [_model.delegates removeObject:self];
        _model = model;
        [_model.delegates addObject:self];
        self.modelError = nil;
        
        if (_model) {
            _flags.isModelWillLoadInvalid = NO;
            _flags.isModelDidLoadInvalid = NO;
            _flags.isModelDidLoadFirstTimeInvalid = NO;
            _flags.isModelDidShowFirstTimeInvalid = YES;
        }
        
        [self refresh];
    }
}


- (void)setModelError:(NSError*)error {
    if (error != _modelError) {
        _modelError = error;
        
        [self invalidateView];
    }
}


- (void)invalidateModel {
    BOOL wasModelCreated = self.isModelCreated;
    [self resetViewStates];
    [_model.delegates removeObject:self];
    _model = nil;
    if (wasModelCreated) {
        [self model];
    }
}


- (BOOL)isModelCreated {
    return !!_model;
}


- (BOOL)shouldLoad {
    return !self.model.isLoaded;
}


- (BOOL)shouldReload {
    return !_modelError && self.model.isOutdated;
}


- (BOOL)shouldLoadMore {
    return NO;
}


- (BOOL)canShowModel {
    return YES;
}


- (void)reload {
    _flags.isViewInvalid = YES;
    [self.model loadMore:NO];
}


- (void)reloadIfNeeded {
    if ([self shouldReload] && !self.model.isLoading) {
        [self reload];
    }
}


- (void)refresh {
    _flags.isViewInvalid = YES;
    _flags.isModelDidRefreshInvalid = YES;
    
    BOOL loading = self.model.isLoading;
    BOOL loaded = self.model.isLoaded;
    if (!loading && !loaded && [self shouldLoad]) {
        // TODO: load from cache first
//        [self.model load:TTURLRequestCachePolicyDefault more:NO];
        [self.model loadMore:NO];
        
    } else if (!loading && loaded && [self shouldReload]) {
        // TODO: force from network
//        [self.model load:TTURLRequestCachePolicyNetwork more:NO];
        [self.model loadMore:NO];
        
    } else if (!loading && [self shouldLoadMore]) {
        [self.model loadMore:YES];
        
    } else {
        _flags.isModelDidLoadInvalid = YES;
        if (_isViewAppearing) {
            [self updateView];
        }
    }
}


- (void)beginUpdates {
    _flags.isViewSuspended = YES;
}


- (void)endUpdates {
    _flags.isViewSuspended = NO;
    [self updateView];
}


- (void)invalidateView {
    _flags.isViewInvalid = YES;
    if (_isViewAppearing) {
        [self updateView];
    }
}


- (void)updateView {
    if (_flags.isViewInvalid && !_flags.isViewSuspended && !_flags.isUpdatingView) {
        _flags.isUpdatingView = YES;
        
        // Ensure the model is created
        [self model];
        // Ensure the view is created
        [self view];
        
        [self updateViewStates];
        
        _flags.isViewInvalid = NO;
        _flags.isUpdatingView = NO;
        
        [self reloadIfNeeded];
    }
}

#pragma mark - AFModelDelegate

- (void)modelDidStartLoad:(id<AFModel>)model {
    if (model == self.model) {
        _flags.isModelWillLoadInvalid = YES;
        _flags.isModelDidLoadFirstTimeInvalid = YES;
        [self invalidateView];
    }
}


- (void)modelDidFinishLoad:(id<AFModel>)model {
    if (model == _model) {
        _modelError = nil;
        _flags.isModelDidLoadInvalid = YES;
        [self invalidateView];
    }
}


- (void)model:(id<AFModel>)model didFailLoadWithError:(NSError*)error {
    if (model == _model) {
        self.modelError = error;
    }
}


- (void)modelDidCancelLoad:(id<AFModel>)model {
    if (model == _model) {
        [self invalidateView];
    }
}


- (void)modelDidChange:(id<AFModel>)model {
    if (model == _model) {
        [self refresh];
    }
}


- (void)modelDidBeginUpdates:(id<AFModel>)model {
    if (model == _model) {
        [self beginUpdates];
    }
}


- (void)modelDidEndUpdates:(id<AFModel>)model {
    if (model == _model) {
        [self endUpdates];
    }
}

#pragma mark - Subclasses should implement

- (AFModel *)newModel;
{
    return [[AFModel alloc] init];
}

- (void)showLoading:(BOOL)show {
}


- (void)showModel:(BOOL)show {
}


- (void)showEmpty:(BOOL)show {
}


- (void)showError:(BOOL)show {
}


- (void)didRefreshModel {
}


- (void)willLoadModel {
}


- (void)didLoadModel:(BOOL)firstTime {
}


- (void)didShowModel:(BOOL)firstTime {
}

- (void)model:(id<AFModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
}


- (void)model:(id<AFModel>)model didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
}


- (void)model:(id<AFModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
}


@end
