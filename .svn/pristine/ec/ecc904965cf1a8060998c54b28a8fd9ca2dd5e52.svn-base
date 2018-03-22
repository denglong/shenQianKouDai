//
//  MyInfoModel.m
//  KingProFrame
//
//  Created by lihualin on 15/8/10.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MyInfoModel.h"

@implementation MyInfoModel

@synthesize nickName,userCart,userCoupin,sex,userOrder,imgUrl,userType,userWaitOrder,acceptDis,ifAccept,ifDelivery,balance,epea,cartPrice,cartShipping,token,userFinishOrder,userWaitAssessOrder,orderRevenue,commissionRevenue,totalCounsumption,vipRetrench;
+ (MyInfoModel *)sharedInstance
{
    static MyInfoModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
    
}
-(void)setToken:(NSString *)aToken
{
    token = aToken;
}
-(void)setNickName:(NSString *)aNickName
{
    nickName = aNickName;
}
-(void)setIfAccept:(NSString *)aIfAccept
{
    ifAccept = aIfAccept;
}
-(void)setIfDelivery:(NSString *)aIfDelivery
{
    ifDelivery = aIfDelivery;
}
-(void)setSex:(NSString *)aSex
{
    sex = aSex;
}
-(void)setUserCart:(NSString *)aUserCart
{
    userCart = aUserCart;
}
-(void)setImgUrl:(NSString *)aImgUrl
{
    imgUrl = aImgUrl;
}
-(void)setUserCoupin:(NSString *)aUserCoupin
{
    userCoupin = aUserCoupin;
}
-(void)setUserOrder:(NSString *)aUserOrder
{
    userOrder = aUserOrder;
}
-(void)setUserType:(NSString *)aUserType
{
    userType = aUserType;
}
-(void)setUserWaitOrder:(NSString *)aUserWaitOrder
{
    userWaitOrder = aUserWaitOrder;
}
-(void)setAcceptDis:(NSString *)aAcceptDis
{
    acceptDis = aAcceptDis;
}
-(void)setBalance:(NSString *)aBalance
{
    balance = aBalance;
}
-(void)setCartPrice:(NSString *)aCartPrice
{
    cartPrice = aCartPrice;
}
-(void)setCartShipping:(NSString *)aCartShipping
{
    cartShipping = aCartShipping;
}
-(void)setEpea:(NSString *)aEpea
{
    epea = aEpea;
}
-(void)setUserWaitAssessOrder:(NSString *)uUserWaitAssessOrder
{
    userWaitAssessOrder = uUserWaitAssessOrder;
}
-(void)setUserFinishOrder:(NSString *)uUserFinishOrder
{
    userFinishOrder = uUserFinishOrder;
}
-(void)setOrderRevenue:(NSString *)oOrderRevenue
{
    orderRevenue = oOrderRevenue;
}
-(void)setCommissionRevenue:(NSString *)cCommissionRevenue
{
    commissionRevenue = cCommissionRevenue;
}

-(void)setTotalCounsumption:(NSString *)atotalCounsumption {
    totalCounsumption = atotalCounsumption;
}

-(void)setVipRetrench:(NSString *)avipRetrench {
    vipRetrench = avipRetrench;
}

-(NSString *)getTotalConsumption {
    return totalCounsumption;
}

-(NSString *)getVipRetrench {
    return vipRetrench;
}

-(NSString *)getUserWaitAssessOrder
{
    return userWaitAssessOrder;
}
-(NSString *)getUserFinishOrder
{
    return userFinishOrder;
}
-(NSString *)getToken
{
    return token;
}
-(NSString *)getNickName
{
    return nickName;
}
-(NSString *)getAcceptDis
{
    return acceptDis;
}
-(NSString *)getBalance
{
    return balance;
}
-(NSString *)getSex
{
    return sex;
}
-(NSString *)getCartPrice
{
    return cartPrice;
}
-(NSString *)getImgUrl
{
    return imgUrl;
}
-(NSString *)getCartShipping
{
    return cartShipping;
}
-(NSString *)getEpea
{
    return epea;
}
-(NSString *)getIfAccept
{
    return ifAccept;
}
-(NSString *)getIfDelivery
{
    return ifDelivery;
}
-(NSString *)getUserCart
{
    return userCart;
}
-(NSString *)getUserCoupin
{
    return userCoupin;
}
-(NSString *)getUserOrder
{
    return userOrder;
}
-(NSString *)getUserType
{
    return userType;
}
-(NSString *)getUserWaitOrder
{
    return userWaitOrder;
}
-(NSString *)getOrderRevenue
{
    return orderRevenue;
}
-(NSString *)getCommissionRevenue
{
    return commissionRevenue;
}
+(void)create:(NSDictionary *)inDic
{
    [ResponseModel class:@"MyInfoModel" dic:inDic];
}

+(void)setClassEmue:(NSDictionary *)inDic
{
    [ResponseModel setClassEmue:@"MyInfoModel" dic:inDic];
}

@end

