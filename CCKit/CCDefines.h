//
//  CCDefines.h
//  CCKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#ifdef DEBUG
#define CCLog(format, ...) NSLog(@"%s | %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__])
#define CCDebug(format, ...) NSLog(@"%s | %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__])
#define CC_ENTER CCDebug(@"%@", @"entered")
#define CC_EXIT CCDebug(@"%@", @"exiting")
#define CC_MARK	CCDebug(@"")
#define CC_START_TIMER NSTimeInterval ___start = [NSDate timeIntervalSinceReferenceDate]
#define CC_END_TIMER(msg) 	NSTimeInterval ___stop = [NSDate timeIntervalSinceReferenceDate]; CCDebug([NSString stringWithFormat:@"%@ | Time=%f", msg, ___stop - ___start])
#else
#define CCLog(format, ...)
#define CCDebug(format, ...)
#define CC_ENTER
#define CC_EXIT
#define CC_MARK
#define CC_START_TIMER
#define CC_END_TIMER(msg)
#endif

#pragma mark - CC Device
#define CC_IDIOM_IPAD      (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define CC_IDIOM_IPHONE    (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
#define CC_ORIENT_PORTRAIT  (UIInterfaceOrientationIsPortrait(interfaceOrientation))
#define CC_ORIENT_LANDSCAPE (UIInterfaceOrientationIsLandscape(interfaceOrientation))

#define CCisPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define CCiPhone568NameForImage(image) (CCisPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
#define CCiPhone568ImageNamed(image) ([UIImage imageNamed:CCiPhone568NameForImage(image)])

#define CCisRetina ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#pragma mark - CC Singleton

#define CC_SINGLETON_INTERFACE(CLASSNAME)  \
+ (CLASSNAME *)sharedInstance;

#define CC_SINGLETON_IMPLEMENTATION(CLASSNAME)      \
\
+(CLASSNAME *)sharedInstance {                      \
static dispatch_once_t pred;                    \
static CLASSNAME *shared = nil;                 \
dispatch_once(&pred, ^{                         \
shared = [[CLASSNAME alloc] init];          \
});                                             \
return shared;                                  \
}


#pragma mark - Constants

#pragma mark Model error
#define kCCModelErrorDomain @"CCModelErrorDomain"
#define kCCModelErrorHTTPDomain @"CCModelErrorHTTPDomain"
#define kCCModelErrorAPIDomain @"CCModelErrorAPIDomain"
#define kCCModelErrorCodeInternal 500
#define kCCModelErrorCodeAPI 505
#define kCCModelErrorCodeAuthentication 510
