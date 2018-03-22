//
//  ConfirmOrderCell.h
//  KingProFrame
//
//  Created by denglong on 8/19/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;       /**<商品名称*/
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;        /**<商品数量*/
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;      /**<商品金额*/
@property (weak, nonatomic) IBOutlet UIButton *chonseBtn;      /**<选择配送方式按钮*/
@property (weak, nonatomic) IBOutlet UILabel *chooseWay;       /**<配送方式*/
@property (weak, nonatomic) IBOutlet UITextField *remarksTextFile;
@property (weak, nonatomic) IBOutlet UIImageView *addIcon;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrows;
@property (weak, nonatomic) IBOutlet UIImageView *greenImg;

@end
