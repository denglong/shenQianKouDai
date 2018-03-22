//
//  HomeADCell.m
//  KingProFrame
//
//  Created by denglong on 12/1/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "HomeADCell.h"
#import "Headers.h"

@implementation HomeADCell
@synthesize AdImageView;

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellStyleDefault;
    
    AdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/8)];
    [self.contentView addSubview:AdImageView];
}

- (void)setAdImageUrl:(NSString *)adImageUrl {
    self.frame = CGRectMake(0, 0, viewWidth, viewWidth/8);
    [AdImageView setImageWithURL:[NSURL URLWithString:adImageUrl]
                   placeholderImage:UIIMAGE(@"icon_titleMsg")];
}

- (void)dealloc {
    [AdImageView removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
