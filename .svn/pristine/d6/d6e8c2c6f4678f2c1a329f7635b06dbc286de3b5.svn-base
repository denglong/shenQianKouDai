//
//  CloudClientRequest.m
//  KingProFrame
//
//  Created by JinLiang on 15/7/22.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CloudClientRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "CommClass.h"
#import "JSONKit.h"
#import "BaseViewController.h"
#import "TabBarController.h"
#import "SSKeychain.h"

@implementation CloudClientRequest
@synthesize delegate=_delegate;
@synthesize finishSelector=_finishSelector;
@synthesize finishErrorSelector=_finishErrorSelector;
@synthesize progressSelector=_progressSelector;


-(id)init
{
    self=[super init];
    if(self)
    {
        self.AFAppDotNetClient=[[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:CLOUD_API_URL]];
        DLog(@"%@",CLOUD_API_URL);
    }
    return self;
}


//检查服务器返回是否为空 no为空
BOOL TTIsStringWithAnyText(id object) {
    return [object isKindOfClass:[NSString class]] && [(NSString*)object length] > 0;
}


-(NSString*)getRequestUrl:(NSString*)mod parameter:(NSDictionary *)jsonDic{
    
    //时间戳
    NSString *timeStamp=[CommClass getCurrentTimeStamp];
    
    NSString *testUUID = [NSString stringWithFormat:@"%@", [self getDeviceId]];
    
    NSString *clientVersion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *methodName=[NSString stringWithFormat:@"/%@",mod];
    NSString *jsonString=@"{}";
    if ([DataCheck isValidDictionary:jsonDic]) {
        
        NSError *error;
        NSData *jsonData=[NSJSONSerialization dataWithJSONObject:jsonDic
                                                         options:kNilOptions
                                                           error:&error];
        jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        //end  change
        
    }
    NSString *token = [[CommClass sharedCommon] objectForKey:LOGGED_TOKEN];
    if (![DataCheck isValidString:token]) {
        token = @"";
    }
    
    NSString *imei = [[CommClass sharedCommon] objectForKey:@"deviceToken"];
    if (![DataCheck isValidString:imei]) {
        imei = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    }
    
    NSString *md5Str=[CommClass md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",timeStamp,testUUID,clientVersion,methodName,jsonString, imei]];

    
    NSArray *addList = [[CommClass sharedCommon] localObjectForKey:AUTOLOCATIONADDRESS];
    NSString *ct = nil;
    if (addList.count > 1) {
        ct = addList.firstObject;
    }
    else
    {
        ct = @"029";
    }
    
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@?t=%@&token=%@&uuid=%@&vid=%@&sign=%@&imei=%@&nt=wifi&cid=dev&ct=%@",API_URL,mod,timeStamp,token,testUUID,clientVersion,md5Str,imei,ct];
//    requestUrl = [NSString stringWithFormat:@"%@%@?t=%@&token=%@&uuid=%@&vid=%@&imei=%@&nt=wifi&cid=dev&ct=%@",API_URL,mod,timeStamp,token,testUUID,clientVersion,imei,ct];
    
    return requestUrl;
}

#pragma mark - 获取设备uuid
- (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@"IDENTIFIERFORVENDOR"account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@"IDENTIFIERFORVENDOR"account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

/**
 *  普通的网络请求POST
 *
 *  @param url        请求链接
 *  @param postParam  请求参数
 *  @param block      成功回掉
 *  @param blockError 失败回掉
 */
-(void)callMethodWithMod:(NSString *)mod
              parameters:(NSDictionary *)parameters
                delegate:(id)delegate
                 succeed:(SEL)succeedSel
                 failure:(SEL)errorSel
        progressSelector:(SEL)progressSel
           statusMessage:(NSString *)loadingMessage
{
    
    DLog(@"%@",parameters);
    
    NSString *requestUrl=[self getRequestUrl:mod parameter:parameters];
    
    DLog(@"请求URL-----------%@",requestUrl);
    
    CloudClientRequest *cloudRequestPost=[[CloudClientRequest alloc] init];
    
    [cloudRequestPost setconManagefiguration];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     delegate, @"delegate",
                                     NSStringFromSelector(succeedSel),  @"selector",
                                     NSStringFromSelector(errorSel),    @"errorSelector",
                                     NSStringFromSelector(progressSel), @"progressSelector",
                                     nil];
    
    [cloudRequestPost.AFAppDotNetClient POST:requestUrl
                                  parameters:parameters
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         @try {
                                             if ([DataCheck isValidDictionary:responseObject]) {
                                                 
                                                 NSDictionary *resultDic=[NSDictionary dictionaryWithDictionary:responseObject];

                                                 int code=[[resultDic objectForKey:@"code"] intValue];
                                                 NSString *message = [resultDic objectForKey:@"msg"];
                                                 
                                                 if (code != 0 ) {
                                                     NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                [NSString stringWithFormat:@"%d", code], @"code",
                                                                                message, @"msg", nil];
                                                     
                                                     [_delegate performSelector:_finishErrorSelector
                                                                     withObject:userInfo
                                                                     withObject:errorInfo];
                                                     if(code == 41006 || code == 41003)
                                                     {
                                                         return ;
                                                     }
                                                     if ([[userInfo objectForKey:@"errorSelector"] isEqualToString:@"checkOldPswError:"]) {
                                                         return;
                                                     }
                                                     if (code ==CODE_LOGINFAIL) {
                                                         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CODE_ISLOGIN];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                         
                                                         if ([[userInfo objectForKey:@"selector"] isEqualToString:@"addShoppingSuccess:"]) {
                                                             return;
                                                         }
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [SRMessage loginInfoMessage:message block:^{
                                                                 BaseViewController * base = [[CommClass sharedCommon] objectForKey:@"windowRootController"];
                                                                 [[AppModel sharedModel] presentLoginController:base];
                                                                 
                                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                     
                                                                 });
                                                                 
                                                             }];
                                                         });
                                                         
                                                         return;
                                                     }
                                                     if (code == 41808 || code == 41904) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             BaseViewController * base = [[CommClass sharedCommon] objectForKey:@"windowRootController"];
                                                             [SRMessage infoMessageWithTitle:nil message:message delegate:base];
                                                         });
                                                         return;
                                                     }
                                                    
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         BaseViewController * base = [[CommClass sharedCommon] objectForKey:@"windowRootController"];
                                                         [SRMessage infoMessage:message delegate:base];
                                                        
                                                     });
                                                    
                                                     
                                                     return;
                                                 }
                                                 
                                                 
                                                 [_delegate performSelector:_finishSelector
                                                                 withObject:userInfo
                                                                 withObject:[resultDic objectForKey:@"data"]];
                                                 
                                             }
                                         }
                                         @catch (NSException *exception) {
                                             
                                         }
                                         
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         DLog(@"%@",error);
                                         
                                         [_delegate performSelector:_finishErrorSelector
                                                         withObject:userInfo
                                                         withObject:nil];
                                     }];
    
}

/**
 *  普通的网络请求GET
 *
 *  @param url        请求链接
 *  @param postParam  请求参数
 *  @param block      成功回掉
 *  @param blockError 失败回掉
 */
-(void)callGETMethodWithMod:(NSString *)mod
              parameters:(NSDictionary *)parameters
                delegate:(id)delegate
                 succeed:(SEL)succeedSel
                 failure:(SEL)errorSel
        progressSelector:(SEL)progressSel
           statusMessage:(NSString *)loadingMessage
{
    
    DLog(@"%@",parameters);
    
    NSString *requestUrl=[self getRequestUrl:mod parameter:parameters];
//    requestUrl = [NSString stringWithFormat:@"%@%@", API_URL, mod];
    
    DLog(@"请求URL-----------%@",requestUrl);
    
    CloudClientRequest *cloudRequestPost=[[CloudClientRequest alloc] init];
    
    [cloudRequestPost setconManagefiguration];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     delegate, @"delegate",
                                     NSStringFromSelector(succeedSel),  @"selector",
                                     NSStringFromSelector(errorSel),    @"errorSelector",
                                     NSStringFromSelector(progressSel), @"progressSelector",
                                     nil];
    
    [cloudRequestPost.AFAppDotNetClient GET:requestUrl
                                  parameters:nil
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         @try {
                                             if ([DataCheck isValidDictionary:responseObject]) {
                                                 
                                                 NSDictionary *resultDic=[NSDictionary dictionaryWithDictionary:responseObject];
                                                 
                                                 int code=[[resultDic objectForKey:@"code"] intValue];
                                                 NSString *message = [resultDic objectForKey:@"msg"];
                                                 
                                                 if (code != 0 ) {
                                                     NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                [NSString stringWithFormat:@"%d", code], @"code",
                                                                                message, @"msg", nil];
                                                     
                                                     [_delegate performSelector:_finishErrorSelector
                                                                     withObject:userInfo
                                                                     withObject:errorInfo];
                                                     if(code == 41006 || code == 41003)
                                                     {
                                                         return ;
                                                     }
                                                     if ([[userInfo objectForKey:@"errorSelector"] isEqualToString:@"checkOldPswError:"]) {
                                                         return;
                                                     }
                                                     if (code ==CODE_LOGINFAIL) {
                                                         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CODE_ISLOGIN];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                         
                                                         if ([[userInfo objectForKey:@"selector"] isEqualToString:@"addShoppingSuccess:"]) {
                                                             return;
                                                         }
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [SRMessage loginInfoMessage:message block:^{
                                                                 BaseViewController * base = [[CommClass sharedCommon] objectForKey:@"windowRootController"];
                                                                 [[AppModel sharedModel] presentLoginController:base];
                                                                 
                                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                     
                                                                 });
                                                                 
                                                             }];
                                                         });
                                                         
                                                         return;
                                                     }
                                                     if (code == 41808 || code == 41904) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             BaseViewController * base = [[CommClass sharedCommon] objectForKey:@"windowRootController"];
                                                             [SRMessage infoMessageWithTitle:nil message:message delegate:base];
                                                         });
                                                         return;
                                                     }
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         BaseViewController * base = [[CommClass sharedCommon] objectForKey:@"windowRootController"];
                                                         [SRMessage infoMessage:message delegate:base];
                                                         
                                                     });
                                                     
                                                     
                                                     return;
                                                 }
                                                 
                                                 
                                                 [_delegate performSelector:_finishSelector
                                                                 withObject:userInfo
                                                                 withObject:[resultDic objectForKey:@"data"]];
                                                 
                                             }
                                         }
                                         @catch (NSException *exception) {
                                             
                                         }
                                         
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         DLog(@"%@",error);
                                         
                                         [_delegate performSelector:_finishErrorSelector
                                                         withObject:userInfo
                                                         withObject:nil];
                                     }];
    
}


#pragma mark------------------------------------配置------------------------------------------------------
/**
 *  AFHTTPSessionManager 配置
 */
-(void)setconManagefiguration
{
    
    
    self.AFAppDotNetClient.requestSerializer = [AFJSONRequestSerializer serializer];
    
    self.AFAppDotNetClient.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.AFAppDotNetClient.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    
    [self.AFAppDotNetClient.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    
    [self.AFAppDotNetClient.requestSerializer setTimeoutInterval:30];
    
}


@end
