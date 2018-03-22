//
//  CYGoodsTagModel.h
//  KingProFrame
//
//  Created by eqbang on 16/1/21.
//  Copyright © 2016年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYGoodsTagModel : NSObject

/** 商品标签文字 */
@property (nonatomic,copy) NSString *text;
/** 商品标签文字颜色 */
@property (nonatomic,copy) NSString *textColor;
/** 商品标签背景颜色 */
@property (nonatomic,copy) NSString *bgColor;
/** 商品标签边框颜色 */
@property (nonatomic,copy) NSString *borderColor;
/** 商品标签边框样式 */
@property (nonatomic,assign) int borderStyle;

@end
