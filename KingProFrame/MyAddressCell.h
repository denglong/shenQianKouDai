//
//  MyAddressCell.h
//  KingProFrame
//
//  Created by lihualin on 15/8/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "MyAddressModel.h"
@interface MyAddressCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *phonelable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;

@property (weak, nonatomic) IBOutlet UIImageView *alreadySelectedImg;
@property (nonatomic , retain) MyAddressModel * addressModel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (nonatomic , retain) NSString * selectedID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailImgConstraint;
-(void)setAddressModel:(MyAddressModel *)addressModel index:(NSInteger)index;
@end
