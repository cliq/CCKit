//
//  CCModel.m
//  CCKit
//
//  Created by Leonardo Lobato on 12/2/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "CCModel.h"

@implementation CCModel

@synthesize delegates = _delegates;

#pragma mark - Default implementation

- (BOOL)isLoaded;
{
    return YES;
}
- (BOOL)isLoading;
{
    return NO;
}
- (BOOL)isLoadingMore;
{
    return NO;
}
- (BOOL)isOutdated;
{
    return NO;
}

- (void)loadMore:(BOOL)more;
{
}
- (void)cancel;
{
}

- (void)reset;
{
}

#pragma mark - Notify Delegates

- (void)didStartLoad;
{
    [self delegatePerformSelector:@selector(modelDidStartLoad:) withObject:self];
}
- (void)didFinishLoad;
{
    [self delegatePerformSelector:@selector(modelDidFinishLoad:) withObject:self];
}
- (void)didFailLoadWithError:(NSError*)error;
{
    [self delegatePerformSelector:@selector(model:didFailLoadWithError:) withObject:self withObject:error];
}
- (void)didCancelLoad;
{
    [self delegatePerformSelector:@selector(modelDidCancelLoad:) withObject:self];
}

- (void)didChange;
{
    [self delegatePerformSelector:@selector(modelDidChange:) withObject:self];
}
- (void)beginUpdates;
{
    [self delegatePerformSelector:@selector(modelDidBeginUpdates:) withObject:self];
}
- (void)endUpdates;
{
    [self delegatePerformSelector:@selector(modelDidEndUpdates:) withObject:self];
}

- (void)didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
{
    [self delegatePerformSelector:@selector(model:didUpdateObject:atIndexPath:) withObject:self withObject:object withObject:indexPath];
}
- (void)didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
{
    [self delegatePerformSelector:@selector(model:didInsertObject:atIndexPath:) withObject:self withObject:object withObject:indexPath];
}
- (void)didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
{
    [self delegatePerformSelector:@selector(model:didDeleteObject:atIndexPath:) withObject:self withObject:object withObject:indexPath];
}


#pragma mark - Delegates

- (NSMutableArray *)delegates;
{
    // Creates a non-retaining array
    if (!_delegates) {
        CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
        _delegates = (__bridge id)(CFArrayCreateMutable(0, 0, &callbacks));
    }
    return _delegates;
}

#pragma mark - Protected

// Disabling warnings for performSelector: on ARC.
// http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

- (void)delegatePerformSelector:(SEL)selector withObject:(id)object1;
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSArray *copy = [[NSArray alloc] initWithArray:self.delegates];
    NSEnumerator* e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:object1];
        }
    }
#pragma clang diagnostic pop
}

- (void)delegatePerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2;
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSArray *copy = [[NSArray alloc] initWithArray:self.delegates];
    NSEnumerator* e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:object1 withObject:object2];
        }
    }
#pragma clang diagnostic pop
}

- (void)delegatePerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3;
{
    NSArray *copy = [[NSArray alloc] initWithArray:self.delegates];
    NSEnumerator* e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            NSMethodSignature *signature = [delegate methodSignatureForSelector:selector];
            if (signature) {
                NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
                [invocation setTarget:delegate];
                [invocation setSelector:selector];
                [invocation setArgument:&object1 atIndex:2];
                [invocation setArgument:&object2 atIndex:3];
                [invocation setArgument:&object3 atIndex:4];
                [invocation invoke];
            }
        }
    }
}

@end
