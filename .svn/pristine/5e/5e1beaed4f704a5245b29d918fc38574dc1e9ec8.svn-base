//
//  LaunchViewController.m
//  KingProFrame
//
//  Created by JinLiang on 15/6/26.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "LaunchViewController.h"
#import "TabBarController.h"
#import "HomeViewController.h"
#import "NavigationController.h"
#import "MyViewController.h"
#import "CategoryController.h"
#import "MyOrderController.h"
#import "DistributionViewController.h"
#import "BusinessOrderController.h"
#import "LoginViewController.h"
#import "CYShopCartingViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (UITabBarController *)creatTabBarController{
    
    //设置状态栏属性
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    //首页
    HomeViewController *homeControl = [[HomeViewController alloc] init];
    NavigationController *navHome=[[NavigationController alloc]initWithRootViewController:homeControl];
    navHome.tabBarItem.title = @"首页";
    homeControl.navigationController.navigationBarHidden = YES;
    navHome.tabBarItem.tag=0;
    
    //分类
    CategoryController *categoryControl=[[CategoryController alloc]initWithNibName:@"CategoryController" bundle:nil];
    NavigationController *navCategory=[[NavigationController alloc]initWithRootViewController:categoryControl];
    navCategory.tabBarItem.tag=1;
    
    //购物车
    CYShopCartingViewController *shoppingCartController = [[CYShopCartingViewController alloc]initWithNibName:@"CYShopCartingViewController" bundle:nil];
    NavigationController *navShopCart=[[NavigationController alloc]initWithRootViewController:shoppingCartController];
    navShopCart.tabBarItem.tag=2;
    
    //订单
    MyOrderController *orderControl = [[MyOrderController alloc] initWithNibName:@"MyOrderController" bundle:nil];
    NavigationController *navOrder=[[NavigationController alloc]initWithRootViewController:orderControl];
    navOrder.tabBarItem.tag=3;
    
    //我的
    MyViewController *myControl=[[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil];
    NavigationController *navMy=[[NavigationController alloc]initWithRootViewController:myControl];
    navMy.tabBarItem.tag=4;
    
    TabBarController *tabBarControl=[TabBarController sharedInstance];
    NSArray *controllers=[NSArray arrayWithObjects:navHome, navCategory, navShopCart, orderControl, myControl, nil];
    tabBarControl.viewControllers=controllers;
    tabBarControl.selectedIndex=0;
    
    UITabBarItem * item=[tabBarControl.tabBar.items objectAtIndex:tabBarControl.selectedIndex];
    
    //设置tabbar的标题颜色
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor_HEX colorWithHexString:@"#ffffff"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
//    [[CommClass sharedCommon] setObject:@[homeControl, categoryControl] forKey:@"myRootViewController"];
    
    return tabBarControl;
}


//创建登录controller
+(UIViewController*)creatLoginController{
    
    LoginViewController *loginView=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    NavigationController *navLog=[[NavigationController alloc]initWithRootViewController:loginView];
    
    return navLog;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
