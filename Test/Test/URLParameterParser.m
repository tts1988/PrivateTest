//
//  URLParameterParser.m
//  Test
//
//  Created by tangtianshuai on 2017/8/15.
//  Copyright © 2017年 tangtianshuai. All rights reserved.
//

#import "URLParameterParser.h"

@implementation URLParameterParser

+ (NSDictionary *)parserParametersFromURL:(NSString *)urlString
{
    NSString *url=[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSRange range=[url rangeOfString:@"?"];
    
    if (range.location==NSNotFound)
    {
        return nil;
    }
    else
    {
        NSString *propertys=[url substringFromIndex:range.location+1];
        
        NSArray *keyValues=[propertys componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
        
        for (NSString *keyValue in keyValues)
        {
            NSArray *keyValueArray=[keyValue componentsSeparatedByString:@"="];
            
            if (keyValueArray.count==2)
            {
                [parameters setValue:keyValueArray[1] forKey:keyValueArray[0]];
            }
        }
        
        return parameters;
    }
    
    
}

@end
