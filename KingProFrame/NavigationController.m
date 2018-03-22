//
//  NavigationController.m
//  KingProFrame
//
//  Created by JinLiang on 15/7/1.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view setBackgroundColor:[UIColor clearColor]];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)loadView
{
    [super loadView];
    
    UINavigationBar *bar = self.navigationBar;
    bar.tintColor = [UIColor blackColor];
//    [bar setBackgroundColor:[UIColor clearColor]];
    self.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 如果当前显示的是第一个子控制器,就应该禁止掉[返回手势]
    return self.childViewControllers.count > 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
