//
//  CCHTTPModel.m
//  CCKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "CCHTTPModel.h"

#import "CCHTTPModelJSONResponse.h"

@interface CCHTTPModel ()

@property (nonatomic, strong, readonly) NSString *baseUrl;
@property (nonatomic, strong, readonly) NSString *resource;

@end

@implementation CCHTTPModel

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
            
            NSMutableCharacterSet *allowed = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
            [allowed removeCharactersInString:@"!*'();:@&=+$,/?%#[]"];
            NSString *value = [stringValue stringByAddingPercentEncodingWithAllowedCharacters:allowed];
            [urlString appendFormat:@"%@=%@", key, value];
        }
    }
    
    return urlString;
}


#pragma mark - Private

- (NSURL *)requestUrl;
{
    if (!_requestUrl) {
        // Base URL with resource, if available
        NSURL *baseUrl = [NSURL URLWithString:[self baseUrl]];
        NSString *resource = [self resource];
        if (resource.length>0) {
            baseUrl = [baseUrl URLByAppendingPathComponent:resource];
        }
        NSMutableString *urlString = [[baseUrl absoluteString] mutableCopy];
        
        // Query parameters
        if (![self usePostBody]) {
            // GET, PUT
            NSDictionary *params = [self queryStringParameters];
            NSString *paramsString = [self urlRepresentationForObject:params];
            if (paramsString.length>0) {
                [urlString appendFormat:@"?%@", paramsString];
            }
        }
        
        return [NSURL URLWithString:urlString];
    } else {
        return _requestUrl;
    }
}

#pragma mark - To override

- (BOOL)isOutdated;
{
    return _isOutdated;
}

- (NSString *)baseUrl;
{
    return nil;
}

- (NSString *)resource;
{
    return nil;
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

- (NSData *)postBody;
{
    NSDictionary *params = [self queryStringParameters];
    NSMutableString *paramsString = [self urlRepresentationForObject:params];
    NSData *httpBody = nil;
    if (paramsString.length>0) {
        httpBody = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
    }
    return httpBody;
}

- (CCHTTPModelResponse *)newResponseObject;
{
    return [[CCHTTPModelJSONResponse alloc] init];
}

#pragma mark Public

- (void)reset;
{
    [super reset];
    _isOutdated = NO;
}

#pragma mark - CCModel

- (void)didFinishLoad;
{
    _isOutdated = NO;
    
    [super didFinishLoad];
}

@end
