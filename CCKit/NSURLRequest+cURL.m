//
//  NSURLRequest+cURL.m
//  CCKit
//
//  Created by Leonardo Lobato on 26/09/19.
//  Copyright © 2019 Cliq Consulting. All rights reserved.
//

#import "NSURLRequest+cURL.h"

@implementation NSURLRequest (cURL)

- (NSString *)curlDescription;
{
    __block NSMutableString *displayString = [NSMutableString stringWithFormat:@"curl -v -X %@", self.HTTPMethod];
    
    [displayString appendFormat:@" \'%@\'",  self.URL.absoluteString];
    
    [self.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
        [displayString appendFormat:@" -H \'%@: %@\'", key, val];
    }];
    
    if ([self.HTTPMethod isEqualToString:@"POST"] ||
        [self.HTTPMethod isEqualToString:@"PUT"] ||
        [self.HTTPMethod isEqualToString:@"PATCH"]) {
        
        [displayString appendFormat:@" -d \'%@\'",
         [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding]];
    }
    
    return displayString;
}

@end
