//
//  CCLoadingController.m
//  CCKit
//
//  Created by Leonardo Lobato on 3/15/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import "CCLoadingController.h"

@implementation CCLoadingController

#pragma mark - Loading

- (UIView *)loadingView;
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIView *background = [[UIView alloc] initWithFrame:_loadingView.bounds];
        background.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_loadingView addSubview:background];
        
        UILabel *loadingLabel = [[UILabel alloc] init];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        NSString *title = @"Loading...";
        if ([_delegate respondsToSelector:@selector(titleForLoadingViewOnLoadingController:)]) {
            title = [_delegate titleForLoadingViewOnLoadingController:self];
        }
        loadingLabel.text = title;
        [loadingLabel sizeToFit];
        loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        CGRect rect = loadingLabel.bounds;
        rect.origin.x = floorf((_loadingView.bounds.size.width-rect.size.width)/2.0f);
        rect.origin.y = floorf((_loadingView.bounds.size.height-rect.size.height)/2.0f);
        UIView *labelContainer = [[UIView alloc] initWithFrame:rect];
        labelContainer.backgroundColor = [UIColor clearColor];
        labelContainer.clipsToBounds = NO;
        labelContainer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [labelContainer addSubview:loadingLabel];
        [_loadingView addSubview:labelContainer];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityView startAnimating];
        rect = activityView.frame;
        rect.origin.x = 0.0f - rect.size.width - 5.0f;
        rect.origin.y = floorf((labelContainer.bounds.size.height-rect.size.height)/2.0f) + 1.0f;
        activityView.frame = rect;
        [labelContainer addSubview:activityView];
    }
    return _loadingView;
}

- (void)showLoadingView:(BOOL)show animated:(BOOL)animated;
{
    UIView *parentView = [_delegate parentViewForLoadingController:self];
    UIView *topView = nil;
    CGRect topViewFrame = CGRectZero;
    if ([_delegate respondsToSelector:@selector(loadingControllerShouldBeDisplayedBelowView:)]) {
        topView = [_delegate loadingControllerShouldBeDisplayedBelowView:self];
        topViewFrame = topView.frame;
    }
    
    CGFloat showY = CGRectGetMaxY(topViewFrame);
    CGFloat hideY = showY - self.loadingView.frame.size.height;
    
    if (show) {
        if (animated) {
            CGRect rect = self.loadingView.frame;
            rect.origin.x = 0.0f;
            rect.size.width = parentView.bounds.size.width;
            rect.origin.y = hideY;
            self.loadingView.frame = rect;
        } else {
            CGRect rect = self.loadingView.frame;
            rect.size.width = parentView.bounds.size.width;
            self.loadingView.frame = rect;
        }
        
        if (self.loadingView.superview!=parentView || topView) {
            if (topView) {
                [parentView insertSubview:self.loadingView belowSubview:topView];
            } else {
                [parentView addSubview:self.loadingView];
            }
        }
    }
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    CGRect rect = self.loadingView.frame;
    if (show) {
        rect.origin.y = showY;
    } else {
        rect.origin.y = hideY;
    }
    self.loadingView.frame = rect;
    
    if (animated) {
        [UIView commitAnimations];
    }
}

@end
