//
//  ConfirmOrderController.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BaseViewController.h"

#import "PayModel.h"
#import "ShoppingCartModel.h"

@interface ConfirmOrderController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITableView *myAlertTableView;
@property(nonatomic,retain)CloudClient * cloudClient;
@property(nonatomic,retain)NSDictionary *orderInfoDic;

@property (weak, nonatomic) IBOutlet UILabel *totlePrice;         /**<商品合计金额*/
@property (weak, nonatomic) IBOutlet UILabel *totleNum;           /**<商品合计数量*/
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *alertBgView;
@property (weak, nonatomic) IBOutlet UIView *myAlertView;
@property (nonatomic, assign) BOOL secKill;                          /**<秒杀*/
@property (nonatomic, assign) BOOL presell;                          /**<无现货*/
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;
@property (nonatomic, copy) NSString *goodId;
@property (nonatomic, copy) NSString *goodNum;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *again;


@end
