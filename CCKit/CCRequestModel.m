//
//  CCRequestModel.m
//  CCKit
//
//  Created by Leonardo Lobato on 29/10/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import "CCRequestModel.h"
#import "CCDefines.h"

#import "NSURLRequest+cURL.h"

@interface CCRequestModel ()

@property (nonatomic, readwrite, getter = isLoadingStubData) BOOL loadingStubData;

@property (nonatomic, readwrite, strong) NSURLConnection *connection;

@end

@implementation CCRequestModel

@synthesize response = _response;

- (id)init
{
    self = [super init];
    if (self) {
        self.timeoutInterval = 60;
        self.requestMethod = @"GET";
    }
    return self;
}

#pragma mark - Support methods

- (NSMutableString *)urlRepresentationForObject:(NSDictionary *)params;
{
    return [self urlRepresentationForObject:params withKeys:nil];
}

- (NSMutableString *)urlRepresentationForObject:(NSDictionary *)params withKeys:(NSArray *)keys;
{
    NSMutableString *urlString = [NSMutableString string];
    
    if (!keys) {
        keys = [[params allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    int i=0;
    for (NSString *key in keys) {
        id valueObject = [params objectForKey:key];
        if (!valueObject)
            continue;
        NSString *stringValue = nil;
        NSArray *values = nil;
        
        // Look for an array of values or a single value
        if ([valueObject isKindOfClass:[NSArray class]]) {
            values = (NSArray *)valueObject;
        } else {
            values = [NSArray arrayWithObject:valueObject];
        }
        
        for (id object in values) {
            if (i++>0)
                [urlString appendString:@"&"];
            
            if ([object isKindOfClass:[NSString class]]) {
                stringValue = (NSString *)object;
            } else if ([object respondsToSelector:@selector(stringValue)]) {
                stringValue = [object stringValue];
            }
            
            if (!stringValue)
                continue;
            
            // TODO: validate memory management with __bridge
            NSString *value = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                          (CFStringRef)stringValue,
                                                                                          NULL,
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8);
            [urlString appendFormat:@"%@=%@", key, value];
        }
    }
    
    return urlString;
}


#pragma mark - Queue

- (NSOperationQueue *)requestQueue;
{
    if (!_requestQueue) {
        _requestQueue = [NSOperationQueue mainQueue];
    }
    return _requestQueue;
}

#pragma mark - Response

- (NSString *)contentType;
{
    return @"application/x-www-form-urlencoded";
}

- (NSMutableDictionary *)requestHeaders;
{
    NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary];
    if (self.contentType) {
        [requestHeaders setObject:self.contentType forKey:@"Content-type"];
    }
    return requestHeaders;
}

- (BOOL)usePostBody;
{
	NSString *method = [self requestMethod];
	return ([method isEqualToString:@"POST"]);
}

- (CCHTTPModelResponse *)newResponseObject;
{
    return [[CCHTTPModelResponse alloc] init];
}

#pragma mark Public

- (void)loadMore:(BOOL)more;
{
    [self load:NSURLRequestUseProtocolCachePolicy
          more:more];
}

- (void)reset;
{
    [super reset];
    
    [self cancel];
    
    self.response = nil;
    _isLoadingMore = NO;
    _isLoaded = NO;
    _connectionResponse = nil;
    _connectionResponseData = nil;
}

- (void)cancel;
{
    if (self.isLoading) {
        CCDebug(@"Canceling %@", self);
        [self.connection cancel];
        
        if (self.connection) {
            self.connection = nil;
            [self didCancelLoad];
        }
    }
}

- (void)load:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more;
{
    // TODO: cache policy
    
	if ([self isLoading]) {
        CCLog(@"Model request already in progress: %@", self);
        return;
    }
    
    _isLoadingMore = more;
    
	if (!self.response) {
		self.response = [self newResponseObject];
    }
	
	// Test the resulting URL
    NSURL *url = [self requestUrl];
	if (!url) {
        NSError *error = [NSError errorWithDomain:kCCModelErrorDomain
											 code:kCCModelErrorCodeInternal
										 userInfo:[NSDictionary dictionaryWithObject:@"Unable to create request URL." forKey:NSLocalizedDescriptionKey]];
		[self didFailLoadWithError:error];
        return;
    }
	
	NSString *method = [self requestMethod];
	
    CCLog(@"%@: Request URL (%@): %@", self, method, url);
    
	// Make request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:cachePolicy
                                                       timeoutInterval:self.timeoutInterval];
	request.HTTPMethod = method;
    
    NSMutableDictionary *requestHeaders = [self requestHeaders];
	
	if ([self usePostBody]) {
        NSData *httpBody = [self postBody];
        if (httpBody) {
            [request setHTTPBody:httpBody];
        }
        
	}
    
    for (NSString *key in requestHeaders) {
        id value = [requestHeaders objectForKey:key];
        [request setValue:value forHTTPHeaderField:key];
    }
    
#if DEBUG
    NSString *curl = [request curlDescription];
    CCLog(@"%@: %@", self, curl);
#endif
    
    // Clear
    _connectionResponse = nil;
    _connectionResponseData = nil;
    
#if kCCHTTPModelUseStubData
    // Check for stub data
    NSString *stubJson = [self stubJsonResponse];
    if (stubJson) {
        self.loadingStubData = YES;
        [self performSelector:@selector(didStartLoad)
                   withObject:nil
                   afterDelay:0.1];
        [self performSelector:@selector(processStubResponse:)
                   withObject:stubJson
                   afterDelay:1.0];
        return;
    }
#endif
    
    // Create the request
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.connection cancel];
    
    self.connection = connection;
    [self.connection start];
    
    if (self.connection==connection) {
        [self didStartLoad];
    }
}

#pragma mark - CCModel

- (BOOL)isLoading;
{
    return (self.connection!=nil || self.isLoadingStubData);
}

- (BOOL)isLoadingMore;
{
    return _isLoadingMore;
}

- (BOOL)isLoaded;
{
    return _isLoaded;
}

- (void)didFinishLoad;
{
    [super didFinishLoad];
    
    _isLoadingMore = NO;
}

- (void)didFailLoadWithError:(NSError *)error;
{
    [super didFailLoadWithError:error];
    
    _isLoadingMore = NO;
}

- (void)didCancelLoad;
{
    [super didCancelLoad];
    
    _isLoadingMore = NO;
}

#pragma mark - Stub data

- (void)processStubResponse:(NSString *)json;
{
    self.loadingStubData = NO;
    
    NSURL *url = [self requestUrl];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:200
                                                             HTTPVersion:nil
                                                            headerFields:nil];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    [self parseResponse:response withData:data];
}

// Override if needed
- (NSString *)stubJsonResponse;
{
    return nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    if (self.connection!=connection) {
        return;
    }
    
    self.connection = nil;
    
    if (error.domain==NSURLErrorDomain && error.code==NSURLErrorCancelled) {
        [self didCancelLoad];
    } else {
        [self didFailLoadWithError:error];
    }
}

- (void)parseResponse:(NSHTTPURLResponse *)response withData:(NSData *)data;
{
    // Only clear response when we got data back from server.
    if (!self.isLoadingMore) {
        [self.response clear];
    }
    
    NSError *error = [self.response parseResponse:response
                                         withData:data
                                            error:nil];
    
    if (error) {
        [self didFailLoadWithError:error];
    } else {
        _isLoaded = YES;
        [self didFinishLoad];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    if (self.connection!=connection) {
        return;
    }

    self.connection = nil;
    
    [self parseResponse:(NSHTTPURLResponse *)_connectionResponse
               withData:_connectionResponseData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    if (self.connection!=connection) {
        return;
    }

    _connectionResponse = response;
    _connectionResponseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    if (self.connection!=connection) {
        return;
    }

    [_connectionResponseData appendData:data];
}

@end
