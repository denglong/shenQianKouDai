//
//  MyInfoHeaderCell.m
//  KingProFrame
//
//  Created by lihualin on 15/7/31.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MyInfoHeaderCell.h"
#import "Headers.h"
@implementation MyInfoHeaderCell

- (void)awakeFromNib {
    // Initialization code
    self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrows"]];
    self.titleImage.layer.cornerRadius = self.titleImage.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setMyInfo:(MyInfo *)myInfo indexPath:(NSIndexPath *)indexPath
{
    NSArray * titles = @[@"头像",@"名字",@"性别",@"生日",@"注册账号"];
    self.titleImage.hidden = YES;
    self.finishLabel.hidden = NO;
    if (indexPath.section == 0) {
        self.finishLabel.tag = indexPath.row;
        switch (indexPath.row) {
            case 0:
            { // 头像
                self.titleImage.hidden = NO;
                self.finishLabel.hidden = YES;
                NSURL * url = [NSURL URLWithString:myInfo.imgUrl];
                [self.titleImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"header"]];
            }
                break;
            case 1:
            { //姓名
                if ([DataCheck isValidString:myInfo.nickName]) {
                     self.finishLabel.text = myInfo.nickName;
                }else{
                   self.finishLabel.text = @"（点击编辑名字）";
                }
            }
                break;
            case 2:
            { //性别
                if ([DataCheck isValidString:myInfo.sex]) {
                    if ([myInfo.sex isEqualToString:@"F"]) {
                        self.finishLabel.text = @"女士";
                    }else{
                        self.finishLabel.text = @"男士";
                    }
                }else{
                    self.finishLabel.text = @"未设置";
                }
            }
                break;
            case 3:
            {   //生日
                if ([DataCheck isValidString:myInfo.birthday]) {
                    self.finishLabel.text = myInfo.birthday;
                }else{
                    self.finishLabel.text = @"未设置";
                }
            }
                break;
            case 4:
            {   //注册账号
               self.finishLabel.text = [[CommClass sharedCommon] objectForKey:LOGGED_USERNAME];
            }
                break;
            default:
                break;
        }
    }

    
    if (indexPath.section == 1) {
        titles = @[@"账户与安全"];//@[@"收货地址",@"账户与安全"];
//        if (indexPath.row == 0) {
//            self.finishLabel.text = [NSString stringWithFormat:@"%@个",myInfo.addrNum];
//        }
    }
    self.nameLabel.text = [titles objectAtIndex:indexPath.row];
}
@end
