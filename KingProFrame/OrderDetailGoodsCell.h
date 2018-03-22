//
//  OrderDetailGoodsCell.h
//  KingProFrame
//
//  Created by lihualin on 15/10/26.
//  Copyright © 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsModel.h"
@interface OrderDetailGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *zuheLine;

@property (nonatomic, retain) NSArray *groupGoods;
@property (nonatomic ,retain) goodsModel * goods;
@end
