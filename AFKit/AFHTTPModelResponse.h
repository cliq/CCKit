//
//  AFHTTPModelResponse.h
//  AFKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFHTTPModelResponse : NSObject

@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, retain) NSError *lastError;
@property (nonatomic, retain) id parsedResponse;

// Override
- (void)clear;
- (NSError *)parseJSON:(id)jsonBody;

// Protected:
- (NSError *)parseResponse:(NSHTTPURLResponse *)response withData:(NSData *)responseData error:(NSError *)error;

@end
