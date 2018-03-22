//
//  transferGoodsCell.h
//  KingProFrame
//
//  Created by eqbang on 15/12/3.
//  Copyright © 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYCartGoodsModel.h"

@protocol transferGoodsCellDelegate <NSObject>

@optional

//点击删除商品数量按钮
- (void)specialGoodsDeleteAction:(UIButton *)button;

@end


@interface transferGoodsCell : UITableViewCell

/** 商品模型 */
@property (nonatomic , strong) CYCartGoodsModel *goodsModel;
/** 代理 */
@property (nonatomic , weak) id<transferGoodsCellDelegate> delegate;

- (void)setGoodsButtonTag:(NSInteger)goodsButtonTag;

@end
