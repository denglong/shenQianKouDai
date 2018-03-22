//
//  ChangeViewController.m
//  KingProFrame
//
//  Created by 李栋 on 15/7/30.
//  Copyright (c) 2015年 king. All rights reserved.
//

//此类暂时没用
#import "ChangeViewController.h"
#import "CodeLoginViewController.h"
#import "PasswordWayViewController.h"

@interface ChangeViewController ()

@end

@implementation ChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title = @"修改密码";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (IBAction)twoWayButtonPress:(id)sender {
    UIButton *button = (UIButton *)sender;
    self.hidesBottomBarWhenPushed = YES;
    switch (button.tag) {
        case 0:
        {
            PasswordWayViewController *passwordWay = [[PasswordWayViewController alloc]init];
            [self.navigationController pushViewController:passwordWay animated:YES];
        }
            break;
        case 1:
        {
            CodeLoginViewController *codeLogin = [[CodeLoginViewController alloc]init];
            [self.navigationController pushViewController:codeLogin animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
