//
//  CCHTTPModel.m
//  CCKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "CCHTTPModel.h"

@interface CCHTTPModel ()

@property (nonatomic, readwrite, getter = isLoadingStubData) BOOL loadingStubData;

@property (nonatomic, readonly) NSString *baseUrl;
@property (nonatomic, readonly) NSString *resource;
@property (nonatomic, readonly) NSString *requestMethod;
@property (nonatomic, readonly) NSString *contentType;

@end

@implementation CCHTTPModel

- (id)init
{
    self = [super init];
    if (self) {
        self.timeoutInterval = 60;
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


#pragma mark - Private

- (NSMutableString *)queryUrl;
{
	// Base URL with resource, if available
	NSMutableString *urlString = [[self baseUrl] mutableCopy];
	NSString *resource = [self resource];
	if (resource.length>0) {
		[urlString appendString:resource];
	}
	
	// Query parameters
	if ([[self requestMethod] isEqualToString:@"GET"]) {
        NSDictionary *params = [self queryStringParameters];
        NSString *paramsString = [self urlRepresentationForObject:params];
        if (paramsString.length>0) {
            [urlString appendFormat:@"?%@", paramsString];
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


#pragma mark - To override

- (NSString *)baseUrl;
{
    return nil;
}

- (NSString *)resource;
{
    return nil;
}

- (NSString *)requestMethod;
{
    return @"GET";
}

- (NSString *)contentType;
{
    return @"application/x-www-form-urlencoded";
}

- (NSMutableDictionary *)queryStringParameters;
{
    NSMutableDictionary *queryStringParameters = [NSMutableDictionary dictionary];
    return queryStringParameters;
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

    _isLoadingMore = NO;
    _isLoaded = NO;
    _connectionResponse = nil;
    _connectionResponseData = nil;
    _isOutdated = NO;
}

- (void)cancel;
{
    if (self.isLoading) {
        [_connection cancel];
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
	
	if (!_response) {
		self.response = [self newResponseObject];
    }
	
	if (!more) {
        [self.response clear];
    }
    
    NSMutableString *urlString = [self queryUrl];
	
	// Test the resulting URL
    NSURL *url = [NSURL URLWithString:urlString];
	if (!url) {
        NSError *error = [NSError errorWithDomain:kCCModelErrorDomain
											 code:kCCModelErrorCodeInternal
										 userInfo:[NSDictionary dictionaryWithObject:@"Unable to create request URL." forKey:NSLocalizedDescriptionKey]];
		[self didFailLoadWithError:error];
        return;
    }
	
	NSString *method = [self requestMethod];
	
    CCLog(@"Request URL (%@): %@", method, url);
    
	// Make request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:cachePolicy
                                                       timeoutInterval:self.timeoutInterval];
	request.HTTPMethod = method;
	
	if ([method isEqualToString:@"POST"]) {
        NSDictionary *params = [self queryStringParameters];
        NSMutableString *paramsString = [self urlRepresentationForObject:params];
		if (paramsString.length>0) {
            if (self.contentType) {
                [request setValue:self.contentType forHTTPHeaderField:@"content-type"];
            }
            
            CCLog(@"POST body:\n%@", paramsString);
            NSData *httpBody = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPBody:httpBody];
        }
        
	}

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
    [_connection cancel];
    _connection = connection;
    [_connection start];
}

#pragma mark - CCModel

- (BOOL)isLoading;
{
    return (_connection!=nil || self.isLoadingStubData);
}

- (BOOL)isLoadingMore;
{
    return _isLoadingMore;
}

- (BOOL)isOutdated;
{
    return _isOutdated;
}

- (BOOL)isLoaded;
{
    return _isLoaded;
}

#pragma mark - Stub data

- (void)processStubResponse:(NSString *)json;
{
    self.loadingStubData = NO;
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil
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
    if (error.domain==NSURLErrorDomain && error.code==NSURLErrorCancelled) {
        [self didCancelLoad];
    } else {
        [self didFailLoadWithError:error];
    }
    _connection = nil;
}

- (void)parseResponse:(NSHTTPURLResponse *)response withData:(NSData *)data;
{
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
    [self parseResponse:(NSHTTPURLResponse *)_connectionResponse
               withData:_connectionResponseData];
    
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    _connectionResponse = response;
    _connectionResponseData = [[NSMutableData alloc] init];

    [self didStartLoad];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    [_connectionResponseData appendData:data];
}

#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)requestDidStartLoad:(TTURLRequest*)request {
//    [_loadingRequest release];
//    _loadingRequest = [request retain];
//    [self didStartLoad];
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)requestDidFinishLoad:(TTURLRequest*)request {
//    if (!self.isLoadingMore) {
//        [_loadedTime release];
//        _loadedTime = [request.timestamp retain];
//        self.cacheKey = request.cacheKey;
//    }
//    
//    TT_RELEASE_SAFELY(_loadingRequest);
//    [self didFinishLoad];
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
//    TT_RELEASE_SAFELY(_loadingRequest);
//    [self didFailLoadWithError:error];
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)requestDidCancelLoad:(TTURLRequest*)request {
//    TT_RELEASE_SAFELY(_loadingRequest);
//    [self didCancelLoad];
//}
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (float)downloadProgress {
//    if ([self isLoading]) {
//        if (!_loadingRequest.totalContentLength) {
//            return 0;
//        }
//        return (float)_loadingRequest.totalBytesDownloaded / (float)_loadingRequest.totalContentLength;
//    }
//    return 0.0f;
//}


@end
