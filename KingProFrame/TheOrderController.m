//
//  ViewController.m
//  FARME_OBJECT_TEST
//
//  Created by denglong on 7/16/15.
//  Copyright (c) 2015 邓龙. All rights reserved.
//

#import "TheOrderController.h"
#import "TheOrderCell.h"
#import "OrderPayController.h"
#import "OrderDetailViewController.h"
#import "EvaluateViewController.h"
#import "TheOrderRespModel.h"
#import "ShopCartController.h"
#import "GeTuiSdk.h"
#import "CancelReason.h"
#import "NavigationController.h"

@interface TheOrderController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, reloadDelegate>
{
    NSMutableArray          *myBtns;            /**<顶部btn数组*/
    NSMutableArray          *lineViews;        /**<底部btn下线*/
    UIView                    *headerView;       /**<顶部view*/
    NSArray                   *statesBtn;        /**<自定义alert选择btn数组*/
    CloudClient              *client;            /**<网络请求类*/
    TheOrderRespModel       *orderResp;
    NSString                  *labelId;           /**<取消订单选择原因*/
    NSMutableArray           *titleBtns;        /**<选择取消原有的Btn*/
    UIView                    *titleView;         /**<点击取消弹出的view*/
    NSString                  *canaleOrderNum;  /**<取消订单的订单号*/
    NSMutableArray          *myOrderLists;     /**<获取我的订单列表*/
    NSInteger                 pageNum;           /**<请求时分页号码*/
    NSInteger                deleteNum;          /**<点击取消订单的tag*/
    NSInteger                 scrollNum;         //切换页面时tableview置顶，1表示不置顶，0表示置顶
    NSString                 *goodsNum;          //商品数量
    NSString                 *goodsId;           //商品id
    NSString                 *phoneNum;          //催单电话号码
    NSString                  *confamOrderNo;   //确认订单订单号
    BOOL                       tableViewScroll;  //判断tableView停止滚动
    UIView                     *noNetWork;

    NSArray                   *orderList;
}

@end

@implementation TheOrderController
@synthesize myTableView, myAlertView, bgView, horizontalLine, verticalLine, cancle, cancleOk, indexPag, titleMessage;
@synthesize nullImage, nullLab, homeJumping, statusNum;

//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    
//    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    
//    if (self) {
//        UITabBarItem *tabBarItem = nil;
//        if (IOS7) {
//            UIImage *img           = [UIImage imageNamed:@"ordertab.png"];
//            UIImage *normalImage   = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            UIImage *selectImage=[UIImage imageNamed:@"ordertab_p.png"];
//            UIImage *selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            tabBarItem             = [[UITabBarItem alloc] initWithTitle:@"订单" image:normalImage selectedImage:selectedImage];
//        } else {
//            UIImage *img           = [UIImage imageNamed:@"ordertab.png"];
//            UIImage *selectImage=[UIImage imageNamed:@"ordertab_p.png"];
//            tabBarItem=[[UITabBarItem alloc]initWithTitle:@"订单" image:img selectedImage:selectImage];
//        }
//        
//        self.tabBarItem        = tabBarItem;
//    }
//    
//    return self;
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    headerView.hidden = NO;
    
    if (![UserLoginModel isLogged]) {
        myTableView.hidden = YES;
        [[AppModel sharedModel]  presentLoginController:[UIApplication sharedApplication].keyWindow.rootViewController];
        return;
    }
    
    if ([[[CommClass sharedCommon] objectForKey:@"GeTuiTag"] integerValue] != 10) {
        pageNum = 1;
        myOrderLists = [NSMutableArray array];
        [self setupHeaderRefresh:myTableView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[CommClass sharedCommon] setObject:@"1" forKey:@"GeTuiTag"];
}


//MARK: - 设置tableView与底部对齐
-(void)setConstraint{
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:myTableView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:1.0f
                                                                      constant:myTableView.frame.size.height + 48];
    
    
    [self.view addConstraints:@[topConstraint]];
    
    if (IOS8) {
        topConstraint.active = YES;
    }
}

//MARK: - 从我的进入返回方法
- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    myOrderLists = [NSMutableArray array];
    
    headerView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myBtns     = [NSMutableArray array];
    lineViews = [NSMutableArray array];
    [self createHeaderBtn];
    [self setUpFooterRefresh:myTableView];
    myTableView.hidden = YES;
    
    client = [CloudClient getInstance];

    [self showHUD];
    
    switch (statusNum) {
        case 0:
            self.title = @"我的订单";
            break;
        case 1:
            self.title = @"待处理订单";
            break;
        case 2:
            self.title = @"已完成订单";
            break;
        case 3:
            self.title = @"待点评订单";
            break;
        default:
            break;
    }
    
    pageNum = 1;
    tableViewScroll = NO;
}

/**
 * Method name: createHeaderBtn
 * MARK: - 创建头部按钮
 */
- (void)createHeaderBtn {
//    headerView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.navigationController.navigationBar.frame.size.width-100, self.navigationController.navigationBar.frame.size.height)];
//    
//    //[self.navigationController.navigationBar addSubview: headerView];
//    
//    NSArray *nameStr = @[@"待处理", @"已完成", @"待点评"];
//    for (NSInteger i = 0; i < 3; i ++) {
//        CGFloat btnWidth = ([[UIScreen mainScreen] bounds].size.width - 100) / 3;
//        UIButton *headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * btnWidth, 0, btnWidth, self.navigationController.navigationBar.frame.size.height)];
//        [headerBtn setTitle:[NSString stringWithFormat:@"%@", nameStr[i]] forState:UIControlStateNormal];
//        [headerBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#6a3906"] forState:UIControlStateNormal];
//        headerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        
//        headerBtn.tag = i;
//        [headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:headerBtn];
//        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, headerBtn.frame.size.height - 2, headerBtn.frame.size.width - 20, 2)];
//        lineView.backgroundColor = [UIColor_HEX colorWithHexString:@"#ff5a1e"];
//        lineView.tag = i;
//        lineView.hidden = YES;
//        [headerBtn addSubview:lineView];
//        
//        
//        if (i == 0) {
//            lineView.hidden = NO;
//            [headerBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#ff5a1e"] forState:UIControlStateNormal];
//        }
//        [myBtns addObject:headerBtn];
//        [lineViews addObject:lineView];
//    }
//    
//    if (homeJumping == YES) {
//        UIButton *btn = myBtns[1];
//        [self headerBtnAction:btn];
//    }
    
    //自定义alertView
    myAlertView.layer.cornerRadius = 10;
    
    titleMessage = [[UILabel alloc] init];
    titleMessage.text = @"请您选择取消订单原因";
    titleMessage.font = [UIFont systemFontOfSize:14];
    titleMessage.textColor = [UIColor blackColor];
    titleMessage.textAlignment = NSTextAlignmentCenter;
    
    cancle = [[UIButton alloc] init];
    [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancle setTitle:@"返回" forState:UIControlStateNormal];
    cancle.tag = 0;
    [cancle addTarget:self action:@selector(cancleOrOkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cancleOk = [[UIButton alloc] init];
    [cancleOk setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleOk setTitle:@"确定" forState:UIControlStateNormal];
    cancleOk.enabled = NO;
    cancleOk.tag = 1;
    [cancleOk addTarget:self action:@selector(cancleOrOkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    horizontalLine = [[UIImageView alloc] init];
    horizontalLine.backgroundColor = RGBACOLOR(204, 204, 204, 1);
    verticalLine = [[UIImageView alloc] init];
    verticalLine.backgroundColor = RGBACOLOR(204, 204, 204, 1);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    bgView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [window addSubview:bgView];
    
    myAlertView.hidden = YES;
    bgView.hidden = YES;
    
//    NSArray *cancelList = [[CommClass sharedCommon] objectForKey:HOMEINFO_CANCELLIST];
//    NSMutableArray *names = [NSMutableArray array];
//    NSMutableArray *labelIds = [NSMutableArray array];
//    
//    if ([DataCheck isValidArray:cancelList]) {
//        
//        for (NSInteger i = 0; i < cancelList.count; i ++) {
//            NSString *name = [cancelList[i] objectForKey:@"labelText"];
//            NSString *myId = [cancelList[i] objectForKey:@"labelId"];
//            [names addObject:name];
//            [labelIds addObject:myId];
//        }
//    }
//    
//    self.cancleTag = 1;
//    titleView =  [self createTitle:@{@"titleName":names, @"labelId":labelIds} andViewWidth:viewWidth - 50];
//    titleView.frame = CGRectMake(0, 0, viewWidth - 50, titleView.frame.size.height);
    
    nullLab.hidden = YES;
    nullImage.hidden = YES;
    nullLab.text = @"没有待处理的订单";
}

//MARK: - 显示取消订单弹框
- (void)myAlertViewShow {
    myAlertView.hidden = NO;
    bgView.hidden = NO;
    [self popupAnimation:myAlertView duration:0.5];
}

//MARK: - 隐藏取消订单弹框
- (void)myAlertViewHidden {
    self.alertScrollView.contentOffset = CGPointMake(0, 0);
    myAlertView.hidden = YES;
    bgView.hidden = YES;
}

/**
 * Method name: headerBtnAction
 * MARK: - 点击顶部按钮切换状态
 * Parameter: sender
 */
- (void)headerBtnAction:(UIButton *)sender {
    if (tableViewScroll == YES) {
        return;
    }
    
    statusNum = sender.tag + 1;
    
    pageNum = 1;
    scrollNum = 0;
    myOrderLists = [NSMutableArray array];
    
    [self getOrderData];
    
    for (UIButton *btn in myBtns) {
        [btn setTitleColor:[UIColor_HEX colorWithHexString:@"#6a3906"] forState:UIControlStateNormal];
    }
    
    for (UIView *line in lineViews) {
        line.hidden = YES;
    }
    
    UIView *myLine          = lineViews[sender.tag];
    myLine.hidden = NO;
    
    UIButton *myBtn         = myBtns[sender.tag];
    [myBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#ff5a1e"] forState:UIControlStateNormal];
    
    if (sender.tag == 0) {
        nullLab.text = @"没有待处理的订单";
    }
    else if (sender.tag == 1) {
        nullLab.text = @"没有已完成的订单";
    }
    else
    {
        nullLab.text = @"没有待点评的订单";
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    tableViewScroll = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    tableViewScroll = NO;
}

/**
 * Method name: tableView
 * MARK: - tableView相关实现方法
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (statusNum) {
        case 0:
            return orderResp.handleList.count;
            break;
        case 1:
            return orderResp.handleList.count;
            break;
        case 2:
            return orderResp.finishList.count;
            break;
        case 3:
            return orderResp.evaluationList.count;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    TheOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TheOrderCell" owner:self options:nil];
        cell = [views objectAtIndex:0];
        cell.selectionStyle = UITableViewCellStyleDefault;
    }
    
    cell.downImage.frame = CGRectMake(0, cell.bgView.frame.size.height, cell.downImage.frame.size.width, 6.5);
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 0.5);
    cell.myScrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollAction:)];
    cell.myScrollView.tag = indexPath.section;
    
    [cell.myScrollView addGestureRecognizer:tap];
    switch (statusNum) {
        case 0:
        {
            cell.imageUrls = [orderResp.handleList[indexPath.section] objectForKey:@"goodsImgList"];
            
            if (orderResp.handleList.count == 0) {
                return nil;
            }
            NSString *myDate = [NSString stringWithFormat:@"%@", [orderResp.handleList[indexPath.section] objectForKey:@"createTime"]];
            cell.date.text = [self formatTimeStamp:[myDate substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"];
            
            cell.amount.text = [NSString stringWithFormat:@"合计：￥%.2f", [[orderResp.handleList[indexPath.section] objectForKey:@"totalPay"] floatValue]];
            cell.sum.text = [NSString stringWithFormat:@"共%@件商品", [orderResp.handleList[indexPath.section] objectForKey:@"totalNumber"]];
            
            NSString *orderStatus = [orderResp.handleList[indexPath.section] objectForKey:@"orderStatus"];
            switch ([orderStatus integerValue]) {
                case 1:
                    cell.state.text = @"待抢单";
                    cell.payBtn.hidden = YES;
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
                case 2:
                    cell.state.text = @"待付款";
                    cell.payBtn.tag = indexPath.section;
                    [cell.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
                case 3:
                    cell.state.text = @"配货中";
                    cell.payBtn.hidden = YES;
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //                    cell.confirmBtn.hidden = NO;
                    //                    CGRect confRect = cell.confirmBtn.frame;
                    //                    cell.confirmBtn.frame = CGRectMake(cell.cancleBtn.frame.origin.x - confRect.size.width - 10, confRect.origin.y, confRect.size.width, confRect.size.height);
                    //                    cell.confirmBtn.tag = indexPath.section;
                    //                    [cell.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
                case 4:
                {
                    cell.state.text = @"待收货";
                    cell.confirmBtn.hidden = NO;
                    cell.payBtn.backgroundColor = [UIColor whiteColor];
                    [cell.payBtn setTitle:@"催单" forState:UIControlStateNormal];
                    [cell.payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    cell.payBtn.layer.borderColor   = [[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1] CGColor];
                    cell.payBtn.layer.borderWidth   =0.5f;
                    
                    cell.confirmBtn.tag = indexPath.section;
                    [cell.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell.payBtn.tag = indexPath.section;
                    [cell.payBtn addTarget:self action:@selector(hurryOrderAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
                    NSString *isCancel = [orderResp.handleList[indexPath.section] objectForKey:@"isCancel"];
                    if ([isCancel integerValue] == 0) {
                        cell.cancleBtn.enabled = NO;
                        cell.cancleBtn.backgroundColor = RGBACOLOR(204, 204, 204, 1);
                    }
                }
                    break;
                case 5:
                {
                    cell.state.text = @"已完成";
                    [cell.cancleBtn setTitle:@"查看点评" forState:UIControlStateNormal];
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(searchEvaluation:) forControlEvents:UIControlEventTouchUpInside];
                    cell.payBtn.hidden = YES;
                    [cell.payBtn setTitle:@"查看点评" forState:UIControlStateNormal];
                    
                    cell.payBtn.tag = indexPath.section;
                    [cell.payBtn addTarget:self action:@selector(orderAgainAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                case 6:
                {
                    cell.state.text = @"已取消";
                    cell.payBtn.hidden = YES;
                    cell.cancleBtn.hidden = YES;
                    cell.line.hidden = YES;
                    cell.frame = CGRectMake(0, 0, cell.frame.size.width, 130);
                    cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, 130 + 0.5);
                    cell.bgView.frame = CGRectMake(0, 0, cell.frame.size.width, 124);
                    cell.downImage.frame = CGRectMake(0, 124, cell.frame.size.width, 6.5);
                }
                    break;
                case 7:
                {
                    cell.state.text = @"已完成";
                    
                    [cell.payBtn setTitle:@"点评" forState:UIControlStateNormal];
                    cell.payBtn.tag = indexPath.section;
                    cell.payBtn.frame = cell.cancleBtn.frame;
                    [cell.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.payBtn addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.cancleBtn setTitle:@"再来一单" forState:UIControlStateNormal];
                    cell.cancleBtn.tag = indexPath.section;
                    cell.cancleBtn.hidden = YES;
                    [cell.cancleBtn addTarget:self action:@selector(orderAgainAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 1:
        {
            cell.imageUrls = [orderResp.handleList[indexPath.section] objectForKey:@"goodsImgList"];
            
            if (orderResp.handleList.count == 0) {
                return nil;
            }
            NSString *myDate = [NSString stringWithFormat:@"%@", [orderResp.handleList[indexPath.section] objectForKey:@"createTime"]];
            cell.date.text = [self formatTimeStamp:[myDate substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"];
            
            cell.amount.text = [NSString stringWithFormat:@"合计：￥%.2f", [[orderResp.handleList[indexPath.section] objectForKey:@"totalPay"] floatValue]];
            cell.sum.text = [NSString stringWithFormat:@"共%@件商品", [orderResp.handleList[indexPath.section] objectForKey:@"totalNumber"]];
            
            NSString *orderStatus = [orderResp.handleList[indexPath.section] objectForKey:@"orderStatus"];
            switch ([orderStatus integerValue]) {
                case 1:
                    cell.state.text = @"待抢单";
                    cell.payBtn.hidden = YES;
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
                case 2:
                    cell.state.text = @"待付款";
                    cell.payBtn.tag = indexPath.section;
                    [cell.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
                case 3:
                    cell.state.text = @"配货中";
                    cell.payBtn.hidden = YES;
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
                    
//                    cell.confirmBtn.hidden = NO;
//                    CGRect confRect = cell.confirmBtn.frame;
//                    cell.confirmBtn.frame = CGRectMake(cell.cancleBtn.frame.origin.x - confRect.size.width - 10, confRect.origin.y, confRect.size.width, confRect.size.height);
//                    cell.confirmBtn.tag = indexPath.section;
//                    [cell.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
                case 4:
                {
                    cell.state.text = @"待收货";
                    cell.confirmBtn.hidden = NO;
                    cell.payBtn.backgroundColor = [UIColor whiteColor];
                    [cell.payBtn setTitle:@"催单" forState:UIControlStateNormal];
                    [cell.payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    cell.payBtn.layer.borderColor   = [[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1] CGColor];
                    cell.payBtn.layer.borderWidth   =0.5f;
                    
                    cell.confirmBtn.tag = indexPath.section;
                    [cell.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell.payBtn.tag = indexPath.section;
                    [cell.payBtn addTarget:self action:@selector(hurryOrderAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
                    NSString *isCancel = [orderResp.handleList[indexPath.section] objectForKey:@"isCancel"];
                    if ([isCancel integerValue] == 0) {
                        cell.cancleBtn.enabled = NO;
                        cell.cancleBtn.backgroundColor = RGBACOLOR(204, 204, 204, 1);
                    }
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 2:
        {
            cell.imageUrls = [orderResp.finishList[indexPath.section] objectForKey:@"goodsImgList"];
            
            if (orderResp.finishList.count == 0) {
                return nil;
            }
            NSString *myDate = [NSString stringWithFormat:@"%@", [orderResp.finishList[indexPath.section] objectForKey:@"createTime"]];
            cell.date.text = [self formatTimeStamp:[myDate substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"];
            
            
            cell.amount.text = [NSString stringWithFormat:@"合计：￥%.2f", [[orderResp.finishList[indexPath.section] objectForKey:@"totalPay"] floatValue]];
            cell.sum.text = [NSString stringWithFormat:@"共%@件商品", [orderResp.finishList[indexPath.section] objectForKey:@"totalNumber"]];
            
            NSString *orderStatus = [orderResp.finishList[indexPath.section] objectForKey:@"orderStatus"];
            if ([orderStatus integerValue] == 7) {
                cell.state.text = @"已完成";
                
                [cell.payBtn setTitle:@"点评" forState:UIControlStateNormal];
                cell.payBtn.tag = indexPath.section;
                cell.payBtn.frame = cell.cancleBtn.frame;
                [cell.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.payBtn addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.cancleBtn setTitle:@"再来一单" forState:UIControlStateNormal];
                cell.cancleBtn.tag = indexPath.section;
                cell.cancleBtn.hidden = YES;
                [cell.cancleBtn addTarget:self action:@selector(orderAgainAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([orderStatus integerValue] == 5) {
                
                cell.state.text = @"已完成";
                [cell.cancleBtn setTitle:@"查看点评" forState:UIControlStateNormal];
                cell.cancleBtn.tag = indexPath.section;
                [cell.cancleBtn addTarget:self action:@selector(searchEvaluation:) forControlEvents:UIControlEventTouchUpInside];
                cell.payBtn.hidden = YES;
                [cell.payBtn setTitle:@"查看点评" forState:UIControlStateNormal];
                
                cell.payBtn.tag = indexPath.section;
                [cell.payBtn addTarget:self action:@selector(orderAgainAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                cell.state.text = @"已取消";
                cell.payBtn.hidden = YES;
                cell.cancleBtn.hidden = YES;
                cell.line.hidden = YES;
                cell.frame = CGRectMake(0, 0, cell.frame.size.width, 130);
                cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, 130 + 0.5);
                cell.bgView.frame = CGRectMake(0, 0, cell.frame.size.width, 124);
                cell.downImage.frame = CGRectMake(0, 124, cell.frame.size.width, 6.5);
            }
        }
            break;
        case 3:
        {
            cell.imageUrls = [orderResp.evaluationList[indexPath.section] objectForKey:@"goodsImgList"];
            
            if (orderResp.evaluationList.count == 0) {
                return nil;
            }
            NSString *myDate = [NSString stringWithFormat:@"%@", [orderResp.evaluationList[indexPath.section] objectForKey:@"createTime"]];
            cell.date.text = [self formatTimeStamp:[myDate substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"];
            
            cell.state.text = @"已完成";
            
            cell.amount.text = [NSString stringWithFormat:@"合计：￥%.2f", [[orderResp.evaluationList[indexPath.section] objectForKey:@"totalPay"] floatValue]];
            cell.sum.text = [NSString stringWithFormat:@"共%@件商品", [orderResp.evaluationList[indexPath.section] objectForKey:@"totalNumber"]];
            
            [cell.payBtn setTitle:@"点评" forState:UIControlStateNormal];
            cell.payBtn.tag = indexPath.section;
            [cell.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.payBtn.frame = cell.cancleBtn.frame;
            [cell.payBtn addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.cancleBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            cell.cancleBtn.tag = indexPath.section;
            cell.cancleBtn.hidden = YES;
            [cell.cancleBtn addTarget:self action:@selector(orderAgainAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 16)];
    footView.backgroundColor = [UIColor clearColor];
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

/**
 * Method name: scrollAction
 * MARK: - 点击图片跳转
 * Parameter: sender
 */
- (void)scrollAction:(UIGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag;
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    headerView.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    switch (statusNum) {
        case 1:
        {
            orderDetail.orderNum = [orderResp.handleList[tag] objectForKey:@"orderNo"];
        }
            break;
            
        case 2:
            orderDetail.orderNum = [orderResp.finishList[tag] objectForKey:@"orderNo"];
            break;
            
        case 3:
            orderDetail.orderNum = [orderResp.evaluationList[tag] objectForKey:@"orderNo"];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:orderDetail animated:YES];
}

/**
 * Method name: payAction
 * MARK: - 跳转支付
 * Parameter: sender
 */
- (void)payAction:(UIButton *)sender {
    
    OrderPayController *orderPay = [[OrderPayController alloc] init];
    headerView.hidden = YES;
    orderPay.orderNum = [orderResp.handleList[sender.tag] objectForKey:@"orderNo"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderPay animated:YES];
}

/**
 * Method name: cancleAction
 * MARK: - 取消订单处理方法
 * Parameter: sender
 */
- (void)cancleAction:(UIButton *)sender {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    deleteNum = sender.tag;
    
    canaleOrderNum = [orderResp.handleList[sender.tag] objectForKey:@"orderNo"];
    [self getCancleOrderReasons:canaleOrderNum];
}

-(void)refeshCancelAlertView
{
    self.alertScrollView.frame = CGRectMake(0, 40, 300, 124);
    [self.alertScrollView addSubview:titleView];
    self.alertScrollView.contentSize = CGSizeMake(0, titleView.frame.size.height);
    
    titleMessage.frame = CGRectMake(0, 10, myAlertView.frame.size.width, 20);
    [myAlertView addSubview:titleMessage];
    
    cancle.frame = CGRectMake(0, myAlertView.frame.size.height - 45, myAlertView.frame.size.width/2, 45);
    cancle.titleLabel.font = [UIFont systemFontOfSize:14];
    cancleOk.frame = CGRectMake(myAlertView.frame.size.width/2, myAlertView.frame.size.height - 45, myAlertView.frame.size.width/2, 45);
    cancleOk.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleOk setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myAlertView addSubview:cancle];
    [myAlertView addSubview:cancleOk];
    
    horizontalLine.frame = CGRectMake(0, myAlertView.frame.size.height - 46, myAlertView.frame.size.width, 0.5);
    verticalLine.frame = CGRectMake(myAlertView.frame.size.width/2, horizontalLine.frame.origin.y, 0.5, 46);
    [myAlertView addSubview:horizontalLine];
    [myAlertView addSubview:verticalLine];
    
    labelId = nil;
    if (self.myTitleBtns.count > 0) {
        for (UIButton *btn in self.myTitleBtns) {
            btn.layer.borderColor = [[UIColor clearColor] CGColor];
            btn.backgroundColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    titleBtns = [NSMutableArray array];
}

/**获取取消原因标签*/
-(void)getCancleOrderReasons:(NSString *)orderNum
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [self showHUD];
    [client requestMethodWithMod:@"order/reasonList"
                                params:nil
                            postParams:@{@"orderNo":orderNum}
                              delegate:self
                              selector:@selector(getCancleOrderReasonsSuccessed:)
                         errorSelector:@selector(getCancleOrderReasonsFiled:)
                      progressSelector:nil];
}

-(void)getCancleOrderReasonsSuccessed:(NSDictionary *)response
{
    [super hidenHUD];
    if ([DataCheck isValidArray:response[@"labelList"]]) {
        NSArray * cancelList = [CancelReason mj_objectArrayWithKeyValuesArray:response[@"labelList"]];
        NSMutableArray *names = [NSMutableArray array];
        NSMutableArray *labelIds = [NSMutableArray array];
        
        if ([DataCheck isValidArray:cancelList]) {
            for (NSInteger i = 0; i < cancelList.count; i ++) {
                CancelReason * cancelReason = cancelList[i];
                [names addObject:cancelReason.labelText];
                [labelIds addObject:cancelReason.labelId];
            }
        }
        self.cancleTag = 1;
        titleView =  [self createTitle:@{@"titleName":names, @"labelId":labelIds} andViewWidth:viewWidth - 50];
        titleView.frame = CGRectMake(0, 0, viewWidth - 50, titleView.frame.size.height);
        [self myAlertViewShow];
        [self refeshCancelAlertView];
    }
}
-(void)getCancleOrderReasonsFiled:(NSDictionary *)response
{
    [super hidenHUD];
}

//MARK: - 选择标签处理事件
- (void)titleAction:(UIButton *)sender {
    if (titleBtns.count > 0) {
        for (UIButton *btn in titleBtns) {
            btn.layer.borderColor = [[UIColor clearColor] CGColor];
            btn.backgroundColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    [titleBtns addObject:sender];
    
    sender.backgroundColor = [UIColor_HEX colorWithHexString:@"#f57d6e"];
    sender.layer.borderColor = [[UIColor clearColor] CGColor];
    labelId = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    
    if (labelId) {
        cancleOk.enabled = YES;
        [cancleOk setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

/**
 * Method name: cancleOrOkAction
 * MARK: - 取消订单弹框选择取消或确定处理
 * Parameter: sender
 */
- (void)cancleOrOkAction:(UIButton *)sender {
     [MobClick event:Cancel_byUser];
    [self myAlertViewHidden];
    
    if (sender.tag == 1) {
        if (labelId) {
            [self cancleOrderRequest];
        }
        else
        {
            [SRMessage infoMessage:@"请选择取消原因" delegate:self];
        }
    }
    else
    {
        [cancleOk setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

/**
 * Method name: confirmaction
 * MARK: - 确认收货处理方法
 * Parameter: sender
 */
- (void)confirmAction:(UIButton *)sender {
     [MobClick event:Cfm_Receiving];
    deleteNum = sender.tag;
    
    confamOrderNo = [orderResp.handleList[sender.tag] objectForKey:@"orderNo"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您选购的商品已到达了吗？" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确定", nil];
    alert.tag = 200;
    [alert show];
}

/**
 * Method name: hurryOrderAction
 * MARK: - 催单处理方法
 * Parameter: sender
 */
- (void)hurryOrderAction:(UIButton *)sender {
     [MobClick event:Reminder];
    phoneNum = [orderResp.handleList[sender.tag] objectForKey:@"mobile"];
    
    //拨打用户电话
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"是否拨打电话 %@?", phoneNum] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 100) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]]];
        }
        else if (alertView.tag == 200)
        {
            [self confirmGoodsRequest:confamOrderNo];
        }
    }
}

/**
 * Method name: evaluateAction
 * MARK: - 点评处理方法
 * Parameter: sender
 */
- (void)evaluateAction:(UIButton *)sender {
     [MobClick event:Comment_byUser];
    NSString *orderNum = nil;
    EvaluateViewController *evaluation = [[EvaluateViewController alloc] init];
    if (statusNum == 2) {
        orderNum = [orderResp.finishList[sender.tag] objectForKey:@"orderNo"];
    }
    else
    {
        orderNum = [orderResp.evaluationList[sender.tag] objectForKey:@"orderNo"];
    }
    evaluation.orderNum = orderNum;
    evaluation.indexNum = 1;
    evaluation.type = @"2";
    [self.navigationController pushViewController:evaluation animated:YES];
}

/**
 * Method name: orderAgainAction
 * MARK: - 再来一单处理方法
 * Parameter: sender
 */
- (void)orderAgainAction:(UIButton *)sender {
    [MobClick event:OneOrder_Again];
    NSString *goodsOrderNo = nil;
    if (statusNum == 2) {
        goodsOrderNo = [orderResp.finishList[sender.tag] objectForKey:@"orderNo"];
        goodsNum = [orderResp.finishList[sender.tag] objectForKey:@"totalNumber"];
    }
    else
    {
        goodsOrderNo = [orderResp.evaluationList[sender.tag] objectForKey:@"orderNo"];
        goodsNum = [orderResp.evaluationList[sender.tag] objectForKey:@"totalNumber"];
    }
    
    [self buyAgainRequest:goodsOrderNo];
}

//MARK: - 点击查看点评处理事件
- (void)searchEvaluation:(UIButton *)sender {
    EvaluateViewController *evaluation = [[EvaluateViewController alloc] init];
    NSString *orderNum = [orderResp.finishList[sender.tag] objectForKey:@"orderNo"];
    evaluation.orderNum = orderNum;
    evaluation.indexNum = 2;
    evaluation.type = @"2";
    [self.navigationController pushViewController:evaluation animated:YES];
}

//MARK: - 无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        nullImage.hidden = YES;
        nullLab.hidden = YES;
        myTableView.hidden = YES;
        
        noNetWork = [NoNetworkView sharedInstance].view;
        [NoNetworkView sharedInstance].reloadDelegate = self;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:noNetWork];
        
        return YES;
    }
    else
    {
        if (noNetWork) {
            [noNetWork removeFromSuperview];
        }
        return NO;
    }
}

- (void)reloadAgainAction {
    pageNum = 1;
    scrollNum = 0;
    myOrderLists = [NSMutableArray array];
    [self getOrderData];
}

/**
 * Method name: getOrderData
 * MARK: - 获取我的订单列表处理方法
 */
- (void)getOrderData {
    
    if ([self noNetwork]) {
        return;
    }
    
    if ([UserLoginModel isLogged]) {
        
        NSString *status = [NSString stringWithFormat:@"%ld", (long)statusNum];
        NSString *page = [NSString stringWithFormat:@"%ld", (long)pageNum];
        
        [client requestMethodWithMod:@"order/getOrders"
                              params:nil
                          postParams:@{@"status":status, @"pageNum":page}
                            delegate:self
                            selector:@selector(getOrderDataSuccessed:)
                       errorSelector:@selector(getOrderDatafiled:)
                    progressSelector:nil];
    }
}

- (void)getOrderDataSuccessed:(NSDictionary *)response {
    if ([DataCheck isValidDictionary:response]) {
        
        orderResp = [TheOrderRespModel sharedInstance];
        
        orderList = [response objectForKey:@"orderList"];
        
        if (orderList.count == 0 && pageNum > 1) {
            pageNum --;
        }
        
        switch (statusNum) {
            case 0:
                orderResp.handleList = [response objectForKey:@"orderList"];
                
                for (NSDictionary *dic in orderResp.handleList) {
                    [myOrderLists addObject:dic];
                }
                if (pageNum > 1) {
                    orderResp.handleList = myOrderLists;
                }
                break;
            case 1:
                orderResp.handleList = [response objectForKey:@"orderList"];
                
                for (NSDictionary *dic in orderResp.handleList) {
                    [myOrderLists addObject:dic];
                }
                if (pageNum > 1) {
                    orderResp.handleList = myOrderLists;
                }
                
                break;
            case 2:
                orderResp.finishList = [response objectForKey:@"orderList"];
                
                for (NSDictionary *dic in orderResp.finishList) {
                    [myOrderLists addObject:dic];
                }
                if (pageNum > 1) {
                    orderResp.finishList = myOrderLists;
                }
                
                break;
            case 3:
                orderResp.evaluationList = [response objectForKey:@"orderList"];
                
                for (NSDictionary *dic in orderResp.evaluationList) {
                    [myOrderLists addObject:dic];
                }
                if (pageNum > 1) {
                    orderResp.evaluationList = myOrderLists;
                }
                
                break;
            default:
                break;
        }
        
        if (myOrderLists.count > 0) {
            myTableView.hidden = NO;
            [myTableView reloadData];
            if (pageNum == 1 && scrollNum != 1) {
                [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
            
            nullImage.hidden = YES;
            nullLab.hidden = YES;
        }
        else
        {
            myTableView.hidden = YES;
            nullImage.hidden = NO;
            nullLab.hidden = NO;
        }
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}

- (void)getOrderDatafiled:(NSDictionary *)response {
    
    if (pageNum > 1) {
        pageNum --;
    }
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}

/**
 * Method name: cancleOrderRequest
 * MARK: - 取消订单请求接口处理方法
 */
- (void)cancleOrderRequest {
    [self showHUD];
    
    [client requestMethodWithMod:@"order/cancel"
                          params:nil
                      postParams:@{@"orderNo":canaleOrderNum, @"labelId":labelId}
                        delegate:self
                        selector:@selector(getCancleOrderDataSuccessed:)
                   errorSelector:@selector(getCancleOrderDatafiled:)
                progressSelector:nil];
}

- (void)getCancleOrderDataSuccessed:(NSDictionary *)response {
    DLog(@"%@", response);
    
    [myOrderLists removeObjectAtIndex:deleteNum];
    if (myOrderLists.count == 0) {
        pageNum = 1;
        [self getOrderData];
    }
    else
    {
        [myTableView reloadData];
    }
    labelId = nil;
    [self hidenHUD];
}

- (void)getCancleOrderDatafiled:(NSDictionary *)response {
    
    
    [self hidenHUD];
}

/**
 * Method name: confirmGoodsRequest
 * MARK: - 确认收货请求接口处理方法
 * Parameter: goodsOrderNo
 */
- (void)confirmGoodsRequest:(NSString *)goodsOrderNo {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    [self showHUD];
    
    [client requestMethodWithMod:@"order/confirm"
                          params:nil
                      postParams:@{@"orderNo":goodsOrderNo}
                        delegate:self
                        selector:@selector(getconfirmGoodsDataSuccessed:)
                   errorSelector:@selector(getconfirmGoodsDatafiled:)
                progressSelector:nil];
}

- (void)getconfirmGoodsDataSuccessed:(NSDictionary *)response {
    DLog(@"%@", response);
    
    [myOrderLists removeObjectAtIndex:deleteNum];
    if (myOrderLists.count == 0) {
        pageNum = 1;
        [self getOrderData];
    }
    else
    {
        [myTableView reloadData];
    }
    
    
    [self hidenHUD];
}

- (void)getconfirmGoodsDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

/**
 * Method name: buyAgainRequest
 * MARK: - 再来一单请求接口处理方法
 */
- (void)buyAgainRequest:(NSString *)goodsOrderNo {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    [self showHUD];
    
    [client requestMethodWithMod:@"order/again"
                          params:nil
                      postParams:@{@"orderNo":goodsOrderNo}
                        delegate:self
                        selector:@selector(getbuyAgainDataSuccessed:)
                   errorSelector:@selector(getbuyAgainDatafiled:)
                progressSelector:nil];
}

- (void)getbuyAgainDataSuccessed:(NSDictionary *)response {
    
    ShopCartController *shopCart = [[ShopCartController alloc] init];
    NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:shopCart];
    [self presentViewController:navigation animated:YES completion:nil];

    [self hidenHUD];
}

- (void)getbuyAgainDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

- (void)headerRereshing {
    myOrderLists = [NSMutableArray array];
    pageNum = 1;
    scrollNum = 1;
    
    [self getOrderData];
}

- (void)footerRereshing {
    pageNum ++;
    if (orderList.count >= 20) {
        [self getOrderData];
    }
    else
    {
        [self.refreshFooterView endRefreshing];
    }
}

- (void)dealloc {
    [headerView removeFromSuperview];
}

@end
