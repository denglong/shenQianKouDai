//
//  ConfirmOrderCell.m
//  KingProFrame
//
//  Created by denglong on 8/19/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "ConfirmOrderCell.h"

@implementation ConfirmOrderCell
@synthesize goodsName, goodsNum, goodsPrice, chonseBtn, chooseWay, remarksTextFile, addIcon, address;

- (void)awakeFromNib {
    
    chonseBtn.hidden = YES;
    chooseWay.hidden = YES;
    remarksTextFile.hidden = YES;
    address.hidden = YES;
    addIcon.hidden = YES;
    self.rightArrows.hidden = YES;
    self.greenImg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
