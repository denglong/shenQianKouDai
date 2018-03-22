
//
//  OrderPayController.m
//  KingProFrame
//
//  Created by denglong on 7/29/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "OrderPayController.h"
#import "PayTimeCell.h"
#import "HeaderCell.h"
#import "MiddleCell.h"
#import "WeChatPayController.h"
#import "AlipayController.h"
#import "ShopDetailsController.h"
#import "ShopCartController.h"
#import "TabBarController.h"
#import "MyOrderController.h"
#import "GeneralShowWebView.h"
#import "HomeViewController.h"
#import "BusinessInfoViewController.h"
@interface OrderPayController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, reloadDelegate>
{
    NSInteger           indexTag;            /**<选择的支付方式，2微信支付，3支付宝支付*/
    NSMutableArray    *myBtns;              /**<保存之前选择的支付方式btn*/
    NSInteger           secondsContDown;   /**<倒计时时间*/
    NSTimer             *countDownTimer;   /**<倒计时timer*/
    CloudClient        *client;             /**<网络请求类*/
    BOOL                 toPay;              /**<是否跳转支付*/
    NSDictionary       *respData;
    UIView               *noNetWork;
}

@end

@implementation OrderPayController
@synthesize myTableView, orderNum, inPageNum;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [countDownTimer invalidate];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    [self getPayOrderData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付订单";
    myBtns = [NSMutableArray array];
    
    client = [CloudClient getInstance];
    indexTag = 2;
     myBtns = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi) name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wePayAlipaySuccessed) name:@"ALIPAYSESSUED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wePayAlipaySuccessed) name:@"ALIPAYFILED" object:nil];
    
    if (inPageNum == 1) {
        self.navigationItem.leftBarButtonItem = [self createLeftItem:self itemStr:nil itemImage:UIIMAGE(@"back.png") itemImageHG:nil selector:@selector(shopBackAction)];
    }
}

- (void)shopBackAction {
    [self backAction:nil];
}

//MARK: - 返回处理方法
-(void)backAction:(id)sender {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 0;
            break;
        case 4:
            return 4;;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section == 0) {
        
        PayTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PayTimeCell" owner:self options:nil];
            cell = [views objectAtIndex:0];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellStyleDefault;
        }
        
        [cell timeDown:secondsContDown];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        
        HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HeaderCell" owner:self options:nil];
            cell = [views objectAtIndex:0];
            cell.selectionStyle = UITableViewCellStyleDefault;
        }
        
        NSURL * url = [NSURL URLWithString:[respData objectForKey:@"imgUrl"]];
        [cell.headerImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ShopImage"]];
        [cell.shopName setTitle:[NSString stringWithFormat:@"%@", [respData objectForKey:@"name"]] forState:UIControlStateDisabled];
        cell.totalNum.text = [NSString stringWithFormat:@"已完成%@单", [respData objectForKey:@"finishOrder"]];
        
        return cell;
    }
    else
    {
        MiddleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MiddleCell" owner:self options:nil];
            cell = [views objectAtIndex:0];
            cell.selectionStyle = UITableViewCellStyleDefault;
        }
        
        if (indexPath.section == 2 || indexPath.section == 3) {
            cell.leftName.hidden = NO;
            cell.moneyNum.hidden = NO;
            
            if (indexPath.section == 2) {
                switch (indexPath.row) {
                    case 0:
                        cell.leftName.text = [NSString stringWithFormat:@"订单编号：%@", orderNum];
                        cell.moneyNum.hidden = YES;
                        cell.headerLine.hidden = YES;
                        break;
                    case 1:
                        cell.leftName.text = @"订单金额";
                        cell.moneyNum.text = [NSString stringWithFormat:@"￥%.2f", [[respData objectForKey:@"totalPrice"] floatValue]];
                        break;
                    case 2:
                        cell.leftName.text = @"优惠券";
                        cell.moneyNum.text = [NSString stringWithFormat:@"-￥%.2f", [[respData objectForKey:@"couponPrice"] floatValue]];
                        if ([cell.moneyNum.text isEqualToString:@"-￥0"]) {
                            cell.moneyNum.text = @"￥0.00";
                        }
                        break;
                    case 3:
                        cell.leftName.text = @"配送费";
                        cell.moneyNum.text = [NSString stringWithFormat:@"￥%.2f", [[respData objectForKey:@"expressPrice"] floatValue]];
                        if ([cell.moneyNum.text isEqualToString:@"￥0"]) {
                            cell.moneyNum.text = @"￥0.00";
                            cell.moneyNum.textColor = [UIColor lightGrayColor];
                        }
                        break;
                    case 4:
                        cell.leftName.text = @"小费";
                        cell.moneyNum.text = [NSString stringWithFormat:@"￥%.2f", [[respData objectForKey:@"tipPrice"] floatValue]];
                        if ([cell.moneyNum.text isEqualToString:@"￥0"]) {
                            cell.moneyNum.text = @"￥0.00";
                            cell.moneyNum.textColor = [UIColor lightGrayColor];
                        }
                        break;
                    default:
                        break;
                }
            }
            else
            {
                cell.leftName.text = @"还需支付";
                cell.moneyNum.textColor = [UIColor redColor];
                cell.moneyNum.text = [NSString stringWithFormat:@"￥%.2f", [[respData objectForKey:@"payPrice"] floatValue]];
                cell.headerLine.hidden = YES;
            }
        }
        else
        {
            switch (indexPath.row) {
                case 0:
                    cell.leftName.hidden = NO;
                    cell.headerLine.hidden = YES;
                    cell.leftName.text = @"选择支付方式";
                    cell.backgroundColor = self.view.backgroundColor;
                    break;
                case 1:
                    cell.leftImage.hidden = NO;
                    cell.leftImage.image = [UIImage imageNamed:@"icon_weiPay"];
                    cell.payName.hidden = NO;
                    cell.rightBtn.hidden = NO;
                    if (indexTag == 2) {
                        cell.rightBtn.selected = YES;
                    }
                    else
                    {
                        cell.rightBtn.selected = NO;
                    }
                    cell.payName.text = @"微信支付";
                    cell.rightBtn.tag = 2;
                    [myBtns setObject:cell.rightBtn atIndexedSubscript:0];
//                    cell.frame = CGRectMake(0, 0, 0, 0);
                    [cell.rightBtn addTarget:self action:@selector(payMethod:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 2:
                    cell.leftImage.hidden = NO;
                    cell.leftImage.image = [UIImage imageNamed:@"icon_aliPay"];
                    cell.payName.hidden = NO;
                    if (indexTag == 3) {
                        cell.rightBtn.selected = YES;
                    }
                    else
                    {
                        cell.rightBtn.selected = NO;
                    }
                    cell.rightBtn.hidden = NO;
                    cell.payName.text = @"支付宝支付";
                    cell.rightBtn.tag = 3;
                    [myBtns setObject:cell.rightBtn atIndexedSubscript:1];
                    
                    [cell.rightBtn addTarget:self action:@selector(payMethod:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 3:
                {
                    cell.headerLine.hidden = YES;
                    cell.frame = CGRectMake(0, 0, viewWidth, 100);
                    cell.backgroundColor = [UIColor clearColor];
                    
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, viewWidth - 20, 40)];
                    payBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#25BCFC"];
                    NSString *str = [NSString stringWithFormat:@"确认支付 ￥%.2f", [[respData objectForKey:@"totalPrice"] floatValue]];
                    [payBtn setTitle:str forState:UIControlStateNormal];
                    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    payBtn.layer.cornerRadius = 4;
                    [payBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:payBtn];
                    
                    UILabel *lestLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, viewWidth, 15)];
                    lestLab.textAlignment = NSTextAlignmentCenter;
                    lestLab.textColor = RGBACOLOR(153, 153, 153, 1);
                    lestLab.font = [UIFont systemFontOfSize:12];
//                    lestLab.text = @"平台代收款项，您确认收货后方可转账给店主";
                    [cell.contentView addSubview:lestLab];
                }
                    break;
                default:
                    break;
            }
            
        }
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView           = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    footView.frame = CGRectMake(0, 0, viewWidth, 10);
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 1) {
//        ShopDetailsController *shopDetail = [[ShopDetailsController alloc] init];
//        shopDetail.shopId = [respData objectForKey:@"shopId"];
//        [self.navigationController pushViewController:shopDetail animated:YES];
        BusinessInfoViewController * businessInfoViewcontroller = [[BusinessInfoViewController alloc]init];
        //              businessInfoViewcontroller.comePageTag = -100;
        NSString *str = [NSString stringWithFormat:@"%@", [respData objectForKey:@"shopId"]];
        businessInfoViewcontroller.shopId = str;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:businessInfoViewcontroller animated:YES];
    }
}

/**
 * Method name: payMethod
 * MARK: - 选择支付方式
 * Parameter: sender
 */
- (void)payMethod:(UIButton *)sender {
    
    if (secondsContDown == 0) {
        return;
    }
    
    if (sender.tag == 2) {
        indexTag = 2;
    }
    else
    {
        indexTag = 3;
    }
    sender.selected = YES;
    
    [myTableView reloadData];
}

/**
 * Method name: payBtnAction
 * MARK: - 支付跳转方法
 * Parameter: sender
 */
- (void)payBtnAction:(UIButton *)sender {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    [self getServicesPayInfo];
    
/*----------------v302前支付---------------------------------------
    if (indexTag == 2) {
        WeChatPayController *weChatPay = [WeChatPayController sharedManager];
        weChatPay.orderNum = [NSString stringWithFormat:@"%@", [respData objectForKey:@"orderNo"]];
        weChatPay.ORDER_NAME = [NSString stringWithFormat:@"%@", [respData objectForKey:@"orderName"]];
        weChatPay.ORDER_PRICE = [NSString stringWithFormat:@"%.0f", [[respData objectForKey:@"payPrice"] floatValue] * 100];
        [weChatPay weChatPayAction];
    }
    else if (indexTag == 3) {
        AlipayController *alipay = [AlipayController sharedManager];
        alipay.orderNum = [NSString stringWithFormat:@"%@", [respData objectForKey:@"orderNo"]];
        alipay.productName= [NSString stringWithFormat:@"%@", [respData objectForKey:@"orderName"]];
        alipay.amount = [NSString stringWithFormat:@"%@", [respData objectForKey:@"payPrice"]];
        [alipay alipayAction];
    }
    
    toPay = YES;
// ------------------v302前支付-----------------------------------*/
}

/**
 * Method name: downTimer
 * Description: 倒计时方法
 * Parameter: 无
 * Parameter: 无
 */
- (void)downTimer {
    if (countDownTimer == nil) {
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    }
}

- (void)timeFireMethod {
    if(secondsContDown==0){
        [countDownTimer invalidate];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示！" message:@"支付订单已超时！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        secondsContDown--;
    }
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.secKill == YES || self.presell == YES) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[GeneralShowWebView class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//后台进入前台通知调用方法
- (void)tongzhi {
    if (toPay == NO) {
        if (orderNum) {
            [self getPayOrderData];
        }
    }
}

//微信支付支付成功通知回调方法
- (void)paySuccesd {
    [countDownTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: - 无网页面方法
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
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
    [self getPayOrderData];
}

/**
 * Method name: getPayOrderData
 * MARK: -  订单支付页面请求处理方法
 */
- (void)getPayOrderData {
    if ([self noNetwork]) {
        return;
    }
    
    if (![DataCheck isValidString:orderNum]) {
        return;
    }
    
    [client requestMethodWithMod:@"order/pay"
                          params:nil
                      postParams:@{@"orderNo":orderNum}
                        delegate:self
                        selector:@selector(getPayOrderDataSuccessed:)
                   errorSelector:@selector(getPayOrderDatafiled:)
                progressSelector:nil];
}

- (void)getPayOrderDataSuccessed:(NSDictionary *)response {
    DLog(@"%@", response);
    if ([DataCheck isValidDictionary:response]) {
        respData = response;
        
        secondsContDown = [[respData objectForKey:@"surPayTime"] integerValue];
       [self downTimer];
    }
    
    myTableView.hidden = NO;
    [myTableView reloadData];
}

- (void)getPayOrderDatafiled:(NSDictionary *)response {
    
}

/**
 * Method name: getPayOrderData
 * MARK: -  支付请求后台服务处理方法
 */
- (void)getServicesPayInfo {
    
    //type:1.支付宝，2.微信，phoneType:1.android,2.ios
    NSInteger type = 0;
    if (indexTag == 3) {
        type = 1;
    }
    else if (indexTag == 2) {
        type = 2;
    }
    NSString *typeNumber = [NSString stringWithFormat:@"%ld", (long)type];
    NSDictionary *params = @{@"orderNo":orderNum, @"type":typeNumber, @"phoneType":@"2"};
    
    [client requestMethodWithMod:@"order/prepay"
                          params:nil
                      postParams:params
                        delegate:self
                        selector:@selector(getServicesPayInfoSuccessed:)
                   errorSelector:@selector(getServicesPayInfofiled:)
                progressSelector:nil];
}

- (void)getServicesPayInfoSuccessed:(NSDictionary *)response {
    DLog(@"%@", response);
    if ([DataCheck isValidDictionary:response]) {
        if (indexTag == 2) {
            if ([WXApi isWXAppSupportApi]) {
                WeChatPayController *weChatPay = [WeChatPayController sharedManager];
                weChatPay.serviceDict = response;
                [weChatPay weChatServicesPayAction];
                
                [[CommClass sharedCommon] setObject:@"2" forKey:@"PAYTYPE"];
                [countDownTimer invalidate];
            }
            else
            {
                [SRMessage infoMessage:@"尚未安装微信" delegate:self];
            }
        }
        else if (indexTag == 3) {
            AlipayController *alipay = [AlipayController sharedManager];
            alipay.myOrderString = [response objectForKey:@"alidata"];
            [alipay alipayServicesPayAction];
            
            [[CommClass sharedCommon] setObject:@"2" forKey:@"PAYTYPE"];
            [countDownTimer invalidate];
        }
        
        toPay = YES;
    }
}

- (void)getServicesPayInfofiled:(NSDictionary *)response {

}

//微信支付宝回调
- (void)wePayAlipaySuccessed {
    //type:1.支付宝，2.微信，phoneType:1.android,2.ios
    NSInteger type = 0;
    if (indexTag == 3) {
        type = 1;
    }
    else if (indexTag == 2) {
        type = 2;
    }
    NSString *typeNumber = [NSString stringWithFormat:@"%ld", (long)type];
    
    [client requestMethodWithMod:@"order/checkpay"
                          params:nil
                      postParams:@{@"orderNo":orderNum, @"type":typeNumber, @"phoneType":@"2"}
                        delegate:self
                        selector:@selector(getWePayAlipaySuccessed:)
                   errorSelector:@selector(getWePayAlipayfiled:)
                progressSelector:nil];
}

- (void)getWePayAlipaySuccessed:(NSDictionary *)response {
    DLog(@"回调成功");
    [self wePayAlipayBack];
}

- (void)getWePayAlipayfiled:(NSDictionary *)response {

    NSLog(@"%@", response);
    NSLog(@"%@", [response objectForKey:@"msg"]);
    [self wePayAlipayBack];
}

- (void)wePayAlipayBack {
    
    if (inPageNum == 1 || self.secKill == YES || self.homePush == YES) {
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[GeneralShowWebView class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
            if ([controller isKindOfClass:[HomeViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
