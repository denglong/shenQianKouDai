//
//  CYSearchResultGoodsModel.m
//  KingProFrame
//
//  Created by eqbang on 15/12/9.
//  Copyright © 2015年 king. All rights reserved.
//

#import "CYSearchResultGoodsModel.h"
#import "CYGoodsTagModel.h"

@implementation CYSearchResultGoodsModel


+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"goodsTags":@"CYGoodsTagModel"
             };
}


@end
