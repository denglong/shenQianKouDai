//
//  MyInfoList.m
//  KingProFrame
//
//  Created by lihualin on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MyInfoList.h"

@implementation MyInfoList
@synthesize profileList,userLabelList;
//初始化单例
+ (MyInfoList *)sharedInstance
{
    static MyInfoList *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)setProfileList:(NSArray *)myProfileList
{
    
    profileList = myProfileList;
}
-(void)setUserLabelList:(NSArray *)myUserLabelList
{
    userLabelList = myUserLabelList;
}
-(NSArray *)getProfileList
{
    return profileList;
}
-(NSArray *)getUserLabelList
{
    return userLabelList;
}
+ (void)create:(NSString *)str
{
    MyInfoList *resp = [MyInfoList sharedInstance];
    for (int i = 0; i < resp.profileList.count; i ++) {
        NSDictionary *inDic = resp.profileList[i];
        [ResponseModel setClassEmue:str dic:inDic];
    }
}

@end
