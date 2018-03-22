//
//  SearchAddressCell.m
//  KingProFrame
//
//  Created by lihualin on 15/8/5.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "SearchAddressCell.h"
@implementation SearchAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAddress:(NSDictionary *)address
{
    self.titleLabel.text= [address objectForKey:@"address"];
    self.detailLabel.text = [address objectForKey:@"area"];
    [self.detailLabel sizeToFit];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
    float width = self.frame.size.width - 30;
//    CGSize size = [self.detailLabel.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y, width, self.detailLabel.frame.size.height);
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.detailLabel.frame.origin.y+self.detailLabel.frame.size.height+13);
}
@end
