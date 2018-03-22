//
//  MessageCell.m
//  KingProFrame
//
//  Created by lihualin on 15/8/5.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MessageCell.h"
#import "Headers.h"
@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
    self.contentlabel.frame = CGRectMake(48, self.contentlabel.frame.origin.y, viewWidth-48-15, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMsgDic:(NSDictionary *)msgDic
{
    self.titleLabel.text = [msgDic objectForKey:@"title"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[msgDic objectForKey:@"create_time"]];
    self.timelabel.text = [CommClass formatIntiTimeStamp:timeStr timeFormat:@"yyyy-MM-dd HH:mm"];
    self.contentlabel.text = [msgDic objectForKey:@"content"];
    if ([[msgDic objectForKey:@"ifRead"] integerValue] == 1) {
        //已读
        self.headerImageView.image = [UIImage imageNamed:@"msgRead"];
        self.titleLabel.textColor = RGBACOLOR(102, 102, 102, 1.0);
    }else{
        //未读
        self.headerImageView.image = [UIImage imageNamed:@"msgNot"];
        self.titleLabel.textColor = [UIColor blackColor];
    }
    [self.contentlabel sizeToFit];
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.contentlabel.frame.origin.y+self.contentlabel.frame.size.height+17);
}

@end
