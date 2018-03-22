//
//  SelectedAttendantViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/8/22.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "SelectedAttendantViewController.h"
#import "MyInfoModel.h"
@interface SelectedAttendantViewController ()
@property (weak, nonatomic) IBOutlet UIButton *coPeopleBtn;
@property (weak, nonatomic) IBOutlet UIButton *attPeopleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)btnClick:(UIButton *)sender;
@end

@implementation SelectedAttendantViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    self.title = @"选择身份";
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.coPeopleBtn.layer.cornerRadius = self.coPeopleBtn.frame.size.height/2;
    self.attPeopleBtn.layer.cornerRadius = self.attPeopleBtn.frame.size.height/2;
    self.sureBtn.layer.cornerRadius = 3;
    self.attPeopleBtn.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(UIButton *)sender {
    
    if (sender == self.coPeopleBtn) {
        [[MyInfoModel sharedInstance] setIfDelivery:@"0"];
        self.attPeopleBtn.selected = NO;
        self.coPeopleBtn.selected = YES;
        [[CommClass sharedCommon]setObject:@"0" forKey:LOGGED_MARKIYPE];
        return;
    }
    if (sender == self.attPeopleBtn) {
        [[MyInfoModel sharedInstance] setIfDelivery:@"1"];
        [[CommClass sharedCommon]setObject:@"1" forKey:LOGGED_MARKIYPE];
        self.attPeopleBtn.selected = YES;
        self.coPeopleBtn.selected = NO;
        return;
    }
    if (sender == self.sureBtn) {
        NSString * token = [[CommClass sharedCommon] objectForKey:LOGGED_TOKEN];
        NSString * userName = [[CommClass sharedCommon] objectForKey:LOGGED_USERNAME];
        NSDictionary * userInfo = [RequestModel class:@"MyInfoModel"];
        [UserLoginModel setLoginWithToken:token userName:userName userInfo:userInfo];
   
        //登录成功退出当前登录页面
        [self dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];

        return;
    }
    
}


@end
