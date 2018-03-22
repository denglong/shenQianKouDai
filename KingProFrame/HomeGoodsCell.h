//
//  HomeGoodsCell.h
//  KingProFrame
//
//  Created by denglong on 11/27/15.
//  Copyright © 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsListModel.h"
#import "CounterClass.h"

@interface HomeGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *signImage;
@property (weak, nonatomic) IBOutlet UILabel *purchaseLab;
@property (strong, nonatomic) UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *markBtn1;
@property (weak, nonatomic) IBOutlet UIButton *markBtn2;
@property (weak, nonatomic) IBOutlet UIButton *markBtn3;
@property (nonatomic, strong) CounterClass *counterView;

@property (nonatomic, strong) goodsListModel *goodModel;

@end
