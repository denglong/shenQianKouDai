//
//  VipPrivilegeHeaderCell.h
//  KingProFrame
//
//  Created by meyki on 11/29/16.
//  Copyright © 2016 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface VipPrivilegeHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *timeName;
@property (nonatomic, strong) BaseViewController *baseC;

- (void)showOrHiddenHeader:(NSDictionary *)vipDic;

@end
