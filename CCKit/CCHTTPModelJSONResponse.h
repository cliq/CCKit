//
//  CCHTTPModelJSONResponse.h
//  CCKit
//
//  Created by Leonardo Lobato on 29/10/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import "CCHTTPModelResponse.h"

@interface CCHTTPModelJSONResponse : CCHTTPModelResponse

@property (nonatomic, strong) id parsedResponse;

// To override:
- (NSError *)parseJSON:(id)jsonBody;

@end
