//
//  BusinessOrderController.m
//  KingProFrame
//
//  Created by denglong on 7/31/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "BusinessOrderController.h"
#import "TheOrderCell.h"
#import "BusinessOrderCell.h"
#import "OrderDetailController.h"
#import "BusinessOrderModel.h"
#import "TheOrderRespModel.h"
#import "OrderDetailViewController.h"
#import "EvaluationViewController.h"

@interface BusinessOrderController ()<UITextFieldDelegate, UIScrollViewDelegate, UIAlertViewDelegate, reloadDelegate>
{
    NSMutableArray          *myBtns;                 /**<顶部btn数组*/
    NSMutableArray          *lineViews;             /**<底部btn下线*/
    UIView                    *headerView;            /**<顶部view*/
    NSInteger                statusNum;               /**<请求商家我的订单类型，4：待处理，5：已完成，6：待评价*/
    NSInteger                stateNum;                /**<附近订单和我的订单状态，0：附近订单，1：我的订单*/
    CloudClient              *client;
    UITextField              *myField;               /**<验证码输入框*/
    BusinessOrderModel     *bOrderResp;            /**<附近订单数据model*/
    TheOrderRespModel       *orderResp;            /**<我的订单数据model*/
    UIView                    *distanceView;         /**<切换距离View*/
    NSInteger                 height;                 /**<键盘高度*/
    NSInteger                 tableViewHeight;      /**<记录开始tableView的高度*/
    NSMutableArray          *orderLists;
    NSMutableArray          *myOrderLists;
    NSInteger                  pageNum;                /**<请求分页数*/
    NSString                  *orderDistance;         /**<传入订单搜索范围*/
    NSInteger                 scrollNum;
    NSString                  *phoneNum;
    NSArray                   *disStr;
    BOOL                       tableViewScroll;
    NSInteger                 myIndexPag;
    UIView                    *noNetWork;              /**<无网络页面*/
    BOOL                       isJump;
    NSArray                   *orderList;
    NSMutableArray          *headerBtns;
}

@end

@implementation BusinessOrderController
@synthesize myTableView, neighbourView, leftImage, distance, refresh, myHeadView, indexPag;
@synthesize nullLab, nullImage;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        UITabBarItem *tabBarItem  = nil;
        if (IOS7) {
            UIImage *img = [UIImage imageNamed:@"ordertab.png"];
            UIImage *normalImage = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *selectImage=[UIImage imageNamed:@"ordertab_p.png"];
            UIImage *selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订单" image:normalImage selectedImage:selectedImage];
        } else {
            UIImage *img = [UIImage imageNamed:@"ordertab.png"];
            UIImage *selectImage=[UIImage imageNamed:@"ordertab_p.png"];
            tabBarItem=[[UITabBarItem alloc]initWithTitle:@"订单" image:img selectedImage:selectImage];
        }
        
        self.tabBarItem       = tabBarItem;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    headerView.hidden = NO;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, headerView.frame.size.height)];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    if (![UserLoginModel isLogged]) {
        
        myTableView.hidden = YES;
        [[AppModel sharedModel]  presentLoginController:[UIApplication sharedApplication].keyWindow.rootViewController];
        return;
    }
    
    pageNum = 1;
    NSString *acceptDis = [[NSUserDefaults standardUserDefaults] objectForKey:@"ACCEPTDIS"];
    if ([DataCheck isValidString:acceptDis]) {
        orderDistance = acceptDis;
    }
    else
    {
        orderDistance = @"1000";
    }
    if ([orderDistance integerValue] < 1000) {
        distance.text = [NSString stringWithFormat:@"设置接单距离<%ldm", [orderDistance integerValue]];
    }
    else
    {
        distance.text = [NSString stringWithFormat:@"设置接单距离<%.1fkm", [orderDistance floatValue]/1000];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
    if (stateNum == 0) {
        orderLists = [NSMutableArray array];
        [self setupHeaderRefresh:myTableView];
    }
    else
    {
        myOrderLists = [NSMutableArray array];
        [self getBusinessOrderData];
    }
    
    
    if (indexPag == 1 || indexPag == 2) {
        headerView.hidden = NO;
        self.navigationController.navigationBarHidden = NO;
        
        if (myIndexPag != 1) {
            [self shopHeaderBtnAction:myBtns[1]];
        }
        orderLists = [NSMutableArray array];
        [self setupHeaderRefresh:myTableView];
        
//        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, headerView.frame.size.height)];
//        [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:backBtn];
    }
    else
    {
        headerView.hidden = NO;
        
        //[self shopHeaderBtnAction:myBtns[0]];
    }
    
}

//MARK: - 从我的进入返回方法
- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    headerView.hidden = YES;
    distanceView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor_HEX colorWithHexString:@"#f5f5f1"];
    
    [self setUpFooterRefresh:myTableView];
    if (indexPag == 1) {
        neighbourView.hidden = YES;
    }
    
    myBtns     = [NSMutableArray array];
    lineViews = [NSMutableArray array];
    orderLists = [NSMutableArray array];
    myOrderLists = [NSMutableArray array];
    
    [self createHeaderBtn];
    myTableView.hidden = YES;
    
    headerBtns = [NSMutableArray array];
    [self createMyHeaderViewBtn];
    
    stateNum = 0;
    pageNum = 1;
    statusNum = 4;
    
    tableViewHeight = myTableView.frame.size.height;
//    [self setupRefresh:myTableView];
    
    
    client = [CloudClient getInstance];
    
    //键盘打开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘收起
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createMyHeaderViewBtn {
    NSArray *titleStr = @[@"待处理", @"已完成", @"待点评"];
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * viewWidth/3, 0, viewWidth/3, 40)];
        [headerBtn setTitle:titleStr[i] forState:UIControlStateNormal];
        headerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [headerBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [headerBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#282828"] forState:UIControlStateSelected];
        [headerBtn setBackgroundImage:UIIMAGE(@"order_btnBgImage") forState:UIControlStateSelected];
        headerBtn.backgroundColor = [UIColor clearColor];
        [myHeadView addSubview:headerBtn];
        [headerBtns addObject:headerBtn];
        switch (i) {
            case 0:
                headerBtn.selected = YES;
                [headerBtn addTarget:self action:@selector(dealAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                [headerBtn addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                [headerBtn addTarget:self action:@selector(evaluationAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
    }
    
    for (NSInteger i = 1; i < 3; i ++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/3 * i, 0, 0.5, 40)];
        lineView.backgroundColor = [UIColor_HEX colorWithHexString:@"#f5f5f1"];
        [myHeadView addSubview:lineView];
    }
}

/**
 * Method name: createHeaderBtn
 * MARK: - 创建头部按钮
 */
- (void)createHeaderBtn {
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    
    [self.navigationController.navigationBar addSubview: headerView];
    
    NSArray *nameStr = @[@"附近订单(0)", @"我的订单(0)"];
    for (NSInteger i = 0; i < 2; i ++) {
        CGFloat btnWidth = ([[UIScreen mainScreen] bounds].size.width - 100) / 2;
        CGFloat x =  ([[UIScreen mainScreen] bounds].size.width - btnWidth * 2)/2;
        UIButton *headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * btnWidth + x + 5, 0, btnWidth, self.navigationController.navigationBar.frame.size.height)];
        [headerBtn setTitle:[NSString stringWithFormat:@"%@", nameStr[i]] forState:UIControlStateNormal];
        [headerBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#6a3906"] forState:UIControlStateNormal];
        headerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        headerBtn.tag = i;
        [headerBtn addTarget:self action:@selector(shopHeaderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:headerBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, headerBtn.frame.size.height - 2, headerBtn.frame.size.width - 30, 2)];
        lineView.backgroundColor = [UIColor clearColor];
        lineView.tag = i;
        lineView.hidden = YES;
        [headerBtn addSubview:lineView];
        
        
        if (i == 0) {
            lineView.hidden = NO;
            [headerBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#ff5a1e"] forState:UIControlStateNormal];
        }
        [myBtns addObject:headerBtn];
        [lineViews addObject:lineView];
    }
    
    myHeadView.hidden = YES;
    
    [self chooseDistanceView];
    
    if (indexPag == 1) {
        nullLab.hidden = YES;
        nullImage.hidden = YES;
        nullLab.text = @"没有待处理的订单";
    }
    else
    {
        nullLab.hidden = YES;
        nullImage.hidden = YES;
        nullLab.text = @"您设置的范围内暂无订单";
    }
}

//MARK: - 创建选择距离view
- (void)chooseDistanceView {
    disStr = @[@"<500m", @"<1.0km", @"<1.5km", @"<2.0km", @"<2.5km", @"<3.0km"];
    distanceView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 150, 40 * disStr.count)];
    distanceView.backgroundColor = RGBACOLOR(235, 111, 103, 1);
    distanceView.hidden = YES;
    [self.view addSubview:distanceView];
    
    for (NSInteger i = 0; i < disStr.count; i ++) {
        UIButton *disBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 40, distanceView.frame.size.width, distanceView.frame.size.height / disStr.count)];
        [disBtn setTitle:disStr[i] forState:UIControlStateNormal];
        disBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [disBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        disBtn.tag = i;
        [disBtn addTarget:self action:@selector(distanceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [distanceView addSubview:disBtn];
    }
    
    for (NSInteger i = 1; i < disStr.count; i ++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 40, distanceView.frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor whiteColor];
        [distanceView addSubview:lineView];
    }
}

- (void)distanceBtnAction:(UIButton *)sender {
    distance.text = [NSString stringWithFormat:@"设置接单距离%@", disStr[sender.tag]];
    switch (sender.tag) {
        case 0:
            orderDistance = @"500";
            break;
        case 1:
            orderDistance = @"1000";
            break;
        case 2:
            orderDistance = @"1500";
            break;
        case 3:
            orderDistance = @"2000";
            break;
        case 4:
            orderDistance = @"2500";
            break;
        case 5:
            orderDistance = @"3000";
            break;
        default:
            break;
    }
    distanceView.hidden = YES;
    
    pageNum = 1;
    orderLists = [NSMutableArray array];
    [self getNearbyOrderData];
}

- (void)shopHeaderBtnAction:(UIButton *)sender {
    if (tableViewScroll == YES) {
        return;
    }
    
    pageNum = 1;
    scrollNum = 0;
    myTableView.hidden = YES;
    orderLists = [NSMutableArray array];
    myOrderLists = [NSMutableArray array];
    
    distanceView.hidden = YES;
    stateNum = sender.tag;
    
    if (sender.tag == 1) {
        for (NSInteger i =0; i < 3; i++) {
            UIButton *btn = headerBtns[i];
            if (i == 0) {
                btn.titleLabel.textColor = [UIColor_HEX colorWithHexString:@"#282828"];
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }

        statusNum = 4;
        [self getBusinessOrderData];
    }
    else
    {
        if (indexPag == 1) {
            myIndexPag = 1;
        }
        [self getNearbyOrderData];
    }
    
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
        neighbourView.hidden = NO;
        myHeadView.hidden = YES;
        [myTableView reloadData];
    }
    else
    {
        neighbourView.hidden = YES;
        myHeadView.hidden = NO;
        [myTableView reloadData];
    }
    
    if (sender.tag == 0) {
        neighbourView.hidden = NO;
        nullLab.text = @"您设置的范围内暂无订单";
    }
    else
    {
        nullLab.text = @"没有待处理的订单";
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    tableViewScroll = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    tableViewScroll = NO;
}

//MARK: - 附近订单切换距离
- (IBAction)distanceCatAction:(UIButton *)sender {
    
    [self popupAnimation:distanceView duration:0.5];
    if (distanceView.hidden == YES) {
        [MobClick event:Swtich_Distance];
        distanceView.hidden = NO;
    }
    else
    {
        distanceView.hidden = YES;
    }
}

- (void) keyboardWasShown:(NSNotification *) notification
{
    isJump = YES;
    if (stateNum == 1) {
        //获取键盘的高度
        NSDictionary *userInfo = [notification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        height = keyboardRect.size.height;
        NSInteger keyboardY = keyboardRect.origin.y;
        
        myTableView.frame = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, keyboardY - 104);
    }
}

- (void) keyboardWasHidden:(NSNotification *)notification {
    
    isJump = NO;
    if (stateNum == 1) {
        if (indexPag == 1) {
            myTableView.frame = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, myTableView.frame.size.height + height + 45);
        }
        else
        {
            myTableView.frame = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, myTableView.frame.size.height + height - 5);
        }
    }
}

- (IBAction)hiddenKeyboardAction:(UITapGestureRecognizer *)sender {
    [myField resignFirstResponder];
}

//滑动隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [myField resignFirstResponder];
    distanceView.hidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    myField = textField;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

/**
 * Method name: tableView
 * MARK: - tableView相关实现方法
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (stateNum == 0) {
        return bOrderResp.orderList.count;
    }
    else
    {
        switch (statusNum) {
            case 4:
                return orderResp.handleList.count;
                break;
                
            case 5:
                return orderResp.finishList.count;
                break;
                
            case 6:
                return orderResp.evaluationList.count;
                break;
            default:
                break;
        }
    }
    return  0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (indexPag == 1) {
        if ([UIScreen mainScreen].bounds.size.height > 600) {
            myTableView.frame = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, tableViewHeight + 48 * 3);
        }
        else
        {
            myTableView.frame = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, tableViewHeight + 48);
        }
        
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    if (myHeadView.hidden == NO) {
        TheOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TheOrderCell" owner:self options:nil];
            cell = [views objectAtIndex:0];
            cell.selectionStyle = UITableViewCellStyleDefault;
        }
        
        cell.myScrollView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shopScrollAction:)];
        cell.myScrollView.tag = indexPath.section;
        
        [cell.myScrollView addGestureRecognizer:tap];
        
        cell.payBtn.hidden = YES;
        NSDictionary *orderDic = nil;
        
        switch (statusNum) {
            case 4:
            {
                cell.imageUrls = [orderResp.handleList[indexPath.section] objectForKey:@"goodsImgList"];
                [cell setShopImage];
                
                orderDic = orderResp.handleList[indexPath.section];
                
                switch ([[orderDic objectForKey:@"orderStatus"] integerValue]) {
                    case 2:
                    {
                        cell.state.text = @"待付款";
                        cell.cancleBtn.hidden = NO;
                        cell.backOrderBtn.hidden = NO;
                        cell.backOrderBtn.tag = indexPath.section;
                        cell.cancleBtn.tag = indexPath.section;
                        [cell.backOrderBtn addTarget:self action:@selector(backOrderAction:) forControlEvents:UIControlEventTouchUpInside];
                        cell.backOrderBtn.frame = CGRectMake(cell.cancleBtn.frame.origin.x - cell.backOrderBtn.frame.size.width - 10, cell.backOrderBtn.frame.origin.y, cell.backOrderBtn.frame.size.width, cell.backOrderBtn.frame.size.height);
                        [cell.cancleBtn addTarget:self action:@selector(cancleOrderAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                        
                    case 3:
                    {
                        cell.state.text = @"配货中";
                        cell.backOrderBtn.hidden = NO;
                        cell.payBtn.hidden = NO;
                        [cell.payBtn setTitle:@"开始配送" forState:UIControlStateNormal];
                        [cell.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cell.payBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
                        [cell.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                        CGRect cancleRect = cell.cancleBtn.frame;
                        CGRect backRect = cell.backOrderBtn.frame;
                        CGRect payRect = cell.payBtn.frame;
                        cell.backOrderBtn.frame = CGRectMake(cancleRect.origin.x - backRect.size.width - 10, backRect.origin.y, backRect.size.width, backRect.size.height);
                        cell.payBtn.frame = CGRectMake(cancleRect.origin.x - backRect.size.width - payRect.size.width - 20, payRect.origin.y, payRect.size.width, payRect.size.height);
                        
                        cell.backOrderBtn.tag = indexPath.section;
                        [cell.backOrderBtn addTarget:self action:@selector(backOrderAction:) forControlEvents:UIControlEventTouchUpInside];
                        cell.payBtn.tag = indexPath.section;
                        [cell.payBtn addTarget:self action:@selector(startDistributionAction:) forControlEvents:UIControlEventTouchUpInside];
                        cell.cancleBtn.tag = indexPath.section;
                        [cell.cancleBtn addTarget:self action:@selector(cancleOrderAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                        
                    case 4:
                    {
                        cell.state.text = @"待收货";
                        cell.goodsNum.hidden = NO;
                        cell.goodsField.hidden = NO;
                        cell.goodsField.tag = indexPath.section;
                        cell.goodsField.delegate = self;
                        [cell.cancleBtn setTitle:@"验证" forState:UIControlStateNormal];
                        [cell.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cell.cancleBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
                        
                        cell.cancleBtn.tag = indexPath.section;
                        [cell.cancleBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.phoneImg.hidden = NO;
                        cell.phoneImg.tag = indexPath.section;
                        [cell.phoneImg addTarget:self action:@selector(callPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    default:
                        break;
                }
                
            }
                break;
                
            case 5:
            {
                cell.imageUrls = [orderResp.finishList[indexPath.section] objectForKey:@"goodsImgList"];
                [cell setShopImage];
                
                orderDic = orderResp.finishList[indexPath.section];
                
                switch ([[orderDic objectForKey:@"orderStatus"] integerValue]) {
                    case 5:
                    {
                        cell.state.text = @"已完成";
                        //cell.cancleBtn.hidden = NO;
                        cell.goodsNum.hidden = NO;
                        cell.goodsField.hidden = NO;
                        cell.goodsField.enabled = NO;
                        cell.goodsField.text = [orderDic objectForKey:@"receiveCode"];
                        cell.cancleBtn.hidden = YES;
                        [cell.cancleBtn setTitle:@"查看点评" forState:UIControlStateNormal];
                        cell.cancleBtn.tag = indexPath.section;
                        [cell.cancleBtn addTarget:self action:@selector(busSearchEvaluation:) forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                        
                    case 6:
                    {
                        cell.state.text = @"已取消";
                        cell.cancleBtn.hidden = YES;
                        cell.downLine.hidden = YES;
                        cell.frame = CGRectMake(0, 0, cell.frame.size.width, 130);
                        cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, 130);
                        cell.bgView.frame = CGRectMake(0, 0, cell.frame.size.width, 124);
                        cell.downImage.frame = CGRectMake(0, 123, cell.frame.size.width, 7);
                    }
                        break;
                        
                    case 7:
                    {
                        cell.goodsField.enabled = NO;
                        cell.goodsField.hidden = NO;
                        cell.goodsNum.hidden = NO;
                        cell.state.text = @"已完成";
                        cell.goodsField.text = [orderDic objectForKey:@"receiveCode"];
                        cell.cancleBtn.hidden = YES;
                        [cell.cancleBtn setTitle:@"点评" forState:UIControlStateNormal];
                        [cell.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cell.cancleBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
                        
                        cell.cancleBtn.tag = indexPath.section;
                        [cell.cancleBtn addTarget:self action:@selector(clickEvaluationAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
                
            case 6:
            {
                cell.imageUrls = [orderResp.evaluationList[indexPath.section] objectForKey:@"goodsImgList"];
                [cell setShopImage];
                
                orderDic = orderResp.evaluationList[indexPath.section];
                
                cell.state.text = @"已完成";
                cell.goodsField.enabled = NO;
                cell.goodsNum.hidden = NO;
                cell.goodsField.hidden = NO;
                cell.goodsField.text = [orderDic objectForKey:@"receiveCode"];
                cell.cancleBtn.hidden = YES;
                [cell.cancleBtn setTitle:@"点评" forState:UIControlStateNormal];
                [cell.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.cancleBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
                
                cell.cancleBtn.tag = indexPath.section;
                [cell.cancleBtn addTarget:self action:@selector(clickEvaluationAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
                break;
        }
        
        if ([DataCheck isValidDictionary:orderDic]) {
            NSString *myDate = [NSString stringWithFormat:@"%@", [orderDic objectForKey:@"createTime"]];
            NSString *time = [self formatTimeStamp:[myDate substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"];
            NSString *userName = [orderDic objectForKey:@"addressName"];
            if ([DataCheck isValidString:userName]) {
                if (userName.length > 4) {
                    userName = [userName substringToIndex:4];
                }
            }
            cell.date.text = [NSString stringWithFormat:@"%@ (%@)",userName, time];
            
            if ([[orderDic objectForKey:@"yushou"] integerValue] == 1) {
                cell.yushouSign.hidden = NO;
                cell.date.frame = CGRectMake(CGRectGetMaxX(cell.yushouSign.frame) + 2, 8, cell.date.frame.size.width, cell.date.frame.size.height);
            }
        }
        
        cell.sum.text = [NSString stringWithFormat:@"共%@件商品", [orderDic objectForKey:@"totalNumber"]];
        if ([[orderDic objectForKey:@"yushou"] integerValue] == 1)
        {
            cell.amount.text = [NSString stringWithFormat:@"收入合计：￥%.2f", [[orderDic objectForKey:@"totalPay"] floatValue]];
        }
        else
        {
            cell.amount.text = [NSString stringWithFormat:@"合计：￥%.2f", [[orderDic objectForKey:@"totalPay"] floatValue]];
        }
    
        cell.address.hidden = NO;
        cell.address.numberOfLines = 0;
        cell.address.text = [NSString stringWithFormat:@"%@", [orderDic objectForKey:@"address"]];
        CGSize size =  [self sizeWithString:cell.address.text font:cell.address.font];
        cell.address.frame = CGRectMake(cell.address.frame.origin.x, cell.address.frame.origin.y, cell.address.frame.size.width, size.height);
        
        cell.phoneImg.center = CGPointMake(cell.phoneImg.center.x, cell.address.center.y);
        
        if (statusNum == 5 && [[orderDic objectForKey:@"orderStatus"] integerValue] == 6) {
            cell.bgView.frame = CGRectMake(0, 0, cell.bgView.frame.size.width, cell.address.frame.origin.y + size.height + 10);
            cell.downImage.frame = CGRectMake(0, cell.bgView.frame.size.height, cell.downImage.frame.size.width, 6.5);
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.address.frame.origin.y + size.height + 17);
        }
        else
        {
            cell.downLine.hidden = NO;
            cell.downLine.frame = CGRectMake(cell.downLine.frame.origin.x, cell.address.frame.origin.y + size.height + 10, cell.downLine.frame.size.width, 1);
            cell.bgView.frame = CGRectMake(0, 0, cell.bgView.frame.size.width, cell.downLine.frame.origin.y + 43);
            cell.downImage.frame = CGRectMake(0, cell.bgView.frame.size.height, cell.downImage.frame.size.width, 6.5);
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.downLine.frame.origin.y + 50);
        }
        
        return cell;
    }
    else
    {
        BusinessOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"BusinessOrderCell" owner:self options:nil];
            cell = [views objectAtIndex:0];
            cell.selectionStyle = UITableViewCellStyleDefault;
        }
        
        cell.rightBtn.tag = indexPath.section;
        [cell.rightBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *orderDic = bOrderResp.orderList[indexPath.section];
        cell.orderNum.text = [NSString stringWithFormat:@"订单:%@", [orderDic objectForKey:@"orderNo"]];
        cell.money.text = [NSString stringWithFormat:@"￥%.2f", [[orderDic objectForKey:@"totalPrice"] floatValue]];
        if ([[orderDic objectForKey:@"yushou"] integerValue] == 1) {
            cell.totalLabel.hidden = NO;
            cell.totalLabel.text = [NSString stringWithFormat:@"收入合计:¥%.2f", [[orderDic objectForKey:@"shopPrice"] floatValue]];
        }
        cell.consumptionLab.text = [NSString stringWithFormat:@"含小费:￥%.2f", [[orderDic objectForKey:@"tip"] floatValue]];
        cell.subsidyLab.text = [NSString stringWithFormat:@"平台奖励:￥%.2f", [[orderDic objectForKey:@"subsidy"] floatValue]];
        cell.time.text = [NSString stringWithFormat:@"%@", [orderDic objectForKey:@"orderTime"]];
        
        cell.oneLab.text = [orderDic objectForKey:@"deliveryTime"];
        float myDistance = [[orderDic objectForKey:@"distance"] floatValue] / 1000.0;
        if (myDistance > 1.0) {
//            myDistance = ceilf(myDistance);
            cell.twoLab.text = [NSString stringWithFormat:@"%.1fkm", myDistance];
        }
        else
        {
            myDistance = [[orderDic objectForKey:@"distance"] floatValue];
            cell.twoLab.text = [NSString stringWithFormat:@"%.0fm", myDistance];
        }
        
        
        
        cell.addressLab.numberOfLines = 0;
        NSString *addressStr = [NSString stringWithFormat:@"地址:%@", [orderDic objectForKey:@"address"]];
        cell.addressLab.text = addressStr;
        CGSize size =  [self sizeWithString:cell.addressLab.text font:cell.addressLab.font];
        cell.addressLab.frame = CGRectMake(cell.addressLab.frame.origin.x, cell.addressLab.frame.origin.y, cell.addressLab.frame.size.width, size.height);
        
        //调整label间距
        cell.downLine.frame = CGRectMake(cell.downLine.frame.origin.x, cell.addressLab.frame.origin.y + cell.addressLab.frame.size.height + 13, cell.downLine.frame.size.width, 1);
        CGRect downRect = cell.downLine.frame;
        
        if ([cell.oneLab.text isEqualToString:@"立即送达"]) {
            [cell.headerLeft setTitle:@"实时" forState:UIControlStateNormal];
            cell.oneLab.frame = CGRectMake(downRect.origin.x, downRect.origin.y + 11, cell.oneLab.frame.size.width, cell.oneLab.frame.size.height);
            cell.time.center = CGPointMake(cell.time.center.x, cell.oneLab.center.y);
            cell.twoLab.frame = CGRectMake(cell.twoLab.frame.origin.x, downRect.origin.y + 11, cell.twoLab.frame.size.width, cell.twoLab.frame.size.height);
            cell.oneLab.layer.borderColor = [cell.headerLeft.backgroundColor CGColor];
            cell.oneLab.textColor = cell.headerLeft.backgroundColor;
        }
        else
        {
            if ([[orderDic objectForKey:@"yushou"] integerValue] == 1)
            {
                [cell.headerLeft setTitle:@"预售" forState:UIControlStateNormal];
                cell.oneLab.frame = CGRectMake(downRect.origin.x, downRect.origin.y + 11, cell.oneLab.frame.size.width, cell.oneLab.frame.size.height);
                cell.time.center = CGPointMake(cell.time.center.x, cell.oneLab.center.y);
                cell.twoLab.frame = CGRectMake(cell.twoLab.frame.origin.x, downRect.origin.y + 11, cell.twoLab.frame.size.width, cell.twoLab.frame.size.height);
                
                cell.headerView.layer.cornerRadius = 20;
                cell.headerView.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#00b7ee"] CGColor];
                cell.headerView.layer.borderWidth = 1.0f;
                
                cell.headerLeft.layer.cornerRadius = 20;
                cell.headerLeft.backgroundColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
                cell.headerLine.backgroundColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
                cell.oneLab.layer.borderColor = [cell.headerLeft.backgroundColor CGColor];
                cell.oneLab.textColor = cell.headerLeft.backgroundColor;
            }
            else
            {
                [cell.headerLeft setTitle:@"预约" forState:UIControlStateNormal];
                cell.oneLab.frame = CGRectMake(downRect.origin.x, downRect.origin.y + 11, cell.oneLab.frame.size.width, cell.oneLab.frame.size.height);
                cell.time.center = CGPointMake(cell.time.center.x, cell.oneLab.center.y);
                cell.twoLab.frame = CGRectMake(cell.twoLab.frame.origin.x, downRect.origin.y + 11, cell.twoLab.frame.size.width, cell.twoLab.frame.size.height);
                
                cell.headerView.layer.cornerRadius = 20;
                cell.headerView.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#f3c849"] CGColor];
                cell.headerView.layer.borderWidth = 1.0f;
                
                cell.headerLeft.layer.cornerRadius = 20;
                cell.headerLeft.backgroundColor = [UIColor_HEX colorWithHexString:@"#f3c849"];
                cell.headerLine.backgroundColor = [UIColor_HEX colorWithHexString:@"#f3c849"];
                cell.oneLab.layer.borderColor = [cell.headerLeft.backgroundColor CGColor];
                cell.oneLab.textColor = cell.headerLeft.backgroundColor;
            }
        }
        
        //cell.bgView.frame = CGRectMake(0, 0, cell.bgView.frame.size.width, cell.bgView.frame.size.height + cell.addressLab.frame.size.height - 13);
        
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height + cell.addressLab.frame.size.height - 13);
        
        cell.downImageView.frame = CGRectMake(cell.downImageView.frame.origin.x, cell.frame.size.height - 8, cell.downImageView.frame.size.width, 6.5);
        
        return cell;
    }
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
 * Method name: sizeWithString
 * MARK: - 根据label内容计算label高度
 * Parameter: label内容
 * Parameter: label字体大小
 */
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect;
    if ([[UIScreen mainScreen] bounds].size.width > 320) {
        rect = [string boundingRectWithSize:CGSizeMake(240, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    else
    {
        rect = [string boundingRectWithSize:CGSizeMake(200, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    
    
    return rect.size;
}

/**
 * Method name: scrollAction
 * MARK: - 点击图片跳转
 * Parameter: sender
 */
- (void)shopScrollAction:(UIGestureRecognizer *)sender {
    if (isJump == YES) {
        return;
    }
    
    NSInteger tag = sender.view.tag;
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    headerView.hidden = YES;
    switch (statusNum) {
        case 4:
            orderDetail.orderNum = [orderResp.handleList[tag] objectForKey:@"orderNo"];
            break;
            
        case 5:
            orderDetail.orderNum = [orderResp.finishList[tag] objectForKey:@"orderNo"];
            break;
            
        case 6:
            orderDetail.orderNum = [orderResp.evaluationList[tag] objectForKey:@"orderNo"];
            break;
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

//MARK: - 待收货拨打电话
- (void)callPhoneAction:(UIButton *)sender {
    NSString *myPhoneNum = [orderResp.handleList[sender.tag] objectForKey:@"mobile"];
    //拨打用户电话
    [SRMessage infoMessage:[NSString stringWithFormat:@"是否拨打电话 %@?",myPhoneNum] block:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",myPhoneNum]]];
    }];
}

//MARK: - 刷新处理事件
- (IBAction)refreshAction:(UIButton *)sender {
    pageNum = 1;
    orderLists = [NSMutableArray array];
    
    [self getNearbyOrderData];
    
    distanceView.hidden = YES;
}

//MARK: - 待处理处理事件
- (void)dealAction:(UIButton *)sender {
    nullLab.text = @"没有待处理的订单";
    
    if (tableViewScroll == YES) {
        return;
    }
    
    myIndexPag = 1;
    statusNum = 4;
    for (NSInteger i =0; i < 3; i++) {
        UIButton *btn = headerBtns[i];
        if (i == 0) {
            btn.titleLabel.textColor = [UIColor_HEX colorWithHexString:@"#282828"];
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    
    pageNum = 1;
    scrollNum = 0;
    myOrderLists = [NSMutableArray array];
    
    [self getBusinessOrderData];
}

//MARK: - 已完成处理事件
- (void)completeAction:(UIButton *)sender {
    nullLab.text = @"没有已完成的订单";
    
    if (tableViewScroll == YES) {
        return;
    }
    
    myIndexPag = 1;
    statusNum = 5;
    for (NSInteger i =0; i < 3; i++) {
        UIButton *btn = headerBtns[i];
        if (i == 1) {
            btn.titleLabel.textColor = [UIColor_HEX colorWithHexString:@"#282828"];
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    
    pageNum = 1;
    scrollNum = 0;
    myOrderLists = [NSMutableArray array];
    
    [self getBusinessOrderData];
}

//MARK: - 待评价处理事件
- (void)evaluationAction:(UIButton *)sender {
    nullLab.text = @"没有待点评的订单";
    
    if (tableViewScroll == YES) {
        return;
    }
    
    myIndexPag = 1;
    statusNum = 6;
    for (NSInteger i =0; i < 3; i++) {
        UIButton *btn = headerBtns[i];
        if (i == 2) {
            btn.titleLabel.textColor = [UIColor_HEX colorWithHexString:@"#282828"];
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    
    pageNum = 1;
    scrollNum = 0;
    myOrderLists = [NSMutableArray array];
    
    [self getBusinessOrderData];
}

//MARK: - 查看详情处理事件
- (void)detailAction:(UIButton *)sender {
    [MobClick event:View_Order];
    OrderDetailController *orderDetail = [[OrderDetailController alloc] init];
    headerView.hidden = YES;
    orderDetail.orderNum = [bOrderResp.orderList[sender.tag] objectForKey:@"orderNo"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

//MARK: - 缺货申请退单处理事件
- (void)backOrderAction:(UIButton *)sender {
     [MobClick event:Contact_Customer];
    phoneNum = [orderResp.handleList[sender.tag] objectForKey:@"mobile"];
    
    //拨打用户电话
    [SRMessage infoMessage:[NSString stringWithFormat:@"是否拨打电话 %@?",phoneNum] block:^{
        NSString *orderNum = [orderResp.handleList[sender.tag] objectForKey:@"orderNo"];
        [self getOderStockoutData:orderNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    }];
}

//MARK: - 开始配送处理事件
- (void)startDistributionAction:(UIButton *)sender {
    NSString *orderNum = [orderResp.handleList[sender.tag] objectForKey:@"orderNo"];
    [self getDistributionData:orderNum];
}

//MARK: - 验证订单处理事件
- (void)checkAction:(UIButton *)sender {
    NSString *orderNum = [orderResp.handleList[sender.tag] objectForKey:@"orderNo"];
    [self getCheckData:orderNum];
}

//MARK: - 点击评价按钮处理事件
- (void)clickEvaluationAction:(UIButton *)sender {
    NSString *orderNum = nil;
    if (statusNum == 5) {
        orderNum = [orderResp.finishList[sender.tag] objectForKey:@"orderNo"];
    }
    else
    {
        orderNum = [orderResp.evaluationList[sender.tag] objectForKey:@"orderNo"];
    }
    
    EvaluationViewController *evaluation = [[EvaluationViewController alloc] init];
    evaluation.orderNum = orderNum;
    evaluation.indexNum = 1;
    evaluation.type = @"1";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluation animated:YES];
}

//MARK: - 点击查看点评处理事件
- (void)busSearchEvaluation:(UIButton *)sender {
    NSString *orderNum = [orderResp.finishList[sender.tag] objectForKey:@"orderNo"];
    
    EvaluationViewController *evaluation = [[EvaluationViewController alloc] init];
    evaluation.orderNum = orderNum;
    evaluation.indexNum = 2;
    evaluation.type = @"1";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluation animated:YES];
}

//MARK: - 取消订单处理事件
- (void)cancleOrderAction:(UIButton *)sender {
     [MobClick event:CancelbyStore];
    NSString *orderNum = [orderResp.handleList[sender.tag] objectForKey:@"orderNo"];
    
    NSString *shopCancelStr = [[CommClass sharedCommon] objectForKey:SHOPCANCELALERT];
    [SRMessage orderBusinessMessage:shopCancelStr block:^{
        if ([self noNetwork]) {
            return;
        }
        
        if ([UserLoginModel isLogged]) {
            
            [self showHUD];
            
            [client requestMethodWithMod:@"business/cancel"
                                  params:nil
                              postParams:@{@"orderNo":orderNum}
                                delegate:self
                                selector:@selector(cancleOrderDataSuccessed:)
                           errorSelector:@selector(cancleOrderDatafiled:)
                        progressSelector:nil];
        }

    }];
}

- (void)cancleOrderDataSuccessed:(NSDictionary *)response {
    myOrderLists = [NSMutableArray array];
    pageNum = 1;
    [self getBusinessOrderData];
    [myTableView reloadData];
    
    [self hidenHUD];
}

- (void)cancleOrderDatafiled:(NSDictionary *)response {
    [self hidenHUD];
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
    if (stateNum == 0) {
        orderLists = [NSMutableArray array];
        [self getNearbyOrderData];
    }
    else
    {
        myOrderLists = [NSMutableArray array];
        [self getBusinessOrderData];
    }
}

/**
 * Method name: getNearbyOrderData
 * MARK: - 获取附近订单列表
 */
- (void)getNearbyOrderData {
    if ([self noNetwork]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:orderDistance forKey:@"ACCEPTDIS"];
    DLog(@"%@", orderDistance);
    
    if ([UserLoginModel isLogged]) {
        
        [self showHUD];
        
        NSString *page = [NSString stringWithFormat:@"%ld", (long)pageNum];
        
        [client requestMethodWithMod:@"business/getOrders"
                              params:nil
                          postParams:@{@"distance":orderDistance, @"pageNum":page}
                            delegate:self
                            selector:@selector(getNearbyOrderDataSuccessed:)
                       errorSelector:@selector(getNearbyOrderDatafiled:)
                    progressSelector:nil];
    }
}

- (void)getNearbyOrderDataSuccessed:(NSDictionary *)response {
    
    if ([DataCheck isValidDictionary:response]) {
        
        bOrderResp = [BusinessOrderModel sharedInstance];
        bOrderResp.orderList = [response objectForKey:@"orderList"];
        bOrderResp.orderNum = [response objectForKey:@"orderNum"];
        bOrderResp.myOrderNum = [response objectForKey:@"myOrderNum"];
        
        for (NSDictionary *dic in bOrderResp.orderList) {
            [orderLists addObject:dic];
        }
        
        if (pageNum > 1) {
            bOrderResp.orderList = orderLists;
        }
        
        
        if (orderList.count == 0 && pageNum > 1) {
            pageNum --;
        }
    }
    
    NSString *nearbyOrderNum = [NSString stringWithFormat:@"附近订单(%@)", bOrderResp.orderNum];
    NSString *myOrderNum = [NSString stringWithFormat:@"我的订单(%@)", bOrderResp.myOrderNum];
    UIButton *nearbyBtn = myBtns[0];
    [nearbyBtn setTitle:nearbyOrderNum forState:UIControlStateNormal];
    UIButton *myBtn = myBtns[1];
    [myBtn setTitle:myOrderNum forState:UIControlStateNormal];
    
    if (indexPag != 1 || myIndexPag == 1) {
        
        if (orderLists.count == 0) {
            myTableView.hidden = YES;
            
            nullImage.hidden = NO;
            nullLab.hidden = NO;
        }
        else
        {
            myTableView.hidden = NO;
            [myTableView reloadData];
            if (pageNum == 1 && scrollNum != 1) {
                [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
            
            nullImage.hidden = YES;
            nullLab.hidden = YES;
        }
    }
    
//    if ([[MyInfoModel sharedInstance].ifAccept integerValue] == 0) {
//        myTableView.hidden = YES;
//        [nearbyBtn setTitle:@"附近订单(0)" forState:UIControlStateNormal];
//    }
    
    if (indexPag == 1) {
        
        [self.view addSubview:distanceView];
    }
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}

- (void)getNearbyOrderDatafiled:(NSDictionary *)response {
    
    if (pageNum > 1) {
        pageNum --;
    }
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}

/**
 * Method name: getBusinessOrderData
 * MARK: - 获取商家我的订单列表处理方法
 */
- (void)getBusinessOrderData {
    if ([self noNetwork]) {
        return;
    }
    
    if ([UserLoginModel isLogged]) {
        
        [self showHUD];
        
        NSString *status = [NSString stringWithFormat:@"%ld", (long)statusNum];
        NSString *page = [NSString stringWithFormat:@"%ld", (long)pageNum];
        
        [client requestMethodWithMod:@"order/getOrders"
                              params:nil
                          postParams:@{@"status":status, @"pageNum":page}
                            delegate:self
                            selector:@selector(getBusinessOrderDataSuccessed:)
                       errorSelector:@selector(getBusinessOrderDatafiled:)
                    progressSelector:nil];
    }
}

- (void)getBusinessOrderDataSuccessed:(NSDictionary *)response {
    if ([DataCheck isValidDictionary:response]) {
        
        orderResp = [TheOrderRespModel sharedInstance];
        
        orderList = [response objectForKey:@"orderList"];
        if (orderList.count == 0 && pageNum > 1) {
            pageNum --;
            [self.refreshFooterView endRefreshing];
            [myTableView reloadData];
            return;
        }
        
        switch (statusNum) {
            case 4:
                orderResp.handleList = [response objectForKey:@"orderList"];
                
                for (NSDictionary *dic in orderResp.handleList) {
                    [myOrderLists addObject:dic];
                }
                if (pageNum > 1) {
                    orderResp.handleList = myOrderLists;
                }
                
                break;
            case 5:
                orderResp.finishList = [response objectForKey:@"orderList"];
                
                for (NSDictionary *dic in orderResp.finishList) {
                    [myOrderLists addObject:dic];
                }
                if (pageNum > 1) {
                    orderResp.finishList = myOrderLists;
                }
                
                break;
            case 6:
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

- (void)getBusinessOrderDatafiled:(NSDictionary *)response {
    
    if (pageNum > 1) {
        pageNum --;
    }
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}

/**
 * Method name: getOderStockoutData
 * MARK: - 缺货申请退单处理方法
 * Parameter: orderNum
 */
- (void)getOderStockoutData:(NSString *)orderNum {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    [self showHUD];
    
    [client requestMethodWithMod:@"business/stockout"
                          params:nil
                      postParams:@{@"orderNo":orderNum}
                        delegate:self
                        selector:@selector(getOderStockoutDataSuccessed:)
                   errorSelector:@selector(getOderStockoutDatafiled:)
                progressSelector:nil];
}

- (void)getOderStockoutDataSuccessed:(NSDictionary *)response {
    
    [self hidenHUD];
}

- (void)getOderStockoutDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

/**
 * Method name: getDistributionData
 * MARK: - 开始配送处理方法
 * Parameter: orderNum
 */
- (void)getDistributionData:(NSString *)orderNum {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    [self showHUD];
    
    [client requestMethodWithMod:@"business/delivery"
                          params:nil
                      postParams:@{@"orderNo":orderNum}
                        delegate:self
                        selector:@selector(getDistributionDataSuccessed:)
                   errorSelector:@selector(getDistributionDatafiled:)
                progressSelector:nil];
}

- (void)getDistributionDataSuccessed:(NSDictionary *)response {
    
    myOrderLists = [NSMutableArray array];
    pageNum = 1;
    [self getBusinessOrderData];
    [myTableView reloadData];
    
    [self hidenHUD];
}

- (void)getDistributionDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

/**
 * Method name: getCheckData
 * MARK: - 订单验证处理方法
 * Parameter: orderNum
 */
- (void)getCheckData:(NSString *)orderNum {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    if (![DataCheck isValidString:myField.text]) {
        [SRMessage infoMessage:@"请输入收货码" delegate:self];
        return;
    }
    
    [self showHUD];
    
    [client requestMethodWithMod:@"business/verification"
                          params:nil
                      postParams:@{@"orderNo":orderNum, @"receiveCode":myField.text}
                        delegate:self
                        selector:@selector(getCheckDataSuccessed:)
                   errorSelector:@selector(getCheckDatafiled:)
                progressSelector:nil];
}

- (void)getCheckDataSuccessed:(NSDictionary *)response {
    
    myOrderLists = [NSMutableArray array];
    pageNum = 1;
    [self getBusinessOrderData];
    [myTableView reloadData];
    
    [self hidenHUD];
}

- (void)getCheckDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

- (void)headerRereshing {
    orderLists = [NSMutableArray array];
    myOrderLists = [NSMutableArray array];
    
    pageNum = 1;
    scrollNum = 1;
    if (stateNum == 0) {
        [self getNearbyOrderData];
    }
    else
    {
        [self getBusinessOrderData];
    }
}

- (void)footerRereshing {
    if (stateNum == 0) {
        if (bOrderResp.orderList.count >= 20) {
            pageNum ++;
            [self getNearbyOrderData];
        }
        else
        {
            [self.refreshFooterView endRefreshing];
        }
    }
    else
    {
        if (orderList.count >= 20) {
            pageNum ++;
            [self getBusinessOrderData];
        }
        else
        {
           [self.refreshFooterView endRefreshing];
        }
    }
}

- (void)dealloc {
    [headerView removeFromSuperview];
}

@end
