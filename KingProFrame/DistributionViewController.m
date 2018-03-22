//
//  DistributionViewController.m
//  KingProFrame
//
//  Created by denglong on 8/14/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "DistributionViewController.h"
#import "OrderDetailViewController.h"
#import "TheOrderRespModel.h"
#import "TheOrderCell.h"
#import "EvaluationViewController.h"

@interface DistributionViewController ()<UITextFieldDelegate, UIScrollViewDelegate, reloadDelegate>
{
    NSMutableArray          *myBtns;            /**<顶部btn数组*/
    NSMutableArray          *lineViews;        /**<底部btn下线*/
    UIView                    *headerView;       /**<顶部view*/
    CloudClient              *client;            /**<网络请求类*/
    NSInteger                 statusNum;         /**<头部切换状态btn， 7：待处理，8：已完成，9：待评价*/
    TheOrderRespModel       *orderResp;
    UITextField              *myField;           /**<验证码输入框*/
    NSInteger                 height;             /**<键盘高度*/
    NSMutableArray          *myOrderLists;
    NSInteger                 pageNum;
    NSInteger                 scrollNum;
    BOOL                       tableViewScroll;
    UIView                    *noNetWork;
    NSArray                   *orderList;
}

@end

@implementation DistributionViewController
@synthesize myTableView, indexPag, nullLab, nullImage;

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
    
    if (indexPag == 1) {
        myTableView.frame = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, myTableView.frame.size.height + 48);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (indexPag == 1) {
        headerView.hidden = NO;
        self.navigationController.navigationBarHidden = NO;
        
//        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, headerView.frame.size.height)];
//        [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:backBtn];
    }
    else
    {
        headerView.hidden = NO;
    }
     pageNum= 1;
    [self setupHeaderRefresh:myTableView];
}



//MARK: - 从我的进入返回方法
- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    myOrderLists      = [NSMutableArray array];
    
    headerView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    myBtns             = [NSMutableArray array];
    lineViews          = [NSMutableArray array];
    myOrderLists       = [NSMutableArray array];
    [self createHeaderBtn];
    [self setUpFooterRefresh:myTableView];
    myTableView.hidden = YES;
    
    pageNum            = 1;
    statusNum          = 7;
    client             = [CloudClient getInstance];
    
    //键盘打开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘收起
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 * Method name: createHeaderBtn
 * MARK: - 创建头部按钮
 */
- (void)createHeaderBtn {
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    
    [self.navigationController.navigationBar addSubview: headerView];
    
    NSArray *nameStr = @[@"待处理", @"已完成", @"待点评"];
    for (NSInteger i = 0; i < 3; i ++) {
        CGFloat btnWidth          = ([[UIScreen mainScreen] bounds].size.width - 100) / 3;
        UIButton *headerBtn       = [[UIButton alloc] initWithFrame:CGRectMake(i * btnWidth + 50, 0, btnWidth, self.navigationController.navigationBar.frame.size.height)];
        [headerBtn setTitle:[NSString stringWithFormat:@"%@", nameStr[i]] forState:UIControlStateNormal];
        [headerBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#6a3906"] forState:UIControlStateNormal];
        headerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        headerBtn.tag             = i;
        [headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:headerBtn];
        
        UIView *lineView          = [[UIView alloc] initWithFrame:CGRectMake(10, headerBtn.frame.size.height - 2, headerBtn.frame.size.width - 20, 2)];
        lineView.backgroundColor  = [UIColor_HEX colorWithHexString:@"#ff5a1e"];
        lineView.tag              = i;
        lineView.hidden           = YES;
        [headerBtn addSubview:lineView];
        
        
        if (i == 0) {
            lineView.hidden = NO;
            [headerBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#ff5a1e"] forState:UIControlStateNormal];
        }
        [myBtns addObject:headerBtn];
        [lineViews addObject:lineView];
    }
    
    nullImage.hidden = YES;
    nullLab.hidden = YES;
    nullLab.text = @"没有待处理的订单";
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
    
    if (sender.tag == 0) {
        statusNum = 7;
    }
    else if (sender.tag == 1) {
        statusNum = 8;
    }
    else
    {
        statusNum = 9;
    }
    
    pageNum      = 1;
    scrollNum    = 0;
    myOrderLists = [NSMutableArray array];
    [self getDisOrderData];
    
    for (UIButton *btn in myBtns) {
        [btn setTitleColor:[UIColor_HEX colorWithHexString:@"#6a3906"] forState:UIControlStateNormal];
    }
    
    for (UIView *line in lineViews) {
        line.hidden = YES;
    }
    
    UIView *myLine  = lineViews[sender.tag];
    myLine.hidden   = NO;
    
    UIButton *myBtn = myBtns[sender.tag];
    [myBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#ff5a1e"] forState:UIControlStateNormal];
    
    [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if (sender.tag == 0) {
        nullLab.text = @"没有待处理的订单";
    }
    else if (sender.tag == 1)
    {
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

- (void) keyboardWasShown:(NSNotification *) notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue        = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect    = [aValue CGRectValue];
    height                 = keyboardRect.size.height;
    NSInteger keyboardY    = keyboardRect.origin.y;
    
    myTableView.frame      = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, keyboardY - 64);
}

- (void) keyboardWasHidden:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue        = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect    = [aValue CGRectValue];
    NSInteger keyboardY    = keyboardRect.origin.y;
    
    if (indexPag == 1) {
        myTableView.frame = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, keyboardY - 25);
    }
    else
    {
        myTableView.frame = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, keyboardY - 75);
    }
}

- (IBAction)hiddenKeyboardAction:(UITapGestureRecognizer *)sender {
    [myField resignFirstResponder];
}

//MARK: - 滑动隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [myField resignFirstResponder];
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
    switch (statusNum) {
        case 7:
            return orderResp.handleList.count;
            break;
        case 8:
            return orderResp.finishList.count;
            break;
        case 9:
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
        NSArray *views      = [[NSBundle mainBundle] loadNibNamed:@"TheOrderCell" owner:self options:nil];
        cell                = [views objectAtIndex:0];
        cell.selectionStyle = UITableViewCellStyleDefault;
    }
    
    cell.downImage.frame = CGRectMake(0, cell.bgView.frame.size.height, cell.downImage.frame.size.width, 6.5);
    cell.myScrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap             = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollDisAction:)];
    cell.myScrollView.tag                    = indexPath.section;
    
    [cell.myScrollView addGestureRecognizer:tap];
    
    cell.payBtn.hidden       = YES;
    cell.backOrderBtn.hidden = YES;
    NSDictionary *orderDic   = nil;
    
    switch (statusNum) {
        case 7:
        {
            cell.imageUrls = [orderResp.handleList[indexPath.section] objectForKey:@"goodsImgList"];
            [cell setShopImage];
            
            orderDic = orderResp.handleList[indexPath.section];
            
            switch ([[orderDic objectForKey:@"orderStatus"] integerValue]) {
                case 3:
                {
                    cell.state.text = @"配货中";
                    [cell.cancleBtn setTitle:@"开始配送" forState:UIControlStateNormal];
                    [cell.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cell.cancleBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
                    
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(startDistributionAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    
                case 4:
                {
                    cell.state.text          = @"待收货";
                    cell.goodsNum.hidden     = NO;
                    cell.goodsField.hidden   = NO;
                    cell.goodsField.tag      = indexPath.section;
                    cell.goodsField.delegate = self;
                    [cell.cancleBtn setTitle:@"验证" forState:UIControlStateNormal];
                    [cell.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cell.cancleBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
                    
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 8:
        {
            cell.imageUrls = [orderResp.finishList[indexPath.section] objectForKey:@"goodsImgList"];
            [cell setShopImage];
            
            orderDic = orderResp.finishList[indexPath.section];
            
            switch ([[orderDic objectForKey:@"orderStatus"] integerValue]) {
                case 5:
                {
                    cell.state.text         = @"已完成";
                    cell.goodsNum.hidden    = NO;
                    cell.goodsField.hidden  = NO;
                    cell.goodsField.enabled = NO;
                    cell.goodsField.text = [orderDic objectForKey:@"receiveCode"];
                    cell.cancleBtn.hidden = YES;
                    [cell.cancleBtn setTitle:@"查看点评" forState:UIControlStateNormal];
                    cell.cancleBtn.tag = indexPath.section;
                    [cell.cancleBtn addTarget:self action:@selector(disSearchEvaluation:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    
                case 6:
                {
                    cell.state.text        = @"已取消";
                    cell.cancleBtn.hidden  = YES;
                    cell.line.hidden       = YES;
                    cell.frame             = CGRectMake(0, 0, cell.frame.size.width, 130);
                    cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, 130);
                    cell.bgView.frame      = CGRectMake(0, 0, cell.frame.size.width, 124);
                    cell.downImage.frame   = CGRectMake(0, 123, cell.frame.size.width, 7);
                }
                    break;
                    
                case 7:
                {
                    cell.goodsField.enabled = NO;
                    cell.goodsField.hidden  = NO;
                    cell.goodsNum.hidden    = NO;
                    cell.state.text         = @"已完成";
                    cell.goodsField.text    = [orderDic objectForKey:@"receiveCode"];
                    cell.cancleBtn.hidden = YES;
                    [cell.cancleBtn setTitle:@"点评" forState:UIControlStateNormal];
                    [cell.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cell.cancleBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
                    [cell.cancleBtn addTarget:self action:@selector(evaluateDisAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        case 9:
        {
            cell.imageUrls = [orderResp.evaluationList[indexPath.section] objectForKey:@"goodsImgList"];
            [cell setShopImage];
            
            orderDic = orderResp.evaluationList[indexPath.section];
            
            cell.state.text         = @"已完成";
            cell.goodsField.enabled = NO;
            cell.goodsNum.hidden    = NO;
            cell.goodsField.hidden  = NO;
            cell.goodsField.text    = [orderDic objectForKey:@"receiveCode"];
            cell.cancleBtn.hidden = YES;
            [cell.cancleBtn setTitle:@"点评" forState:UIControlStateNormal];
            [cell.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.cancleBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
            [cell.cancleBtn addTarget:self action:@selector(evaluateDisAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
    
    if ([DataCheck isValidDictionary:orderDic]) {
        NSString *myDate = [NSString stringWithFormat:@"%@", [orderDic objectForKey:@"createTime"]];
        cell.date.text   = [self formatTimeStamp:[myDate substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"];
    }
    cell.sum.text    = [NSString stringWithFormat:@"共%@件商品", [orderDic objectForKey:@"totalNumber"]];
    cell.amount.text = [NSString stringWithFormat:@"合计：￥%.2f", [[orderDic objectForKey:@"totalPay"] floatValue]];
    
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
    
    UIView *footView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 16)];
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
- (void)scrollDisAction:(UIGestureRecognizer *)sender {
    NSInteger tag                          = sender.view.tag;
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    headerView.hidden                      = YES;
    switch (statusNum) {
        case 7:
            orderDetail.orderNum = [orderResp.handleList[tag] objectForKey:@"orderNo"];
            break;
            
        case 8:
            orderDetail.orderNum = [orderResp.finishList[tag] objectForKey:@"orderNo"];
            break;
            
        case 9:
            orderDetail.orderNum = [orderResp.evaluationList[tag] objectForKey:@"orderNo"];
            break;
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

//MARK: - 开始配送处理事件
- (void)startDistributionAction:(UIButton *)sender {
    NSString *orderNum = [orderResp.handleList[sender.tag] objectForKey:@"orderNo"];
    [self getDisDistributionData:orderNum];
}

//MARK: - 验证处理事件
- (void)checkAction:(UIButton *)sender {
    NSString *orderNum = [orderResp.handleList[sender.tag] objectForKey:@"orderNo"];
    [self getDisCheckData:orderNum];
}

- (void)disEvaluationAction:(UIButton *)sender {
    NSString *orderNum = nil;
    if (statusNum == 8) {
        orderNum = [orderResp.finishList[sender.tag] objectForKey:@"orderNo"];
    }
    else
    {
        orderNum = [orderResp.evaluationList[sender.tag] objectForKey:@"orderNo"];
    }
    
    EvaluationViewController *evaluation = [[EvaluationViewController alloc] init];
    evaluation.orderNum                  = orderNum;
    evaluation.type                      = @"1";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluation animated:YES];
}

//MARK: - 点击查看点评处理事件
- (void)disSearchEvaluation:(UIButton *)sender {
    NSString *orderNum = [orderResp.finishList[sender.tag] objectForKey:@"orderNo"];
    
    EvaluationViewController *evaluation = [[EvaluationViewController alloc] init];
    evaluation.orderNum = orderNum;
    evaluation.indexNum = 2;
    evaluation.type     = @"1";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluation animated:YES];
}

//MARK: - 无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        nullImage.hidden   = YES;
        nullLab.hidden     = YES;
        myTableView.hidden = YES;
        noNetWork          = [NoNetworkView sharedInstance].view;
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
    [self getDisOrderData];
}

/**
 * Method name: getDisOrderData
 * MARK: - 获取配送员我的订单列表处理方法
 */
- (void)getDisOrderData {
    if ([self noNetwork]) {
        return;
    }
    
    if ([UserLoginModel isLogged]) {
        [self showHUD];
        
        NSString *status = [NSString stringWithFormat:@"%ld", (long)statusNum];
        NSString *page   = [NSString stringWithFormat:@"%ld", (long)pageNum];
        
        [client requestMethodWithMod:@"order/getOrders"
                              params:nil
                          postParams:@{@"status":status, @"pageNum":page}
                            delegate:self
                            selector:@selector(getDisOrderDataSuccessed:)
                       errorSelector:@selector(getDisOrderDatafiled:)
                    progressSelector:nil];
    }
}

- (void)getDisOrderDataSuccessed:(NSDictionary *)response {
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
            case 7:
                orderResp.handleList = [response objectForKey:@"orderList"];
                
                for (NSDictionary *dic in orderResp.handleList) {
                    [myOrderLists addObject:dic];
                }
                if (pageNum > 1) {
                    orderResp.handleList = myOrderLists;
                }
                
                break;
            case 8:
                orderResp.finishList = [response objectForKey:@"orderList"];
                
                for (NSDictionary *dic in orderResp.finishList) {
                    [myOrderLists addObject:dic];
                }
                if (pageNum > 1) {
                    orderResp.finishList = myOrderLists;
                }
                
                break;
            case 9:
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
            nullLab.hidden   = YES;
        }
        else
        {
            myTableView.hidden = YES;
            nullLab.hidden     = NO;
            nullImage.hidden   = NO;
        }
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}

- (void)getDisOrderDatafiled:(NSDictionary *)response {
    myTableView.hidden = YES;
    
    if (pageNum > 1) {
        pageNum --;
    }
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}

/**
 * Method name: getDisCheckData
 * MARK: - 订单验证处理方法
 * Parameter: orderNum
 */
- (void)getDisCheckData:(NSString *)orderNum {
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
                        selector:@selector(getDisCheckDataSuccessed:)
                   errorSelector:@selector(getDisCheckDatafiled:)
                progressSelector:nil];
}

- (void)getDisCheckDataSuccessed:(NSDictionary *)response {
    
    myOrderLists = [NSMutableArray array];
    pageNum = 1;
    [self getDisOrderData];
    [myTableView reloadData];
    
    [self hidenHUD];
}

- (void)getDisCheckDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

/**
 * Method name: getDistributionData
 * MARK: - 开始配送处理方法
 * Parameter: orderNum
 */
- (void)getDisDistributionData:(NSString *)orderNum {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    [self showHUD];
    
    [client requestMethodWithMod:@"business/delivery"
                          params:nil
                      postParams:@{@"orderNo":orderNum}
                        delegate:self
                        selector:@selector(getDisDistributionDataSuccessed:)
                   errorSelector:@selector(getDisDistributionDatafiled:)
                progressSelector:nil];
}

- (void)getDisDistributionDataSuccessed:(NSDictionary *)response {
    
    myOrderLists = [NSMutableArray array];
    pageNum = 1;
    [self getDisOrderData];
    [myTableView reloadData];
    
    [self hidenHUD];
}

- (void)getDisDistributionDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

- (void)headerRereshing {
    myOrderLists = [NSMutableArray array];
    pageNum = 1;
    scrollNum = 1;
    [self getDisOrderData];
}

- (void)footerRereshing {
    pageNum ++;
    [self getDisOrderData];
}

/**
 * Method name: evaluateAction
 * MARK: - 点评处理方法
 * Parameter: sender
 */
- (void)evaluateDisAction:(UIButton *)sender {
    NSString *orderNum = nil;
    if (statusNum == 8) {
        orderNum = [orderResp.finishList[sender.tag] objectForKey:@"orderNo"];
    }
    else
    {
        orderNum = [orderResp.evaluationList[sender.tag] objectForKey:@"orderNo"];
    }
    
    EvaluationViewController *evaluation = [[EvaluationViewController alloc] init];
    evaluation.orderNum = orderNum;
    evaluation.indexNum = 1;
    evaluation.type     = @"1";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluation animated:YES];
}

- (void)dealloc {
    [headerView removeFromSuperview];
}

@end
