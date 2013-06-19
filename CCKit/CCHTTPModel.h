//
//  CCHTTPModel.h
//  CCKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "CCModel.h"

#import "CCHTTPModelResponse.h"

@interface CCHTTPModel : CCModel {
    BOOL _isOutdated;
    BOOL _isLoadingMore;
    BOOL _isLoaded;
    
    NSMutableData *_connectionResponseData;
    NSURLResponse *_connectionResponse;
}

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, retain) NSOperationQueue *requestQueue;
@property (nonatomic, retain) CCHTTPModelResponse *response;

- (void)load:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more;


// Protected:
@property (nonatomic, readonly, strong) NSURLConnection *connection;
- (NSMutableDictionary *)queryStringParameters;
- (NSString *)stubJsonResponse;
- (CCHTTPModelResponse *)newResponseObject;
- (NSData *)postBody;

@end
