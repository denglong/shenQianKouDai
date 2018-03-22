//
//  OrderDetailViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/8/6.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailHeaderCell.h"
#import "OrderDetailInfoCell.h"
#import "OrderDetailShopCell.h"
#import "OrderDetailFootCell.h"
#import "OrderDetailGoodsCell.h"
#import "OrderDetail.h"
#import "goodsModel.h"
#import "OrderPayController.h"
#import "EvaluationViewController.h"
#import "EvaluateViewController.h"
#import "ShopCartController.h"
#import "ShopDetailsController.h"
#import "MyOrderController.h"
#import "TabBarController.h"
#import "CancelReason.h"
#import "GeneralShowWebView.h"
#import "HomeViewController.h"
#import "BusinessInfoViewController.h"
#import "NavigationController.h"
#import "EvaluteNoPhysicObjectViewController.h"
#import "CYShopCartingViewController.h"

#define TIME_JUMPTOPAY   3//跳转至支付页面倒计时时间
#define TAG_DAY_EXCEPTBTN  1001 //白天打赏按钮tag
#define TAG_NIGHT_EXCEPTBTN 1002 //夜晚打赏按钮tag
@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,reloadDelegate,UITextFieldDelegate,CYShopCartingViewControllerDelegate>
{
    CloudClient * _cloudClient;
    NSInteger goodsNum;
    NSInteger shengTime;
    NSTimer * _timer;
    UIView * titleView;
    NSMutableArray * titleBtns;
    NSArray *cancelList;
    NSString * labelId;
    UITextField * _textField;
//    NSString * ordertype;
    BOOL dianping;
    BOOL isFirst;
    UIView * line;
    UIView                     *noNetWork;
    
    NSTimer * _pollTime; //轮循
    int  payTimeNum;//跳转支付宝时间
    UIView * cancelReasoniew;
}

@property (nonatomic , retain)OrderDetail * orderDetail;


- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *ordertitleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *orderDetailTableView;


@property (weak, nonatomic) IBOutlet UIButton *RedEnvelope; //发红包
/**再来一单View*/
@property (weak, nonatomic) IBOutlet UIView *againView;
/**点评按钮*/
@property (weak, nonatomic) IBOutlet UIButton *dianPingBtn;
/**点评事件*/
- (IBAction)dianPingBtnAction:(UIButton *)sender;
/**再来一单按钮y轴约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *againBtnConstraint;
/**再来一单按钮*/
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
- (IBAction)RedEnvelopeClick:(UIButton *)sender;
/**再来一单事件*/
- (IBAction)againBtnAction:(UIButton *)sender;
/**取消订单View*/
@property (weak, nonatomic) IBOutlet UIView *cancelView;
/**取消订单按钮*/
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/**取消订单事件*/
- (IBAction)cancelBtnAction:(UIButton *)sender;
/**去支付View*/
@property (weak, nonatomic) IBOutlet UIView *payView;
/**确认收货view*/
@property (weak, nonatomic) IBOutlet UIView *confirmView;
/**确认收货按钮*/
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/**去支付按钮*/
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
/**实际支付金额*/
@property (weak, nonatomic) IBOutlet UILabel *totalPayPrice;
/**支付事件*/
- (IBAction)payBtnAction:(UIButton *)sender;

/**取消原因*/
@property (weak, nonatomic) IBOutlet UIView *myAlertView;
@property (weak, nonatomic) IBOutlet UIButton *cancleOrOk;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIButton *callPhone;
@property (weak, nonatomic) IBOutlet UILabel *callPhoneLable;


#pragma -mark 抢单成功页面元素
//被抢单成功的界面元素-------------------------------//
@property (strong, nonatomic) IBOutlet UIView *successView;//被抢单成功页面
@property (strong, nonatomic) IBOutlet UIImageView *supermarketImgView;//超市的头像
@property (strong, nonatomic) IBOutlet UILabel *supermarketNameLabel;//超市名字
@property (strong, nonatomic) IBOutlet UILabel *completedOrderNumLabel;//已完成的订单
@property (strong, nonatomic) IBOutlet UILabel *grabTimeLabel;//抢单时间
@property (strong, nonatomic) IBOutlet UILabel *promptPayLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkImgView;//认证标识

#pragma -mark 白天小费提示页面元素
@property(nonatomic)int tipAmount;
@property(strong,nonatomic) NSDictionary * dialogInfoDic;//弹出对话框信息
@property(strong,nonatomic) NSDictionary *pollDic;//轮询后的数据字典
/** 记录选中小费 */
@property (nonatomic , strong) UIButton *selectedButton;

@property (strong, nonatomic) IBOutlet UIView *dayAlertTipView;
@property (strong, nonatomic) IBOutlet UIView *nightAlertTipView;

@property (strong, nonatomic) IBOutlet UIView *dayTipView;//白天小费视图
@property (strong, nonatomic) IBOutlet UIButton *dayExceptionalBtn;//白天打赏按钮
@property (strong, nonatomic) IBOutlet UIButton *dayCancelBtn;//白天取消按钮

#pragma -mark 晚上小费提示页面元素

@property (strong,nonatomic) IBOutlet UILabel *inputTipLabel;//输入小费提示label
@property (strong,nonatomic) IBOutlet UIView *nightTipView;//夜晚小费弹出视图

@property (strong, nonatomic) IBOutlet UIButton *nightExcepBtn;//晚上打赏按钮
@property (strong, nonatomic) IBOutlet UIButton *nightCancelBtn;//晚上取消按钮
@property (strong, nonatomic) IBOutlet UIButton *selfHelpBtn;//自己填btn
@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;//输入钱数textfield
/** 购物车商品下单信息 */
@property (nonatomic , strong) NSDictionary *orderInfoDictionary;
/**轮询时间间隔*/
@property(nonatomic,retain)NSString *pollTimeStr;
/**已通知的商家数*/
@property(nonatomic,retain)NSString *shopNumStr;

//选择小费点击事件
-(IBAction)choseATipToExceptional:(UIButton*)sender;
/**自定义小费按钮*/
- (IBAction)selfHelpTouch:(id)sender;

/** 是否打赏过 */
@property (nonatomic,retain) NSString * hasTipped;
@end

@implementation OrderDetailViewController
@synthesize orderDetail;

//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        return YES;
    }
    else
    {
        [noNetWork removeFromSuperview];
        return NO;
    }
}

-(void)reloadAgainAction
{
    [self getOrderDetail];
}

/**获取详情*/
-(void)getOrderDetail
{
    if ([self noNetwork]) {
        return;
    }
    
    NSDictionary * postParams = @{@"orderNo":self.orderNum};
    [_cloudClient requestMethodWithMod:@"order/getOrderInfo"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(getOrderDetailSuccessed:)
                         errorSelector:@selector(getOrderDetailError:)
                      progressSelector:nil];
}
-(void)getOrderDetailSuccessed:(NSDictionary *)response
{
    NSLog(@"%@", response);
    orderDetail = [OrderDetail mj_objectWithKeyValues:response];
    
    NSInteger time = ([orderDetail.serverTime integerValue]- [orderDetail.createTime integerValue])/1000;
    if (time > 900 && orderDetail.orderStatus == 1) {
        [self timeOutAction];
    }

    [self showBtn];
    if (isFirst == NO) {
        for (int i = 0; i < orderDetail.goodsList.count; i++) {
            goodsModel * goods = [orderDetail.goodsList objectAtIndex:i];
            goodsNum += goods.goodsNumber;
        }
        isFirst = YES;
    }
     [_timer invalidate];
    if (orderDetail.orderStatus == 1 || orderDetail.orderStatus == 2) {
        shengTime = orderDetail.countDown;
        if (shengTime > 0) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojisheiAction) userInfo:nil repeats:YES];
        }
    }
    
    
    self.orderDetailTableView.hidden = NO;
    [self.orderDetailTableView reloadData];
  
    [self hidenHUD];
}
-(void)getOrderDetailError:(NSDictionary *)response
{
    [self hidenHUD];
    if ([[[CommClass sharedCommon] objectForKey:@"GeTuiTag"] integerValue] == 100) {
        [[CommClass sharedCommon] setObject:@"10" forKey:@"GeTuiTag"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)showBtn
{
    self.titleLabel.text = @"订单详情";//orderDetail.orderTextA;
    self.againView.hidden = YES;
    self.payView.hidden = YES;
    self.confirmView.hidden = YES;
    self.dianPingBtn.hidden = YES;
    self.cancelBtn.hidden = NO;
    self.againBtn.hidden = NO;
    self.callPhone.hidden = YES;
    self.callPhoneLable.hidden = YES;
    self.againBtnConstraint.constant = 0;
    self.orderDetailTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    if (orderDetail.isCancel != 1) {
//        self.cancelBtn.hidden = YES;
//        self.orderDetailTableView.contentInset = UIEdgeInsetsMake(0, 0, -self.cancelView.frame.size.height, 0);
//    }
//    if (orderDetail.again == 2) {
//        self.againView.hidden = NO;
//        [self.againView addSubview:line];
//        self.orderDetailTableView.contentInset = UIEdgeInsetsMake(0, 0, -self.cancelView.frame.size.height+self.againView.frame.size.height, 0);
//        if (orderDetail.orderStatus == 7) {
//            self.dianPingBtn.hidden = NO;
//            self.againBtnConstraint.constant = self.againBtn.frame.size.width/2+5;
//        }
//        return;
//    }
//    if (orderDetail.orderStatus == 7 && orderDetail.again != 1) {
//        self.againView.hidden = NO;
//        self.dianPingBtn.hidden = NO;
//        self.againBtn.hidden = YES;
//        [self.againView addSubview:line];
//        self.orderDetailTableView.contentInset = UIEdgeInsetsMake(0, 0, -self.cancelView.frame.size.height+self.againView.frame.size.height, 0);
//        self.againBtnConstraint.constant = self.againBtn.frame.size.width+10;
//        return;
//    }
    if ( orderDetail.orderStatus == 1) {
        self.payView.hidden = NO;
        self.confirmView.hidden = YES;
        [self.payView addSubview:line];
        self.totalPayPrice.text = [NSString stringWithFormat:@"¥%.2f",orderDetail.payPrice];
        self.orderDetailTableView.contentInset = UIEdgeInsetsMake(0, 0, self.payView.frame.size.height, 0);
        return;
    }
    
    if ( orderDetail.orderStatus == 4) {
        self.confirmView.hidden = NO;
        self.payView.hidden = YES;
        self.callPhone.hidden = NO;
        self.callPhoneLable.hidden = NO;
        return;
    }
}

#pragma mark - 倒计时
-(void)daojisheiAction
{
    if (shengTime > 0) {
        shengTime --;
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        OrderDetailHeaderCell * cell = (OrderDetailHeaderCell *)[self.orderDetailTableView cellForRowAtIndexPath:indexPath];
        if (orderDetail.orderStatus == 2) {
             cell.titleLable2.text = [self getShengyushijian];
        }else{
             cell.titleLabel3.text = [self getShengyushijian];
        }
    }else{
        [_timer invalidate];
        [_pollTime invalidate];
        [_dayTipView removeFromSuperview];
        [_nightTipView removeFromSuperview];
        [self getOrderDetail];
    }
}

-(NSString *)getShengyushijian
{
    if (orderDetail.orderStatus == 2) {
        NSInteger min =(30*60 - shengTime)/60;
        NSInteger second = (30*60 - shengTime)%60;
        if (min < 60) {
            if (second < 10) {
                return [NSString stringWithFormat: @"%ld:0%ld",(long)min,(long)second];
            }
            return [NSString stringWithFormat: @"%ld:%ld",(long)min,(long)second];
        }else{
            NSInteger h = min/60;
            min = min%60;
            if (second < 10) {
                return [NSString stringWithFormat: @"%ld:%ld:0%ld",(long)h,(long)min,(long)second];
            }
            return [NSString stringWithFormat: @"%ld:%ld:%ld",(long)h,(long)min,(long)second];
        }
    }

    NSInteger min = shengTime/60;
    NSInteger second = shengTime%60;
    if (min < 60) {
        if (second < 10) {
            return [NSString stringWithFormat: @"%ld:0%ld%@",(long)min,(long)second,orderDetail.orderTextC];
        }
        return [NSString stringWithFormat: @"%ld:%ld%@",(long)min,(long)second,orderDetail.orderTextC];
    }else{
        NSInteger h = min/60;
        min = min%60;
        if (second < 10) {
            return [NSString stringWithFormat: @"%ld:%ld:0%ld%@",(long)h,(long)min,(long)second,orderDetail.orderTextC];
        }
        return [NSString stringWithFormat: @"%ld:%ld:%ld%@",(long)h,(long)min,(long)second,orderDetail.orderTextC];
    }
    
}

-(void)backAction:(id)sender
{
    //信鸽消息回跳
    if (self.xgTag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.secKill == YES || self.presell == YES) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[GeneralShowWebView class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
    }
    if (self.homePush == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
 
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title =@"订单详情";
//    if ([UserLoginModel isLogged]) {
//        [self getOrderDetail];
//    }
    [self getOrderDetail];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    [_pollTime invalidate];
    [_dayTipView removeFromSuperview];
    [_nightTipView removeFromSuperview];
    [_successView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBtnLayer];
    // Do any additional setup after loading the view from its nib.
    self.orderDetailTableView.hidden = YES;
    self.orderDetailTableView.backgroundColor = [self.view backgroundColor];
    [super setExtraCellLineHidden:self.orderDetailTableView];
    self.orderDetailTableView.tableFooterView = self.cancelView;
    [self registerCell];
    goodsNum = 0;

   
    [self setLayerOut];
    _cloudClient = [CloudClient getInstance];
   [self showHUD];
    if ([UserLoginModel isLogged] && self.orderState == 2) {
        self.shopNumStr = @"0";
//        [self requestPollInfo];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeOutAction) name:@"timeOut" object:nil];
}
/**
 *  设置按钮的边框及圆角
 */
-(void)setBtnLayer
{
    self.ordertitleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBarBackground"]];
    self.cancelBtn.layer.cornerRadius = 4;
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = self.cancelBtn.titleLabel.textColor.CGColor;
    self.callPhone.layer.cornerRadius = 4;
    self.againBtn.layer.cornerRadius = 4;
    self.againBtn.layer.borderWidth = 0.5;
    self.againBtn.layer.borderColor = self.againBtn.titleLabel.textColor.CGColor;
    self.payBtn.layer.cornerRadius = 4;
    self.confirmBtn.layer.cornerRadius = 4;
    self.dianPingBtn.layer.borderWidth = 0.5;
    self.dianPingBtn.layer.borderColor = self.againBtn.titleLabel.textColor.CGColor;
    self.dianPingBtn.layer.cornerRadius = 4;
    line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 0.5)];
    line.backgroundColor = self.view.backgroundColor;
    self.againView.hidden = YES;
    self.payView.hidden = YES;
    self.dianPingBtn.hidden = YES;
}
//注册cell
-(void)registerCell
{
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"OrderDetailHeaderCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDetailHeaderCell class])];
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"OrderDetailInfoCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDetailInfoCell class])];
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"OrderDetailShopCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDetailShopCell class])];
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"OrderDetailFootCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDetailFootCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return LHLHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *headerView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, LHLHeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    
    return headerView;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if ((orderDetail.orderStatus >= 1  && section == 1)) {
        return orderDetail.goodsList.count+2;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
         return 127;
    }
    if (indexPath.section > 0 && indexPath.row == 0) {
        return 41;
    }
    if ((orderDetail.orderStatus >= 1 && indexPath.section == 1 && indexPath.row == orderDetail.goodsList.count+1) || (orderDetail.orderStatus == 1 && indexPath.section == 2 && indexPath.row == orderDetail.goodsList.count+1)) {
        return 130;
    }
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ( ((orderDetail.orderStatus >= 1  && indexPath.section == 1) || (orderDetail.orderStatus == 1 && indexPath.section == 2)) && (indexPath.row == orderDetail.goodsList.count)) {
         return cell.frame.size.height + 12;
    }
    return cell.frame.size.height + 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        //订单状态
        OrderDetailHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailHeaderCell class])];
        cell.shengTime = shengTime;
        [cell setOrderDetail:orderDetail];
        NSInteger status = orderDetail.orderStatus;
        self.RedEnvelope.hidden = YES;
        //顾客
        if (status == 5 && orderDetail.packets > 0) {
            self.RedEnvelope.hidden = NO;
        }
        [cell.zhifuBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sureOrder addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    if (indexPath.section > 0 && indexPath.row == 0) {
        OrderDetailShopCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailShopCell class])];
        [cell setOrderDetail:orderDetail WithIndexPath:indexPath total:goodsNum];
        return cell;
    }

    if ((orderDetail.orderStatus >= 1 && indexPath.section == 1 && indexPath.row < orderDetail.goodsList.count+1)) {
        //商品详情
        OrderDetailGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailGoodsCell class])];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailGoodsCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell setGoods:[orderDetail.goodsList objectAtIndex:indexPath.row-1]];
        return cell;
    }

    if ((orderDetail.orderStatus >= 1 && indexPath.section == 2 && indexPath.row == 1) || (orderDetail.orderStatus == 1 && indexPath.section == 1 && indexPath.row == 1)) {
        OrderDetailFootCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailFootCell class])];
        cell.orderDetail = orderDetail;
        return cell;
    }
    OrderDetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailInfoCell class])];
    cell.orderDetail = orderDetail;
    return cell;
}


/*
 * 客户端状态按钮事件
 * 打赏一下301 再来一单302 付款101  点评103 催单200 查看点评201 "逛一逛 500
 */
-(void)orderBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 101:
        {
            [self payBtnAction:nil];
        }
            break;
        case 102:
        {
            //确认收货
            [MobClick event:Cfm_Receiving];
            [SRMessage infoMessage:@"您选购的商品已到达了吗？" block:^{
                [self confirmGoodsRequest:orderDetail.orderNo];
            }];
        }
            break;
        case 103:
        {
            [MobClick event:Comment_byUser];
            [self dianPingBtnAction:sender];
        }
            break;
        case 201:
        {
            if (orderDetail.yushou == 1) {
                /**无现货商品查看点评*/
                EvaluteNoPhysicObjectViewController * evaluteNoPhysicObjectVC = [[EvaluteNoPhysicObjectViewController alloc]init];
                evaluteNoPhysicObjectVC.orderNum = orderDetail.orderNo;
                evaluteNoPhysicObjectVC.checkOutEvalute = YES;
                [self.navigationController pushViewController:evaluteNoPhysicObjectVC animated:YES];
            }else{
                EvaluateViewController *evaluation = [[EvaluateViewController alloc] init];
                evaluation.orderNum = orderDetail.orderNo;
                evaluation.type = @"2";
                evaluation.indexNum = 2;
                [self.navigationController pushViewController:evaluation animated:YES];
            }
        }
            break;
        case 301:
        { //打赏
            [self showTipViewTouch:sender];
        }
            break;
       case 302:
            [self againBtnAction:nil];
            break;
        case 500:
        {
           //逛一逛
            //信鸽消息回跳
            if (self.xgTag == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
                TabBarController *tabBarControl=[TabBarController sharedInstance];
                tabBarControl.selectedIndex = 0;
                return;
            }
           
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default:
        {
            //联系商家
            [MobClick event:Reminder];
            NSString *phoneNum = orderDetail.mobile;
            //拨打用户电话
            [SRMessage infoMessage:[NSString stringWithFormat:@"是否拨打电话 %@?",phoneNum] block:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]]];
            }];
        }
            break;
    }
}

#pragma mark - textFeild delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField = textField;
    return YES;
}
#pragma mark - cancelOrder  取消订单
/**
 *  取消按钮事件
 *
 *  @param sender
 */
- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self cancleOrderRequest];
//    [self getCancleOrderReasons];
}
/**获取取消原因标签*/
-(void)getCancleOrderReasons
{
     [MobClick event:Cancel_byUser];
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [self showHUD];
    [_cloudClient requestMethodWithMod:@"order/reasonList"
                                params:nil
                            postParams:@{@"orderNo":self.orderNum}
                              delegate:self
                              selector:@selector(getCancleOrderReasonsSuccessed:)
                         errorSelector:@selector(getCancleOrderReasonsFiled:)
                      progressSelector:nil];
}

-(void)getCancleOrderReasonsSuccessed:(NSDictionary *)response
{
    [super hidenHUD];
    if ([DataCheck isValidArray:response[@"labelList"]]) {
        cancelList =[CancelReason mj_objectArrayWithKeyValuesArray:response[@"labelList"]];
        [self myAlertViewShow];
    }
}
-(void)getCancleOrderReasonsFiled:(NSDictionary *)response
{
    [super hidenHUD];
}
/**显示取消原因标签*/
- (void)myAlertViewShow {
//    myAlertView.hidden = NO;
//    bgView.hidden = NO;
//    cancelList = [[CommClass sharedCommon] objectForKey:HOMEINFO_CANCELLIST];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    cancelReasoniew.frame = CGRectMake(0, 0, window.frame.size.width,  window.frame.size.height);
    //    [cancelReasoniew addSubview:myAlertView];
    
    
    NSMutableArray * names =[NSMutableArray array];
    for (CancelReason * dic in cancelList) {
        [names addObject:dic.labelText];
    }
    
    self.cancleTag = 1;
    titleView =  [self createTitle:@{@"titleName":names} andViewWidth:viewWidth-50];
    titleView.frame = CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height);
    [_myScrollView addSubview:titleView];
    _myScrollView.contentSize = CGSizeMake(0, titleView.frame.size.height+10);
    
     titleBtns = [NSMutableArray array];
    [self popupAnimation:_myAlertView duration:0.5];
    
    if (self.myTitleBtns.count > 0) {
        for (UIButton *btn in self.myTitleBtns) {
            btn.layer.borderColor = [[UIColor clearColor] CGColor];
            btn.backgroundColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    [window addSubview:cancelReasoniew];
}
/**隐藏取消原因标签*/
- (void)myAlertViewHidden {
    [titleView removeFromSuperview];
    [cancelReasoniew removeFromSuperview];
    [self.cancleOrOk setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self popupAnimation:_myAlertView duration:0.5];
}
/**
 * Method name: cancleOrOkAction
 * Description: 取消订单弹框选择取消或确定处理
 * Parameter: sender
 * Parameter: 无
 */
- (IBAction)cancleOrOkAction:(UIButton *)sender {
    [self myAlertViewHidden];
    
    if (sender.tag == 1) {
        if (![DataCheck isValidString:labelId]) {
            [SRMessage infoMessage:@"请选择取消原因" delegate:self];
            return;
        }
         [self cancleOrderRequest];
    }
}
//选择标签处理事件
- (void)titleAction:(UIButton *)sender {
    if (titleBtns.count > 0) {
        for (UIButton *btn in titleBtns) {
            btn.layer.borderColor = [[UIColor clearColor] CGColor];
            btn.backgroundColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    [self.cancleOrOk setTitleColor:RGBACOLOR(245, 125, 110, 1) forState:UIControlStateNormal];
    [titleBtns addObject:sender];

    sender.backgroundColor = [UIColor_HEX colorWithHexString:@"#f57d6e"];
    sender.layer.borderColor = [[UIColor clearColor] CGColor];
    CancelReason * cancelReason = [cancelList objectAtIndex:sender.tag];
    labelId = [NSString stringWithFormat:@"%@",cancelReason.labelId];
}



/**
 * Method name: cancleOrderRequest
 * Description: 取消订单请求接口处理方法
 * Parameter: 无
 * Parameter: 无
 */
- (void)cancleOrderRequest {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [self showHUD];
    [_cloudClient requestMethodWithMod:@"order/cancel"
                                params:nil
                            postParams:@{@"orderNo":self.orderNum,@"labelId":@"1"}
                              delegate:self
                              selector:@selector(getCancleOrderDataSuccessed:)
                         errorSelector:@selector(getCancleOrderDatafiled:)
                      progressSelector:nil];

    
}

- (void)getCancleOrderDataSuccessed:(NSDictionary *)response {
    DLog(@"%@", response);
    [self hidenHUD];
    [_timer invalidate];
    [_pollTime invalidate];
    [self getOrderDetail];
}

- (void)getCancleOrderDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}
#pragma mark - sure收货
/**
 * Method name: confirmGoodsRequest
 * Description: 确认收货请求接口处理方法
 * Parameter: goodsOrderNo
 * Parameter: 无
 */
- (void)confirmGoodsRequest:(NSString *)goodsOrderNo {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [self showHUD];
    
    [_cloudClient requestMethodWithMod:@"order/confirm"
                          params:nil
                      postParams:@{@"orderNo":goodsOrderNo}
                        delegate:self
                        selector:@selector(getconfirmGoodsDataSuccessed:)
                   errorSelector:@selector(getconfirmGoodsDatafiled:)
                progressSelector:nil];
}

- (void)getconfirmGoodsDataSuccessed:(NSDictionary *)response {

    [self getOrderDetail];
    [self hidenHUD];
}

- (void)getconfirmGoodsDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}


#pragma mark - 再来一单
/**
 *  再来一单点击事件
 *
 *  @param sender
 */
- (IBAction)againBtnAction:(UIButton *)sender {
    if (orderDetail.yushou == 1) {
        /**无现货商品再来一单*/
        ConfirmOrderController *confirm = [[ConfirmOrderController alloc] init];
        confirm.presell = YES;
        goodsModel * goods = [orderDetail.goodsList firstObject];
        confirm.goodId = goods.goodsId;
        confirm.goodNum = [NSString stringWithFormat:@"%ld",goods.goodsNumber];
        confirm.shopId = orderDetail.shopId;
        confirm.again = @"1";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:confirm animated:YES];
    }
    else
    {
        [self buyAgainRequest:orderDetail.orderNo];
    }
}

/**
 * Method name: buyAgainRequest
 * Description: 再来一单请求接口处理方法
 * Parameter: 无
 * Parameter: 无
 */
- (void)buyAgainRequest:(NSString *)goodsOrderNo {
     [MobClick event:OneOrder_Again];
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
//    [self showHUD];
    [_cloudClient requestMethodWithMod:@"order/again"
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
//    NSInteger goodsNumber = orderDetail.goodsList.count;
    
    CYShopCartingViewController *shoppingCartController = [[CYShopCartingViewController alloc]initWithNibName:@"CYShopCartingViewController" bundle:nil];
    
    shoppingCartController.passOrderInfo = ^(NSDictionary *dictionary){
        
        self.orderInfoDictionary = dictionary;
        
    };
    
    shoppingCartController.delegate = self;
    
    ShoppingCartModel *cartModel = [ShoppingCartModel shareModel];
    
    NSInteger cartGoodsNumber = cartModel.shopInfos.count;
    
    // 先判断购物车数量是否为0，为0，直接cartGoodsNumber设置为再来一单数量
    if (cartGoodsNumber == 0)
    {
        cartGoodsNumber = orderDetail.goodsList.count;
    }
    else
    {
        for (int i = 0;i < orderDetail.goodsList.count;i++)
        {
            BOOL isEqual = YES;
            goodsModel *goodsModel =  orderDetail.goodsList[i];
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
    
    CGFloat height = CYGoodsSectionHeight * cartGoodsNumber  + CYShoppingCartMenuHeight;
    
    if (cartGoodsNumber == 0) {
        height = CYEmptyShoppingCartHeight;
    }
    
    if (height >= [UIScreen mainScreen].bounds.size.height *0.9)
    {
        height = [UIScreen mainScreen].bounds.size.height *0.9;
    }
    
    shoppingCartController.height = height;
    
    [self presentViewController:shoppingCartController animated:YES completion:nil];
    
//    [self presentSemiViewController:shoppingCartController
//                        withOptions:@{
//                                      KNSemiModalOptionKeys.pushParentBack : @(NO),
//                                      KNSemiModalOptionKeys.parentAlpha : @(0.5)
//                                      }
//                         completion:nil
//                       dismissBlock:^{
////                           [self.navigationController setNavigationBarHidden:NO];
//                       }];
//    

    
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
//    [self.navigationController setNavigationBarHidden:NO];

    
}




- (void)getbuyAgainDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

#pragma mark - 发红包
/**
 *  点击发红包按钮 ， 弹出发红包框
 */
- (IBAction)RedEnvelopeClick:(UIButton *)sender {
    //发红包
    UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信" otherButtonTitles: @"朋友圈",nil];
    [action showInView:self.view];

}

#pragma mark - actionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * urlString = orderDetail.packetUrl;
       switch (buttonIndex) {
           case 0:
           {
               //微信好友
               [super shareapplicationContent:orderDetail.packText
                               defaultContent:nil
                                        title:orderDetail.packTitle
                                          url:urlString
                                  description:nil
                                         type:SSDKPlatformSubTypeWechatSession
                                    imagePath:orderDetail.packImg];
           }
               break;
        case 1:
           {
               //微信朋友圈
               [super shareapplicationContent:orderDetail.packText
                               defaultContent:nil
                                        title:orderDetail.packTitle
                                          url:urlString
                                  description:nil
                                         type:SSDKPlatformSubTypeWechatTimeline
                                    imagePath:orderDetail.packImg];
           }
               break;
//        case 2:
//           {
//               //QQ好友
//               [super shareapplicationContent:orderDetail.packText
//                               defaultContent:nil
//                                        title:orderDetail.packTitle
//                                          url:urlString
//                                  description:nil
//                                         type:ShareTypeQQ
//                                    imagePath:orderDetail.packImg];
//               
//           }
//               break;
//           case 3:
//           {
//               //QQ空间
//               [super shareapplicationContent:orderDetail.packText
//                               defaultContent:nil
//                                        title:orderDetail.packTitle
//                                          url:urlString
//                                  description:nil
//                                         type:ShareTypeQQSpace
//                                    imagePath:orderDetail.packImg];
//           }
//               break;
        default:
              
            break;
    }

}

#pragma mark - 支付事件
- (IBAction)payBtnAction:(UIButton *)sender {
    OrderPayController *orderPay = [[OrderPayController alloc] init];
    orderPay.orderNum = orderDetail.orderNo;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderPay animated:YES];
}
#pragma -mark ----------------->抢单接口
/**
 * Method name: pollingRequest
 * Description: 轮询发送抢单
 */
-(void)pollingRequest{
    double timeInter=[self.pollTimeStr doubleValue]/1000;
    [_pollTime invalidate];
    _pollTime=[NSTimer scheduledTimerWithTimeInterval:timeInter
                                                target:self
                                              selector:@selector(requestPollInfo)
                                              userInfo:nil
                                               repeats:YES];
}
/**
 * Method name: requestPollInfo
 * Description: 轮询抢单
 */
-(void)requestPollInfo{
    
    if (![UserLoginModel isLogged]) {
        return;
    }
    NSDictionary *paramsDic=@{@"orderNo":self.orderNum,
                              @"shopNumber":self.shopNumStr};
    
    [_cloudClient requestMethodWithMod:@"order/poll"
                                params:nil
                            postParams:paramsDic
                              delegate:self
                              selector:@selector(requestPollSuccess:)
                         errorSelector:@selector(requestPollFail:)
                      progressSelector:nil];
}

-(void)requestPollSuccess:(NSDictionary*)response{
    
    if ([DataCheck isValidDictionary:response]) {
        
        _pollDic=[NSDictionary dictionaryWithDictionary:response];

        //重新赋值轮询抢单时间
        self.pollTimeStr=[response objectForKey:@"pollTime"];
        //重新赋值已通知商家个数
        self.shopNumStr=[response objectForKey:@"shopNumber"];
 
        //弹框信息赋值
        if ([DataCheck isValidArray:[response objectForKey:@"dialogList"]]) {
            
            NSArray * dialogArray=[response objectForKey:@"dialogList"];
            _dialogInfoDic=[NSDictionary dictionaryWithDictionary:[self formatSpecialArray:dialogArray]];
        }
        [self pollingRequest];
        [self dealRobbedOrderAction];
    }
}

-(void)requestPollFail:(NSDictionary*)response{
    [self backAction:nil];
    if ([[response objectForKey:@"code"] integerValue] == 101) {
        [_timer invalidate];
        [_pollTime invalidate];
    }
}
#pragma -mark ----------------->被抢单事件的处理
/**
 * Method name: dealRobbedOrderAction
 * Description: 被抢单的事件
 */
-(void)dealRobbedOrderAction{
    
    //1:未被抢单  2:已被抢单
    
    int flag=[[_pollDic objectForKey:@"flag"] intValue];
    if (flag==1) {
        NSString *tip=[_dialogInfoDic objectForKey:@"tip"];
        OrderDetailHeaderCell * cell = [self.orderDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([DataCheck isValidString:tip]) {
            NSArray *tipArray=[tip componentsSeparatedByString:@","];
            [self setTipValueWithArray:tipArray];
            // 根据订单号存储打赏小费
            self.hasTipped = [[CommClass sharedCommon] localObjectForKey:self.orderNum];
            if ([self.hasTipped isEqualToString:@"YES"])
            {
                cell.shengTime = shengTime;
                [cell showTipBtn:orderDetail ifshow:YES shengTime:shengTime];
            }else
            {
                
                [self showTipViewTouch:nil];
            }
        }
    }
    else if (flag==2){

        [_dayTipView removeFromSuperview];
        [_nightTipView removeFromSuperview];
        [_pollTime invalidate];
        if (orderDetail == nil) {
            return;
        }
        //抢单时间
        NSString *grabTime=[_dialogInfoDic objectForKey:@"rushTime"];
        NSString *ssTime=[NSString stringWithFormat:@"%d",[grabTime intValue]%60];
        NSString *mmTime=[NSString stringWithFormat:@"%d",([grabTime intValue]/60)%60];
        
        _grabTimeLabel.text=[NSString stringWithFormat:@"抢单时间%@分%@秒",mmTime,ssTime];
        
        //超市的头像 img
        NSURL *imageUrl=[NSURL URLWithString:[_dialogInfoDic objectForKey:@"img"]];
        self.supermarketImgView.layer.cornerRadius = 48/2;
        [self.supermarketImgView setImageWithURL:imageUrl placeholderImage:UIIMAGE(@"ShopImage.png")];
        [self.supermarketImgView setBackgroundColor:[UIColor clearColor]];
        
        _supermarketNameLabel.text=[_dialogInfoDic objectForKey:@"name"];//超市名称 isCheck
        
        NSString *finishOrder=[_dialogInfoDic objectForKey:@"finishOrder"];//已完成的订单量
        _completedOrderNumLabel.text=[NSString stringWithFormat:@"已完成%@单",finishOrder];
        
        NSString *isCheck=[_dialogInfoDic objectForKey:@"isCheck"];//0:未认证  1:已认证
        if ([isCheck intValue]==0) {
            _checkImgView.hidden=YES;
        }
        else if ([isCheck intValue]==1){
            _checkImgView.hidden=NO;
        }
        
        [_timer invalidate];
        payTimeNum = 3;
        _timer= [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(countDownToPayView)
                                                 userInfo:nil
                                                  repeats:YES];
        [self showTipOrSuccessView:0];
    }else{
        
        [SRMessage infoMessage:[_pollDic objectForKey:@"msg"] delegate:self];
        
    }
}
/**
 * Method name: countDownToPayView
 * Description: 跳转支付页面倒计时
 */
-(void)countDownToPayView{
    
    if (payTimeNum==0) {
        [_timer invalidate];
        [self jumpToPayView];
        self.promptPayLabel.text=@"自动跳转至支付页面0秒";
    }
    else{
        self.promptPayLabel.text=[NSString stringWithFormat:@"自动跳转至支付页面%d秒",payTimeNum];
        payTimeNum--;
    }
}
//跳转支付页面
-(void)jumpToPayView{
    [self.successView removeFromSuperview];
    OrderPayController*orderPayControll=[[OrderPayController alloc]initWithNibName:@"OrderPayController" bundle:nil];
    orderPayControll.secKill = self.secKill;
    orderPayControll.presell = self.presell;
    orderPayControll.homePush = self.homePush;
    orderPayControll.orderNum=self.orderNum;
    [self.navigationController pushViewController:orderPayControll animated:YES];
}

#pragma mark - 打赏
//点击打赏显示小费界面
- (void)showTipViewTouch:(id)sender {
    //0:白天(不能自定义小费金额)  1:晚上(可以自定义小费金额)
    int isSetFlag=[[_dialogInfoDic objectForKey:@"isSet"] intValue];
    if (isSetFlag==0) {
        [self showTipOrSuccessView:1];
    }
    else if (isSetFlag==1){
         [self showTipOrSuccessView:2];
    }
}
/**设置打赏，轮循成功的弹框*/
-(void)setLayerOut
{
    //自定义alertView
    _myAlertView.layer.cornerRadius = 10;
    _myAlertView.layer.shadowRadius = 10;
    _myAlertView.layer.shadowColor = [UIColor blackColor].CGColor;
    _myAlertView.layer.shadowOpacity = 0.7;

    _bgView.frame = CGRectMake(0, 0, viewWidth, self.view.frame.size.height);
    
    
    [self circleView:self.dayAlertTipView sizeHeight:10*2 borderColor:[UIColor clearColor] borderWidth:0.0f];
    [self circleView:self.nightAlertTipView sizeHeight:10*2 borderColor:[UIColor clearColor] borderWidth:0.0f];
    //被抢单后的view
    [self circleView:self.supermarketImgView sizeHeight:48 borderColor:[UIColor clearColor] borderWidth:0.0f];
    
    //初始化白天小费界面元素
    [self circleView:_dayCancelBtn sizeHeight:48 borderColor:[UIColor_HEX colorWithHexString:@"#999999"] borderWidth:1.0f];
    [self circleView:_dayExceptionalBtn sizeHeight:48 borderColor:[UIColor clearColor] borderWidth:0.0f];
    //夜晚
    [self circleView:_nightExcepBtn sizeHeight:48 borderColor:[UIColor clearColor] borderWidth:1.0f];
    [self circleView:_nightCancelBtn sizeHeight:48 borderColor:[UIColor_HEX colorWithHexString:@"#999999"] borderWidth:2.0f];
    _bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    cancelReasoniew = _bgView;
    
    _successView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    _dayTipView.backgroundColor= [[UIColor blackColor]colorWithAlphaComponent:0.5];
    _nightTipView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    [_dayExceptionalBtn setTag:TAG_DAY_EXCEPTBTN];
    [_nightExcepBtn setTag:TAG_NIGHT_EXCEPTBTN];
    [self.moneyTextField addTarget:self action:@selector(moneyTextFieldValueChanged) forControlEvents:UIControlEventAllEditingEvents];
}
/**显示弹框 0 为 被抢 1 非自定义打赏 2 为自定义打赏*/
-(void)showTipOrSuccessView:(NSInteger)tag
{
    [self.dayTipView removeFromSuperview];
    [self.nightTipView removeFromSuperview];
    
    [self myAlertViewHidden];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (tag) {
        case 0:
            _successView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
            [window addSubview:_successView];
            break;
        case 1:
            _dayTipView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
            [window addSubview:_dayTipView];
            break;
        case 2:
            _nightTipView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
            [window addSubview:_nightTipView];
            if (_tipAmount > 0) {
                self.nightExcepBtn.enabled = YES;
                self.nightExcepBtn.backgroundColor = [UIColor colorWithRed:0.937 green:0.400 blue:0.357 alpha:1.000];
            }else{
                self.nightExcepBtn.enabled = NO;
                self.nightExcepBtn.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
            }
           
            break;
        default:
            break;
    }
}

//设置小费金额
-(void)setTipValueWithArray:(NSArray *)tipArray{
    
    int index=0;
    NSString *isSet = [_dialogInfoDic objectForKey:@"isSet"];
    if ([isSet integerValue] == 1) {
        for (id view in self.nightAlertTipView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                if (index>=[tipArray count]) {
                    return;
                }
                UIButton *btn=(UIButton *)view;
                NSString *btnTitle=[NSString stringWithFormat:@"%@元",[tipArray objectAtIndex:btn.tag]];
                [btn setTitle:btnTitle forState:UIControlStateNormal];
                [btn setTitle:btnTitle forState:UIControlStateHighlighted];
                index++;
            }
        }
    }
    else
    {
        for (id view in self.dayAlertTipView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                if (index>=[tipArray count]) {
                    return;
                }
                UIButton *btn=(UIButton *)view;
                NSString *btnTitle=[NSString stringWithFormat:@"%@元",[tipArray objectAtIndex:index]];
                [btn setTitle:btnTitle forState:UIControlStateNormal];
                [btn setTitle:btnTitle forState:UIControlStateHighlighted];
                
                index++;
            }
        }
    }
}

//选择小费点击事件
-(IBAction)choseATipToExceptional:(UIButton*)sender{
    
    NSArray *viewsArray=[NSArray array];
    //0:白天(不能自定义小费金额)  1:晚上(可以自定义小费金额)
    int isSetFlag=[[_dialogInfoDic objectForKey:@"isSet"] intValue];
    
    if (isSetFlag==0) {
        viewsArray=self.dayAlertTipView.subviews;
    }
    else if (isSetFlag==1){
        viewsArray=self.nightAlertTipView.subviews;
    }
    for (id view in viewsArray) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)view;
            btn.selected=NO;
        }
    }
    [sender setSelected:YES];
    self.selectedButton = sender;
    [self.moneyTextField resignFirstResponder];
    
    NSString*btnText= sender.titleLabel.text;
    DLog(@"选择钱数------->%@",btnText);
    NSString *btnMoney = [btnText componentsSeparatedByString:@"元"][0];
    int meony=[btnMoney intValue];
    _tipAmount=meony;
    self.nightExcepBtn.enabled = YES;
    self.nightExcepBtn.backgroundColor = [UIColor colorWithRed:0.937 green:0.400 blue:0.357 alpha:1.000];
    //选项金额后填写金额隐藏
    _selfHelpBtn.hidden=NO;
    _moneyTextField.hidden=YES;
    [_moneyTextField resignFirstResponder];
    _inputTipLabel.hidden=YES;
    _moneyTextField.text = @"";
}

//自己填点击事件
- (IBAction)selfHelpTouch:(id)sender {
    
    for (id view in self.nightAlertTipView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)view;
            btn.selected=NO;
        }
    }
    _selfHelpBtn.hidden=YES;
    _moneyTextField.hidden=NO;
    [_moneyTextField becomeFirstResponder];
    _inputTipLabel.hidden=NO;
    _tipAmount=[_moneyTextField.text intValue];
}

//取消打赏
- (IBAction)cancelTipView:(id)sender {

    _moneyTextField.text = nil;
    [self.dayTipView removeFromSuperview];
    [self.nightTipView removeFromSuperview];
    _selfHelpBtn.hidden=NO;
    _moneyTextField.hidden=YES;
    OrderDetailHeaderCell * cell = [self.orderDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[CommClass sharedCommon] localObject:@"YES" forKey:self.orderNum];
    [cell showTipBtn:orderDetail ifshow:YES shengTime:shengTime];
    [_moneyTextField resignFirstResponder];
}
#pragma -mark  ---------------->打赏接口
- (IBAction)exceptionalTip:(id)sender {
    

    [_moneyTextField resignFirstResponder];
    if ([_moneyTextField.text integerValue] > 0 ) {
        _tipAmount = [_moneyTextField.text intValue];
    }
    
    if (_tipAmount == 0) {
    
        [self.nightTipView removeFromSuperview];
        [SRMessage infoMessage:@"最少打赏一元" delegate:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipOrSuccessView:2];
        });
        self.moneyTextField.text = @"";
        return;
    }else if (_tipAmount > 999)
    {
        [self.nightTipView removeFromSuperview];
        [SRMessage infoMessage:@"最多打赏999元" delegate:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipOrSuccessView:2];
        });
        return;
    }
    [super showHUD];
    NSString *tipAmountStr=[NSString stringWithFormat:@"%d",_tipAmount];
    
    NSDictionary *paramsDic=@{@"orderNo":self.orderNum,
                              @"tip":tipAmountStr};
    
    [_cloudClient requestMethodWithMod:@"order/tip"
                                params:nil
                            postParams:paramsDic
                              delegate:self
                              selector:@selector(exceptionalSuccess:)
                         errorSelector:@selector(exceptionalFail:)
                      progressSelector:nil];
}

-(void)exceptionalSuccess:(NSDictionary*)response{
    [super hidenHUD];
    [_dayTipView removeFromSuperview];
    [_nightTipView removeFromSuperview];
    orderDetail.tipPrice = _tipAmount;
//    OrderDetailHeaderCell * cell = [self.orderDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [cell showTipBtn:orderDetail ifshow:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.orderNum];
//    OrderDetailInfoCell * cell1 = [self.orderDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:orderDetail.goodsList.count+1 inSection:2]];
//    cell1.pingtaiPrice.text = [NSString stringWithFormat:@"￥%.2f",orderDetail.tipPrice];
    [self getOrderDetail];
    [SRMessage infoMessage:@"打赏成功" delegate:self];
   
}
-(void)exceptionalFail:(NSDictionary*)response{
    
    [super hidenHUD];
    [SRMessage infoMessage:@"打赏失败" delegate:self];
}


- (void)moneyTextFieldValueChanged
{
    if ([DataCheck isValidString:self.moneyTextField.text])
    {
        if ([self.moneyTextField.text integerValue] > 0) {
            self.nightExcepBtn.enabled = YES;
            self.nightExcepBtn.backgroundColor = [UIColor colorWithRed:0.937 green:0.400 blue:0.357 alpha:1.000];
        }else{
            self.nightExcepBtn.enabled = NO;
            self.nightExcepBtn.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
        }
        if (self.moneyTextField.text.length >3) {
            self.moneyTextField.text = [self.moneyTextField.text substringToIndex:3];
            [self.moneyTextField resignFirstResponder];
            return;
        }
    
    }else{
        self.nightExcepBtn.enabled = NO;
        self.nightExcepBtn.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    }
    
}

- (IBAction)clickCloseTextFieldAction:(id)sender {
    [_moneyTextField resignFirstResponder];
}
//返回
- (IBAction)backBtnAction:(id)sender {
    [self backAction:nil];
}
#pragma mark - 点评事件
- (IBAction)dianPingBtnAction:(UIButton *)sender {
    if (orderDetail.yushou == 1) {
        /**无现货商品点评*/
        EvaluteNoPhysicObjectViewController * evaluteNoPhysicObjectVC = [[EvaluteNoPhysicObjectViewController alloc]init];
        evaluteNoPhysicObjectVC.orderNum = orderDetail.orderNo;
        evaluteNoPhysicObjectVC.checkOutEvalute = NO;
        [self.navigationController pushViewController:evaluteNoPhysicObjectVC animated:YES];
    }else{
        dianping = YES;
        EvaluateViewController *evaluation = [[EvaluateViewController alloc] init];
        evaluation.orderNum = orderDetail.orderNo;
        evaluation.type = @"2";
        evaluation.indexNum = 1;
        [self.navigationController pushViewController:evaluation animated:YES];
    }

}

- (IBAction)confirmAction:(id)sender {
    [SRMessage infoMessage:@"您选购的商品已到达了吗？" block:^{
        [self confirmGoodsRequest:orderDetail.orderNo];
    }];
}

-(void)timeOutAction {
    [self cancleOrderRequest];
}
- (IBAction)callPhoneAction:(id)sender {
    [SRMessage infoMessage:[NSString stringWithFormat:@"是否拨打客服电话？"] block:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"13310953123"]]];
    }];
}

@end
