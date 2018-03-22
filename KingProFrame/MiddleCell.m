//
//  MiddleCell.m
//  KingProFrame
//
//  Created by denglong on 7/29/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "MiddleCell.h"

@implementation MiddleCell
@synthesize leftImage, payName, rightBtn, leftName, moneyNum, headerLine;

- (void)awakeFromNib {
    leftImage.layer.cornerRadius = 15;
    headerLine.frame = CGRectMake(15, 0, self.frame.size.width - 30, 0.5);
    leftImage.hidden                = YES;
    payName.hidden                  = YES;
    rightBtn.hidden                 = YES;
    leftName.hidden                 = YES;
    moneyNum.hidden                 = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
