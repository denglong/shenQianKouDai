//
//  AlipayController.h
//  KingProFrame
//
//  Created by denglong on 7/28/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlipayController : NSObject

@property(nonatomic, copy) NSString * productName;            /**<商品名称*/
@property(nonatomic, copy) NSString * productDescription;   /**<商品描述*/
@property(nonatomic, copy) NSString * amount;                  /**<商品价格*/
@property(nonatomic, retain) NSString *orderNum;
@property(nonatomic, retain) NSString *myOrderString;

+ (AlipayController *)sharedManager;   /**<支付宝支付单例创建*/
- (void)alipayAction;                     /**<支付宝客服端签名支付执行方法*/
- (void)alipayServicesPayAction;       /**<支付宝服务端签名支付执行方法*/

@end
