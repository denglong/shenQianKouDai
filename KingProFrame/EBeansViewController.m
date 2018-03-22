//
//  EBeansViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/7/30.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "EBeansViewController.h"
#import "BalanceCell.h"

#import "eBeansHeaderCell.h"
#import "RultsWebViewController.h"
#import "GeneralShowWebView.h"
#import "EBeanDetail.h"
#import "EBean.h"
@interface EBeansViewController ()<UITableViewDataSource,UITableViewDelegate,reloadDelegate>
{
    CloudClient * _cloudClient;
    NSInteger _pageNum;
    NSMutableArray * list;
    UIView * noNetWork;
}
@property (nonatomic , retain) EBeanDetail * eBeanDetail;
@property (weak, nonatomic) IBOutlet UIView *nullView;
@property (weak, nonatomic) IBOutlet UITableView *eBeansTableView;
@end

@implementation EBeansViewController
//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        [super hidenHUD];
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
    [self showHUD];
    [self headerRereshing];
}

-(void)getEBeansDetail
{
    if ([self noNetwork]) {
        [self hidenHUD];
        return;
    }
    NSString * _pageStr = [NSString stringWithFormat:@"%ld",(long)_pageNum];
    NSDictionary * postParams = @{@"pageNum":_pageStr};
    [_cloudClient requestMethodWithMod:@"member/getEpeaDetail"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(getEBeansDetailSuccessed:)
                         errorSelector:@selector(getEBeansDetailError:)
                      progressSelector:nil];
    
}
-(void)getEBeansDetailSuccessed:(NSDictionary *)response
{
    self.eBeanDetail = [EBeanDetail mj_objectWithKeyValues:response];
    NSArray * more = self.eBeanDetail.detailList;
    
    if (_pageNum == 1) {
        list = [NSMutableArray arrayWithArray:more];
        [[CommClass sharedCommon] removeObjectForKey:EBEANRED];
    }else {
        if ([DataCheck isValidArray:more]) {
            [list addObjectsFromArray:more];
        }else{
            _pageNum--;
        }
    }
    
    if (![DataCheck isValidArray:list]) {
        self.nullView.hidden = NO;
    }
    self.eBeansTableView.hidden = NO;
    [self.eBeansTableView reloadData];
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}
-(void)getEBeansDetailError:(NSDictionary *)response
{
    if (_pageNum >1) {
        _pageNum--;
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
    
    if ([[[CommClass sharedCommon] objectForKey:@"GeTuiTag"] integerValue] == 100) {
        [[CommClass sharedCommon] setObject:@"10" forKey:@"GeTuiTag"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title = @"e豆";
    self.navigationController.navigationBarHidden = NO;

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([UserLoginModel isLogged]) {
//        [self setupRefresh:self.eBeansTableView];
        [self setupHeaderRefresh:self.eBeansTableView];
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
    self.navigationItem.rightBarButtonItem =[super createRightItem:self itemStr:nil itemImage:[UIImage imageNamed:@"help"] itemImageHG:[UIImage imageNamed:@"help"] selector:@selector(eBeansHelp)];
    [self eBeanRegisterCell];
    [super setExtraCellLineHidden:self.eBeansTableView];
    self.eBeansTableView.hidden = YES;
   
    _cloudClient = [CloudClient getInstance];
    
    if (self.xgTag == 1) {
        UIBarButtonItem *backbutton = [self createLeftItem:self itemStr:nil itemImage:UIIMAGE(@"back.png") itemImageHG:UIIMAGE(@"back_p.png") selector:@selector(backAction:)];
        self.navigationItem.leftBarButtonItem = backbutton;
    }
    [self setUpFooterRefresh:self.eBeansTableView];

}

/**
   e豆列表注册Cell
 **/
-(void)eBeanRegisterCell
{
    [self.eBeansTableView registerNib:[UINib nibWithNibName:@"BalanceCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BalanceCell class])];
    [self.eBeansTableView registerNib:[UINib nibWithNibName:@"eBeansHeaderCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([eBeansHeaderCell class])];
}

//下拉刷新方法
-(void)headerRereshing
{
    _pageNum = 1;
    [self getEBeansDetail];
}
//上拉加载方法
-(void)footerRereshing
{
    _pageNum++;
    [self getEBeansDetail];
}
-(void)eBeansHelp{
    RultsWebViewController * rultsWebViewController = [[RultsWebViewController alloc]init];
    rultsWebViewController.ViewTag = 101;
    rultsWebViewController.urlStr = self.eBeanDetail.epeaUrl;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rultsWebViewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    if (indexPath.section == 0) {
        eBeansHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([eBeansHeaderCell class])];
        if ([DataCheck isValidString:self.eBeanDetail.shopUrl]) {
            [cell.eBeansBtn addTarget:self action:@selector(eBeanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell setEBeanDetail:self.eBeanDetail];
        return cell;
    }
    
    BalanceCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BalanceCell class])];
    [cell setEBean:[list objectAtIndex:indexPath.section-1]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 e豆兑换事件
 */

-(void)eBeanBtnAction:(UIButton *)sender
{
    GeneralShowWebView * generalShowWebView = [[GeneralShowWebView alloc]init];
    generalShowWebView.advUrlLink = self.eBeanDetail.shopUrl;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalShowWebView animated:YES];
}
@end
