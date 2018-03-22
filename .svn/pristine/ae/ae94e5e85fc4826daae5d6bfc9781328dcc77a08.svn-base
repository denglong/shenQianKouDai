//
//  RultsWebViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/8/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "RultsWebViewController.h"

@interface RultsWebViewController ()<reloadDelegate>
{
    UIView * noNetWork;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation RultsWebViewController
@synthesize urlStr;
//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        _webView.hidden = YES;
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        return YES;
    }
    else
    {
        _webView.hidden = NO;
        [noNetWork removeFromSuperview];
        return NO;
    }
}

-(void)reloadAgainAction
{
    if ([self noNetwork]) {
        return;
    }
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    if (self.ViewTag == -100) {
        self.title = @"系统消息";
    }else if (self.ViewTag == 101) {
        self.title = @"e豆规则";
    }else if(self.ViewTag == 201){
        self.title = @"优惠券规则";
    }else{
        self.title = @"提现规则";
    }
    [self noNetwork];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];

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

@end
