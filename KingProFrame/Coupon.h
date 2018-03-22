//
//  Coupon.h
//  KingProFrame
//
//  Created by lihualin on 15/11/19.
//  Copyright © 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property(nonatomic,strong) NSString * ID;
@property(nonatomic,assign) NSInteger  type;
@property(nonatomic,strong) NSString * couponName;
@property(nonatomic,strong) NSString * apply;
@property(nonatomic,assign) float  price;
@property(nonatomic,assign) NSInteger  state;
@property(nonatomic,strong) NSString * startTime;
@property(nonatomic,strong) NSString * endTime;

@property(nonatomic,assign) NSInteger aboutExpire;
@property(nonatomic,strong) NSString * goodsId;
@property(nonatomic,strong) NSString * specialName;
@property(nonatomic,assign) NSInteger  subType;
@property(nonatomic,strong) NSString * cityLimit;
@end
