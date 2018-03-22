//
//  HomeHeaderCell.m
//  KingProFrame
//
//  Created by denglong on 12/7/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "HomeHeaderCell.h"

@implementation HomeHeaderCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellStyleDefault;
}

- (void)setBannersView:(UIView *)bannersView {
    self.frame = CGRectMake(0, 0, bannersView.frame.size.width, bannersView.frame.size.height);
    [self addSubview:bannersView];
}

- (void)dealloc {
    [self.bannersView removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
