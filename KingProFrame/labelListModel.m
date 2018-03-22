//
//  labelListModel.m
//  KingProFrame
//
//  Created by denglong on 12/2/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "labelListModel.h"

@implementation labelListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"topicGoodsVos" : @"goodsListModel",
             };
}

@end
