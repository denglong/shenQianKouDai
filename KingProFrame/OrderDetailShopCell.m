//
//  OrderDetailShopself.m
//  KingProFrame
//
//  Created by lihualin on 15/8/6.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "OrderDetailShopCell.h"
#import "Headers.h"
@implementation OrderDetailShopCell

- (void)awakeFromNib {
    // Initialization code
    self.kindFeiLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//各种费用，合计，订单号
-(void)setOrderDetail:(OrderDetail *)orderDetail WithIndexPath:(NSIndexPath *)indexPath total:(NSInteger)totalNum
{
    if ((orderDetail.orderStatus >=1 && indexPath.section == 1)) {
        if ([DataCheck isValidString:orderDetail.name]) {
            self.nameLabel.text = orderDetail.name;
        }else{
            self.nameLabel.text = @"购物清单";
        }
        self.priceCountLabel.text = [NSString stringWithFormat:@"共计%ld件",totalNum];
        return;
    }
    /**订单号*/
    self.nameLabel.text = @"订单详情";
    self.priceCountLabel.text = [NSString stringWithFormat:@"编号 : %@",orderDetail.orderNo];
}


///**订单号*/
//-(void)setOrderNo:(NSString *)orderNo
//{
//    self.nameLabel.text = [NSString stringWithFormat:@"订单号：%@",orderNo];
//    self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, 0, self.frame.size.width-30, self.frame.size.height);
//    self.numLabel.hidden = YES;
//    self.priceCountLabel.hidden = YES;
//
//}
@end
