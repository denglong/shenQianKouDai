//
//  RedEnvelopeView.m
//  KingProFrame
//
//  Created by lihualin on 15/8/22.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "RedEnvelopeView.h"

@implementation RedEnvelopeView


- (void)drawRect:(CGRect)rect {
    self.textALabel.text = @"分享红包给好友\n红包可用于抵扣在线支付金额";
}



- (IBAction)cancelOrOkBtnClick:(UIButton *)sender {
    [self.delegate cancelOrSureBtnClick:sender.tag];
}
@end
