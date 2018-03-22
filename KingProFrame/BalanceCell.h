//
//  BalanceCell.h
//  KingProFrame
//
//  Created by lihualin on 15/7/30.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBean.h"
#import "Balance.h"
@interface BalanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic ,retain) EBean * eBean;

@property (nonatomic ,retain) Balance * balance;
@end
