//
//  AFHTTPModelResponse.m
//  AFKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "AFHTTPModelResponse.h"

@implementation AFHTTPModelResponse

@synthesize parsedResponse = _parsedResponse;

#pragma mark -
#pragma mark To override

- (NSError *)parseJSON:(id)jsonBody;
{
    self.parsedResponse = jsonBody;
    
    return nil;
}

- (void)clear;
{
    self.parsedResponse = nil;
}


#pragma mark -
#pragma mark TTURLResponse


- (NSError *)parseResponse:(NSHTTPURLResponse *)response withData:(NSData *)responseData error:(NSError *)error;
{
    self.statusCode = response.statusCode;
    
    // Create object based on JSON string
    NSError *jsonParsingError = nil;
    id jsonBody = [NSJSONSerialization JSONObjectWithData:responseData
                                                  options:0
                                                    error:&jsonParsingError];
    
    if (!jsonBody) {
        // Not a valid JSON string.
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        AFLog(@"Invalid server response:\n%@", responseString);
        NSError *error = [NSError errorWithDomain:kAFModelErrorHTTPDomain
                                             code:_statusCode
                                         userInfo:[NSDictionary dictionaryWithObject:@"Invalid server response."
                                                                              forKey:NSLocalizedDescriptionKey]];
        self.lastError = error;
    } else {
        self.lastError = nil;
        
        @try {
            // Parse the JSON object.
            self.lastError = [self parseJSON:jsonBody];
            
        } @catch (NSException *e) {
            AFDebug(@"Error parsing JSON object: %@", e);
            NSError *error = [NSError errorWithDomain:kAFModelErrorDomain
                                                 code:kAFModelErrorCodeInternal
                                             userInfo:[NSDictionary dictionaryWithObject:@"Couldn't parse server response."
                                                                                  forKey:NSLocalizedDescriptionKey]];
            self.lastError = error;
        }
    }
    
	return _lastError;
}

@end
