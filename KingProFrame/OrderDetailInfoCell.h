//
//  OrderDetailInfoCell.h
//  KingProFrame
//
//  Created by lihualin on 15/8/6.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetail.h"
@interface OrderDetailInfoCell : UITableViewCell
/**商品总价*/
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalPrice;
/**优惠券折扣*/
@property (weak, nonatomic) IBOutlet UILabel *couponPrice;
/**平台优惠*/
@property (weak, nonatomic) IBOutlet UILabel *pingtaiPrice;
/**配送费*/
@property (weak, nonatomic) IBOutlet UILabel *peisongPrice;
/**实际支付*/
@property (weak, nonatomic) IBOutlet UILabel *payPrice;

@property (nonatomic , retain) OrderDetail * orderDetail;
@end
