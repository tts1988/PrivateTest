//
//  LocationTransformer.m
//  BYGVigourBox
//
//  Created by tangtianshuai on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LocationTransformer.h"


static const double a = 6378245.0;

static const double ee = 0.00669342162296594323;

static const double pi = M_PI;

static const double xPi = M_PI  * 3000.0 / 180.0;


@implementation LocationTransformer

+ (CLLocationCoordinate2D)transformLocation:(CLLocationCoordinate2D)fromLocation fromType:(CoordinateType)fromType toType:(CoordinateType)toType
{
    
    if (fromType!=toType)
    {
        CLLocationCoordinate2D toLocation;
        
        switch (fromType)
        {
            case LocationTypeBD_09:
            {
                if (toType==LocationTypeWGS_84)
                {
                    toLocation=[self transformLocationFromBD_09ToWGS_84:fromLocation];
                }
                else
                {
                    toLocation=[self transformLocationFromBD_09ToGCJ_02:fromLocation];
                }
            }
                break;
                
            case LocationTypeGCJ_02:
            {
                if (toType==LocationTypeWGS_84)
                {
                    toLocation=[self transformLocationFromGCJ_02ToWGS_84:fromLocation];
                }
                else
                {
                    toLocation=[self transformLocationFromGCJ_02ToBD_09:fromLocation];
                }
            }
                break;
                
            case LocationTypeWGS_84:
            {
                if (toType==LocationTypeGCJ_02)
                {
                    toLocation=[self transformLocationFromWGS_84ToGCJ_02:fromLocation];
                }
                else
                {
                    toLocation=[self transformLocationFromWGS_84ToBD_09:fromLocation];
                }
            }
                break;
                
            default:
                break;
        }
        
        return toLocation;
    }
    else
    {
        return fromLocation;
    }
    
}

#pragma mark-百度坐标偏移标准转国际标准
+ (CLLocationCoordinate2D)transformLocationFromBD_09ToWGS_84:(CLLocationCoordinate2D)fromLocation
{
    CLLocationCoordinate2D start_coor = [self transformLocationFromBD_09ToGCJ_02:fromLocation];
    
    CLLocationCoordinate2D end_coor = [self transformLocationFromGCJ_02ToWGS_84:start_coor];
    
    return end_coor;
}


#pragma mark-百度坐标偏移标准转中国坐标偏移标准
+ (CLLocationCoordinate2D)transformLocationFromBD_09ToGCJ_02:(CLLocationCoordinate2D)fromLocation
{
    double x = fromLocation.longitude - 0.0065, y = fromLocation.latitude - 0.006;
    
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);
    
    double theta = atan2(y, x) - 0.000003 * cos(x * xPi);
    
    CLLocationCoordinate2D toLocation;
    
    toLocation.latitude  = z * sin(theta);
    
    toLocation.longitude = z * cos(theta);
    
    return toLocation;
}

#pragma mark-中国坐标偏移标准转国际标准
+ (CLLocationCoordinate2D)transformLocationFromGCJ_02ToWGS_84:(CLLocationCoordinate2D)fromLocation
{
    double threshold = 0.00001;
    
    // The boundary
    double minLat = fromLocation.latitude - 0.5;
    
    double maxLat = fromLocation.latitude + 0.5;
    
    double minLng = fromLocation.longitude - 0.5;
    
    double maxLng = fromLocation.longitude + 0.5;
    
    double delta = 1;
    
    int maxIteration = 30;
    
    // Binary search
    while(true)
    {
        CLLocationCoordinate2D leftBottom  = [self transformLocationFromWGS_84ToGCJ_02:(CLLocationCoordinate2D){.latitude = minLat,.longitude = minLng}];
        
        CLLocationCoordinate2D rightBottom = [[self class] transformLocationFromWGS_84ToGCJ_02:(CLLocationCoordinate2D){.latitude = minLat,.longitude = maxLng}];
        
        CLLocationCoordinate2D leftUp      = [[self class] transformLocationFromWGS_84ToGCJ_02:(CLLocationCoordinate2D){.latitude = maxLat,.longitude = minLng}];
        
        CLLocationCoordinate2D midPoint    = [[self class] transformLocationFromWGS_84ToGCJ_02:(CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2),.longitude = ((minLng + maxLng) / 2)}];
        
        delta = fabs(midPoint.latitude - fromLocation.latitude) + fabs(midPoint.longitude - fromLocation.longitude);
        
        if(maxIteration-- <= 0 || delta <= threshold)
        {
            return (CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2),.longitude = ((minLng + maxLng) / 2)};
        }
        
        if(isContains(fromLocation, leftBottom, midPoint))
        {
            maxLat = (minLat + maxLat) / 2;
            
            maxLng = (minLng + maxLng) / 2;
        }
        else if(isContains(fromLocation, rightBottom, midPoint))
        {
            maxLat = (minLat + maxLat) / 2;
            
            minLng = (minLng + maxLng) / 2;
        }
        else if(isContains(fromLocation, leftUp, midPoint))
        {
            minLat = (minLat + maxLat) / 2;
            
            maxLng = (minLng + maxLng) / 2;
        }
        else
        {
            minLat = (minLat + maxLat) / 2;
            
            minLng = (minLng + maxLng) / 2;
        }
    }
    
}

#pragma mark-中国坐标偏移标准转百度坐标偏移标准
+ (CLLocationCoordinate2D)transformLocationFromGCJ_02ToBD_09:(CLLocationCoordinate2D)fromLocation
{
    CLLocationCoordinate2D toLocation;
    
//    NSDictionary *dict= BMKConvertBaiduCoorFrom(fromLocation, BMK_COORDTYPE_COMMON);
//    
//    return BMKCoorDictionaryDecode(dict);
    
    return toLocation;
}


#pragma mark-国际标准转中国坐标偏移标准
+ (CLLocationCoordinate2D)transformLocationFromWGS_84ToGCJ_02:(CLLocationCoordinate2D)fromLocation
{
    CLLocationCoordinate2D toLocation;
    
 
    double adjustLat = [self transformLatWithX:fromLocation.longitude - 105.0 withY:fromLocation.latitude - 35.0];
    
    double adjustLon = [self transformLonWithX:fromLocation.longitude - 105.0 withY:fromLocation.latitude - 35.0];
    
    long double radLat = fromLocation.latitude / 180.0 * pi;
    
    long double magic = sin(radLat);
    
    magic = 1 - ee * magic * magic;
    
    long double sqrtMagic = sqrt(magic);
    
    adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    
    adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    
    toLocation.latitude = fromLocation.latitude + adjustLat;
    
    toLocation.longitude = fromLocation.longitude + adjustLon;
    
    
    return toLocation;
}

#pragma mark-国际标准转百度坐标偏移标准
+ (CLLocationCoordinate2D)transformLocationFromWGS_84ToBD_09:(CLLocationCoordinate2D)fromLocation
{
    //NSDictionary *dict= BMKConvertBaiduCoorFrom(fromLocation, BMK_COORDTYPE_GPS);
    
    return fromLocation;
}



#pragma mark - 判断某个点point是否在p1和p2之间
static bool isContains(CLLocationCoordinate2D point, CLLocationCoordinate2D p1, CLLocationCoordinate2D p2) {
    return (point.latitude >= MIN(p1.latitude, p2.latitude) && point.latitude <= MAX(p1.latitude, p2.latitude)) && (point.longitude >= MIN(p1.longitude,p2.longitude) && point.longitude <= MAX(p1.longitude, p2.longitude));
}


+ (double)transformLatWithX:(double)x withY:(double)y {
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

+ (double)transformLonWithX:(double)x withY:(double)y {
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}


@end
