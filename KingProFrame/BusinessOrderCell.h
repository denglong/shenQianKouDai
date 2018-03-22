//
//  BusinessOrderCell.h
//  KingProFrame
//
//  Created by denglong on 7/31/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView        *bgView;                 /**<背景View*/
@property (weak, nonatomic) IBOutlet UILabel       *orderNum;              /**<订单号*/
@property (weak, nonatomic) IBOutlet UILabel       *money;                  /**<订单金额*/
@property (weak, nonatomic) IBOutlet UILabel       *consumptionLab;       /**<含消费Lab*/
@property (weak, nonatomic) IBOutlet UILabel       *subsidyLab;            /**<平台奖励Lab*/
@property (weak, nonatomic) IBOutlet UILabel       *time;                   /**<距离发布的时间*/
@property (weak, nonatomic) IBOutlet UIImageView  *middleLine;            /**<中部线*/
@property (weak, nonatomic) IBOutlet UILabel       *oneLab;
@property (weak, nonatomic) IBOutlet UILabel       *twoLab;
@property (weak, nonatomic) IBOutlet UIButton      *rightBtn;               /**<查看详情btn*/
@property (weak, nonatomic) IBOutlet UIImageView  *downImageView;         /**<底部imageView*/
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *downLine;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *headerLeft;
@property (weak, nonatomic) IBOutlet UIView *headerLine;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end
