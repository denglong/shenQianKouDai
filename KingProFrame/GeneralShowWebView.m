//
//  GeneralShowWebView.m
//  KingProFrame
//
//  Created by JinLiang on 15/8/31.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "GeneralShowWebView.h"
#import "HomeViewController.h"
#import "CategoryController.h"
#import "TabBarController.h"
#import "LocationReportModel.h"

@interface GeneralShowWebView ()<UIActionSheetDelegate, LocationReportDelegate>
{
    NSDictionary *infoDic;//分享获取字典
    NSDictionary *queryDic;
    UIView *sharePage;
    UIView *shareBg;
}

@end

@implementation GeneralShowWebView
@synthesize advUrlLink;
@synthesize showWebView;
@synthesize isNotShare;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title = @"loading...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setTokenAndLoadUrl];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.geTuiTag == 1)
    {
        self.navigationItem.leftBarButtonItem = [super createLeftItem:self itemStr:nil itemImage:UIIMAGE(@"back.png") itemImageHG:nil selector:@selector(backUpAction:)];
    }
    
    if (isNotShare == YES)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopNotificationAction) name:@"SHOPNOTIFICATION" object:nil];
    
    [self showHUD];
    
    [self createSharePage];
}

#pragma mark - 创建分享view
- (void)createSharePage {
    shareBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, kViewHeight)];
    shareBg.hidden = YES;
    shareBg.backgroundColor = [UIColor blackColor];
    shareBg.alpha = 0.1;
    sharePage = [[UIView alloc] initWithFrame:CGRectMake(0, kViewHeight, viewWidth, 130)];
    sharePage.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0.5)];
    lineView.backgroundColor = [UIColor_HEX colorWithHexString:@"#cccccc"];
    UIButton *wechatBtn = [[UIButton alloc] initWithFrame:CGRectMake(57, 22, 53, 53)];
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"icon_weChat"] forState:UIControlStateNormal];
    UIButton *friendBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth - 110, 22, 53, 53)];
    [friendBtn setBackgroundImage:[UIImage imageNamed:@"icon_firend"] forState:UIControlStateNormal];
    UILabel *wechatLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 61, 53, 13)];
    wechatLab.font = [UIFont systemFontOfSize:13];
    wechatLab.textAlignment = NSTextAlignmentCenter;
    wechatLab.textColor = [UIColor_HEX colorWithHexString:@"#323232"];
    wechatLab.text = @"微信";
    UILabel *friendLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 61, 53, 13)];
    friendLab.font = [UIFont systemFontOfSize:13];
    friendLab.textAlignment = NSTextAlignmentCenter;
    friendLab.textColor = [UIColor_HEX colorWithHexString:@"#323232"];
    friendLab.text = @"朋友圈";
    wechatBtn.tag = 0;
    friendBtn.tag = 1;
    
    [wechatBtn addTarget:self action:@selector(wechatAndFriendShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [friendBtn addTarget:self action:@selector(wechatAndFriendShareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [wechatBtn addSubview:wechatLab];
    [friendBtn addSubview:friendLab];
    [sharePage addSubview:wechatBtn];
    [sharePage addSubview:friendBtn];
    [sharePage addSubview:lineView];
    [[UIApplication sharedApplication].keyWindow addSubview:shareBg];
    [[UIApplication sharedApplication].keyWindow addSubview:sharePage];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShareAction)];
    [gesture setNumberOfTouchesRequired:1];
    [shareBg addGestureRecognizer:gesture];
}

- (void)hiddenShareAction {
    [UIView animateWithDuration:0.5 animations:^{
        shareBg.hidden = YES;
        sharePage.frame = CGRectMake(0, kViewHeight, viewWidth, 150);
    }];
}

#pragma mark - 分享事件
- (void)sharePage {
    [UIView animateWithDuration:0.5 animations:^{
        shareBg.hidden = NO;
        sharePage.frame = CGRectMake(0, kViewHeight - 150, viewWidth, 150);
    }];
}

- (void)wechatAndFriendShareAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        shareBg.hidden = YES;
        sharePage.frame = CGRectMake(0, kViewHeight, viewWidth, 150);
    } completion:^(BOOL finished) {
        if ([DataCheck isValidDictionary:infoDic])
        {
            NSString * urlString = [infoDic objectForKey:@"link"];
            NSString * imgUrl = [infoDic objectForKey:@"imgUrl"];
            NSString * title = [infoDic objectForKey:@"title"];
            NSString * text = [infoDic objectForKey:@"desc"];
            
            switch (sender.tag) {
                case 0:
                {
//                    //微信好友
//                    [super shareapplicationContent:text
//                                    defaultContent:nil
//                                             title:title
//                                               url:urlString
//                                       description:nil
//                                              type:ShareTypeWeixiSession
//                                         imagePath:imgUrl];
                }
                    break;
                case 1:
                {
//                    //微信朋友圈
//                    [super shareapplicationContent:text
//                                    defaultContent:nil
//                                             title:title
//                                               url:urlString
//                                       description:nil
//                                              type:ShareTypeWeixiTimeline
//                                         imagePath:imgUrl];
                }
                    break;
                    
                default:
                    
                    break;
            }
        }

    }];
}

#pragma mark - url拼接token和时间戳，加载url
- (void)setTokenAndLoadUrl {
    NSString *urlStr = [[CommClass sharedCommon] objectForKey:@"WebUrlStr"];
    if ([DataCheck isValidString:urlStr])
    {
        self.advUrlLink = urlStr;
        [[CommClass sharedCommon] setObject:@"" forKey:@"WebUrlStr"];
    }
    
    NSString *myToken = [[CommClass sharedCommon] objectForKey:LOGGED_TOKEN];
    if ([DataCheck isValidString:myToken])
    {
        if([self.advUrlLink rangeOfString:@"?"].location != NSNotFound)
        {
            self.advUrlLink = [NSString stringWithFormat:@"%@&k=%@", self.advUrlLink, myToken];
        }
        else
        {
            self.advUrlLink = [NSString stringWithFormat:@"%@?k=%@", self.advUrlLink, myToken];
        }
        
    }
    else
    {
        self.advUrlLink = [NSString stringWithFormat:@"%@", self.advUrlLink];
    }
    
    //链接追加时间戳
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSString *nowTime = [NSString stringWithFormat:@"%lld", date];
    if ([self.advUrlLink rangeOfString:@"timestamp="].location == NSNotFound)
    {
        if ([self.advUrlLink rangeOfString:@"?"].location != NSNotFound) {
            self.advUrlLink = [NSString stringWithFormat:@"%@&timestamp=%@", self.advUrlLink, nowTime];
        }
        else
        {
            self.advUrlLink = [NSString stringWithFormat:@"%@?timestamp=%@", self.advUrlLink, nowTime];
        }
    }
    
    NSURL *requestUrl=[NSURL URLWithString:self.advUrlLink];
    //NSURL *requestUrl=[NSURL URLWithString:@"http://192.168.30.19:8080/adv/dev.jhtml"];
    [showWebView loadRequest:[NSURLRequest requestWithURL:requestUrl]];
}

#pragma mark - 个推返回上一页
- (void)backUpAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//返回上一页
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 通知回跳事件
- (void)shopNotificationAction {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - webView加载事件
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self hidenHUD];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *shareInfo = [showWebView stringByEvaluatingJavaScriptFromString:@"JSBridge.getString('pageInfo')"];
    NSData *infoData = [shareInfo dataUsingEncoding:NSUTF8StringEncoding];
    infoDic = [NSJSONSerialization JSONObjectWithData:infoData options:NSJSONReadingMutableContainers error:nil];
    if ([DataCheck isValidDictionary:infoDic])
    {
        NSString * share = [infoDic objectForKey:@"share"];
        if ([share integerValue] == 1)
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(sharePage)];
            self.navigationController.navigationBarHidden = NO;
        }
    }
    
    
    //清除缓存
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hidenHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    DLog(@"\n url=%@\n host=%@\n scheme= %@\n query=%@", request.mainDocumentURL, request.mainDocumentURL.host, request.mainDocumentURL.scheme, request.mainDocumentURL.query);
    
    NSString *scheme = request.mainDocumentURL.scheme;
    if ([scheme isEqualToString:@"eqbang"])
    {
        NSString *host = request.mainDocumentURL.host;
        NSArray *arr = @[@"presell", @"sharePage", @"myHome", @"back", @"getLocation", @"seckill", @"setTitle"];
        NSInteger typeTag = [arr indexOfObject:host];
        if ([DataCheck isValidString:request.mainDocumentURL.query]) {
            queryDic = [self queryToDictionary:request.mainDocumentURL.query];
            if ([self isNotNetwork]) {
                NSString *str = [queryDic objectForKey:@"callback"];
                [showWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('0', '0', '0')", str]];
            }
        }
        switch (typeTag) {
            case 0://预售
            {
                if ([DataCheck isValidDictionary:queryDic])
                {
                    ConfirmOrderController *confirm = [[ConfirmOrderController alloc] init];
                    confirm.presell = YES;
                    confirm.goodId = [queryDic objectForKey:@"goodsId"];
                    confirm.goodNum = [queryDic objectForKey:@"goodsNumber"];
                    confirm.shopId = [queryDic objectForKey:@"shopId"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:confirm animated:YES];
                }
            }
                break;
            case 1:
                [self sharePage];
                break;
            case 2:
                [self back];
                break;
            case 3:
                [self back];
                break;
            case 4:
                [self locationAction];
                break;
            case 5://H5秒杀跳确认订单
            {
                ConfirmOrderController *confirm = [[ConfirmOrderController alloc] init];
                confirm.secKill = YES;
                if ([DataCheck isValidDictionary:queryDic]) {
                    confirm.goodId = [queryDic objectForKey:@"goodsId"];
                    confirm.goodNum = @"1";
                    confirm.shopId = @"0";
                }
                else
                {
                    confirm.goodNum = @"";
                    confirm.shopId = @"";
                    confirm.goodId = @"";
                }
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:confirm animated:YES];
            }
                break;
            case 6:
                self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
                break;
            default:
                break;
        }
    }
    
    return YES;
}

#pragma mark - 参数转字典
- (NSDictionary *)queryToDictionary:(NSString *)query {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    query = [self decodeFromPercentEscapeString:query];
    NSArray *arr = [query componentsSeparatedByString:@"&"];
    for (NSString *str in arr) {
        NSArray *querys = [str componentsSeparatedByString:@"="];
        if (querys.count == 2) {
            [dic setObject:querys[1] forKey:querys[0]];
        }
    }
    return dic;
}

#pragma mark - 参数decode
- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - web定位调app
- (void)locationAction {
    LocationReportModel *location = [LocationReportModel reportSharedModel];
    location.delegate = self;
    [[LocationReportModel reportSharedModel] fixAndReport];
}

- (void)locationReportSuccess:(NSDictionary *)dic {
    NSString *str = [queryDic objectForKey:@"callback"];
    [showWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('1', '%@', '%@')", str, [dic objectForKey:@"lat"], [dic objectForKey:@"lng"]]];
}

- (void)locationReportfaile {
    NSString *str = [queryDic objectForKey:@"callback"];
    [showWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('0', '0', '0')", str]];
}

- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    NSURL *requestUrl = nil;
    [showWebView loadRequest:[NSURLRequest requestWithURL:requestUrl]];
    [showWebView removeFromSuperview];
    showWebView = nil;
    showWebView.delegate = nil;
    [showWebView stopLoading];
}

@end
