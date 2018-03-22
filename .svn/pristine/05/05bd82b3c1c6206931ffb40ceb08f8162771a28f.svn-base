//
//  MyViewController.m
//  Eqbang_shop
//
//  Created by lihualin on 15/7/27.
//  Copyright (c) 2015年 lihualin. All rights reserved.
//

#import "MyViewController.h"
#import "MyheaderCell.h"
#import "MyOtherCell.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "BalanceViewController.h"
#import "SettingsViewController.h"
#import "EBeansViewController.h"
#import "AttendantViewController.h"
#import "MyInfoViewController.h"
#import "MyAddressViewController.h"
#import "CouponViewController.h"
#import "MsgSortViewController.h"
#import "RecommendFriendsViewController.h"
#import "MyOrderController.h"
#import "BusinessOrderController.h"
#import "DistributionViewController.h"
#import "MyOrderController.h"
#import "VipPrivilegeController.h"

#import "ShopCartController.h"
#import "TabBarController.h"
#import "GeneralShowWebView.h"
#import "NavigationController.h"

#import "BusinessInfoViewController.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    NSArray * titles;
    CloudClient * _cloudClient;
}
//@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation MyViewController

#pragma mark - getInfo
-(void)getMyInfoData
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        [super hidenHUD];
        return;
    }
    [_cloudClient requestMethodWithMod:@"member/getUserInfo"
                                params:nil
                            postParams:nil
                              delegate:self
                              selector:@selector(getMyInfoSuccessed:)
                         errorSelector:@selector(getMyInfoError:)
                      progressSelector:nil];
    
}
-(void)getMyInfoSuccessed:(NSDictionary *)response
{
    [self hidenHUD];
    NSArray * userInfoArray =[response objectForKey:@"profileList"];
    for (int i = 0; i<userInfoArray.count; i++) {
        [MyInfoModel setClassEmue:[userInfoArray objectAtIndex:i]];
    }
    
    [self.myTableView reloadData];
}
-(void)getMyInfoError:(NSDictionary *)response
{
    [self hidenHUD];
}

-(void)setTitles
{
//    titles = @[@[@{@"image":@"huiyuan",@"title":@"会员特权"}],
//               @[@{@"image":@"icon_dizhi",@"title":@"我的收货地址"}],
//               @[@[@{@"image":@"shezhi",@"title":@"设置"}],
//               @[@{@"image":@"tuijian",@"title":@"推荐给好友"}],
//               @[@{@"image":@"lianxiwomen",@"title":@"联系客服"}]]];
    titles = @[@[@{@"image":@"huiyuan",@"title":@"会员特权"}],
               @[@{@"image":@"icon_dizhi",@"title":@"我的收货地址"}],
               @[@[@{@"image":@"shezhi",@"title":@"设置"}],
                 @[@{@"image":@"lianxiwomen",@"title":@"联系客服"}]]];
}


/**返回事件*/
-(void)backHomeAction:(UIButton *)sender
{
    [super backAction:sender];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
   
    if ([UserLoginModel isLogged]) {
        if ([[[CommClass sharedCommon] objectForKey:@"GeTuiTag"] integerValue] != 10) {
            [self getMyInfoData];
        }
        
        [[CommClass sharedCommon] setObject:@"1" forKey:@"GeTuiTag"];
    }else{
        [self.myTableView reloadData];
    }

}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenHUD];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitles];
    [self createMyTableView];
//    [self setExtraCellLineHidden:self.myTableView];
    _cloudClient = [CloudClient getInstance];
    //红点小通知
    if ([UserLoginModel isAverageUser]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redDian:) name:@"MyRed" object:nil];
    }
}

- (void)createMyTableView {
    
    self.myTableView = [[UITableView alloc] init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    self.myTableView.backgroundColor = self.view.backgroundColor;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(-20, 0, 0, 0);
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view).insets(edge);
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
   推送红点显示
 */
-(void)redDian:(NSNotification *)not
{
    NSString * msgType = [not object];
    self.tabBarItem.badgeValue = @"";
    if ([msgType integerValue] == 510) {
        [[CommClass sharedCommon] setObject:@"YES" forKey:COUPONRED];
        NSIndexPath * index =[NSIndexPath indexPathForRow:0 inSection:0];
        [self.myTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    if ([msgType integerValue] == 600) {
        [[CommClass sharedCommon] setObject:@"YES" forKey:EBEANRED];
        NSIndexPath * index =[NSIndexPath indexPathForRow:0 inSection:0];
        [self.myTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 2;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return LHLMyHeaderRowHeight;
    }
    
    return LHLRowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return LHLHeaderHeight;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, LHLHeaderHeight)];
    view.backgroundColor = self.myTableView.backgroundColor;
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        Class class = [MyheaderCell class];
        NSString * headerIndentifier = NSStringFromClass(class);
        MyheaderCell * cell = [tableView dequeueReusableCellWithIdentifier:headerIndentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyheaderCell" owner:self options:nil] objectAtIndex:0];
        }
        MyInfoModel *infoModel=[MyInfoModel sharedInstance];
     
        [cell setInfoModel:infoModel];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editAction:)];
        [cell.headerImageView addGestureRecognizer:tap];
        [cell.eidtInfo addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.payButton addTarget:self action:@selector(orderClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.consigneeButton addTarget:self action:@selector(orderClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.finishButton addTarget:self action:@selector(orderClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.myOrderButton addTarget:self action:@selector(orderClickButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        
        Class class = [MyOtherCell class];
        NSString * otherIndentifier = NSStringFromClass(class);
        MyOtherCell * cell = [tableView dequeueReusableCellWithIdentifier:otherIndentifier];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOtherCell" owner:self options:nil] objectAtIndex:0];
        }
        NSArray * sectionTitles = [titles objectAtIndex:indexPath.section-1];
        cell.orderView.hidden = YES;
        cell.detailTitleLable.hidden = YES;
        
        if (indexPath.section == 3) {
            
            cell.dic = [sectionTitles[indexPath.row] firstObject];
        }
        else
        {
            cell.dic = [sectionTitles firstObject];
        }
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || (indexPath.section == 2 && indexPath.row == 0)) {
        
        if (![UserLoginModel isLogged]) {
            [self loginAction:nil];
            return;
        }
    }
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.section) {
        case 1://会员特权
        {
            VipPrivilegeController *vipPrivilege = [[VipPrivilegeController alloc] init];
            [self.navigationController pushViewController:vipPrivilege animated:YES];
        }
            break;
        case 2://我的收货地址
        {
            MyAddressViewController *myAddress = [[MyAddressViewController alloc] initWithNibName:@"MyAddressViewController" bundle:nil];
            [self.navigationController pushViewController:myAddress animated:YES];
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0://设置
                {
                    SettingsViewController *settingsViewController = [[SettingsViewController alloc]init];
                    [self.navigationController pushViewController:settingsViewController animated:YES];
                }
                    break;
                    
//                case 1://推荐给好友
//                {
//                    RecommendFriendsViewController *recommendFriendsVC = [[RecommendFriendsViewController alloc]init];
//                    [self.navigationController pushViewController:recommendFriendsVC animated:YES];
//                }
//                    break;
                    
                case 1://联系客服
                {
                    [SRMessage infoMessage:[NSString stringWithFormat:@"是否拨打客服电话？"] block:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"13310953123"]]];
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;

        default:
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
}

//我的资料
-(void)editAction:(id)sender
{
    if (![UserLoginModel isLogged]) {
        [self loginAction:nil];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    [MobClick event:Edit_AcctInfo];
    MyInfoViewController * MyInfoViewcontroller = [[MyInfoViewController alloc]init];
    [self.navigationController pushViewController:MyInfoViewcontroller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//登录
-(void)loginAction:(id)sender
{
    [[AppModel sharedModel] presentLoginController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

//注册
-(void)resigerAction:(UIButton *)sender
{
 
    [MobClick event:Clik_Reg];
    RegisterViewController * registerViewcontroller = [[RegisterViewController alloc]init];
    registerViewcontroller.viewTag = -1;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerViewcontroller animated:YES];
}

#pragma mark - notLoginview

-(void)notLoginAction:(UIButton *)sender
{
    if (![UserLoginModel isLogged]) {
        [self loginAction:nil];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    switch (sender.tag) {
        case 102:
        {
            //优惠券
            [MobClick event:Query_MyCoupon];
            CouponViewController * couponViewController = [[CouponViewController alloc]init];
            [self.navigationController pushViewController:couponViewController animated:YES];
            [[CommClass sharedCommon] removeObjectForKey:COUPONRED];
        }
            break;
        case 103:
        {
            //e豆
            [MobClick event:Query_eBean];
            EBeansViewController * eBeansviewController = [[EBeansViewController alloc]init];
            [self.navigationController pushViewController:eBeansviewController animated:YES];
            [[CommClass sharedCommon] removeObjectForKey:EBEANRED];
        }
            break;
        case 201:
        {
            //普通用户 我的订单待处理
            MyOrderController *theOrderController = [[MyOrderController alloc] init];
            theOrderController.statusNum = 1;
            [self.navigationController pushViewController:theOrderController animated:YES];
        }
            break;
        case 202:
        {
            //普通用户 我的订单已完成
            MyOrderController *theOrderController = [[MyOrderController alloc] init];
            theOrderController.statusNum = 2;
            [self.navigationController pushViewController:theOrderController animated:YES];
        }
            break;
        case 203:
        {
            //普通用户 我的订单待点评
            MyOrderController *theOrderController = [[MyOrderController alloc] init];
            theOrderController.statusNum = 3;
            [self.navigationController pushViewController:theOrderController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)orderClickButton:(UIButton *)sender {
    
    MyOrderController *theOrderController = [[MyOrderController alloc] init];
    switch (sender.tag) {
        case waitPayOrderType:
            theOrderController.statusNum = 1;
            break;
            
        case waitConsigneeOrderType:
            theOrderController.statusNum = 2;
            break;
            
        case finishOrderType:
            theOrderController.statusNum = 3;
            break;
            
        case myOrderType:
            theOrderController.statusNum = 0;
            break;
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:theOrderController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
