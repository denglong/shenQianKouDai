//
//  ShopCartTableViewCell.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/18.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYCartGoodsModel.h"
#import "Headers.h"

@protocol ShopCartCellDelegate <NSObject>

@optional
//选择商品按钮点击
- (void)selectedGoodsAction:(UIButton *)button;
//点击删除商品数量按钮
- (void)deleteGoodsAction:(UIButton *)button;
// 点击增加商品数量按钮
- (void)addGoodsAction:(UIButton *)button;

@end


@interface ShopCartTableViewCell : UITableViewCell

/** 商品模型 */
@property (nonatomic , strong) CYCartGoodsModel *model;
@property (nonatomic , weak) id <ShopCartCellDelegate> delegate;
/** 按钮tag */
@property (nonatomic,assign) NSInteger buttonTag;

/** 商品图片 */
@property(nonatomic,retain)IBOutlet UIImageView *desImgView;
/** 价格 */
@property(nonatomic,retain)IBOutlet UILabel *priceLabel;
/** 商品数量 */
@property(nonatomic,retain)IBOutlet UILabel *goodsNumLabel;
/** 左边删除按钮 */
@property(nonatomic,retain)IBOutlet UIButton *leftDeletBtn;
/** 右边增加按钮 */
@property(nonatomic,retain)IBOutlet UIButton *rightAddBtn;
/** 商品名称 */
@property(nonatomic,retain)IBOutlet UILabel *goodsTitleLabel;
/** 商品数量和商品增减按钮的contentview */
@property(nonatomic,retain)IBOutlet UIView *contentNumView;
/** 商品下架标识 */
@property(nonatomic,retain)  UIButton *deleteShop;
//选择cell按钮
@property(nonatomic,retain)IBOutlet UIButton *selectBtn;

@property(weak, nonatomic) IBOutlet UIView *shadoView;

@end
