//
//  VipPrivilegeHeaderCell.m
//  KingProFrame
//
//  Created by meyki on 11/29/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "VipPrivilegeHeaderCell.h"
#import "MyInfoModel.h"

@implementation VipPrivilegeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    MyInfoModel *infoModel=[MyInfoModel sharedInstance];
    self.nickName.text = infoModel.nickName;
    self.baseC = [[BaseViewController alloc] init];
    self.iconImg.hidden = YES;
}

- (void)showOrHiddenHeader:(NSDictionary *)vipDic {
    
    if ([vipDic[@"userType"] integerValue] == 0) {
        self.topHeight.constant = -131;
        self.dateTime.hidden = YES;
        self.iconImg.hidden = YES;
        self.timeName.hidden = YES;
    }
    else
    {
        self.dateTime.hidden = NO;
        self.topHeight.constant = 0;
        self.iconImg.hidden = YES;
        self.timeName.hidden = NO;
        
        NSString *dateTime = [NSString stringWithFormat:@"%@", [vipDic objectForKey:@"validateDate"]];
        dateTime = [dateTime substringToIndex:10];
        
        self.dateTime.text = [_baseC formatTimeStamp:dateTime timeFormat:@"YYYY-MM-dd"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
