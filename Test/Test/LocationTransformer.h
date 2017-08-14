//
//  LocationTransformer.h
//  BYGVigourBox
//
//  Created by tangtianshuai on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger,CoordinateType){
    
    LocationTypeBD_09  = 1,//百度坐标偏移标准
    
    LocationTypeGCJ_02 = 2,//中国坐标偏移标准
    
    LocationTypeWGS_84 = 3,//国际标准
    
};

/**
 *
 * 地图坐标转换
 *
 */
@interface LocationTransformer : NSObject

+ (CLLocationCoordinate2D)transformLocation:(CLLocationCoordinate2D)fromLocation fromType:(CoordinateType)fromType toType:(CoordinateType)toType;


@end
