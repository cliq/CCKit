//
//  CCLoadingController.h
//  CCKit
//
//  Created by Leonardo Lobato on 3/15/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCLoadingControllerDelegate;

@interface CCLoadingController : NSObject

@property (nonatomic, readonly) UIView *loadingView;
#if __has_feature(objc_arc)
@property (nonatomic, weak) id<CCLoadingControllerDelegate> delegate;
#else
@property (nonatomic, assign) id<CCLoadingControllerDelegate> delegate;
#endif

- (void)showLoadingView:(BOOL)show animated:(BOOL)animated;

@end


@protocol CCLoadingControllerDelegate <NSObject>
- (UIView *)parentViewForLoadingController:(CCLoadingController *)controller;
@optional;
- (UIView *)loadingControllerShouldBeDisplayedBelowView:(CCLoadingController *)controller;
- (NSString *)titleForLoadingViewOnLoadingController:(CCLoadingController *)controller;
@end