//
//  CouponViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/8/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponCell.h"
#import "RultsWebViewController.h"
#import "CouponListModel.h"
@interface CouponViewController ()<UITableViewDataSource,UITableViewDelegate,reloadDelegate>
{
    CloudClient * _cloudClient;
    NSInteger _pageNum;
    NSMutableArray * list;
    UIView * noNetWork;
    NSDictionary * btnAndLine;
    NSString * state; //优惠券状态
    NSString * ruleUrl;
    BOOL isScoller; //是否滚动
}
/** 优惠券列表*/
@property (weak, nonatomic) IBOutlet UITableView *couponTableView;
/** 未使用按钮*/
@property (weak, nonatomic) IBOutlet UIButton *unusedBtn;
/** 已使用按钮*/
@property (weak, nonatomic) IBOutlet UIButton *usedBtn;
/** 已过期按钮*/
@property (weak, nonatomic) IBOutlet UIButton *outDateBtn;
/** 未使用按钮*/
@property (weak, nonatomic) IBOutlet UIView *unusedLine;
/** 已使用按钮*/
@property (weak, nonatomic) IBOutlet UIView *usedLine;
/** 已过期按钮*/
@property (weak, nonatomic) IBOutlet UIView *outDateLine;
/** 空页面*/
@property (weak, nonatomic) IBOutlet UIButton *nullView;
/** 切换按钮事件*/
- (IBAction)selectedBtnClick:(UIButton *)sender;
@end

@implementation CouponViewController

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
    [self showHUD];
    [self headerRereshing];
}

#pragma mark - 获取优惠券列表
-(void)getCouponListData
{
    if ([self noNetwork]) {
        return;
    }
    NSString * _pageStr = [NSString stringWithFormat:@"%ld",(long)_pageNum];
    NSDictionary * postParams = @{@"pageNum":_pageStr,
                                  @"state":state};
    [_cloudClient requestMethodWithMod:@"member/getCoupon"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(getCouponListSuccessed:)
                         errorSelector:@selector(getCouponListError:)
                      progressSelector:nil];
    
}
-(void)getCouponListSuccessed:(NSDictionary *)response
{
   
    CouponListModel * couponList = [CouponListModel mj_objectWithKeyValues:response];
    ruleUrl = couponList.ruleUrl;
    if (_pageNum == 1) {
         [list removeAllObjects];
    }
    if ([DataCheck isValidArray:couponList.couponList]) {
        [list addObjectsFromArray:couponList.couponList];
        if (_pageNum == 1 && [state integerValue] == 0) {
            [[CommClass sharedCommon] removeObjectForKey:COUPONRED];
        }
    }else{
        if (_pageNum > 1) {
            _pageNum--;
        }
    }
    if ([DataCheck isValidArray:list]) {
        self.nullView.hidden = YES;
        self.couponTableView.hidden = NO;
        [self.couponTableView reloadData];
    }else{
        self.couponTableView.hidden = YES;
        self.nullView.hidden = NO;
    }
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}
-(void)getCouponListError:(NSDictionary *)response
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title = @"优惠券";
    [self noNetwork];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([UserLoginModel isLogged]) {
        state = @"0";
        [super setupHeaderRefresh:self.couponTableView];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenHUD];
    [MobClick endLogPageView:NSStringFromClass([self class])];
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

/*
   规则
 */
-(void)couponHelp
{
    [MobClick event:Clik_Coupon_Rule];
    RultsWebViewController * rultsWebViewController = [[RultsWebViewController alloc]init];
    rultsWebViewController.ViewTag = 201;
    rultsWebViewController.urlStr = ruleUrl;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rultsWebViewController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor_HEX colorWithHexString:@"#F5F5F1"];
     self.navigationItem.rightBarButtonItem =[super createRightItem:self itemStr:nil itemImage:[UIImage imageNamed:@"help"] itemImageHG:[UIImage imageNamed:@"help"] selector:@selector(couponHelp)];
    [self.couponTableView registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CouponCell class])];
    [super setExtraCellLineHidden:self.couponTableView];
    [super setUpFooterRefresh:self.couponTableView];
    list = [NSMutableArray array];
    [super showHUD];
    _cloudClient = [CloudClient getInstance];
//     self.couponTableView.hidden = YES;
    
    
    btnAndLine = @{@"btn":@[self.unusedBtn,self.usedBtn,self.outDateBtn],
                   @"line":@[self.unusedLine,self.usedLine,self.outDateLine]};
    if (self.xgTag == 1) {
        UIBarButtonItem *backbutton = [self createLeftItem:self itemStr:nil itemImage:UIIMAGE(@"back.png") itemImageHG:UIIMAGE(@"back_p.png") selector:@selector(backAction:)];
        self.navigationItem.leftBarButtonItem = backbutton;
    }
}

-(void)headerRereshing
{
    _pageNum = 1;
    [self getCouponListData];
}
-(void)footerRereshing
{
    _pageNum ++;
    [self getCouponListData];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CouponCell class])];
    [cell setCoupon:[list objectAtIndex:indexPath.section]];
    return cell;
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


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    isScoller = YES;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    isScoller = NO;
//}
//-sc
#pragma mark - tap 选择 0=未使用，1=已使用，2=已过期
- (IBAction)selectedBtnClick:(UIButton *)sender {
    if (sender.selected  == YES) {
        return;
    }
    if ([self.refreshHeaderView isRefreshing]) {
        return;
    }
    NSArray * btnArr = [btnAndLine objectForKey:@"btn"];
    for (UIButton * btn in btnArr) {
        btn.selected = NO;
    }
    NSArray * lineArr = [btnAndLine objectForKey:@"line"];
    for (UIView * line in lineArr) {
        if (line.tag == sender.tag) {
            line.hidden = NO;
        }else{
            line.hidden = YES;
        }
    }
    sender.selected = YES;
    state = [NSString stringWithFormat:@"%ld",sender.tag];

    [self headerRereshing];
}



@end
