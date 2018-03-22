//
//  BalanceViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/7/29.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BalanceViewController.h"
#import "BalanceCell.h"
#import "BalanceDetail.h"
#import "CashViewController.h"
#import "RultsWebViewController.h"
#import "BalanceHeaderCell.h"
@interface BalanceViewController ()<UITableViewDataSource,UITableViewDelegate,reloadDelegate>
{
    NSMutableArray * list;
    NSInteger _pageNum;
    NSArray * btnArray;
    CloudClient * _cloudClient;
    UIView * noNetWork;
}
@property (nonatomic , retain) BalanceDetail * balanceDetail;
@property (weak, nonatomic) IBOutlet UITableView *balanceTableView;



@end

@implementation BalanceViewController

//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        [super hidenHUD];
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
     [super showHUD];
    [self getBalanceDetail];
   
}
-(void)getBalanceDetail
{
    if ([self noNetwork]) {
        return;
    }
    NSString * _pageStr = [NSString stringWithFormat:@"%ld",(long)_pageNum];
    NSDictionary * postParams = @{@"pageNum":_pageStr};
    [_cloudClient requestMethodWithMod:@"member/balanceDetail"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(getBalanceDetailSuccessed:)
                         errorSelector:@selector(getBalanceDetailError:)
                      progressSelector:nil];
    
}
-(void)getBalanceDetailSuccessed:(NSDictionary *)response
{
    [ResponseModel class:@"BalanceDetail" dic:response];
    self.balanceDetail = [BalanceDetail mj_objectWithKeyValues:response];
    if ([DataCheck isValidArray:self.balanceDetail.detailList]) {
        if (_pageNum == 1) {
            list = [NSMutableArray arrayWithArray:self.balanceDetail.detailList];
        }else{
            [list addObjectsFromArray:self.balanceDetail.detailList];
        }
    }else{
        if (_pageNum >1) {
            _pageNum-- ;
        }
    }
    self.balanceTableView.hidden = NO;
    [self.balanceTableView reloadData];
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}
-(void)getBalanceDetailError:(NSDictionary *)response
{
    [self hidenHUD];
    if (_pageNum >1) {
        _pageNum--;
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    if ([[[CommClass sharedCommon] objectForKey:@"GeTuiTag"] integerValue] == 100) {
        [[CommClass sharedCommon] setObject:@"10" forKey:@"GeTuiTag"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}
//下拉刷新方法
-(void)headerRereshing
{
    _pageNum = 1;
    [self getBalanceDetail];
}
//上拉加载方法
-(void)footerRereshing
{
    _pageNum++;
    [self getBalanceDetail];
}
#pragma mark - 提现
-(void)cashClick:(UIButton *)sender
{
    [MobClick event:Clik_GetCash];
    CashViewController * cashViewController = [[CashViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cashViewController animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title = @"余额";
    self.navigationController.navigationBarHidden = NO;
  
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([UserLoginModel isLogged]) {
//        [self setupRefresh:self.balanceTableView];
        [self setupHeaderRefresh:self.balanceTableView];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self balanceRegisterCell];
    self.balanceTableView.hidden = YES;
    [super setExtraCellLineHidden:self.balanceTableView];
     self.navigationItem.rightBarButtonItem =[super createRightItem:self itemStr:nil itemImage:[UIImage imageNamed:@"help"] itemImageHG:[UIImage imageNamed:@"help"] selector:@selector(cashViewHelp)];
   _cloudClient = [CloudClient getInstance];
    [super showHUD];
    
    if (self.xgTag == 1) {

        
        self.navigationItem.leftBarButtonItem = [super createLeftItem:self itemStr:nil itemImage:UIIMAGE(@"back.png") itemImageHG:nil selector:@selector(backAction:)];
    }
    
    [self setUpFooterRefresh:self.balanceTableView];
}

/**
    余额列表注册cell
 **/
-(void)balanceRegisterCell
{
    [self.balanceTableView registerNib:[UINib nibWithNibName:@"BalanceHeaderCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BalanceHeaderCell class])];
    [self.balanceTableView registerNib:[UINib nibWithNibName:@"BalanceCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BalanceCell class])];
}

- (void)backAction:(id)sender {
    if (self.xgTag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  提现规则
 */
-(void)cashViewHelp
{
    [MobClick event:Clik_Cash_Rule];
    RultsWebViewController * rultsWebViewController = [[RultsWebViewController alloc]init];
    rultsWebViewController.ViewTag = 301;
    rultsWebViewController.urlStr = self.balanceDetail.ruleUrl;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rultsWebViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return list.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        UIView *headerView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
        headerView.backgroundColor = [UIColor clearColor];
        
        return headerView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BalanceHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BalanceHeaderCell class])];
        [cell setBalanceDetail:self.balanceDetail];
        if ([self.balanceDetail.ifWithdraw integerValue] ==1) {
            [cell.btn addTarget:self action:@selector(cashClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }else{
        BalanceCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BalanceCell class])];
        [cell setBalance:[list objectAtIndex:indexPath.section-1]];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
