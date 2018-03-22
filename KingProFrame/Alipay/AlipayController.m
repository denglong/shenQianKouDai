//
//  AlipayController.m
//  KingProFrame
//
//  Created by denglong on 7/28/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "AlipayController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "PayModel.h"

@implementation AlipayController

+ (AlipayController *)sharedManager
{
    static AlipayController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//客户端签名支付
- (void)alipayAction {
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088511425383693";
    NSString *seller = @"payment@eqbang.com";
    NSString *privateKey =
    @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMvhfOfNFn8V8kx4KEGwYBTXNIEHXZ3iSGffBShr96lHuytouaKVQnUcx5unNNex9EwGP2tdJ8LKCAWIqzxoLjqtLuikaJ/nAIrJ26DUDjOLS5wuZgWZy4hDVbB4UkOLw3DJlE1jceNYaoC95JfO+GXjy6s7xjiT19RKjXmdm34hAgMBAAECgYEAqUMt2KAKwj1tKJFFEqwkSIkWHN0Jms9HP30HIjToqtBTkslh/JmgT+wxx4b8tuoVoJw7QJ5ZKT1jhXyedQsk/LKHlyqQcksNaat2sNtaOm4H92YHEUZ9/tCqVGHCS0bFdzp6T1IHcwjcF/ZcPMgJRxgzO7SRHbrrRWf205vbX6UCQQD85xRpLNgtw6XlB8nOYIfz/xICEd+u5b8YSOWMrxNevNtDPABJ7SiLaKZ5tVcEDob8fYvSfiqmapBLLycB+V33AkEAzmC2B1G4gneWPnGklVC+2Qg5bJfxSdEtDyJH2GK8zT2MkjylQL76hBA7c+0kGYCsYyWL3DHvLyNnQtywjmXepwJBAJRHhD8aTPGgKa88PsVi8bNMlSljg2vPRpidfQFcURYV0tT75At0InaCeEEZ4pf9UIXPsmBLGwSRrGJ4lf1hUQcCQAD5GcKdEwaic7XlqUX+9Hdnf4XQjZWwg8rfeYE+re81zBTgblMI03uN7AnW42WvYqCxC6DFJ4CMZS8+hSKWvl8CQQCfpxkjDUZK6wd0FrzSuLB6fW3ZtF4oa538RhUfSAAA8EMHW2i4r5kBXJ/Np1XKxWDWZllLYOwZNwKJd4sT5xj/";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.orderNum;//[self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = self.productName;//@"鼠标垫"; //商品标题
    order.productDescription = self.productDescription;//@"鼠标垫"; //商品描述
    order.amount = self.amount; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@", [PayModel shareInstance].getAlipayUrl];
    //@"http://payeqb.wicp.net/alipay/notify.do"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"myClass";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    DLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            DLog(@"reslut = %@",resultDic);
        }];
    }
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//服务端签名支付
- (void)alipayServicesPayAction {
    
    NSString *appScheme = @"koudaishengqian";
    
    [[AlipaySDK defaultService] payOrder:self.myOrderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        DLog(@"reslut = %@",resultDic);
        NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
        if (resultStatus == 9000) {
            NSNotification *notification = [NSNotification notificationWithName:@"ALIPAYSESSUED" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        else
        {
            NSNotification *notification = [NSNotification notificationWithName:@"ALIPAYFILED" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }];
}

@end
