//
//  ConfirmHeaderCell.h
//  KingProFrame
//
//  Created by denglong on 8/26/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;              /**<收货人姓名*/
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;         /**<收货人电话*/
@property (weak, nonatomic) IBOutlet UILabel *myAddress;        /**<收货人地址*/
@property (weak, nonatomic) IBOutlet UIImageView *upLline;
@property (weak, nonatomic) IBOutlet UIImageView *downLine;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

@end
