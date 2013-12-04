//
//  CCGroupModel.h
//  missinglink
//
//  Created by Leonardo Lobato on 04/12/13.
//  Copyright (c) 2013 Fanatee. All rights reserved.
//

#import "CCModel.h"

@interface CCGroupModel : CCModel

@property (nonatomic, strong) NSArray *models;

@property (nonatomic, strong, readonly) NSMutableArray *modelsWhichFailedLoadingErrors; // NSError *

@end
