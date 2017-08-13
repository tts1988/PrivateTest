//
//  WaterWaveProgressView.h
//  Test
//
//  Created by tangtianshuai on 2017/7/27.
//  Copyright © 2017年 tangtianshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterWaveProgressView : UIView

//容器填充色
@property (nonatomic, strong) UIColor *border_fillColor;

//容器描边色
@property (nonatomic, strong) UIColor *border_strokeColor;

//前方波纹颜色
@property (nonatomic, strong) UIColor *topColor;

//后方波纹颜色
@property (nonatomic, strong) UIColor *bottomColor;

/**
 * 设置进度
 *
 * @param progress   进度
 *
 * @param animation  是否动画
 *
 */
- (void)setProgress:(float)progress animation:(BOOL)animation;

@end
