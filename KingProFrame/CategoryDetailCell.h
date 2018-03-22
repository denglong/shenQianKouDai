//
//  CategoryDetailCell.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYCategoryCellModel.h"

@protocol CYCategoryDetailCellDelegate <NSObject>

@optional
- (void)pushToBuyNowWebiew:(NSString *)link;
- (void)btnTouchAction:(id)button;
- (void)minusGoodsCount:(id)button;
@end

@interface CategoryDetailCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UIImageView *desImageView;
@property(nonatomic,retain)IBOutlet UIImageView *hotImageView;
@property(nonatomic,retain)IBOutlet UILabel *goodsNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *priceLabel;
@property(nonatomic,retain)IBOutlet UIButton *addBtn;
@property(nonatomic,retain)IBOutlet UIButton *addExtBtn;
@property (strong, nonatomic) IBOutlet UIImageView *advImageView;
@property (weak, nonatomic) IBOutlet UIView *separateLine;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;

/** 分类商品cell模型 */
@property (nonatomic , strong) CYCategoryCellModel *model;
/** 左边的减按钮 */
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
/** 商品数量 */
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
/** 立即购买按钮 */
@property (weak, nonatomic) IBOutlet UIButton *buyItRightNow;
/** 直降 */
@property (weak, nonatomic) IBOutlet UIButton *zhijiangButon;
/** 商品标签1 */
@property (weak, nonatomic) IBOutlet UIButton *firstTagButton;
/** 商品标签2 */
@property (weak, nonatomic) IBOutlet UIButton *secondTagButton;
/** 商品标签3 */
@property (weak, nonatomic) IBOutlet UIButton *thiredTagButton;

/** cell代理 */
@property (nonatomic , weak) id<CYCategoryDetailCellDelegate> delegate;

@end
