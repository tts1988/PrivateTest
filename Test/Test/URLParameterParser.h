//
//  URLParameterParser.h
//  Test
//
//  Created by tangtianshuai on 2017/8/15.
//  Copyright © 2017年 tangtianshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 * URL解析为key value
 *
 */
@interface URLParameterParser : NSObject

+ (NSDictionary *)parserParametersFromURL:(NSString *)urlString;

@end
