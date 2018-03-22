//
//  OrderDetailCell.m
//  KingProFrame
//
//  Created by denglong on 8/3/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell
@synthesize addressIcon, address, rightLab, leftLab, middleLab;

- (void)awakeFromNib {
    addressIcon.hidden = YES;
    address.hidden = YES;
    middleLab.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
