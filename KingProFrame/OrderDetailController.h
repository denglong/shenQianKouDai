//
//  OrderDetailController.h
//  KingProFrame
//
//  Created by denglong on 8/3/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (nonatomic, retain) NSString *orderNum;
@property (nonatomic, assign) NSInteger xgTag;       /**<从信鸽消息进入页面值为1*/

@end
