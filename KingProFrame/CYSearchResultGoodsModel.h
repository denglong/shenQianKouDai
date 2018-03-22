//
//  CYSearchResultGoodsModel.h
//  KingProFrame
//
//  Created by eqbang on 15/12/9.
//  Copyright © 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYSearchResultGoodsModel : NSObject

/** 商品的cid */
@property (nonatomic,assign) int cid;
/** 商品ID */
@property (nonatomic,assign) int goodsId;
/** 商品名称 */
@property (nonatomic,copy) NSString *goodsName;
/** 商品图片 */
@property (nonatomic,copy) NSString *goodsPic;
/** 商品价格 */
@property (nonatomic,assign) float goodsPrice;
/** 热门产品 */
@property (nonatomic,assign) int isHot;
/** 小尺寸的商品图片 */
@property (nonatomic,copy) NSString *smallGoodsPic;
/** 商品类型 */
@property (nonatomic,assign) int sellType;
/** H5链接 */
@property (nonatomic,copy) NSString *link;
/** 商品左上角标签 */
@property (nonatomic,copy) NSString *sellTypeIcon;
/** 商品标签 */
@property (nonatomic , strong) NSMutableArray *goodsTags;

@end

