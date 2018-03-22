//
//  ConfirmHeaderCell.m
//  KingProFrame
//
//  Created by denglong on 8/26/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "ConfirmHeaderCell.h"

@implementation ConfirmHeaderCell
@synthesize upLline, downLine;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    upLline.hidden = YES;
    downLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_line"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.rightImg.center = CGPointMake(self.rightImg.center.x, self.center.y);
}

@end
