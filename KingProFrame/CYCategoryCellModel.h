//
//  CYCategoryCellModel.h
//  KingProFrame
//
//  Created by eqbang on 15/12/16.
//  Copyright © 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYCategoryCellModel : NSObject

/** 购买数量 */
@property (nonatomic,assign) int goodsNumber;
/** 商品ID */
@property (nonatomic,assign) int goodsId;
/** 商品名称 */
@property (nonatomic,copy) NSString *goodsName;
/** 商品图片URLString */
@property (nonatomic,copy) NSString *goodsPic;
/** 商品价格 */
@property (nonatomic,assign) float  goodsPrice;
/** 是否是热门商品 */
@property (nonatomic,assign) int isHot;
/** 商品小图片 */
@property (nonatomic,copy) NSString *smallGoodsPic;
/** 加减按钮的tag */
@property (nonatomic,assign) NSInteger indexPathRow;
/** 会员价格 */
@property (nonatomic,copy) NSString *vipPrice;

/****  V3.24新增接口     ****/

/** 活动商品脚标URL */
@property (nonatomic,strong) NSString *sellTypeIcon;
/** 商品标签数组 */
@property (nonatomic , strong) NSMutableArray *goodsTags;
/** 商品类型 */
@property (nonatomic,assign) int sellType;
/** 活动商品连接URL */
@property (nonatomic,copy) NSString *link;

@end
