//
//  MyOtherCell.m
//  Eqbang_shop
//
//  Created by lihualin on 15/7/27.
//  Copyright (c) 2015年 lihualin. All rights reserved.
//

#import "MyOtherCell.h"
#import "MyInfoModel.h"
#import "Headers.h"
@implementation MyOtherCell

- (void)awakeFromNib {
    // Initialization code
    self.orderUnFinishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.orderFinishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.orderUnStarBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (viewWidth > 320) {
        UIEdgeInsets edge = UIEdgeInsetsMake(9, ((viewWidth-24)/3-35)/2, 0, 0);
        self.orderUnFinishBtn.imageEdgeInsets = edge;
        self.orderFinishBtn.imageEdgeInsets = edge;
        self.orderUnStarBtn.imageEdgeInsets = edge;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDic:(NSDictionary *)dic
{
    
    self.titleLabel.text = [dic objectForKey:@"title"];
    NSString * imageName =[dic objectForKey:@"image"];
    self.header.image = [UIImage imageNamed:imageName];
    //待处理订单
    NSString * unfinishOrderNum = @" ( 0 )";
    if ([[MyInfoModel sharedInstance].userOrder integerValue] > 0) {
        unfinishOrderNum = [NSString stringWithFormat:@" ( %@ )",[MyInfoModel sharedInstance].userOrder];
        if ([[MyInfoModel sharedInstance].userOrder integerValue] > 99) {
            unfinishOrderNum = @" ( 99+ )";
        }
    }
    NSString *couponContent = [NSString stringWithFormat:@"%@%@",self.orderUnFinishBtn.titleLabel.text,unfinishOrderNum];

    [self.orderUnFinishBtn setTitle:couponContent forState:UIControlStateNormal];
    //已完成订单
    NSString * finishOrderNum = @" ( 0 )";
    if ([[MyInfoModel sharedInstance].userFinishOrder integerValue] > 0) {
        finishOrderNum = [NSString stringWithFormat:@" ( %@ )",[MyInfoModel sharedInstance].userFinishOrder];
        if ([[MyInfoModel sharedInstance].userFinishOrder integerValue] > 99) {
            finishOrderNum = @" ( 99+ )";
        }
    }
    NSString *finishContent = [NSString stringWithFormat:@"%@%@",self.orderFinishBtn.titleLabel.text,finishOrderNum];

    [self.orderFinishBtn setTitle:finishContent forState:UIControlStateNormal];
    //待点评订单
    NSString * unStarOrderNum = @" ( 0 )";
    if ([[MyInfoModel sharedInstance].userWaitAssessOrder integerValue] > 0) {
        unStarOrderNum = [NSString stringWithFormat:@" ( %@ )",[MyInfoModel sharedInstance].userWaitAssessOrder];
        if ([[MyInfoModel sharedInstance].userWaitAssessOrder integerValue] > 99) {
            unStarOrderNum = @" ( 99+ )";
        }
    }
    NSString *unStartContent = [NSString stringWithFormat:@"%@%@",self.orderUnStarBtn.titleLabel.text,unStarOrderNum];
    [self.orderUnStarBtn setTitle:unStartContent forState:UIControlStateNormal];

}
@end
