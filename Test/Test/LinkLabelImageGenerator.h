//
//  LinkLabelImageGenerator.h
//  Test
//
//  Created by tangtianshuai on 2017/4/19.
//  Copyright © 2017年 tangtianshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *
 * 根据url返回对应网址的logo
 *
 */
@interface LinkLabelImageGenerator : NSObject

/**
 * 根据url返回对应网址的logo
 *
 * @param urlString 需要关联的图片的url
 *
 * @return 网站icon
 */
+ (UIImage *)imageWithUrlString:(NSString *)urlString;


/**
 * 根据linkLabel返回对应网址的logo
 *
 * @param linkLabel 需要关联的图片的linkLabel
 *
 * @return 网站icon
 */
+ (UIImage *)imageWithLinkLabel:(NSString *)linkLabel;

@end
