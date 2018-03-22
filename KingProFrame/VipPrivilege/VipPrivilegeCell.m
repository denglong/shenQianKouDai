//
//  VipPrivilegeCell.m
//  KingProFrame
//
//  Created by meyki on 11/29/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "VipPrivilegeCell.h"
#import "Headers.h"

@implementation VipPrivilegeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buyButton.layer.cornerRadius = 3;
    self.buyButton.layer.borderColor = [UIColor_HEX colorWithHexString:@"FF5757"].CGColor;
    self.buyButton.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
