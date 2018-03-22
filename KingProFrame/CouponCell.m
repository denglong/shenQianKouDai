
//
//  CouponCell.m
//  KingProFrame
//
//  Created by lihualin on 15/8/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CouponCell.h"
#import "Headers.h"
@implementation CouponCell


- (void)awakeFromNib {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)data
{
    float h = (viewWidth- 30) * self.leftImageView.image.size.height/self.leftImageView.image.size.width;
//    float w = 100.0/290.0;
    if ([[data objectForKey:@"isDefault"] integerValue] == 1) {
        self.rightImageView.hidden = NO;
    }else{
        self.rightImageView.hidden = YES;
    }
    //城市限制文案
    self.couponAddressLabel.text = [data objectForKey:@"cityLimit"];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[data objectForKey:@"price"] floatValue]];
    NSInteger state = [[data objectForKey:@"state"] integerValue];
    self.expiredLabel.hidden = NO;
    self.leftImageView.image = [UIImage imageNamed:@"coupon_old"];
    if (state == 0) {
        NSInteger oldState = [[data objectForKey:@"aboutExpire"] integerValue];
        if (oldState == 0) {
             self.expiredLabel.hidden = YES;
             self.oldImageView.hidden = YES;
            switch ([[data objectForKey:@"type"] integerValue]) {
                case 0:
                {
                    if ([[data objectForKey:@"subType"] integerValue] == 0) {
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_Yunfei"];
                    }else{
                       self.leftImageView.image = [UIImage imageNamed:@"coupon_manJianchild1"];
                    }
                }
                    break;
                case 1:
                {
                    if ([[data objectForKey:@"subType"] integerValue] == 0) {
                         self.leftImageView.image = [UIImage imageNamed:@"coupon_Manjian"];
                    }else{
                        self.leftImageView.image = [UIImage imageNamed:@"coup_LijianChild1"];
                    }
                }
                    break;
                case 2:
                    self.leftImageView.image = [UIImage imageNamed:@"coupon_Lijian"];
                    break;
                default:
                    break;
            }
        }else{
            //即将过期
            self.expiredLabel.text =@"即将过期";
            self.oldImageView.hidden = NO;
            switch ([[data objectForKey:@"type"] integerValue]) {
                case 0:
                {
                    if ([[data objectForKey:@"subType"] integerValue] == 0) {
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_Yunfei"];
                    }else{
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_manJianchild1"];
                    }
                }
                    break;
                case 1:
                {
                    if ([[data objectForKey:@"subType"] integerValue] == 0) {
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_Manjian"];
                    }else{
                        self.leftImageView.image = [UIImage imageNamed:@"coup_LijianChild1"];
                    }
                }
                    break;
                case 2:
                    self.leftImageView.image = [UIImage imageNamed:@"coupon_Lijian"];
                    break;
                default:
                    break;
            }

        }
    }else if(state == 1){
        self.expiredLabel.text =@"已使用";
    }else {
        self.expiredLabel.text =@"已过期";
    }
    self.kindLabel.text = [data objectForKey:@"specialName"];

    NSString * startTimeStr = [data objectForKey:@"startTime"];
    NSString * timeStr = [data objectForKey:@"endTime"];
    
    
    NSString * priceCountStr = [NSString stringWithFormat:@"%@",[data objectForKey:@"couponName"]];
    if ([DataCheck isValidString:priceCountStr]) {
        self.priceCountLabel.text = [NSString stringWithFormat:@"%@",priceCountStr];
        self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",[CommClass formatIntiTimeStamp:startTimeStr timeFormat:@"yyyy-MM-dd"],[CommClass formatIntiTimeStamp:timeStr timeFormat:@"yyyy-MM-dd"]];
    }else{
        self.timeLabel.text = @"";
        self.priceCountLabel.text = [NSString stringWithFormat:@"%@至%@",[CommClass formatIntiTimeStamp:startTimeStr timeFormat:@"yyyy-MM-dd"],[CommClass formatIntiTimeStamp:timeStr timeFormat:@"yyyy-MM-dd"]];
    }
    self.frame = CGRectMake(0, 0, viewWidth - 30, h);
}

-(void)setCoupon:(Coupon *)coupon
{
    float h = (viewWidth- 30) * self.leftImageView.image.size.height/self.leftImageView.image.size.width;
    //    float w = 100.0/290.0;
     //城市限制文案
    self.couponAddressLabel.text = coupon.cityLimit;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",coupon.price];
    self.expiredLabel.hidden = NO;
    self.leftImageView.image = [UIImage imageNamed:@"coupon_old"];
    if (coupon.state == 0) {
        if (coupon.aboutExpire == 0) {
            self.expiredLabel.hidden = YES;
            self.oldImageView.hidden = YES;
            switch (coupon.type) {
                case 0:
                {
                    if (coupon.subType == 0) {
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_Yunfei"];
                    }else{
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_manJianchild1"];
                    }
                }
                    break;
                case 1:
                {
                    if (coupon.subType == 0) {
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_Manjian"];
                    }else{
                        self.leftImageView.image = [UIImage imageNamed:@"coup_LijianChild1"];
                    }
                }
                    break;
                case 2:
                    self.leftImageView.image = [UIImage imageNamed:@"coupon_Lijian"];
                    break;
                default:
                    break;
            }
        }else{
            //即将过期
            self.expiredLabel.text =CouponWillOutDate;
            self.oldImageView.hidden = NO;
            switch (coupon.type) {
                case 0:
                {
                    if (coupon.subType == 0) {
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_Yunfei"];
                    }else{
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_manJianchild1"];
                    }
                }
                    break;
                case 1:
                {
                    if (coupon.subType == 0) {
                        self.leftImageView.image = [UIImage imageNamed:@"coupon_Manjian"];
                    }else{
                        self.leftImageView.image = [UIImage imageNamed:@"coup_LijianChild1"];
                    }
                }
                    break;
                case 2:
                    self.leftImageView.image = [UIImage imageNamed:@"coupon_Lijian"];
                    break;
                default:
                    break;
            }
        }
    }else if(coupon.state == 1){
        self.expiredLabel.text =CouponUsed;
    }else {
        self.expiredLabel.text =CouponOutDate;
    }
    self.kindLabel.text = coupon.specialName;
    
    
    NSString * priceCountStr = coupon.couponName;
    if ([DataCheck isValidString:priceCountStr]) {
        self.priceCountLabel.text = [NSString stringWithFormat:@"%@",priceCountStr];
        self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",[CommClass formatIntiTimeStamp:coupon.startTime timeFormat:@"yyyy-MM-dd"],[CommClass formatIntiTimeStamp:coupon.endTime timeFormat:@"yyyy-MM-dd"]];
    }else{
        self.timeLabel.text = @"";
        self.priceCountLabel.text = [NSString stringWithFormat:@"%@至%@",[CommClass formatIntiTimeStamp:coupon.startTime timeFormat:@"yyyy-MM-dd"],[CommClass formatIntiTimeStamp:coupon.endTime timeFormat:@"yyyy-MM-dd"]];
    }
    self.frame = CGRectMake(0, 0, viewWidth - 30, h);
}



@end
