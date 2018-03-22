//
//  MyAddressModel.m
//  KingProFrame
//
//  Created by lihualin on 15/8/11.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MyAddressModel.h"

@implementation MyAddressModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
//
//@synthesize lat,lng,address,addressDetail,addressTel,addressUser,ifDefault,street;
//@synthesize id=addressId;
//-(void)setId:(NSString *)aId
//{
//    addressId = aId;
//}
//-(void)setLat:(NSString *)lLat
//{
//    lat = lLat;
//}
//-(void)setLng:(NSString *)lLng
//{
//    lng = lLng;
//}
//-(void)setAddress:(NSString *)aAddress
//{
//    address = aAddress;
//}
//-(void)setAddressDetail:(NSString *)aAddressDetail
//{
//    addressDetail = aAddressDetail;
//}
//-(void)setAddressTel:(NSString *)aAddressTel
//{
//    addressTel = aAddressTel;
//}
//-(void)setAddressUser:(NSString *)aAddressUser
//{
//    addressUser = aAddressUser;
//}
//-(void)setIfDefault:(NSString *)iIfDefault
//{
//    ifDefault = iIfDefault;
//}
//-(void)setStreet:(NSString *)sStreet
//{
//    street = sStreet;
//}
//
//-(NSString *)getId
//{
//    return addressId;
//}
//-(NSString *)getLat
//{
//    return lat;
//}
//-(NSString *)getLng
//{
//    return lng;
//}
//-(NSString *)getAddress
//{
//    return address;
//}
//-(NSString *)getAddressDetail
//{
//    return addressDetail;
//}
//-(NSString *)getAddressTel
//{
//    return addressTel;
//}
//-(NSString *)getAddressUser
//{
//    return addressUser;
//}
//-(NSString *)getIfDefault
//{
//    return ifDefault;
//}
//-(NSString *)getStreet
//{
//    return street;
//}

@end
