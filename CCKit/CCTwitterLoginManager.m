//
//  CCTwitterLoginManager.m
//  CCKit
//
//  Created by Leonardo Lobato on 3/7/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import "CCTwitterLoginManager.h"
#import "CCDefines.h"

@implementation CCTwitterLoginManager

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
        _apiManager = [[TWAPIManager alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)obtainAccessToAccountsWithBlock:(void (^)(BOOL, NSError *))block
{
    ACAccountType *twitterType = [self.accountStore
                                  accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler handler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            self.accounts = [_accountStore accountsWithAccountType:twitterType];
        }
        
        block(granted, error);
    };
    
    //  This method changed in iOS6.  If the new version isn't available, fall
    //  back to the original (which means that we're running on iOS5+).
    if ([self.accountStore respondsToSelector:@selector(requestAccessToAccountsWithType:options:completion:)]) {
        [self.accountStore requestAccessToAccountsWithType:twitterType
                                                   options:nil
                                                completion:handler];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.accountStore requestAccessToAccountsWithType:twitterType
                                     withCompletionHandler:handler];
#pragma clang diagnostic pop
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==(actionSheet.numberOfButtons-1)) {
        // Cancel
        if ([_delegate respondsToSelector:@selector(loginManagerCanceledConnectToTwitter:)]) {
            [_delegate loginManagerCanceledConnectToTwitter:self];
        }
        
    } else {
        ACAccount *account = self.accounts[buttonIndex];
        
        if ([_delegate respondsToSelector:@selector(loginManager:willConnectTwitterAccount:)]) {
            [_delegate loginManager:self willConnectTwitterAccount:account];
        }
        
        [self.apiManager
         performReverseAuthForAccount:account
         withHandler:^(NSData *responseData, NSError *error) {
             if (responseData) {
                 NSString *response = [[NSString alloc] initWithData:responseData
                                                            encoding:NSUTF8StringEncoding];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if ([self.delegate respondsToSelector:@selector(loginManager:connectedTwitterAccount:response:)]) {
                         [self.delegate loginManager:self
                             connectedTwitterAccount:account
                                            response:response];
                     }
                 });
             } else {
                 CCLog(@"Error!\n%@", [error localizedDescription]);
                 if ([self.delegate respondsToSelector:@selector(loginManager:failedToConnectedTwitterAccount:error:)]) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.delegate loginManager:self failedToConnectedTwitterAccount:account error:error];
                     });
                 }
             }
         }];
    }
}

- (BOOL)performTwitterReverseAuthInView:(UIView *)view;
{
    if ([TWAPIManager isLocalTwitterAccountAvailable]) {
        UIActionSheet *sheet = [[UIActionSheet alloc]
                                initWithTitle:@"Choose an Account"
                                delegate:self
                                cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                otherButtonTitles:nil];
        
        for (ACAccount *acct in self.accounts) {
            [sheet addButtonWithTitle:acct.username];
        }
        
        [sheet addButtonWithTitle:@"Cancel"];
        [sheet setDestructiveButtonIndex:[_accounts count]];
        [sheet showInView:view];
        return YES;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No Accounts"
                              message:@"Please configure a Twitter account on your device Settings."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

@end