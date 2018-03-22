//
//  BusinessOrderController.h
//  KingProFrame
//
//  Created by denglong on 7/31/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "BaseViewController.h"

@interface BusinessOrderController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIView       *neighbourView;       /**<附近订单头部View*/
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;            /**<附近订单左图标*/
@property (weak, nonatomic) IBOutlet UILabel      *distance;             /**<附近订单显示距离*/
@property (weak, nonatomic) IBOutlet UIButton     *refresh;              /**<附近订单刷新按钮*/

@property (weak, nonatomic) IBOutlet UIView       *myHeadView;           /**<我的订单头部View*/
@property (nonatomic, assign) NSInteger indexPag;

- (IBAction)refreshAction:(UIButton *)sender;                              /**<刷新按钮处理事件*/
@property (weak, nonatomic) IBOutlet UIImageView *nullImage;
@property (weak, nonatomic) IBOutlet UILabel *nullLab;

@end
