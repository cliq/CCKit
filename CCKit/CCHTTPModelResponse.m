//
//  CCHTTPModelResponse.m
//  CCKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "CCHTTPModelResponse.h"

#import "CCDefines.h"

@interface CCHTTPModelResponse ()

@property (nonatomic, strong, readwrite) NSHTTPURLResponse *httpResponse;
@property (nonatomic, strong, readwrite) NSData *responseData;

@end

@implementation CCHTTPModelResponse

- (void)clear;
{
    self.httpResponse = nil;
    self.responseData = nil;
}


#pragma mark -
#pragma mark TTURLResponse


- (NSError *)parseResponse:(NSHTTPURLResponse *)response withData:(NSData *)responseData error:(NSError *)error;
{
    self.responseData = responseData;
    self.httpResponse = response;
    self.statusCode = response.statusCode;
    self.lastError = error;

	return self.lastError;
}

@end
