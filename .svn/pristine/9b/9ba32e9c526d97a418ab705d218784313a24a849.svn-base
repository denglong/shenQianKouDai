//
//  BalanceCell.m
//  KingProFrame
//
//  Created by lihualin on 15/7/30.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BalanceCell.h"
#import "Headers.h"
@implementation BalanceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEBean:(EBean *)eBean
{
    NSString * title = eBean.title;
    NSMutableAttributedString * AttrTitle =[[NSMutableAttributedString alloc]initWithString:title];
    NSRange rang = [title rangeOfString:@"("];
    if (rang.length > 0) {
        [AttrTitle addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(153, 153, 153, 1.0) range:NSMakeRange(rang.location,title.length-rang.location)];
    }
    self.orderNumberLabel.attributedText = AttrTitle;
    NSString * timeStr = eBean.createTime;
    self.timeLabel.text = [CommClass formatIntiTimeStamp:timeStr timeFormat:@"yyyy-MM-dd HH:mm"];
    if (eBean.pea < 0) {
        self.priceLabel.textColor = RGBACOLOR(245, 125, 110, 1.0);
        self.priceLabel.text = [NSString stringWithFormat:@"%ld",eBean.pea];
    }else {
        self.priceLabel.textColor = RGBACOLOR(143, 195, 31, 1.0);
        self.priceLabel.text = [NSString stringWithFormat:@"+%ld",eBean.pea];
    }

}

-(void)setBalance:(Balance *)balance
{
    NSString * title = balance.title;
    NSMutableAttributedString * AttrTitle =[[NSMutableAttributedString alloc]initWithString:title];
    NSRange rang = [title rangeOfString:@":"];
    if (rang.length > 0) {
        [AttrTitle addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(153, 153, 153, 1.0) range:NSMakeRange(rang.location+1,title.length-rang.location-1)];
    }
    self.orderNumberLabel.attributedText = AttrTitle;
    
    NSString * timeStr = balance.createTime;
    self.timeLabel.text = [CommClass formatIntiTimeStamp:timeStr timeFormat:@"yyyy-MM-dd HH:mm"];
//    float number = [[balance objectForKey:@"price"] floatValue];
    NSMutableString * priceStr = [NSMutableString stringWithFormat:@"%.2f",balance.price];
    if (balance.price < 0) {
        self.priceLabel.textColor = RGBACOLOR(245, 125, 110, 1.0);
        [priceStr insertString:@"￥" atIndex:1];
        self.priceLabel.text = priceStr;
    }else {
        self.priceLabel.textColor = RGBACOLOR(143, 195, 31, 1.0);
        [priceStr insertString:@"+￥" atIndex:0];
        NSMutableAttributedString * AttrTitle =[[NSMutableAttributedString alloc]initWithString:priceStr];
        [AttrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0,2)];
        self.priceLabel.attributedText = AttrTitle;
    }
    

}
@end
