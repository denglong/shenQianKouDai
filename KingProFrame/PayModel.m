//
//  PayModel.m
//  KingProFrame
//
//  Created by JinLiang on 15/8/25.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "PayModel.h"

@implementation PayModel

@synthesize data = _data;

#define PAYURL_WEIXIN @"PAYURL_WEIXIN" //微信url key
#define PAYURL_ALIPAY @"PAYURL_ALIPAY"  //支付宝 url  key
//初始化
- (id)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableDictionary dictionary];
    }
    return self;
}

+(PayModel*)shareInstance{
    
    static PayModel *sharedCommon;
    
    @synchronized(self) {
        if (!sharedCommon) {
            sharedCommon = [[self alloc] init];
        }
        return sharedCommon;
    }
}
//写入微信支付url
-(void)setWeixinPayUrl:(NSString *)aWeixinPayUrl{
    
    if (aWeixinPayUrl != nil) {
        [_data setObject:aWeixinPayUrl forKey:PAYURL_WEIXIN];
    }
}
//写入支付宝url
-(void)setAlipayUrl:(NSString *)aAlipayUrl{
    
    if (aAlipayUrl != nil) {
        [_data setObject:aAlipayUrl forKey:PAYURL_ALIPAY];
    }
}

//获取微信url
-(NSString *)getWeixinPayUrl{
    
    return [_data objectForKey:PAYURL_WEIXIN];
}
//获取支付宝 url
-(NSString *)getAlipayUrl{
    
    return [_data objectForKey:PAYURL_ALIPAY];
}
@end
