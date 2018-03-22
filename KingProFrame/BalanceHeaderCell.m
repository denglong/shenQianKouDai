//
//  BalanceHeaderCell.m
//  KingProFrame
//
//  Created by lihualin on 15/8/21.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BalanceHeaderCell.h"
#import "Headers.h"
@implementation BalanceHeaderCell

- (void)awakeFromNib {
    // Initialization code
//    UIView * viewline = [[UIView alloc]initWithFrame:CGRectMake(15, 85, viewWidth-30, 0.5)];
//    viewline.backgroundColor = RGBACOLOR(204, 204, 204, 1.0);
//    [self.contentView addSubview:viewline];
    self.btn.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBalanceDetail:(BalanceDetail *)balanceDetail
{
    self.revenueLabel.text = [NSString stringWithFormat:@"￥%.2f",[balanceDetail.revenue floatValue]];
    [self.revenueLabel sizeToFit];
    self.revenueLabel.center = CGPointMake(self.center.x, self.revenueLabel.center.y);
    self.textA.frame = CGRectMake(self.revenueLabel.frame.origin.x, self.textA.frame.origin.y, self.textA.frame.size.width, self.textA.frame.size.height);
    
    self.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f",[balanceDetail.balance floatValue]];
    self.canBalanceLabel.text = [NSString stringWithFormat:@"￥%.2f",[balanceDetail.canBalance floatValue]];
    if ([balanceDetail.ifWithdraw integerValue] ==1) {
        self.btn.enabled = YES;
        self.btn.backgroundColor = [UIColor_HEX colorWithHexString:@"#ffe100"];
    }else{
        self.btn.enabled = NO;
        self.btn.backgroundColor = RGBACOLOR(204, 204, 204, 1.0);
    }
}
@end
