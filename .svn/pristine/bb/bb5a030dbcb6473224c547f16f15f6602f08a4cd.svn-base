//
//  TheOrderCell.h
//  KingProFrame
//
//  Created by denglong on 7/28/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myOrderModel.h"

@interface TheOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel         *date;                  /**<账单日期*/
@property (weak, nonatomic) IBOutlet UILabel         *state;                 /**<账单状态*/
@property (weak, nonatomic) IBOutlet UIScrollView   *myScrollView;        /**<滚动窗口*/
@property (weak, nonatomic) IBOutlet UILabel         *sum;                   /**<商品数量*/
@property (weak, nonatomic) IBOutlet UILabel         *amount;               /**<合计金额*/
@property (weak, nonatomic) IBOutlet UIImageView    *line;                  /**<分割线*/
@property (weak, nonatomic) IBOutlet UIButton        *payBtn;               /**<付款btn*/
@property (weak, nonatomic) IBOutlet UIButton        *cancleBtn;           /**<取消订单btn*/
@property (weak, nonatomic) IBOutlet UIImageView    *downImage;            /**<底部图片*/
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;                     /**<订单码*/
@property (weak, nonatomic) IBOutlet UITextField *goodsField;             /**<订单码输入框*/
@property (weak, nonatomic) IBOutlet UIButton *backOrderBtn;               /**<缺货申请退单按钮*/
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;                  /**<确认收货按钮*/
@property (nonatomic, retain) NSArray *imageUrls;      
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *phoneImg;
@property (weak, nonatomic) IBOutlet UIImageView *downLine;
@property (nonatomic, strong) myOrderModel *orderModel;
@property (weak, nonatomic) IBOutlet UIButton *yushouSign;

- (void)setShopImage;

@end
