//
//  LocationReportModel.m
//  SixFeetLanePro
//
//  Created by JinLiang on 14/12/1.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import "LocationReportModel.h"
#import "Headers.h"
#import <AMapSearchKit/AMapSearchAPI.h>
@implementation LocationReportModel

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        self.mapLocation = [MapLocation sharedObject];
        _mapLocation.delegate = self;
    }
    return self;
}

+ (id)reportSharedModel
{
    static id reportSharedModel;
    
    @synchronized(self) {
        if (!reportSharedModel) {
            reportSharedModel = [[self alloc] init];
        }
        return reportSharedModel;
    }
}

- (void)dealloc
{
    _mapLocation=nil;
}


#pragma mark - private

- (void)reportWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    //网服务器上报经纬度 在这里写
    
    DLog(@"latitude%@",latitude);
    DLog(@"longitude%@",longitude);
   
    [[CommClass sharedCommon]setObject:longitude forKey:LOCATIONINFO];
}

- (void)fixAndReport
{
    if (!_mapLocation.isFixing) {
        [_mapLocation start];
    }
}

- (void)fixAndReport1
{
    if (!_mapLocation.isFixing) {
        [_mapLocation maggnerIsOpenLocation];
    }
}


#pragma mark - public

+ (void)fixAndReport
{
    [[self reportSharedModel] fixAndReport];
}

+(void)fixLocation
{
   [[self reportSharedModel] fixAndReport1];
}

//判断用户是否登录
+ (BOOL)isPositioningSuccess
{
    NSString *longitude =[[CommClass sharedCommon] objectForKey:LOCATIONINFO];
    
    return ([longitude intValue]>0);
}


#pragma mark - MapLocationDelegate
//定位成功处理
- (void)mapLocation:(MapLocation *)mapLocation fixDidFinishWith:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
//    CLLocation *newLocation=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
//    //   通过经纬度定位城市：
//    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        
//        for (CLPlacemark * placemark in placemarks) {
//            
//            NSString *currentCity = placemark.locality;
//             [[CommClass sharedCommon]setObject:currentCity forKey:CURRENTCITY];
////            NSDictionary * addressDic =placemark.addressDictionary;
//            if ([DataCheck isValidString:placemark.thoroughfare]) {
////                NSString * address = [NSString stringWithFormat:@"%@%@%@",placemark.locality,placemark.subLocality,placemark.thoroughfare];
////                NSDictionary * dic = @{@"area":address,@"address":placemark.name,};
////                [[CommClass sharedCommon] setObject:dic forKey:CURRENTADDRESS];
//            }else{
////                NSString * address = [NSString stringWithFormat:@"%@%@",placemark.locality,placemark.subLocality];
////                NSDictionary * dic = @{@"area":address,@"address":placemark.name,};
////                [[CommClass sharedCommon] setObject:dic forKey:CURRENTADDRESS];
//
//            }  
//        }
//    }];
    NSString *lat = [NSString stringWithFormat:@"%f", latitude];
    NSString *lng = [NSString stringWithFormat:@"%f", longitude];
    
    [self reportWithLatitude:lat longitude:lng];
    
    NSDictionary *dic = @{@"lat":lat, @"lng":lng};
    [self.delegate locationReportSuccess:dic];
}
//定位失败处理
- (void)mapLocation:(MapLocation *)mapLocation fixDidFailed:(NSString *)reason
{
    [self.delegate locationReportfaile];
}


@end
