//
//  MapLocation.m
//  SixFeetLanePro
//  主要用于定位
//  Created by JinLiang on 14/12/1.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import "MapLocation.h"

#define LAST_LATITUDE @"LAST_LATITUDE"
#define LAST_LONGITUDE @"LAST_LONGITUDE"

@implementation MapLocation

#pragma mark - private

- (void)saveLastLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%f", latitude] forKey:LAST_LATITUDE];
    [ud setObject:[NSString stringWithFormat:@"%f", longitude] forKey:LAST_LONGITUDE];
    [ud synchronize];
}

- (CLLocationDegrees)lastLatitude
{
#if TARGET_IPHONE_SIMULATOR
    return 34.245189;
#endif
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *value = [ud objectForKey:LAST_LATITUDE];
    if (value == nil) {
        return 0;
    }
    
    return [value doubleValue];
}

- (CLLocationDegrees)lastLongitude
{
#if TARGET_IPHONE_SIMULATOR
    return 108.862811;
#endif
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *value = [ud objectForKey:LAST_LONGITUDE];
    if (value == nil) {
        return 0;
    }
    
    return [value doubleValue];
}

#pragma mark - init

- (id)init
{
    if (self = [super init]) {
        self.maxTries = 10;
        self.minTries = 3;
        self.isFixing = NO;
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    }
    
    return self;
}

+ (MapLocation *)sharedObject
{
    static id sharedObject;
    
    @synchronized(self) {
        if (!sharedObject) {
            sharedObject = [[self alloc] init];
        }
        return sharedObject;
    }
}


// 定位成功
- (void)fixLocationFinish:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    [self saveLastLatitude:latitude longitude:longitude];
     self.isOpenLocation=YES;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [self getAddressInfo:coordinate];
    if ([_delegate respondsToSelector:@selector(mapLocation:fixDidFinishWith:longitude:)]) {
        [_delegate mapLocation:self fixDidFinishWith:latitude longitude:longitude];
       
    }
    [self cancel];
    _catchLocationTimeUsed = 0;
}

// 定位失败
- (void)fixLocationFinishError:(NSString *)errorMessage
{
    if ([_delegate respondsToSelector:@selector(mapLocation:fixDidFailed:)]) {
        [_delegate mapLocation:self fixDidFailed:errorMessage];
        NSArray *addressList = @[@"029", @{@"lat":@"34.22", @"lng":@"108.978 "}, @"西安市小寨"];
        
        [[CommClass sharedCommon] localObject:addressList forKey:AUTOLOCATIONADDRESS];
    }
    
    [self cancel];
//    self.isOpenLocation=NO;
    _catchLocationTimeUsed = 0;
}

//进行定位
- (void)tryToGetLocation:(NSTimer *)theTimer
{
    CLLocationDegrees latitude = _mapView.userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = _mapView.userLocation.location.coordinate.longitude;
    self.isOpenLocation=NO;
    _catchLocationTimeUsed += 1;
    if (_catchLocationTimeUsed > _maxTries) {
        [self fixLocationFinishError:@"定位超时"];
        return;
    }
    
    if (latitude > 0 && longitude > 0 && _catchLocationTimeUsed > _minTries) {
        [_catchLocationTimer invalidate];
        [self fixLocationFinish:latitude longitude:longitude];
    }
}


//初始化定位属性
-(void)initLocationManager{
    
    if(!_locationManager)
    {
//        [UIApplication sharedApplication].idleTimerDisabled = TRUE;//保持屏幕常亮
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
//        [_locationManager setAllowsBackgroundLocationUpdates:NO];
        _locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
         [_locationManager startUpdatingLocation];
    }
}




-(BOOL)isOpenLocal{

    return self.isOpenLocation;
}
#pragma mark - AMapLocationManager Delegate
//IOS8以后会执行此函数
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    if(status==kCLAuthorizationStatusAuthorized){//确认授权
        
        DLog(@"kCLAuthorizationStatusAuthorized");
        [_locationManager startUpdatingLocation];
        self.isOpenLocation=YES;
    }
    else if (status==kCLAuthorizationStatusDenied){//用户不授权定位
        self.isOpenLocation=NO;
        DLog(@"kCLAuthorizationStatusDenied");
    }
    else if (status==kCLAuthorizationStatusNotDetermined){//授权状态不确定
        self.isOpenLocation=NO;
        DLog(@"kCLAuthorizationStatusNotDetermined");
    }
    else if (status==kCLAuthorizationStatusRestricted){//授权状态受限制
        self.isOpenLocation=NO;
        DLog(@"kCLAuthorizationStatusRestricted");
    }
    else if (status==kCLAuthorizationStatusAuthorizedWhenInUse){
        self.isOpenLocation=YES;
        DLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
        [_locationManager startUpdatingLocation];
    }
    else if (status==kCLAuthorizationStatusAuthorizedAlways){
        self.isOpenLocation=YES;
        DLog(@"kCLAuthorizationStatusAuthorizedAlways");
        [_locationManager startUpdatingLocation];
    }
}
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    DLog(@"%s, didUpdateLocation = {lat:%f; lon:%f;}", __func__, location.coordinate.latitude, location.coordinate.longitude);
   self.isOpenLocation=YES;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    CLLocationDegrees latitude = userLocation.coordinate.latitude;
    CLLocationDegrees longitude = userLocation.coordinate.longitude;
    _catchLocationTimeUsed += 1;
    if (_catchLocationTimeUsed > _maxTries) {
        [self fixLocationFinishError:@"定位超时"];
        return;
    }
    
    if (latitude > 0 && longitude > 0 ) {
        [_catchLocationTimer invalidate];
        [self fixLocationFinish:latitude longitude:longitude];
        [_locationManager stopUpdatingLocation];
        if (_locationManager) {
            _locationManager=nil;
        }
    }

}
-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSArray *addressList = @[@"029", @{@"lat":@"34.22", @"lng":@"108.978 "}, @"西安市小寨"];
    
    [[CommClass sharedCommon] localObject:addressList forKey:AUTOLOCATIONADDRESS];
}

- (void)dealloc
{
    [self cancel];
    
    //[super dealloc];
}

#pragma mark - public

- (void)cancel
{
    if (_catchLocationTimer) {
        [_catchLocationTimer invalidate];
        _catchLocationTimer = nil;
    }
    
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)start
{
    self.isOpenLocation=NO;
    [self maggnerIsOpenLocation];
    
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    }
    //初始化检索对象
    if (_search == nil) {
        _search = [[AMapSearchAPI alloc]init];
        _search.language = 0;
        _search.delegate = self;
    }
}

- (void)maggnerIsOpenLocation
{
    if(_locationManager==nil){
        [self initLocationManager];
    }
}


- (BOOL)isFixing
{
    if (_catchLocationTimer) {
        return [_catchLocationTimer isValid];
    }
    return NO;
}
#pragma mark - 逆地理编码
-(void)getAddressInfo:(CLLocationCoordinate2D)localCoordinate
{
    //构造AMapReGeocodeSearchRequest对象
    if (regeo == nil) {
        regeo = [[AMapReGeocodeSearchRequest alloc] init];
    }
    regeo.location = [AMapGeoPoint locationWithLatitude:localCoordinate.latitude
                                              longitude:localCoordinate.longitude];
    regeo.radius = 200;
    regeo.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch:regeo];
    
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        NSString * address = [NSString stringWithFormat:@"%@%@%@",response.regeocode.addressComponent.city,response.regeocode.addressComponent.district,response.regeocode.addressComponent.township];
        if (response.regeocode.addressComponent.streetNumber.location.latitude == 0.0) {
            localAddress = @{@"location":request.location};
        }else{
            localAddress = @{@"location":response.regeocode.addressComponent.streetNumber.location};
        }
        
        NSDictionary *parms = nil;
        id location = [localAddress objectForKey:@"location"];
        if ([[location class] isSubclassOfClass:[AMapGeoPoint class]]) {
            AMapGeoPoint * location = [localAddress objectForKey:@"location"];
            parms = @{@"lat":[NSString stringWithFormat:@"%f",location.latitude], @"lng":[NSString stringWithFormat:@"%f",location.longitude]};
        }else{
            CLLocation * location = [localAddress objectForKey:@"location"];
            parms = @{@"lat":[NSString stringWithFormat:@"%f",location.coordinate.latitude], @"lng":[NSString stringWithFormat:@"%f",location.coordinate.longitude]};
        }
        
        AMapPOI *poi = response.regeocode.pois.firstObject;
        if (poi) {
            NSArray *addressList = @[response.regeocode.addressComponent.citycode, parms, poi.name];
            
            [[CommClass sharedCommon] localObject:addressList forKey:AUTOLOCATIONADDRESS];
        }
        
        NSNotification *notification = [NSNotification notificationWithName:LOCATIONLATANDLNG
                                                                     object:nil
                                                                   userInfo:parms];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end
