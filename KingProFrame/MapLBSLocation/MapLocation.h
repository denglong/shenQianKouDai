//
//  MapLocation.h
//  SixFeetLanePro
//
//  Created by JinLiang on 14/12/1.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "Headers.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>

@protocol MapLocationDelegate;

@interface MapLocation : NSObject<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
{
    int _catchLocationTimeUsed;
    AMapSearchAPI * _search;
    AMapReGeocodeSearchRequest *regeo;
    NSDictionary * localAddress;
    MAMapView * _mapView;
}
@property (nonatomic, retain) NSTimer *catchLocationTimer;
//@property (nonatomic, retain)

@property (nonatomic, retain) AMapLocationManager *locationManager;
@property (nonatomic) int maxTries;
@property (nonatomic) int minTries; // 尝试的次数越多越精确，但会越耗时
@property (nonatomic, assign) id<MapLocationDelegate> delegate;
@property (nonatomic) BOOL isFixing;
@property (nonatomic) BOOL isOpenLocation;

@property (nonatomic) CLLocationDegrees lastLatitude;
@property (nonatomic) CLLocationDegrees lastLongitude;

+ (MapLocation *)sharedObject;
- (void)start;
- (void)maggnerIsOpenLocation;
- (void)cancel;
- (BOOL)isOpenLocal;
@end

@protocol MapLocationDelegate <NSObject>

- (void)mapLocation:(MapLocation *)mapLocation fixDidFinishWith:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (void)mapLocation:(MapLocation *)mapLocation fixDidFailed:(NSString *)reason;

@end
