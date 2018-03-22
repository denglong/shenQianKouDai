//
//  UserAgreementViewController.m
//  KingProFrame
//
//  Created by 李栋 on 15/7/31.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()
{
    UIView * noNetWork;
}
@end

@implementation UserAgreementViewController

//无网判断添加页面
- (void)noNetwork {
    if ([self isNotNetwork]) {
        self.publicWebView.hidden = YES;
        noNetWork = [[NoNetworkView sharedInstance] setConstraint:self.view.frame.size.height];
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, noNetWork.frame.size.height);
        [self.view addSubview:noNetWork];
        return;
    }
    else
    {
        self.publicWebView.hidden = NO;
        [noNetWork removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.titleString;
    self.navigationController.navigationBarHidden = NO;
    
    if (self.viewTag == -100) {
         self.publicWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0);
    }
    //self.urlString = [NSString stringWithFormat:@"%@user.jhtml", CLOUD_API_URL];
    
    if ([DataCheck isValidString:self.urlString]) {
        
        NSURL *url = [NSURL URLWithString:self.urlString];
        [self.publicWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }

}


#pragma UIWebViewdelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"start");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"finish");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"error");
}

@end
