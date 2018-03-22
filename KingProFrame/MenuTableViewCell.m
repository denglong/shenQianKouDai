//
//  MenuTableViewCell.m
//  KingProFrame
//
//  Created by JinLiang on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

@synthesize desImgView;
@synthesize typeLabel;
- (void)awakeFromNib {
    // Initialization code
    desImgView.backgroundColor=[UIColor clearColor];
    typeLabel.backgroundColor=[UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
