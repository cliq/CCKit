//
//  CCTwitterLoginManager.h
//  CCKit
//
//  Created by Leonardo Lobato on 3/7/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Accounts/Accounts.h>
#import "TWAPIManager.h"

@protocol CCTwitterLoginManagerDelegate;

@interface CCTwitterLoginManager : NSObject <UIActionSheetDelegate>

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) TWAPIManager *apiManager;
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, weak) id<CCTwitterLoginManagerDelegate> delegate;

- (void)obtainAccessToAccountsWithBlock:(void (^)(BOOL, NSError *))block;
- (BOOL)performTwitterReverseAuthInView:(UIView *)view;

@end

@protocol CCTwitterLoginManagerDelegate <NSObject>

- (void)loginManager:(CCTwitterLoginManager *)loginManager connectedTwitterAccount:(ACAccount *)account response:(NSString *)response;

@optional;
- (void)loginManager:(CCTwitterLoginManager *)loginManager willConnectTwitterAccount:(ACAccount *)account;
- (void)loginManagerCanceledConnectToTwitter:(CCTwitterLoginManager *)loginManager;
- (void)loginManager:(CCTwitterLoginManager *)loginManager failedToConnectedTwitterAccount:(ACAccount *)account error:(NSError *)error;

@end