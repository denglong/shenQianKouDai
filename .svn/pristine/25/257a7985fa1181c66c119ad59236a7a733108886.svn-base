//
//  VipPrivilegeController.m
//  KingProFrame
//
//  Created by meyki on 11/29/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "VipPrivilegeController.h"
#import "VipPrivilegeHeaderCell.h"
#import "VipPrivilegeCell.h"
#import "AlipayController.h"
#import "WeChatPayController.h"
#import "VipPayView.h"

/** 头部高度 */
static NSInteger const HeaderViewHeight = 354;

@interface VipPrivilegeController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *vipTableView;
@property (nonatomic, strong) CloudClient *client;
@property (nonatomic, strong) NSDictionary *vipData;
@property (nonatomic, strong) MyInfoModel *model;
@property (nonatomic, copy)   NSString *cardId;
@property (nonatomic, strong) VipPayView *vipPay;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy)   NSString *cardNo;//会员支付单号
/** 1是支付宝支付，2是微信支付 */
@property (nonatomic, copy)   NSString *integerTag;

@end

@implementation VipPrivilegeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连城会员";
    
    self.model = [MyInfoModel sharedInstance];
    self.navigationController.navigationBarHidden = YES;
    _client = [CloudClient getInstance];
    
    [self createVipPrivilegeTableView];
    [self createVipPayViewAction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wePayAlipaySuccessed) name:@"ALIPAYSESSUED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wePayAlipaySuccessed) name:@"ALIPAYFILED" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getVipPrivilegeData];
    if ([self.model.userType integerValue] == 0) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self createNavigationAction];
    }
}

#pragma mark - 创建支付view方法
- (void)createVipPayViewAction {
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height)];
    self.bgView.backgroundColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.3];
    [self.view addSubview:_bgView];
    self.bgView.hidden = YES;
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.bgView addGestureRecognizer:singleRecognizer];
    
    self.vipPay = [[NSBundle mainBundle] loadNibNamed:@"VipPayView" owner:nil options:nil].firstObject;
    self.vipPay.frame = CGRectMake(0, self.view.frame.size.height, viewWidth, 130);
    [self.view addSubview:self.vipPay];
    [self.vipPay.alipayBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vipPay.wePayBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击背景隐藏支付view
- (void)handlePanFrom:(UIGestureRecognizer *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.vipPay.frame = CGRectMake(0, self.view.frame.size.height, viewWidth, 130);
    } completion:^(BOOL finished) {
        self.bgView.hidden = YES;
    }];
}

#pragma mark - 显示支付View
- (void)showPayViewAction {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.vipPay.frame = CGRectMake(0, self.view.frame.size.height-130, viewWidth, 130);
        self.bgView.hidden = NO;
    }];
}

#pragma mark - 创建导航栏
- (void)createNavigationAction {
    
    UIView *navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE(@"myPageHeaderImg")];
    [self.view addSubview:navigationView];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:UIIMAGE(@"icon_back") forState:UIControlStateNormal];
    [navigationView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(clickBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor_HEX colorWithHexString:@"FFFFFF"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.text = @"连城会员";
    [navigationView addSubview:titleLab];
    
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.equalTo(@(64));
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(navigationView).with.offset(26);
        make.left.equalTo(navigationView).with.offset(15);
        make.width.equalTo(@20);
        make.height.equalTo(@36);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(navigationView).with.offset(26);
        make.centerX.equalTo(navigationView.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@36);
    }];
}

- (void)clickBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建会员特权TableView
- (void)createVipPrivilegeTableView {
    
    UITableView *myTableView = [[UITableView alloc] init];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = self.view.backgroundColor;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    self.vipTableView = myTableView;
    
    self.vipTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(44, 0, 0, 0);
    if ([self.model.userType integerValue] == 0) {
        edge = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view).insets(edge);
    }];
    
    [self.vipTableView registerNib:[UINib nibWithNibName:@"VipPrivilegeCell" bundle:nil] forCellReuseIdentifier:@"VipPrivilegeCell"];
    
    [self.vipTableView registerNib:[UINib nibWithNibName:@"VipPrivilegeHeaderCell" bundle:nil] forCellReuseIdentifier:@"VipPrivilegeHeaderCell"];
}

#pragma mark - TableViewDelegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    NSArray *dataArr = self.vipData[@"cards"];
    return dataArr.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 10)];
    footerView.backgroundColor = self.view.backgroundColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.model.userType integerValue] == 0) {
            return HeaderViewHeight-131;
        }
        return HeaderViewHeight;
    }
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        VipPrivilegeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipPrivilegeHeaderCell"];
        cell.backgroundColor = self.view.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell showOrHiddenHeader:self.vipData];
        
        return cell;
    }
    else
    {
        VipPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipPrivilegeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.buyButton.tag = indexPath.row-1;
        
        cell.buyButton.hidden = NO;
        if (indexPath.row == 0) {
            
            cell.infoLabel.text = @"开通会员";
            cell.buyButton.hidden = YES;
        }
        else
        {
            NSArray *dataArr = self.vipData[@"cards"];
            NSDictionary *dic = dataArr[indexPath.row - 1];
            cell.infoLabel.text = [NSString stringWithFormat:@"%@个月 ￥%@", dic[@"month"], dic[@"price"]];
        }
        
//        if (indexPath.row == 3) {
//            
//            cell.bottomLine.hidden = YES;
//        }
//        else
//        {
            cell.bottomLine.hidden = NO;
//        }
        
        [cell.buyButton addTarget:self action:@selector(buyVipAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)buyVipAction:(UIButton *)sender
{
    NSLog(@"%zd", sender.tag);
    NSArray *dataArr = self.vipData[@"cards"];
    NSDictionary *dic = dataArr[sender.tag];
    self.cardId = dic[@"id"];
    
    [self showPayViewAction];
}

#pragma mark - 获取会员列表接口
- (void)getVipPrivilegeData {
    
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        [super hidenHUD];
        return;
    }
    [_client requestMethodWithMod:@"card/cardRules"
                                params:nil
                            postParams:nil
                              delegate:self
                              selector:@selector(getVipPrivilegeDataSuccessed:)
                         errorSelector:@selector(getVipPrivilegeDataError:)
                      progressSelector:nil];
}

- (void)getVipPrivilegeDataSuccessed:(NSDictionary *)response {
    
    self.vipData = response;
    [self.vipTableView reloadData];
    
    NSString *userType = self.vipData[@"userType"];
    if ([userType integerValue] == 0) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self createNavigationAction];
    }
}

- (void)getVipPrivilegeDataError:(NSDictionary *)response {
    
}

#pragma mark - 支付选择处理事件
- (void)payBtnAction:(UIButton *)sender {
    if (sender.tag == 0) {
        self.integerTag = @"1";
        
    }
    else
    {
        self.integerTag = @"2";
    }
    
    [self payVipPrivilegeRequest];
    [self handlePanFrom:nil];
}

#pragma mark - 支付宝支付签名接口
- (void)payVipPrivilegeRequest {
    
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        [super hidenHUD];
        return;
    }
    
    NSDictionary *params = @{@"cardId":self.cardId, @"phoneType":@"2", @"type":self.integerTag};
    [_client requestMethodWithMod:@"card/prepay"
                           params:nil
                       postParams:params
                         delegate:self
                         selector:@selector(payVipPrivilegeDataSuccessed:)
                    errorSelector:@selector(payVipPrivilegeDataError:)
                 progressSelector:nil];
}

- (void)payVipPrivilegeDataSuccessed:(NSDictionary *)response {
    
    if ([self.integerTag integerValue] == 1) {
        
        NSArray *array = [response[@"alidata"] componentsSeparatedByString:@"out_trade_no=\""];
        NSArray *lastArr = [array.lastObject componentsSeparatedByString:@"\"&subject"];
        self.cardNo = lastArr.firstObject;
        
        AlipayController *alipay = [AlipayController sharedManager];
        alipay.myOrderString = [response objectForKey:@"alidata"];
        [alipay alipayServicesPayAction];
        
        [[CommClass sharedCommon] setObject:@"2" forKey:@"PAYTYPE"];
    }
    else
    {
        self.cardNo = response[@"cardNo"];
        if ([WXApi isWXAppSupportApi]) {
            WeChatPayController *weChatPay = [WeChatPayController sharedManager];
            weChatPay.serviceDict = response;
            [weChatPay weChatServicesPayAction];
            
            [[CommClass sharedCommon] setObject:@"2" forKey:@"PAYTYPE"];
        }
        else
        {
            [SRMessage infoMessage:@"尚未安装微信" delegate:self];
        }
    }
}

- (void)payVipPrivilegeDataError:(NSDictionary *)response {
    
}

- (void)wePayAlipaySuccessed {
    
    //type:1.支付宝，2.微信，phoneType:1.android,2.ios
    [_client requestMethodWithMod:@"card/checkpay"
                          params:nil
                      postParams:@{@"cardNo":self.cardNo, @"cardId":self.cardId, @"type":self.integerTag, @"phoneType":@"2"}
                        delegate:self
                        selector:@selector(getWePayAlipaySuccessed:)
                   errorSelector:@selector(getWePayAlipayfiled:)
                progressSelector:nil];
}

- (void)getWePayAlipaySuccessed:(NSDictionary *)response {
    DLog(@"回调成功");
    [self.navigationController popViewControllerAnimated:YES];
    [SRMessage infoMessage:@"支付成功" delegate:self];
}

- (void)getWePayAlipayfiled:(NSDictionary *)response {
    
    NSLog(@"%@", response);
    NSLog(@"%@", [response objectForKey:@"msg"]);
}

@end
