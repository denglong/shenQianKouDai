//
//  OrderDetailInfoCell.m
//  KingProFrame
//
//  Created by lihualin on 15/8/6.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "OrderDetailInfoCell.h"
#import "Headers.h"
@implementation OrderDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrderDetail:(OrderDetail *)orderDetail
{
    self.goodsTotalPrice.text = [NSString stringWithFormat:@"¥%.2f",orderDetail.totalPrice];
    //优惠券
    if (orderDetail.vipSavingPrice == 0) {
        self.couponPrice.text =[NSString stringWithFormat:@"￥%.2f",orderDetail.vipSavingPrice];
    }else {
        self.couponPrice.text =[NSString stringWithFormat:@"-￥%.2f",orderDetail.vipSavingPrice];
    }
    //配送费
    MyInfoModel *myInfo = [MyInfoModel sharedInstance];
    if ([myInfo.userType integerValue] == 1) {
        self.peisongPrice.text =[NSString stringWithFormat:@"￥0.00"];
    }
    else
    {
    self.peisongPrice.text =[NSString stringWithFormat:@"￥%.2f",orderDetail.expressPrice];
    }
    //小费
    self.pingtaiPrice.text =[NSString stringWithFormat:@"￥%.2f",orderDetail.tipPrice];
    //实际支付
    self.payPrice.text = [NSString stringWithFormat:@"￥%.2f",orderDetail.payPrice];
}
@end
