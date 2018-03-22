//
//  HeaderViewCell.m
//  KingProFrame
//
//  Created by denglong on 8/14/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "HeaderViewCell.h"
#import "Headers.h"

@implementation HeaderViewCell
@synthesize shopImage, shopName, totalNum;

- (void)awakeFromNib {
    
    shopImage.layer.cornerRadius = 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
