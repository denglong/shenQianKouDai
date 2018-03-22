//
//  MyOrderController.m
//  KingProFrame
//
//  Created by denglong on 1/18/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "MyOrderController.h"
#import "OrderDetailViewController.h"
#import "EvaluateViewController.h"
#import "EvaluteNoPhysicObjectViewController.h"
#import "OrderPayController.h"
#import "NavigationController.h"
#import "TheOrderCell.h"
#import "myOrderListModel.h"
#import "myOrderModel.h"
#import "CancelReason.h"
#import "GoodsImgModel.h"
#import "CYShopCartingViewController.h"
#import "UIViewController+KNSemiModal.h"

@interface MyOrderController ()<UIAlertViewDelegate, reloadDelegate,CYShopCartingViewControllerDelegate, UITableViewDelegate>
{
    CloudClient              *client;            /**<网络请求类*/
    NSString                  *labelId;           /**<取消订单选择原因*/
    NSMutableArray           *titleBtns;        /**<选择取消原有的Btn*/
    UIView                    *titleView;         /**<点击取消弹出的view*/
    NSString                  *canaleOrderNum;  /**<取消订单的订单号*/
    NSMutableArray          *myOrderLists;     /**<获取我的订单列表*/
    NSInteger                 pageNum;           /**<请求时分页号码*/
    NSInteger                deleteNum;          /**<点击取消订单的tag*/
    NSString                 *goodsNum;          //商品数量
    NSString                 *goodsId;           //商品id
    NSString                 *phoneNum;          //催单电话号码
    NSString                  *confamOrderNo;   //确认订单订单号
    UIView                     *noNetWork;
    myOrderListModel        *orderListModel;
    myOrderModel             *orderModel;
    NSArray                   *orderList;
}

/** 再来一单时商品的数量 */
@property (nonatomic,assign) NSInteger goodsNumber;
/** 再来一单时点击下单时需要传递的参数 */
@property (nonatomic , strong) NSDictionary *orderInfoDictionary;
/** goodsImageModelList */
@property (nonatomic , strong) NSArray *buyAgainGoodsImageModelList;

@end

@implementation MyOrderController
@synthesize myTableView, myAlertView, bgView, horizontalLine, verticalLine, cancle, cancleOk, indexPag, titleMessage;
@synthesize nullImage, nullLab, homeJumping, statusNum;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    if (![UserLoginModel isLogged]) {
        [[AppModel sharedModel] presentLoginController:self];
        return;
    }
    
//    if (![UserLoginModel isLogged]) {
//        myTableView.hidden = YES;
//        [[AppModel sharedModel]  presentLoginController:[UIApplication sharedApplication].keyWindow.rootViewController];
//        return;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self setupHeaderRefresh:myTableView];
    [self setupRefresh:myTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewAction];
    
//    [self setUpFooterRefresh:myTableView];
//    myTableView.hidden = YES;
    
    client = [CloudClient getInstance];
    
//    [self showHUD];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popHomeControllerAction)
                                                 name:NOTIFICATION_LOGINCANCEL
                                               object:nil];
}

- (void)popHomeControllerAction {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)createViewAction {
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
    
    nullLab.hidden = YES;
    nullImage.hidden = YES;
    
    switch (statusNum) {
        case 0:
            self.title = @"我的订单";
            nullLab.text = @"没有订单";
            break;
            
        case 1:
            self.title = @"待支付";
            nullLab.text = @"没有待处理的订单";
            break;
            
        case 2:
            self.title = @"待收货";
            nullLab.text = @"没有已完成的订单";
            break;
            
        case 3:
            self.title = @"已完成";
            nullLab.text = @"没有待点评的订单";
            break;
            
        default:
            break;
    }
    
    //初始化cell
    [myTableView registerNib:[UINib nibWithNibName:@"TheOrderCell" bundle:nil] forCellReuseIdentifier:@"THEORDERCELL"];
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
 * Method name: tableView
 * MARK: - tableView相关实现方法
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return myOrderLists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"THEORDERCELL"];
    
    cell.downImage.frame = CGRectMake(0, cell.bgView.frame.size.height, cell.downImage.frame.size.width, 6.5);
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 0.5);
    cell.myScrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollAction:)];
    cell.myScrollView.tag = indexPath.section;
    [cell.myScrollView addGestureRecognizer:tap];
    
    orderModel = orderListModel.orderList[indexPath.section];
    cell.orderModel = orderModel;
    
    switch ([orderModel.orderStatus integerValue]) {
        case 2:
            cell.cancleBtn.tag = indexPath.section;
            [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 1:
            cell.payBtn.tag = indexPath.section;
            [cell.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.cancleBtn.tag = indexPath.section;
            [cell.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 3:
            cell.cancleBtn.tag = indexPath.section;
            [cell.cancleBtn addTarget:self action:@selector(hurryOrderAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 4:
        {
            cell.confirmBtn.tag = indexPath.section;
            [cell.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 5:
        {
            cell.cancleBtn.tag = indexPath.section;
            [cell.cancleBtn addTarget:self action:@selector(orderAgainAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.payBtn.tag = indexPath.section;
            [cell.payBtn addTarget:self action:@selector(searchEvaluation:) forControlEvents:UIControlEventTouchUpInside];
            if ([orderModel.again integerValue] == 1) {
                cell.payBtn.frame = CGRectMake(CGRectGetMinX(cell.cancleBtn.frame) - 65 , cell.payBtn.frame.origin.y, 60, 24);
                cell.cancleBtn.hidden = NO;
            }
            else
            {
                cell.payBtn.frame = cell.cancleBtn.frame;
                cell.cancleBtn.hidden = YES;
            }
        }
            break;
        case 6:
        {
            cell.state.text = @"已取消";
            cell.cancleBtn.tag = indexPath.section;
            [cell.cancleBtn addTarget:self action:@selector(orderAgainAction:) forControlEvents:UIControlEventTouchUpInside];
            if ([orderModel.again integerValue] == 1) {
                cell.cancleBtn.hidden = NO;
            }
            else
            {
                cell.bgView.frame = CGRectMake(0, 0, cell.bgView.frame.size.width, cell.bgView.frame.size.height - 40);
                cell.downImage.frame = CGRectMake(0, cell.bgView.frame.size.height, cell.downImage.frame.size.width, 6.5);
                cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 0.5);
                cell.cancleBtn.hidden = YES;
            }
        }
            break;
        case 7:
        {
            cell.payBtn.tag = indexPath.section;
            [cell.payBtn addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.cancleBtn.tag = indexPath.section;
            [cell.cancleBtn addTarget:self action:@selector(orderAgainAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([orderModel.again integerValue] == 1) {
                cell.payBtn.frame = CGRectMake(CGRectGetMinX(cell.cancleBtn.frame) - 65 , cell.payBtn.frame.origin.y, 60, 24);
                cell.cancleBtn.hidden = NO;
            }
            else
            {
                cell.payBtn.frame = cell.cancleBtn.frame;
                cell.cancleBtn.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    orderModel = orderListModel.orderList[indexPath.section];
//    if ([orderModel.orderStatus integerValue] == 6) {
//        if ([orderModel.again integerValue] == 1) {
//            return 168.5;
//        }
//        return 130;
//    }
//    else
//    {
//        return 125;
//    }
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 9)];
    footView.backgroundColor = [UIColor clearColor];
    
    return footView;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == myOrderLists.count-2) {
//        [self footerRereshing];
//    }
//}

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
    orderModel = orderListModel.orderList[tag];
    self.hidesBottomBarWhenPushed = YES;
    
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    orderDetail.orderNum = orderModel.orderNo;
    orderDetail.orderState = [orderModel.orderStatus integerValue];
    [self.navigationController pushViewController:orderDetail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/**
 * Method name: payAction
 * MARK: - 跳转支付
 * Parameter: sender
 */
- (void)payAction:(UIButton *)sender {
    orderModel = orderListModel.orderList[sender.tag];
    if ([orderModel.orderStatus integerValue] == 2) {
        OrderPayController *orderPay = [[OrderPayController alloc] init];
        orderPay.orderNum = orderModel.orderNo;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderPay animated:YES];
    }
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

    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        deleteNum = sender.tag;
        orderModel = orderListModel.orderList[sender.tag];
        canaleOrderNum = orderModel.orderNo;
        [self getCancleOrderReasons:canaleOrderNum];
    }
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
    orderModel = orderListModel.orderList[sender.tag];
    confamOrderNo = orderModel.orderNo;
    
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
    orderModel = orderListModel.orderList[sender.tag];
    phoneNum = orderModel.mobile;
    if ([orderModel.orderStatus integerValue] == 3) {
        //拨打用户电话
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"是否拨打电话 %@?", phoneNum] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确定", nil];
        alert.tag = 100;
        [alert show];
    }
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
    orderModel = orderListModel.orderList[sender.tag];
    if ([orderModel.orderStatus integerValue] == 7)
    {
        if ([orderModel.yushou integerValue] == 0)
        {
            EvaluateViewController *evaluation = [[EvaluateViewController alloc] init];
            evaluation.orderNum = orderModel.orderNo;
            evaluation.indexNum = 1;
            evaluation.type = @"2";
            [self.navigationController pushViewController:evaluation animated:YES];
        }
        else
        {
            EvaluteNoPhysicObjectViewController *evaluteNoPhy = [[EvaluteNoPhysicObjectViewController alloc] init];
            evaluteNoPhy.orderNum = orderModel.orderNo;
            evaluteNoPhy.checkOutEvalute = NO;
            [self.navigationController pushViewController:evaluteNoPhy animated:YES];
        }
    }
}

/**
 * Method name: orderAgainAction
 * MARK: - 再来一单处理方法
 * Parameter: sender
 */
- (void)orderAgainAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"再来一单"]) {
        
        [MobClick event:OneOrder_Again];
        NSString *goodsOrderNo = nil;
        orderModel = orderListModel.orderList[sender.tag];
        self.goodsNumber = orderModel.goodsResponses.count;
        self.buyAgainGoodsImageModelList = orderModel.goodsResponses;
        goodsOrderNo = orderModel.orderNo;
        
        goodsNum = orderModel.totalNumber;
        
        if ([orderModel.yushou integerValue] == 1) {
            GoodsImgModel *goodModel = orderModel.goodsResponses.firstObject;
            /**无现货商品再来一单*/
            ConfirmOrderController *confirm = [[ConfirmOrderController alloc] init];
            confirm.presell = YES;
            confirm.goodId = goodModel.goodsId;
            confirm.goodNum = orderModel.totalNumber;
            confirm.shopId = orderModel.shopId;
            confirm.again = @"1";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:confirm animated:YES];
        }
        else
        {
            [self buyAgainRequest:goodsOrderNo];
        }
    }
}

//MARK: - 点击查看点评处理事件
- (void)searchEvaluation:(UIButton *)sender {
    orderModel = orderListModel.orderList[sender.tag];
    if ([orderModel.orderStatus integerValue] == 5) {
        if ([orderModel.yushou integerValue] == 0)
        {
            EvaluateViewController *evaluation = [[EvaluateViewController alloc] init];
            NSString *orderNum = orderModel.orderNo;
            evaluation.orderNum = orderNum;
            evaluation.indexNum = 2;
            evaluation.type = @"2";
            [self.navigationController pushViewController:evaluation animated:YES];
        }
        else
        {
            EvaluteNoPhysicObjectViewController *evaluteNoPhy = [[EvaluteNoPhysicObjectViewController alloc] init];
            evaluteNoPhy.orderNum = orderModel.orderNo;
            evaluteNoPhy.checkOutEvalute = YES;
            [self.navigationController pushViewController:evaluteNoPhy animated:YES];
        }
    }
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
    else
    {
        [self.refreshHeaderView endRefreshing];
        [self.refreshFooterView endRefreshing];
    }
}

- (void)getOrderDataSuccessed:(NSDictionary *)response {
    if ([DataCheck isValidDictionary:response]) {
        
        orderList = [response objectForKey:@"orderList"];
        if (orderList.count == 0 && pageNum > 1) {
            pageNum --;
            [self.refreshFooterView endRefreshing];
            [myTableView reloadData];
            return;
        }
        
        for (NSDictionary *dic in orderList) {
            [myOrderLists addObject:dic];
        }
        
        NSDictionary *respDic = @{@"orderList":myOrderLists};
        orderListModel = [myOrderListModel mj_objectWithKeyValues:respDic];
        
        if (myOrderLists.count > 0) {
            nullImage.hidden = YES;
            nullLab.hidden = YES;
            myTableView.hidden = NO;
            [myTableView reloadData];
            //if (pageNum == 1) {
            //    [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            //}
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
    [myOrderLists removeAllObjects];
    pageNum = 1;
    [self getOrderData];

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
    [myOrderLists removeAllObjects];
    pageNum = 1;
    [self getOrderData];
    
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
    
//    [self showHUD];
    
    [client requestMethodWithMod:@"order/again"
                          params:nil
                      postParams:@{@"orderNo":goodsOrderNo}
                        delegate:self
                        selector:@selector(getbuyAgainDataSuccessed:)
                   errorSelector:@selector(getbuyAgainDatafiled:)
                progressSelector:nil];
}

- (void)getbuyAgainDataSuccessed:(NSDictionary *)response {
    [self hidenHUD];
//    ShopCartController *shopCart = [[ShopCartController alloc] init];
//    NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:shopCart];
//    [self presentViewController:navigation animated:YES completion:nil];
    
    
        CYShopCartingViewController *shoppingCartController = [[CYShopCartingViewController alloc]initWithNibName:@"CYShopCartingViewController" bundle:nil];
    
        shoppingCartController.passOrderInfo = ^(NSDictionary *dictionary){
    
            self.orderInfoDictionary = dictionary;
    
        };
    
        shoppingCartController.delegate = self;
    
        ShoppingCartModel *cartModel = [ShoppingCartModel shareModel];
    
        NSInteger cartGoodsNumber = cartModel.shopInfos.count;
    
        // GoodsImgModel *goodsModel in self.buyAgainGoodsImageModelList
    
        // 判断购物车中商品数量
        if (cartGoodsNumber == 0)
        {
            cartGoodsNumber = self.buyAgainGoodsImageModelList.count;
        }
        else
        {
            for (int i = 0;i < self.buyAgainGoodsImageModelList.count;i++)
            {
                BOOL isEqual = YES;
                GoodsImgModel *goodsModel = self.buyAgainGoodsImageModelList[i];
                for (int j = 0; j<cartModel.shopInfos.count; j++)
                {
                    if ([goodsModel.goodsId integerValue] == [[cartModel.shopInfos[j] objectForKey:@"goodsId"] integerValue])
                    {
                        isEqual = YES;
                        j = (int)cartModel.shopInfos.count;
                    }else
                    {
                        isEqual = NO;
                    }
                }
            
                if (isEqual == NO)
                {
                cartGoodsNumber += 1;
                }
            }
        }
    
        CGFloat height = CYGoodsSectionHeight * cartGoodsNumber + CYShoppingCartMenuHeight;
    
        if (cartGoodsNumber == 0) {
            height = CYEmptyShoppingCartHeight;
        }
    
        if (height >= [UIScreen mainScreen].bounds.size.height *0.9)
        {
            height = [UIScreen mainScreen].bounds.size.height *0.9;
        }
    
        shoppingCartController.height = height;
    
        [self presentSemiViewController:shoppingCartController
                            withOptions:@{
                                          KNSemiModalOptionKeys.pushParentBack : @(NO),
                                          KNSemiModalOptionKeys.parentAlpha : @(0.5)
                                          }
                             completion:nil
                           dismissBlock:^{
                               
                               [self.myTableView reloadData];
                               
                               [self.navigationController setNavigationBarHidden:NO];
                               
                           }];
        

}

#pragma mark - CYShopCartingViewControllerDelegate
// just for fun
- (void)gotoBuy
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CYShopCartingViewController class]]) {
            [controller removeFromParentViewController];
        }
    }
    
    ConfirmOrderController *confirmControll=[[ConfirmOrderController alloc]
                                             initWithNibName:@"ConfirmOrderController"
                                             bundle:nil];
    confirmControll.orderInfoDic=[[NSDictionary alloc]initWithDictionary:self.orderInfoDictionary];
    
    [self.navigationController setNavigationBarHidden:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:confirmControll animated:YES];
    });
    [self.navigationController setNavigationBarHidden:NO];
    
}



- (void)getbuyAgainDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

- (void)headerRereshing {
    myOrderLists = [NSMutableArray array];
    pageNum = 1;
    
    [self getOrderData];
}

- (void)footerRereshing {
    pageNum ++;
    [self getOrderData];
}

- (NSArray *)buyAgainGoodsImageModelList
{
    if (_buyAgainGoodsImageModelList == nil)
    {
        _buyAgainGoodsImageModelList = [NSArray array];
    }
    return _buyAgainGoodsImageModelList;
}

@end
