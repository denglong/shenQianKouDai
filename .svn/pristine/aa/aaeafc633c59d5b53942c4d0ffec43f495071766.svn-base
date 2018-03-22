//
//  WeChatPayController.m
//  KingProFrame
//
//  Created by denglong on 7/28/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "WeChatPayController.h"
#import "PayModel.h"
#import "DataCheck.h"

@implementation WeChatPayController
@synthesize ORDER_NAME, ORDER_PRICE, orderNum, serviceDict;

+ (WeChatPayController *)sharedManager
{
    static WeChatPayController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                DLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            }
                break;
                
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                DLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            }
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

//客服端签名支付方法
- (void)weChatPayAction
{
    bool my = [WXApi registerApp:@"wxb15e39e41e14ee6e" withDescription:@"myClass"];
    if (my) {
        DLog(@"微信支付注册成功！");
    }
    
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    req.order_name = ORDER_NAME;
    req.order_price = ORDER_PRICE;
    req.NOTIFY_URL = [NSString stringWithFormat:@"%@", [PayModel shareInstance].getWeixinPayUrl];
    req.orderno = orderNum;
    
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        //[self alert:@"提示信息" msg:debug];
        
        DLog(@"%@\n\n",debug);
    }else{
        DLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

//服务端签名支付方法
- (void)weChatServicesPayAction {
    bool my = [WXApi registerApp:@"wxe68819a570c073c8" withDescription:@"koudaishengqian"];
    if (my) {
        DLog(@"微信支付注册成功！");
    }
    
    //调起微信支付
    if ([DataCheck isValidDictionary:serviceDict]) {
        
        NSMutableString *stamp  = [serviceDict objectForKey:@"timestamp"];
        
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [serviceDict objectForKey:@"appid"];
        req.partnerId           = [serviceDict objectForKey:@"partnerid"];
        req.prepayId            = [serviceDict objectForKey:@"prepayid"];
        req.nonceStr            = [serviceDict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [serviceDict objectForKey:@"packageValue"];
        req.sign                 = [serviceDict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

@end
