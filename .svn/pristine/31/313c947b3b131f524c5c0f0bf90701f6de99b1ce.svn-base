//
//  UserInfoModel.m
//  SixFeetLanePro
//
//  Created by JinLiang on 14/12/3.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

//编码
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //将每个属性都进行编码
    //[aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userInfo forKey:@"userInfo"];
    [aCoder encodeObject:self.userPhoneNum forKey:@"userPhoneNum"];
    [aCoder encodeObject:self.userToken forKey:@"userToken"];
    [aCoder encodeObject:self.userType forKey:@"userType"];
    [aCoder encodeObject:self.markiType forKey:@"markiType"];
}
//解码
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self==[super init]) {
        //获得解码的内容
        //self.userId=[aDecoder decodeObjectForKey:@"userId"];
        self.userInfo=[aDecoder decodeObjectForKey:@"userInfo"];
        self.userPhoneNum=[aDecoder decodeObjectForKey:@"userPhoneNum"];
        self.userToken = [aDecoder decodeObjectForKey:@"userToken"];
        self.userType = [aDecoder decodeObjectForKey:@"userType"];
        self.markiType=[aDecoder decodeObjectForKey:@"markiType"];
    }
    return self;
}
//为自己开辟一块空的空间，进行占位
-(id)copyWithZone:(NSZone *)zone
{
    UserInfoModel *person=[[self class]allocWithZone:zone];
    //person.userId=[self.userId copyWithZone:zone];
    person.userInfo=[self.userInfo copyWithZone:zone];
    person.userPhoneNum=[self.userPhoneNum copyWithZone:zone];
    person.userToken=[self.userToken copyWithZone:zone];
    person.userType = [self.userType copyWithZone:zone];
    person.markiType=[self.markiType copyWithZone:zone];
    
    return person;
}

@end
