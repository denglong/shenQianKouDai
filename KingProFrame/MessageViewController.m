
//
//  MessageViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/8/5.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "OrderDetailViewController.h"
#import "CouponViewController.h"
#import "OrderDetailController.h"
#import "BalanceViewController.h"
#import "GeneralShowWebView.h"
#import "EBeansViewController.h"
#import "Headers.h"
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,reloadDelegate>
{
    CloudClient * _cloudClient;
    NSMutableArray * list;
    NSInteger _pageNum;
    UIView * noNetWork;
}
@property (weak, nonatomic) IBOutlet UIButton *nullView;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@end

@implementation MessageViewController

//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        [super hidenHUD];
        return NO;
    }
    else
    {
        [noNetWork removeFromSuperview];
        return NO;
    }
}

-(void)reloadAgainAction
{
    [super showHUD];
    [self headerRereshing];
}
-(void)getMessageData
{
    if ([self noNetwork]) {
        return;
    }
    NSString * pageStr = [NSString stringWithFormat:@"%ld",(long)_pageNum];
    [_cloudClient requestMethodWithMod:@"member/getMsg"
                                params:nil
                            postParams:@{@"pageNum":pageStr,@"msgType":self.msgType}
                              delegate:self
                              selector:@selector(getMessageDataSuccess:)
                         errorSelector:@selector(getMessageDataError:)
                      progressSelector:nil];
}

-(void)getMessageDataSuccess:(NSDictionary *)response
{
    NSArray * msgList = [response objectForKey:@"msgList"];
    [super hidenHUD];
    if (_pageNum == 1) {
        list = [NSMutableArray arrayWithArray:msgList];
    }else{
        if ([DataCheck isValidArray:msgList]) {
            [list addObjectsFromArray:msgList];
        }else{
            _pageNum--;
        }
    }
    if ([DataCheck isValidArray:list]) {
        self.nullView.hidden = YES;
        self.messageTableView.hidden = NO;
        [self.messageTableView reloadData];
    }else{
        self.messageTableView.hidden = YES;
        self.nullView.hidden = NO;
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
}
-(void)getMessageDataError:(NSDictionary *)response
{
    if ([[[CommClass sharedCommon] objectForKey:@"GeTuiTag"] integerValue] == 100) {
        [[CommClass sharedCommon] setObject:@"10" forKey:@"GeTuiTag"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [super hidenHUD];
    if (_pageNum >1) {
        _pageNum--;
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
}

-(void)headerRereshing
{
    _pageNum = 1;
  [self getMessageData];
}

-(void)footerRereshing
{
    _pageNum++;
    [self getMessageData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
//    self.title =@"消息中心";
    [[CommClass sharedCommon] setObject:@"1" forKey:@"messageController"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([UserLoginModel isLogged]) {
//        [super setupRefresh:self.messageTableView];
        [self setupHeaderRefresh:self.messageTableView];

    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [[CommClass sharedCommon] setObject:@"0" forKey:@"messageController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [super setExtraCellLineHidden:self.messageTableView];
    _cloudClient = [CloudClient getInstance];
    [super showHUD];
    //取消按钮
    if (self.indexXG == 1) {
        self.navigationItem.leftBarButtonItem =  [self createLeftItem:self
                                                              itemStr:nil
                                                            itemImage:[UIImage imageNamed:@"back"]
                                                          itemImageHG:nil
                                                             selector:@selector(leftCancelAction)];
    }
    [self setUpFooterRefresh:self.messageTableView];
}

- (void)leftCancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return list.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = [MessageCell class];
    NSString * indentifier = NSStringFromClass(class);
    MessageCell * cell =[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:0];
    }
    NSDictionary * msgDic = [list objectAtIndex:indexPath.section];
    [cell setMsgDic:msgDic];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
   NSDictionary * msgDic = [list objectAtIndex:indexPath.section];
    if ([[msgDic objectForKey:@"type"] integerValue] == 1) {
        //订单消息
        OrderDetailViewController * orderDetailViewController = [[OrderDetailViewController alloc]init];
        orderDetailViewController.orderNum = [msgDic objectForKey:@"orderNo"];
        [self.navigationController pushViewController:orderDetailViewController animated:YES];
        return;
    }
    
    if ([[msgDic objectForKey:@"type"] integerValue] == 2) {
        //系统消息
        GeneralShowWebView * msgWebViewController = [[GeneralShowWebView alloc]init];
        msgWebViewController.advUrlLink = [msgDic objectForKey:@"orderNo"];
        [self.navigationController pushViewController:msgWebViewController animated:YES];
        return;
    }
    
    if ([[msgDic objectForKey:@"type"] integerValue] == 3) {
        //优惠券消息
        CouponViewController * couponViewController = [[CouponViewController alloc]init];
        [self.navigationController pushViewController:couponViewController animated:YES];
        return;
    }
    if ([[msgDic objectForKey:@"type"] integerValue] == 4) {
        //商家待抢单消息
        OrderDetailController * orderDetailController = [[OrderDetailController alloc]init];
        orderDetailController.orderNum = [msgDic objectForKey:@"orderNo"];
        [self.navigationController pushViewController:orderDetailController animated:YES];
        return;
    }
    if ([[msgDic objectForKey:@"type"] integerValue] == 5) {
        //e豆消息
        EBeansViewController * eBeansViewController = [[EBeansViewController alloc]init];
        [self.navigationController pushViewController:eBeansViewController animated:YES];
        return;
    }


}
@end
