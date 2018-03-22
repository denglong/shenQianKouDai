//
//  HeaderCell.m
//  KingProFrame
//
//  Created by denglong on 7/29/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell
@synthesize headerImage, totalNum, shopName;

- (void)awakeFromNib {
    headerImage.layer.cornerRadius = 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
