//
//  MyInfo.m
//  KingProFrame
//
//  Created by lihualin on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MyInfo.h"

@implementation MyInfo
@synthesize nickName,ifCheck,imgUrl,sex,sign,age,constrllation,job,contact,birthday,finishOrder,name,addrNum;
+ (MyInfo *)sharedInstance
{
    static MyInfo *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
    
}
-(void)setNickName:(NSString *)aNickName
{
    nickName = aNickName;
}
-(void)setSex:(NSString *)aSex
{
    sex = aSex;
}
-(void)setImgUrl:(NSString *)aImgUrl
{
    imgUrl = aImgUrl;
}
-(void)setFinishOrder:(NSString *)fFinishOrder
{
    finishOrder = fFinishOrder;
}
-(void)setContact:(NSString *)cContact
{
    contact = cContact;
}
-(void)setConstrllation:(NSString *)cConstrllation
{
    constrllation = cConstrllation;
}
-(void)setBirthday:(NSString *)bBirthday
{
    birthday = bBirthday;
}
-(void)setAge:(NSString *)aAge
{
    age = aAge;
}
-(void)setIfCheck:(NSString *)iIfCheck
{
    ifCheck = iIfCheck;
}
-(void)setJob:(NSString *)jJob
{
    job = jJob;
}
-(void)setName:(NSString *)nName
{
    name = nName;
}
-(void)setSign:(NSString *)sSign
{
    sign = sSign;
}
-(void)setAddrNum:(NSString *)aAddrNum
{
    addrNum = aAddrNum;
}

-(NSString *)getNickName
{
    return nickName;
}
-(NSString *)getSex
{
    return sex;
}
-(NSString *)getImgUrl
{
    return imgUrl;
}
-(NSString *)getAge
{
    return age;
}
-(NSString *)getBirthday
{
    return birthday;
}
-(NSString *)getConstrllation
{
    return constrllation;
}
-(NSString *)getContact
{
    return contact;
}
-(NSString *)getFinishOrder
{
    return finishOrder;
}
-(NSString *)getIfCheck
{
    return ifCheck;
}
-(NSString *)getJob
{
    return job;
}
-(NSString *)getName
{
    return name;
}
-(NSString *)getSign
{
    return sign;
}
-(NSString *)getAddrNum
{
    return addrNum;
}
@end
