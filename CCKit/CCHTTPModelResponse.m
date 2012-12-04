//
//  CCHTTPModelResponse.m
//  CCKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "CCHTTPModelResponse.h"

@implementation CCHTTPModelResponse

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
        CCLog(@"Invalid server response:\n%@", responseString);
        NSError *error = [NSError errorWithDomain:kCCModelErrorHTTPDomain
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
            CCDebug(@"Error parsing JSON object: %@", e);
            NSError *error = [NSError errorWithDomain:kCCModelErrorDomain
                                                 code:kCCModelErrorCodeInternal
                                             userInfo:[NSDictionary dictionaryWithObject:@"Couldn't parse server response."
                                                                                  forKey:NSLocalizedDescriptionKey]];
            self.lastError = error;
        }
    }
    
	return _lastError;
}

@end
