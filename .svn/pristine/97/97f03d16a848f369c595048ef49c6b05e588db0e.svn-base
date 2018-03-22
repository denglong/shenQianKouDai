//
//  AroudAddressCell.m
//  KingProFrame
//
//  Created by lihualin on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "AroudAddressCell.h"
#import "Headers.h"
@implementation AroudAddressCell

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
//    self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y, viewWidth-41-16, self.detailLabel.frame.size.height);
//    [self.detailLabel sizeToFit];
    CGSize size = [CommClass getSuitSizeWithString:self.detailLabel.text font:13 bold:NO sizeOfX:viewWidth-41-16];
    if (self.accessoryView != nil) {
        size = [CommClass getSuitSizeWithString:self.detailLabel.text font:13 bold:NO sizeOfX:viewWidth-41-16-20];
    }
   
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.detailLabel.frame.origin.y+size.height+10);
}
@end
