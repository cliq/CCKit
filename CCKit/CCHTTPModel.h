//
//  CCHTTPModel.h
//  CCKit
//
//  Created by Leonardo Lobato on 12/3/12.
//  Copyright (c) 2012 Cliq Consulting. All rights reserved.
//

#import "CCRequestModel.h"

#import "CCHTTPModelResponse.h"

@interface CCHTTPModel : CCRequestModel {
    BOOL _isOutdated;
}

// Protected:
- (NSMutableDictionary *)queryStringParameters;

@end
