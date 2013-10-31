//
//  CCHTTPModelResponse.h
//  CCKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHTTPModelResponse : NSObject

@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSError *lastError;
@property (nonatomic, strong, readonly) NSHTTPURLResponse *httpResponse;
@property (nonatomic, strong, readonly) NSData *responseData;

// Override
- (void)clear;

// Protected:
- (NSError *)parseResponse:(NSHTTPURLResponse *)response withData:(NSData *)responseData error:(NSError *)error;

@end
