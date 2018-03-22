//
//  AttendantViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/7/31.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "AttendantViewController.h"
#import "AttengantCell.h"
#import "AddAttendantViewController.h"
#import "ListModel.h"
#import "Attendant.h"
@interface AttendantViewController ()<UITableViewDataSource,UITableViewDelegate,reloadDelegate>
{
    NSMutableArray * list;
    CloudClient * _cloudClient;
    UIView * noNetWork;
    NSInteger _pageNum;
//    UIView * nullView;
}
@property (weak, nonatomic) IBOutlet UIView *nullView;
@property (weak, nonatomic) IBOutlet UITableView *attendantTableView;
@end

@implementation AttendantViewController


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
     [super showHUD];
   [self headerRereshing];
}

-(void)getDeliveryData
{
    if ([self noNetwork]) {
        return;
    }
    NSDictionary * postParams = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum]};
    [_cloudClient requestMethodWithMod:@"member/getDelivery"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(getDeliveryDataSuccessed:)
                         errorSelector:@selector(getDeliveryDataError:)
                      progressSelector:nil];
    
}
-(void)getDeliveryDataSuccessed:(NSDictionary *)response
{
    [self hidenHUD];
    if ([DataCheck isValidDictionary:response]) {
        ListModel * more = [ListModel mj_objectWithKeyValues:response];
        if ([DataCheck isValidArray:more.deliveryList]) {
            if (_pageNum == 1) {
                list = [NSMutableArray arrayWithArray:more.deliveryList];
            }else{
                [list addObjectsFromArray:more.deliveryList];
            }
        }else{
            if (_pageNum > 1) {
                _pageNum--;
            }else{
               [list removeAllObjects];
            }
        }
        if (![DataCheck isValidArray:list]) {
            self.nullView.hidden = NO;
            self.attendantTableView.hidden = YES;
        }else{
            self.nullView.hidden = YES;
            self.attendantTableView.hidden = NO;
            [self.attendantTableView reloadData];
        }
        [self.refreshHeaderView endRefreshing];
        [self.refreshFooterView endRefreshing];
    }
   
}
-(void)getDeliveryDataError:(NSDictionary *)response
{
    if (_pageNum >1) {
        _pageNum--;
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [self hidenHUD];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的配送员";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([UserLoginModel isLogged]) {
//        [self setupRefresh:self.attendantTableView];
        
        [self setupHeaderRefresh:self.attendantTableView];
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
     self.navigationItem.rightBarButtonItem = [super createRightItem:self itemStr:@"增加" itemImage:nil itemImageHG:nil selector:@selector(addAction:)];
    [self.attendantTableView registerNib:[UINib nibWithNibName:@"AttengantCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AttengantCell class])];
    [super setExtraCellLineHidden:self.attendantTableView];
   
    //创建刷新控件
   
    _cloudClient = [CloudClient getInstance];
    [self showHUD];
    
    [self setUpFooterRefresh:self.attendantTableView];
}
//下拉刷新方法
-(void)headerRereshing
{
    _pageNum = 1;
   [self getDeliveryData];
}
//上拉加载方法
-(void)footerRereshing
{
    _pageNum++;
    [self getDeliveryData];
}

//导航栏有按钮 增加配送员
-(void)addAction:(id)sender
{
    AddAttendantViewController * addAttendant = [[AddAttendantViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addAttendant animated:YES];
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
    AttengantCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AttengantCell class])];
    Attendant * attendant = [list objectAtIndex:indexPath.section];
    [cell.cancelbtn addTarget:self action:@selector(cancelbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.cancelbtn.tag = indexPath.section;
    cell.nameLabel.text = attendant.name;
    cell.phonelabel.text = attendant.mobile;
    if (cell.nameLabel.text.length > 6) {
       cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height+10);
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
  删除配送员
 */
-(void)cancelbtnClick:(UIButton *)sender
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [SRMessage infoMessage:@"您是否确认删除该配送员" block:^{
        [super showHUD];
        Attendant * delivery = [list objectAtIndex:sender.tag];
        NSDictionary * postParams = @{@"id":delivery.ID};
        [_cloudClient requestMethodWithMod:@"member/delDelivery"
                                    params:nil
                                postParams:postParams
                                  delegate:self
                                  selector:@selector(cancelDeliveryDataSuccessed:)
                             errorSelector:@selector(cancelDeliveryDataError:)
                          progressSelector:nil];

    }];
    
}

-(void)cancelDeliveryDataSuccessed:(NSDictionary *)response
{
    [self headerRereshing];
}
-(void)cancelDeliveryDataError:(NSDictionary *)response
{
    
    [super hidenHUD];
}
@end
