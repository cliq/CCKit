//
//  AFHTTPModel.h
//  AFKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "AFModel.h"

#import "AFHTTPModelResponse.h"

@interface AFHTTPModel : AFModel {
    BOOL _isOutdated;
    BOOL _isLoadingMore;
    BOOL _isLoaded;
    
    NSMutableData *_connectionResponseData;
    NSURLResponse *_connectionResponse;
}

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, retain) NSOperationQueue *requestQueue;
@property (nonatomic, retain) AFHTTPModelResponse *response;

// Protected:
@property (nonatomic, readonly) NSURLConnection *connection;
- (NSMutableDictionary *)queryStringParameters;

@end
