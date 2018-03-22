//
//  MsgSortCell.m
//  KingProFrame
//
//  Created by lihualin on 15/11/19.
//  Copyright © 2015年 king. All rights reserved.
//

#import "MsgSortCell.h"
#import "Headers.h"
@implementation MsgSortCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMsgSort:(MsgSort *)msgSort
{
    self.msgSortTitle.text = msgSort.title;
    [self.msgSortImage setImageWithURL:[NSURL URLWithString:msgSort.imgUrl] placeholderImage:[UIImage imageNamed:@"msgSort"]];
    self.msgSortContent.text = msgSort.content;
    if ([msgSort.updateTime integerValue] > 0) {
        self.msgSortTime.text = [CommClass formatYMDOrToday:msgSort.updateTime];
    }
    
}
@end
