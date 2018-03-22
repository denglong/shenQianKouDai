//
//  BusinessOrderCell.m
//  KingProFrame
//
//  Created by denglong on 7/31/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "BusinessOrderCell.h"
#import "UIColor+HEX.h"

@implementation BusinessOrderCell
@synthesize bgView, orderNum, money, headerLeft, headerView, consumptionLab, subsidyLab, time, middleLine, rightBtn, downImageView, addressLab, downLine, totalLabel;

- (void)awakeFromNib {
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 1);
    
    UIImage *orderLine               = [UIImage imageNamed:@"icon_orderLine.png"];
    middleLine.backgroundColor     = [UIColor colorWithPatternImage:orderLine];
    downLine.backgroundColor       = [UIColor colorWithPatternImage:orderLine];
    
    UIImage *image                    = [UIImage imageNamed:@"icon_orderBg.png"];
    downImageView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    rightBtn.layer.cornerRadius    = 20;
    
    headerView.layer.cornerRadius = 20;
    headerView.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#8fc31f"] CGColor];
    headerView.layer.borderWidth = 1.0f;
    
    headerLeft.layer.cornerRadius = 20;
    headerLeft.backgroundColor = [UIColor_HEX colorWithHexString:@"#8fc31f"];
    
    _oneLab.layer.cornerRadius     = 13;
    _oneLab.layer.borderColor      = [headerLeft.backgroundColor CGColor];
    _oneLab.layer.borderWidth      = 0.5f;
    
    _twoLab.layer.cornerRadius     = 13;
    _twoLab.layer.borderColor      = [[UIColor blackColor] CGColor];
    _twoLab.layer.borderWidth      = 0.5f;
    
    time.layer.cornerRadius        = 13;
    time.layer.borderColor         = [[UIColor blackColor] CGColor];
    time.layer.borderWidth         = 0.5f;
    
    totalLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
