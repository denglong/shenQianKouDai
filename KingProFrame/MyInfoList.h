//
//  MyInfoList.h
//  KingProFrame
//
//  Created by lihualin on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "ResponseModel.h"

@interface MyInfoList : ResponseModel
@property (nonatomic) NSArray *profileList;
@property (nonatomic) NSArray * userLabelList;
-(void)setProfileList:(NSArray *)myProfileList;
-(void)setUserLabelList:(NSArray *)myUserLabelList;
-(NSArray *)getProfileList;
-(NSArray *)getUserLabelList;
+ (MyInfoList *)sharedInstance;
+ (void)create:(NSString *)str;
@end
