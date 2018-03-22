//
//  LocationReportModel.h
//  SixFeetLanePro
//
//  Created by JinLiang on 14/12/1.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapLocation.h"

@protocol LocationReportDelegate

- (void)locationReportSuccess:(NSDictionary *)dic;
- (void)locationReportfaile;

@end

@interface LocationReportModel : NSObject<MapLocationDelegate>

@property (nonatomic, retain) MapLocation *mapLocation;
@property (nonatomic, strong) id<LocationReportDelegate> delegate;

+ (id)reportSharedModel;
+ (void)fixAndReport;

+ (void)fixLocation;
//判断用户是否登录
+ (BOOL)isPositioningSuccess;
@end
