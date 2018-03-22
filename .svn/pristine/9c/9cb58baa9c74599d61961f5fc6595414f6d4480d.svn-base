//
//  MyAddressList.m
//  KingProFrame
//
//  Created by lihualin on 15/8/11.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MyAddressList.h"

@implementation MyAddressList
@synthesize addressList;
//初始化单例
+ (MyAddressList *)sharedInstance
{
    static MyAddressList *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)setAddressList:(NSArray *)myAddressList
{
    addressList = myAddressList;
}

-(NSArray *)getAddressList
{
    return addressList;
}

+ (NSMutableArray *)create:(NSString *)str
{
    NSMutableArray *arrs = [NSMutableArray array];
    MyAddressList *resp = [MyAddressList sharedInstance];
    for (int i = 0; i < resp.addressList.count; i ++) {
        NSDictionary *inDic = resp.addressList[i];
        id myClass = [ResponseModel class:str dic:inDic];
        [arrs addObject:myClass];
    }
    return arrs;
}

@end
