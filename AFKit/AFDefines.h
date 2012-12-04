//
//  AFDefines.h
//  AFKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#ifdef DEBUG
#define AFLog(format, ...) NSLog(@"%s | %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__])
#define AFDebug(format, ...) NSLog(@"%s | %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__])
#define AF_ENTER AFDebug(@"%@", @"entered")
#define AF_EXIT AFDebug(@"%@", @"exiting")
#define AF_MARK	AFDebug(@"")
#define AF_START_TIMER NSTimeInterval ___start = [NSDate timeIntervalSinceReferenceDate]
#define AF_END_TIMER(msg) 	NSTimeInterval ___stop = [NSDate timeIntervalSinceReferenceDate]; AFDebug([NSString stringWithFormat:@"%@ | Time=%f", msg, ___stop - ___start])
#else
#define AFLog(format, ...)
#define AFDebug(format, ...)
#define AF_ENTER
#define AF_EXIT
#define AF_MARK
#define AF_START_TIMER
#define AF_END_TIMER(msg)
#endif

#pragma mark - AF Device
#define AF_IDIOM_IPAD      (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define AF_IDIOM_IPHONE    (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
#define AF_ORIENT_PORTRAIT  (UIInterfaceOrientationIsPortrait(interfaceOrientation))
#define AF_ORIENT_LANDSCAPE (UIInterfaceOrientationIsLandscape(interfaceOrientation))

#define AFisPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define AFiPhone568NameForImage(image) (AFisPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
#define AFiPhone568ImageNamed(image) ([UIImage imageNamed:AFiPhone568NameForImage(image)])


#pragma mark - Constants

#pragma mark Model error
#define kAFModelErrorDomain @"AFModelErrorDomain"
#define kAFModelErrorHTTPDomain @"AFModelErrorHTTPDomain"
#define kAFModelErrorAPIDomain @"AFModelErrorAPIDomain"
#define kAFModelErrorCodeInternal 500
#define kAFModelErrorCodeAPI 505
#define kAFModelErrorCodeAuthentication 510
