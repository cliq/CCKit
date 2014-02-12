//
//  CCHTTPModelJSONResponse.m
//  CCKit
//
//  Created by Leonardo Lobato on 29/10/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import "CCHTTPModelJSONResponse.h"

#import "CCDefines.h"

@implementation CCHTTPModelJSONResponse

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
    [super clear];
    self.parsedResponse = nil;
}


#pragma mark -
#pragma mark TTURLResponse

- (NSError *)parseResponse:(NSHTTPURLResponse *)response withData:(NSData *)responseData error:(NSError *)error;
{
    [super parseResponse:response withData:responseData error:error];
    
    // Create object based on JSON string
    NSError *jsonParsingError = nil;
    id jsonBody = [NSJSONSerialization JSONObjectWithData:responseData
                                                  options:0
                                                    error:&jsonParsingError];
    
    if (!jsonBody) {
        // Not a valid JSON string.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
        CCLog(@"Invalid server response:\n%@", responseString);
        NSError *error = [NSError errorWithDomain:kCCModelErrorHTTPDomain
                                             code:self.statusCode
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
    
	return self.lastError;
}

@end
