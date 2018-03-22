//
//  WeChatPayController.h
//  KingProFrame
//
//  Created by denglong on 7/28/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "payRequsestHandler.h"

@interface WeChatPayController : NSObject<WXApiDelegate>

@property (nonatomic, retain) NSString *ORDER_NAME;      /**<账单名称*/
@property (nonatomic, retain) NSString *ORDER_PRICE;     /**<账单金额（单位分）*/
@property (nonatomic, retain) NSString *orderNum;
@property (nonatomic, retain) NSDictionary *serviceDict; /**<服务器返回支付参数*/

+ (WeChatPayController *)sharedManager;   /**<微信支付单例创建*/
- (void)weChatPayAction;                     /**<微信支付执行方法，本地签名*/
- (void)weChatServicesPayAction;           /**<微信支付执行方法，服务器签名*/

@end
