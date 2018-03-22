//
//  MyheaderCell.m
//  Eqbang_shop
//
//  Created by lihualin on 15/7/27.
//  Copyright (c) 2015年 lihualin. All rights reserved.
//

#import "MyheaderCell.h"
#import "Headers.h"
@implementation MyheaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.payButton.status = FLAlignmentStatusTop;
    self.consigneeButton.status = FLAlignmentStatusTop;
    self.finishButton.status = FLAlignmentStatusTop;
    self.myOrderButton.status = FLAlignmentStatusTop;
    
    self.headerImageView.layer.cornerRadius = 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 设置用户信息
-(void)setInfoModel:(MyInfoModel *)infoModel
{
    
    NSURL * url = [NSURL URLWithString:infoModel.imgUrl];

    [self.headerImageView setImageWithURL:url placeholderImage:UIIMAGE(@"myHeader")];
    
    self.nameLabel.text = infoModel.nickName?infoModel.nickName:@"昵称";
    
    self.totleMoney.text = [NSString stringWithFormat:@"￥%@", infoModel.totalCounsumption?infoModel.totalCounsumption:@"0"];
    if (infoModel.totalCounsumption != nil && ![(NSNull *)infoModel.totalCounsumption isEqual:[NSNull null]] && ![infoModel.totalCounsumption isEqual:@"null"]) {
        self.totleMoney.text = [NSString stringWithFormat:@"￥%.2f", [infoModel.totalCounsumption floatValue]];
    }
    else
    {
        self.totleMoney.text = @"￥0";
    }
    self.vipMoney.text = [NSString stringWithFormat:@"￥%@", infoModel.totalBenefit?infoModel.totalBenefit:@"0"];
    if (infoModel.totalBenefit != nil && ![(NSNull *)infoModel.totalBenefit isEqual:[NSNull null]] && ![infoModel.totalBenefit isEqual:@"null"]) {
        self.vipMoney.text = [NSString stringWithFormat:@"￥%.2f", [infoModel.totalBenefit floatValue]];
    }
    else
    {
        self.vipMoney.text = @"￥0";
    }
    
    if ([infoModel.userType integerValue] == 1) {
        self.vipIcon.image = [UIImage imageNamed:@"icon_vip"];
    }
    else
    {
        self.vipIcon.image = [UIImage imageNamed:@"icon_novip"];
    }
}

@end
