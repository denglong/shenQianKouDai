//
//  OrderDetailFootCell.m
//  KingProFrame
//
//  Created by lihualin on 15/8/6.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "OrderDetailFootCell.h"
#import "Headers.h"
@implementation OrderDetailFootCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//时间戳转换成时间 timeFormat是要转换成的时间格式
-(NSString*)formatTimeStamp:(NSString *)timeStamp timeFormat:(NSString *)timeFormat{
    
    
    //NSTimeInterval time=[timeStamp doubleValue]+28800;//因为时差问题要加8小时 == 28800
    NSTimeInterval time=[timeStamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //DLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:timeFormat];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

-(void)setOrderDetail:(OrderDetail *)orderDetail
{
    if (orderDetail == nil) {
        return;
    }
    //姓名
    self.nameLabel.text = orderDetail.addressUser;
    //电话
    self.phonelabel.text = orderDetail.addressTel;
    self.createTime.text = orderDetail.createTime?[self formatTimeStamp:[orderDetail.createTime substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"]:@"";
    
   
//    NSString * address =  [NSString stringWithFormat:@"%@%@%@",orderDetail.street,orderDetail.address,orderDetail.addressDetail];
    NSString *address = orderDetail.address;//orderDetail.address;//[address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   
    self.addressLabel.text = address;
    self.addressLabel.numberOfLines = 2;
    [self.addressLabel sizeToFit];
    if (orderDetail.orderStatus == 1) {
        self.payView.hidden = YES;
        self.timeConstraint.constant = 0;
    }else{
        self.payView.hidden = NO;
        self.timeConstraint.constant = 21;
        if ([orderDetail.shippingType integerValue] == 1) {
            self.kindLabel.text = @"送货上门";
        }else {
            self.kindLabel.text = @"到店自提";
        }
    }
    
    if ([orderDetail.shippingType integerValue] == 1) {
        self.peopleLabel.text = @"联系人:";
        self.peoplePhone.text = @"电话:";
        self.peopleAddress.text = @"收货地址:";
        self.kindConstraints.constant = 20;
        self.orderNoConstraints.constant = 20;
    }
    else{
        self.peopleLabel.text = @"自提点联系人:";
        self.peoplePhone.text = @"联系电话:";
        self.peopleAddress.text = @"自提点地址:";
        self.kindConstraints.constant = 43;
        self.orderNoConstraints.constant = 44;
    }
    
    if ([DataCheck isValidString:orderDetail.orderNo]) {
//        NSString *myDate = orderDetail.createTime;
//        self.timeOrderlabel.text = [CommClass formatIntiTimeStamp:myDate timeFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.timeLabel.text = orderDetail.orderNo;
    }
//    NSString * userdeliveryTime = [NSString stringWithFormat:@"%@",orderDetail.userDeliveryTime];
//    if ([DataCheck isValidString:userdeliveryTime]) {
//        if (orderDetail.yushou == 1) {
//            //预售商品订单 送达时间只显示年月日
//            self.timeLabel.text = [CommClass formatIntiTimeStamp:userdeliveryTime timeFormat:@"yyyy-MM-dd"];
//        }else{
//            self.timeLabel.text = [CommClass formatIntiTimeStamp:userdeliveryTime timeFormat:@"yyyy-MM-dd HH:mm:ss"];
//        }
//    }
    CGSize size =[CommClass getSuitSizeWithString:address font:12 bold:NO sizeOfX:viewWidth-90-15];
    if (orderDetail.orderStatus == 6 && orderDetail.cancelStatus == 5 && orderDetail.refundStatus == 2) {
        self.remarkView.hidden = NO;
        NSString *myDate = orderDetail.cancelTime;
        self.remarkLabel.text = [CommClass formatIntiTimeStamp:myDate timeFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(self.remarkView.frame)+10 + size.height);
    }else {
        self.remarkView.hidden = YES;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(self.detailView.frame)+10 + size.height);
    }
    if (orderDetail.orderStatus == 1) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(self.detailView.frame) - 21 + size.height);
    }
}


@end
