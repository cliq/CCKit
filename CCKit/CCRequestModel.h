//
//  CCRequestModel.h
//  CCKit
//
//  Created by Leonardo Lobato on 29/10/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import "CCModel.h"

#import "CCHTTPModelResponse.h"

@interface CCRequestModel : CCModel {
    BOOL _isLoadingMore;
    BOOL _isLoaded;
    
    NSURL *_requestUrl;
    
    NSMutableData *_connectionResponseData;
    NSURLResponse *_connectionResponse;
}

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong) NSOperationQueue *requestQueue;
@property (nonatomic, strong) CCHTTPModelResponse *response;

@property (nonatomic, strong) NSURL *requestUrl;
@property (nonatomic, strong) NSString *requestMethod;
@property (nonatomic, assign) BOOL usePostBody;
@property (nonatomic, strong) NSData *postBody;
@property (nonatomic, strong, readonly) NSString *contentType;

@property (nonatomic, readonly, strong) NSURLSession *session;
@property (nonatomic, readonly, strong) NSURLSessionDownloadTask *downloadTask;

- (void)setURLSessionConfiguration:(NSURLSessionConfiguration *)configuration;
- (void)load:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more;

// Protected:
- (void)willStartDownloadTask:(NSURLSessionDownloadTask *)downloadTask;
- (void)parseResponse:(NSHTTPURLResponse *)response withData:(NSData *)data;
- (NSMutableDictionary *)requestHeaders;
- (CCHTTPModelResponse *)newResponseObject;
- (NSString *)stubJsonResponse;

@end
