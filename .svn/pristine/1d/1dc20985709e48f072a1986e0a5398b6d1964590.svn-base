//
//  MyAddressCell.m
//  KingProFrame
//
//  Created by lihualin on 15/8/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MyAddressCell.h"
#import "Headers.h"
@implementation MyAddressCell

- (void)awakeFromNib {
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAddressModel:(MyAddressModel *)addressModel index:(NSInteger)index
{
    self.nameLable.text = addressModel.addressUser;
    self.phonelable.text = addressModel.addressTel;
    self.addressLable.text =  [NSString stringWithFormat:@"%@%@%@",addressModel.street,addressModel.address,addressModel.addressDetail];
   //是否默认
    if ([addressModel.ifDefault integerValue] == 1) {
        self.alreadySelectedImg.hidden = NO;
    }else{
        self.alreadySelectedImg.hidden = YES;
    }
    //是否已经选择
    self.detailImgConstraint.constant = -5;
    [self hidenSelectedView:index addressId:addressModel];
}

-(void)hidenSelectedView:(NSInteger)index addressId:(MyAddressModel *)addressModel
{
    switch (index) {
        case 0:
        {//普通地址列表
            self.selectedImg.hidden = YES;
            self.detailImgConstraint.constant = 36;
        }
            break;
        case 1:
        {//选择地址列表
            self.selectedImg.image = [UIImage imageNamed:@"addressSelected"];
            if ([addressModel.ID isEqualToString:self.selectedID]) {
                self.selectedImg.hidden = NO;
            }else{
                self.selectedImg.hidden = YES;
                self.detailImgConstraint.constant = 36;
            }
        }
            break;
        case 2:
        {//选择地址超出范围列表
            self.selectedImg.hidden = NO;
            self.selectedImg.image = [UIImage imageNamed:@"addressOut"];
        }
            break;
        default:
            break;
    }
}
@end
