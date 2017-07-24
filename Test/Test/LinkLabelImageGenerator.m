//
//  LinkLabelImageGenerator.m
//  Test
//
//  Created by tangtianshuai on 2017/4/19.
//  Copyright © 2017年 tangtianshuai. All rights reserved.
//

#import "LinkLabelImageGenerator.h"

@implementation LinkLabelImageGenerator

+ (UIImage *)imageWithUrlString:(NSString *)urlString
{
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:urlString];
    
    NSString *host=url.host;
    
    __block NSString *linkLabel=@"3";
    
    NSDictionary *dict=@{@"taobao":@"1",@"jd":@"2"};
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        if ([host caseInsensitiveCompare:key])
        {
            linkLabel=obj;
            
            *stop=YES;
        }
        
    }];
    
    return [self imageWithLinkLabel:linkLabel];
}

+ (UIImage *)imageWithLinkLabel:(NSString *)linkLabel
{
    NSDictionary *dict=@{@"1":@"taobao",@"2":@"jd",@"3":@"other"};
    
    return [UIImage imageNamed:dict[linkLabel]];
}

@end
