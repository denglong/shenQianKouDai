//
//  OrderDetail.m
//  KingProFrame
//
//  Created by lihualin on 15/8/10.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "OrderDetail.h"

@implementation OrderDetail
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"goodsList":@"goodsModel"};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"addressId" : @"id"};
}
@end
