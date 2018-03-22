//
//  HomePageCell.m
//  KingProFrame
//
//  Created by denglong on 11/27/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "HomePageCell.h"
#import "HotCategoriesModel.h"
#import "Headers.h"

@implementation HomePageCell
@synthesize AdImageView;
@synthesize number;

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellStyleDefault;
}

- (void)setImageUrl:(NSString *)imageUrl {
    if (self.tag == number)
    {
        self.frame = CGRectMake(0, 0, viewWidth, viewWidth/3.516);
    }
    else
    {
       self.frame = CGRectMake(0, 0, viewWidth, viewWidth/3.516 + 12);
    }

    if (AdImageView)
    {
        [AdImageView removeFromSuperview];
    }
    
    AdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3.516)];
    [AdImageView setImageWithURL:[NSURL URLWithString:imageUrl]
                   placeholderImage:UIIMAGE(@"icon_bannerImg")];
    [self.contentView addSubview:AdImageView];
}

- (void)dealloc {
    [AdImageView removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
