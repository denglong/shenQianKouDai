//
//  UserLoginModel.m
//  SixFeetLanePro
//
//  Created by JinLiang on 14/11/12.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import "UserLoginModel.h"
#import "MyInfoModel.h"
#import "RequestModel.h"
#import "TabBarController.h"

@implementation UserLoginModel

//判断用户是否登录
+ (BOOL)isLogged
{
    NSString *sessionId =[[CommClass sharedCommon] objectForKey:LOGGED_TOKEN];
    
    if (!sessionId||[sessionId isEqualToString:@""]) {
        return NO;
    }else{
        return YES;
    }
}



//归档用户信息到本地
+ (void)setLoginWithToken:(NSString *)token userName:(NSString *)userName userInfo:(NSDictionary *)userInfo
{
    [[CommClass sharedCommon]setObject:KManualLogin forKey:KuserLoginType];
    
    // 过滤 null
    NSMutableDictionary *mutableInfo = [NSMutableDictionary dictionary];
    
    for (NSString *key in userInfo) {
        NSString *value = [userInfo objectForKey:key];
        
        if ([DataCheck isValidNumber:value]) {
            value=[NSString stringWithFormat:@"%@",value];
        }
        if (![DataCheck isValidString:value] &&![DataCheck isValidArray:value]) {
            value = @"";
        }
        [mutableInfo setObject:value forKey:key];
    }
    userInfo = (NSDictionary *)mutableInfo;
    [MyInfoModel create:userInfo];
    
    NSString *userType=[userInfo objectForKey:@"userType"];
    NSString *markiType=[userInfo objectForKey:@"ifDelivery"];
    //写入用户ID到内存中
    //[[CommClass sharedCommon]setObject:uid forKey:LOGGED_USERID];
    //用户类型
    [[CommClass sharedCommon]setObject:userType forKey:LOGGED_USERTYPE];
    //配送员类型
    [[CommClass sharedCommon]setObject:markiType forKey:LOGGED_MARKIYPE];
    //写入用户Token到内存中
    [[CommClass sharedCommon]setObject:token forKey:LOGGED_TOKEN];
    //写入用户ID到内存中
    [[CommClass sharedCommon]setObject:userName forKey:LOGGED_USERNAME];
    //写入用户信息到内存中
    [[CommClass sharedCommon]setObject:userInfo forKey:LOGGED_USERINFO];
    
    //更新购物车数据
//    if ([self isAverageUser]) {
//        NSDictionary * cartInfo = @{@"cartNumber":[userInfo objectForKey:@"cartNumber"],
//                                    @"cartPrice":[userInfo objectForKey:@"cartPrice"],
//                                    @"cartShipping":[userInfo objectForKey:@"cartShipping"]};
//        ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
//        [cartModel updateShoppingCartInfo:cartInfo]; 
//    }
   
    NSMutableArray *contentMuArray=[[NSMutableArray alloc]init];
    NSString *plistPath=[self getFilePath:@"coding.plist"];
    //生成对象
    UserInfoModel *personInfo=[[UserInfoModel alloc]init];
    
    personInfo.userType=userType;
    personInfo.markiType=markiType;
    personInfo.userToken=token;
    personInfo.userInfo=userInfo;
    personInfo.userPhoneNum=userName;
    //创建用于包含编码的person对象的data实例
    NSMutableData *data=[[NSMutableData alloc]init];
    //创建编码对象，提前告诉它，谁用来装载数据的
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [contentMuArray addObject:personInfo];
    //进行编码
    [archiver encodeObject:contentMuArray forKey:@"Data"];
    //结束归档
    [archiver finishEncoding];
    //写入数据
    [data writeToFile:plistPath atomically:YES];
    
//    //写入用户信息到本地
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:userInfo forKey:LOGGED_USERINFO];
//    //[ud setObject:uid forKey:LOGGED_USERID];
//    [ud setObject:token forKey:LOGGED_TOKEN];
//    
//    [ud synchronize];
}

+(NSString *)getFilePath:(NSString *)fileName
{
    //取得document的路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //拼接要存储的plist路径
    NSString *plistPath=[docPath stringByAppendingPathComponent:fileName];
    return plistPath;
}

//自动登录
+ (void)setAutoLogin
{
    [[CommClass sharedCommon]setObject:KAutoLogin forKey:KuserLoginType];
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userInfo = [ud objectForKey:LOGGED_USERINFO];
//    [MyInfoModel create:userInfo];
    //    [[CommClass sharedCommon] setObject:userInfo forKey:LOGGED_USERINFO];
    NSString *plistPath=[self getFilePath:@"coding.plist"];
    //获取解码内容
    NSData *data=[[NSData alloc]initWithContentsOfFile:plistPath];
    //创建解码对象
    if (data !=nil) {
        NSKeyedUnarchiver *unArchive=[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        //从解码对象中获得解码内容
        NSMutableArray *personArray=[unArchive decodeObjectForKey:@"Data"];
        UserInfoModel *person=[personArray objectAtIndex:random()%personArray.count];
        [unArchive finishDecoding];
        
        NSString *userToken=person.userToken;
        NSString *userName=person.userPhoneNum;
        NSString *userType=person.userType;
        NSString *markiType=person.markiType;
        NSDictionary *oldUserInfo=person.userInfo;
        [MyInfoModel create:oldUserInfo];
        //[[CommClass sharedCommon] setObject:uid forKey:LOGGED_USERID];
        [[CommClass sharedCommon] setObject:userToken forKey:LOGGED_TOKEN];
        [[CommClass sharedCommon] setObject:userType forKey:LOGGED_USERTYPE];
        [[CommClass sharedCommon] setObject:markiType forKey:LOGGED_MARKIYPE];
        [[CommClass sharedCommon] setObject:userName  forKey:LOGGED_USERNAME];
        [[CommClass sharedCommon] setObject:oldUserInfo forKey:LOGGED_USERINFO];
    }
}

//退出
+ (void)setLoginOut
{
    [[TabBarController sharedInstance] setShopCartNumberNil];
    
    //个推退出后解绑
    NSString *phoneNum = [[CommClass sharedCommon] objectForKey:LOGGED_USERNAME];
    if (phoneNum) {
        [GeTuiSdk registerDeviceToken:@""];
        [GeTuiSdk unbindAlias:phoneNum];
    }
    [GeTuiSdk setPushModeForOff:YES];
    
    NSDictionary *cartInfo=@{@"cartNumber":@"",@"cartPrice":@"",@"cartShipping":@""};
    ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
    [cartModel updateShoppingCartInfo:cartInfo];
    [[CommClass sharedCommon] removeObjectForKey:COUPONRED];
    [[CommClass sharedCommon] removeObjectForKey:EBEANRED];
    [[CommClass sharedCommon] setObject:@"" forKey:LOGGED_MARKIYPE];
    [[CommClass sharedCommon] setObject:@"" forKey:LOGGED_USERTYPE];
    [[CommClass sharedCommon] setObject:@"" forKey:LOGGED_TOKEN];
    [[CommClass sharedCommon] setObject:@"" forKey:LOGGED_USERNAME];
    [[CommClass sharedCommon] setObject:KUnLogin forKey:KuserLoginType];
    [RequestModel clearModel:@"MyInfoModel"];
//    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
//    //退出登录清除本地信息
//    //[defaults removeObjectForKey:LOGGED_USERID];
//    [defaults removeObjectForKey:LOGGED_TOKEN];
//    [defaults removeObjectForKey:LOGGED_USERINFO];
    
    NSMutableArray *contentMuArray=[[NSMutableArray alloc]init];
    NSString *plistPath=[self getFilePath:@"coding.plist"];
    //生成对象
    UserInfoModel *person=[[UserInfoModel alloc]init];
    //person.userId=@"0";
    
    //创建用于包含编码的person对象的data实例
    NSMutableData *data=[[NSMutableData alloc]init];
    //创建编码对象，提前告诉它，谁用来装载数据的
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [contentMuArray addObject:person];
    //进行编码
    [archiver encodeObject:contentMuArray forKey:@"Data"];
    //结束归档
    [archiver finishEncoding];
    //写入数据
    [data writeToFile:plistPath atomically:YES];
}

+ (NSString *)currentToken
{
    return [[CommClass sharedCommon] objectForKey:LOGGED_TOKEN];
    
}

+ (NSDictionary *)currentUserInfo
{
    return [[CommClass sharedCommon] objectForKey:LOGGED_USERINFO];
}

//判断是否是店主
+(BOOL)isShopOwner{
    
    int userTyep=[[[CommClass sharedCommon]objectForKey:LOGGED_USERTYPE] intValue];
    int markiTyep=[[[CommClass sharedCommon]objectForKey:LOGGED_MARKIYPE] intValue];
    
    if (userTyep==USERTYPE_SHOPOWNER && markiTyep==MARKITYPE_NO){
        //验证登录 换身份的时候用
        [[CommClass sharedCommon]setObject:@"" forKey:CART_GOODSID];
        return YES;
    }
    else
        return NO;
}
//判断是否是普通用户
+(BOOL)isAverageUser{
    
    int userTyep=[[[CommClass sharedCommon]objectForKey:LOGGED_USERTYPE] intValue];
    int markiTyep=[[[CommClass sharedCommon]objectForKey:LOGGED_MARKIYPE] intValue];
    
    if (userTyep==USERTYPE_AVERAGE && markiTyep==MARKITYPE_NO)
        return YES;
    else
        return NO;
}
//判断是否是配送员
+(BOOL)isMarki{
    
    int userTyep=[[[CommClass sharedCommon]objectForKey:LOGGED_USERTYPE] intValue];
    int markiTyep=[[[CommClass sharedCommon]objectForKey:LOGGED_MARKIYPE] intValue];
    
    if (userTyep==USERTYPE_AVERAGE && markiTyep==MARKITYPE_YES){
        //验证登录 换身份的时候用
        [[CommClass sharedCommon]setObject:@"" forKey:CART_GOODSID];
        return YES;
    }
    else
        return NO;
}

+(NSString *)userName{
    
    NSString *userPhoneName=[[CommClass sharedCommon] objectForKey:LOGGED_USERNAME];
    
    if (!userPhoneName) {
        userPhoneName=@"";
    }
    return userPhoneName;
}

//判断是否是主动取消登录
+(BOOL)isConscious{
    
    NSString *indentifier=[[CommClass sharedCommon] objectForKey:LOGIN_CANCELINDENTIFY];
    return ([indentifier intValue]>0);
}

//更新取消登录标识
+(void)updateCancelIdentify:(NSString *)indentifier{
    
    [[CommClass sharedCommon]setObject:indentifier forKey:LOGIN_CANCELINDENTIFY];
}

@end
