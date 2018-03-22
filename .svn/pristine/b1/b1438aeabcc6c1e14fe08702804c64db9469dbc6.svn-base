//
//  AddressReqModel.h
//  KingProFrame
//
//  Created by lihualin on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "RequestModel.h"

@interface AddressReqModel : RequestModel
+ (AddressReqModel *)sharedInstance;
@property(nonatomic , retain) NSString * type; //收货信息变更类型 0修改 1新增 2删除
@property(nonatomic , retain) NSString * id; //地址Id
@property(nonatomic , retain) NSString * lng;  //经度
@property(nonatomic , retain) NSString * lat;  //纬度
@property(nonatomic , retain) NSString * address;  //地址名称
@property(nonatomic , retain) NSString * street; //街道
@property(nonatomic , retain) NSString * addressDetail; //具体地址
@property(nonatomic , retain) NSString * addressUser; //收货人名称
@property(nonatomic , retain) NSString * addressTel; //收货人电话
@property(nonatomic , retain) NSString * ifDefault; //是否默认地址
@property(nonatomic , retain) NSString * cityCode; //城市code

-(void)setType:(NSString *)aType;
-(void)setId:(NSString *)aId;
-(void)setLng:(NSString *)lLng;
-(void)setLat:(NSString *)lLat;
-(void)setAddress:(NSString *)aAddress;
-(void)setAddressDetail:(NSString *)aAddressDetail;
-(void)setAddressTel:(NSString *)aAddressTel;
-(void)setAddressUser:(NSString *)aAddressUser;
-(void)setIfDefault:(NSString *)iIfDefault;
-(void)setStreet:(NSString *)sStreet;
-(void)setCityCode:(NSString *)cCityCode;

-(NSString *)getType;
-(NSString *)getId;
-(NSString *)getLng;
-(NSString *)getLat;
-(NSString *)getAddress;
-(NSString *)getAddressDetail;
-(NSString *)getAddressTel;
-(NSString *)getAddressUser;
-(NSString *)getIfDefault;
-(NSString *)getStreet;
-(NSString *)getCityCode;
@end
