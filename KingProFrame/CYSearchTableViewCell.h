//
//  CYSearchTableViewCell.h
//  KingProFrame
//
//  Created by eqbang on 15/12/9.
//  Copyright © 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYSearchResultGoodsModel.h"

@protocol CYSearchResultGoodsModelDelegate <NSObject>

- (void)pushToBuyItRightNowWebiew:(NSString *)link;

@end

@interface CYSearchTableViewCell : UITableViewCell

/** 搜索结果物品模型 */
@property (nonatomic , strong) CYSearchResultGoodsModel *model;
/** 按钮的tag */
@property (nonatomic,assign) NSInteger buttonTag;
/** 添加商品按钮 */
@property(nonatomic,retain)IBOutlet UIButton *addBtn;
/** 搜索结果代理 */
@property (nonatomic , weak) id<CYSearchResultGoodsModelDelegate> delegate;

@end
