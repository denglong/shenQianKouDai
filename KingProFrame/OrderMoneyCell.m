//
//  OrderMoneyCell.m
//  KingProFrame
//
//  Created by denglong on 3/7/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "OrderMoneyCell.h"

@implementation OrderMoneyCell
@synthesize upLine, downLine;

- (void)awakeFromNib {
    [super awakeFromNib];
    upLine.frame = CGRectMake(10, upLine.frame.origin.y, upLine.frame.size.width, 0.5);
    downLine.frame = CGRectMake(10, downLine.frame.origin.y, downLine.frame.size.width, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
