//
//  ViewController.h
//  FARME_OBJECT_TEST
//
//  Created by denglong on 7/16/15.
//  Copyright (c) 2015 邓龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TheOrderController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView       *myAlertView;           /**<取消订单弹框view中View*/
@property (nonatomic, retain) UIButton             *cancleOk;               /**<取消订单弹框中确定按钮*/
@property (weak, nonatomic) IBOutlet UIView       *bgView;                 /**<取消订单弹框View*/
@property (nonatomic, retain) UIButton             *cancle;                  /**<取消订单弹框取消按钮*/
@property (nonatomic, retain)UIImageView           *horizontalLine;       /**<取消订单弹框竖线*/
@property (nonatomic, retain)UIImageView           *verticalLine;          /**<取消订单弹框横线*/
@property (nonatomic, assign) NSInteger            indexPag;                 /**< 1表示从我的页面中跳入订单*/
@property (nonatomic, retain)UILabel                *titleMessage;          /**<取消订单弹框的提示语*/
@property (weak, nonatomic) IBOutlet UIImageView *nullImage;
@property (weak, nonatomic) IBOutlet UILabel      *nullLab;
@property (weak, nonatomic) IBOutlet UIScrollView *alertScrollView;
@property (nonatomic, assign) NSInteger homeJumping;
@property (nonatomic, assign) NSInteger   statusNum;         /**<头部切换状态btn，0：全部订单 1：待处理，2：已完成，3：待评价*/

@end
