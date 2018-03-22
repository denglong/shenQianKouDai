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
{
    enum WXScene    _scene;
    NSString        *Token;
    long             token_time;
}

+ (WeChatPayController *)sharedManager;   /**<支付宝支付单例创建*/
- (void)weChatPayAction;                     /**<支付宝支付执行方法*/

@end
