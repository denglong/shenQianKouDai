//
//  YourSelfInfoCell.m
//  KingProFrame
//
//  Created by 邓龙 on 11/06/2017.
//  Copyright © 2017 king. All rights reserved.
//

#import "YourSelfInfoCell.h"
#import "Headers.h"

@implementation YourSelfInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [UIColor_HEX colorWithHexString:@"666666"].CGColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)colorSelectAction {
    self.bgView.layer.borderColor = [UIColor_HEX colorWithHexString:@"FF5A1E"].CGColor;
    self.nameLab.textColor = [UIColor_HEX colorWithHexString:@"FF5A1E"];
    self.addressLab.textColor = [UIColor_HEX colorWithHexString:@"FF5A1E"];
    self.phoneLab.textColor = [UIColor_HEX colorWithHexString:@"FF5A1E"];
}

- (void)defColorAction {
    self.bgView.layer.borderColor = [UIColor_HEX colorWithHexString:@"666666"].CGColor;
    self.nameLab.textColor = [UIColor_HEX colorWithHexString:@"666666"];
    self.addressLab.textColor = [UIColor_HEX colorWithHexString:@"666666"];
    self.phoneLab.textColor = [UIColor_HEX colorWithHexString:@"666666"];
}

- (void)setYourSelfInfoAction:(NSDictionary *)dic {
    self.nameLab.text = dic[@"addressName"];
    self.addressLab.text = dic[@"address"];
    self.phoneLab.text = [NSString stringWithFormat:@"门店：%@", dic[@"addressMobile"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
