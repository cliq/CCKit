//
//  CCZipper.h
//  MerriamWebster
//
//  Created by Leonardo Lobato on 06/09/16.
//  Copyright © 2016 Cliq Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCZipper : NSObject

+ (NSData *)gzipInflate:(NSData*)data;
+ (NSData *)gzipDeflate:(NSData*)data;

@end
