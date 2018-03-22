//
//  UserLoginModel.h
//  SixFeetLanePro
//
//  Created by JinLiang on 14/11/12.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Headers.h"
#import "UserInfoModel.h"
#import "ShoppingCartModel.h"
@interface UserLoginModel : NSObject

+ (BOOL)isLogged;//判断是否登录
+ (void)setAutoLogin;//设置自动登录
+ (void)setLoginOut;//退出


+(BOOL)isShopOwner;//判断是否是店主
+(BOOL)isAverageUser;//判断是否是普通用户
+(BOOL)isMarki;//判断是否是配送员


//归档用户信息到本地
+ (void)setLoginWithToken:(NSString *)token userName:(NSString *)userName userInfo:(NSDictionary *)userInfo;

+ (NSString *)currentToken;//获取当前登录用户的token
+ (NSDictionary *)currentUserInfo;//获取当前登录用户的登录信息
+ (NSString *)userName;//获取用户的登录名

//判断是否是主动取消登录
+(BOOL)isConscious;
//更新取消登录标识
+(void)updateCancelIdentify:(NSString *)indentifier;

@end
