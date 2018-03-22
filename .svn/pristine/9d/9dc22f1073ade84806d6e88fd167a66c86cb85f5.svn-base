//
//  AddressReqModel.m
//  KingProFrame
//
//  Created by lihualin on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "AddressReqModel.h"

@implementation AddressReqModel
@synthesize lat,lng,address,addressDetail,addressTel,addressUser,type,ifDefault,street,cityCode;
@synthesize id=addressId;
+ (AddressReqModel *)sharedInstance
{
    static AddressReqModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)setType:(NSString *)aType
{
    type = aType;
}
-(void)setId:(NSString *)aId
{
    addressId = aId;
}
-(void)setLat:(NSString *)lLat
{
    lat = lLat;
}
-(void)setLng:(NSString *)lLng
{
    lng = lLng;
}
-(void)setAddress:(NSString *)aAddress
{
    address = aAddress;
}
-(void)setAddressDetail:(NSString *)aAddressDetail
{
    addressDetail = aAddressDetail;
}
-(void)setAddressTel:(NSString *)aAddressTel
{
    addressTel = aAddressTel;
}
-(void)setAddressUser:(NSString *)aAddressUser
{
    addressUser = aAddressUser;
}
-(void)setIfDefault:(NSString *)iIfDefault
{
    ifDefault = iIfDefault;
}
-(void)setStreet:(NSString *)sStreet
{
    street = sStreet;
}
-(void)setCityCode:(NSString *)cCityCode
{
    cityCode = cCityCode;
}

-(NSString *)getType
{
    return type;
}

-(NSString *)getId
{
    return addressId;
}
-(NSString *)getLat
{
    return lat;
}
-(NSString *)getLng
{
    return lng;
}
-(NSString *)getAddress
{
    return address;
}
-(NSString *)getAddressDetail
{
    return addressDetail;
}
-(NSString *)getAddressTel
{
    return addressTel;
}
-(NSString *)getAddressUser
{
    return addressUser;
}
-(NSString *)getIfDefault
{
    return ifDefault;
}
-(NSString *)getStreet
{
    return street;
}
-(NSString *)getCityCode
{
    return cityCode;
}
@end
