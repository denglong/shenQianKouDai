//
//  OrderDetailHeaderCell.h
//  KingProFrame
//
//  Created by lihualin on 15/8/6.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetail.h"
@interface OrderDetailHeaderCell : UITableViewCell

/**标题*/
//@property (weak, nonatomic) IBOutlet UILabel *titleLable1;
/**文案1*/
@property (weak, nonatomic) IBOutlet UILabel *titleLable2;
/**文案2*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
/**状态1*/
@property (weak, nonatomic) IBOutlet UILabel *stateLabel1;
/**状态2*/
@property (weak, nonatomic) IBOutlet UILabel *stateLabel2;
/**状态3*/
@property (weak, nonatomic) IBOutlet UILabel *stateLabel3;
/**状态条*/
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;
@property (weak, nonatomic) IBOutlet UIButton *zhifuBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBtnLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConstraint;
//@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/**确认收货*/
@property (weak, nonatomic) IBOutlet UIButton *sureOrder;
@property (nonatomic ,retain) OrderDetail * orderDetail;
@property (nonatomic ,assign) NSInteger shengTime;
@property (weak, nonatomic) IBOutlet UIImageView *orderStateIcon;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLable;
@property (weak, nonatomic) IBOutlet UILabel *orderStateDetLab;
@property (nonatomic, assign) NSInteger myTime;
@property (nonatomic, assign) NSInteger orderType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTextConstraint;


-(void)showTipBtn:(OrderDetail *)orderDetail ifshow:(BOOL)ifshow shengTime:(NSInteger)sheng;


@end
