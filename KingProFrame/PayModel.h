//
//  PayModel.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/25.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject

@property (nonatomic, retain) NSMutableDictionary *data;


-(void)setWeixinPayUrl:(NSString *)aWeixinPayUrl;
-(void)setAlipayUrl:(NSString *)aAlipayUrl;

-(NSString *)getWeixinPayUrl;//微信支付url
-(NSString *)getAlipayUrl;//支付宝url

+(PayModel*)shareInstance;
@end
