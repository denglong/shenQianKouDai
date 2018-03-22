//
//  MyheaderCell.h
//  Eqbang_shop
//
//  Created by lihualin on 15/7/27.
//  Copyright (c) 2015年 lihualin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoModel.h"
#import "FL_Button.h"

enum OrderClickType {
    /** 待支付订单 */
    waitPayOrderType = 0,
    /** 待收货 */
    waitConsigneeOrderType,
    /** 已完成 */
    finishOrderType,
    /** 我的订单 */
    myOrderType
};

@interface MyheaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//顾客按钮
@property (weak, nonatomic) IBOutlet UIButton *shopingCat;
@property (weak, nonatomic) IBOutlet UIButton *unfinishOrder;
@property (weak, nonatomic) IBOutlet UIButton *eidtInfo;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIView *gukeView;
@property (weak, nonatomic) IBOutlet UIButton *eBeanRedImg;
@property (weak, nonatomic) IBOutlet UIButton *couponRedImg;
@property (weak, nonatomic) IBOutlet UILabel *totleMoney;
@property (weak, nonatomic) IBOutlet UILabel *vipMoney;
@property (weak, nonatomic) IBOutlet UIImageView *vipIcon;


//未登录
@property (weak, nonatomic) IBOutlet UIView *notLoginBTnView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *ResigerBtn;



@property (weak, nonatomic) IBOutlet UIButton * backBtn;

@property (nonatomic , retain) MyInfoModel * infoModel;

@property (weak, nonatomic) IBOutlet FL_Button *payButton;
@property (weak, nonatomic) IBOutlet FL_Button *consigneeButton;
@property (weak, nonatomic) IBOutlet FL_Button *finishButton;
@property (weak, nonatomic) IBOutlet FL_Button *myOrderButton;


@end
