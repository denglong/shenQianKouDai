//
//  RecommendFriendsViewController.m
//  KingProFrame
//
//  Created by 李栋 on 15/8/7.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "RecommendFriendsViewController.h"
#import "Headers.h"
#import "CloudClient.h"


@interface RecommendFriendsViewController ()<reloadDelegate>
{
    CloudClient  *cloudClient;
    NSString *contentString;
    NSString *defaultContentString;
    NSString *urlString;
    NSString *titleString;
    NSString *descriptionString;
    NSString *imagePathString;
    UIView   * noNetWork;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstraint;
@end

@implementation RecommendFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"推荐有奖";
    cloudClient = [CloudClient getInstance];
    if (iPhone4) {
        self.contentConstraint.constant = 100;
    }
    if (iPhone5) {
        self.contentConstraint.constant = 60;
    }
    if (iPhone6) {
        self.contentConstraint.constant = 20;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     if ([UserLoginModel isLogged]) {
         [self recomRequest];
     }
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        self.RecoScrollView.hidden = YES;
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        [super hidenHUD];
        return YES;
    }
    else
    {
        self.RecoScrollView.hidden = NO;
        [noNetWork removeFromSuperview];
        return NO;
    }
}

-(void)reloadAgainAction
{
    [self recomRequest];
}
- (void)recomRequest {
    if ([self noNetwork]) {
        return;
    }
     [super showHUD];
    [cloudClient requestMethodWithMod:@"member/recom"
                               params:nil
                           postParams:nil
                             delegate:self
                             selector:@selector(recomFinish:)
                        errorSelector:@selector(recomError:)
                     progressSelector:nil];

}


- (void)recomFinish:(NSDictionary *)request {
    DLog(@"finish request------>%@",request);
    [super hidenHUD];
    NSString *code = [request objectForKey:@"code"];
    self.shareCode.text = code;
    
    NSString *recomImg = [request objectForKey:@"recomImg"];
    [self.imageView setImageWithURL:[NSURL URLWithString:recomImg] placeholderImage:[UIImage imageNamed:@"recommend_friends"]];
    
    NSString *recomText = [request objectForKey:@"recomText"];
    self.textLabel.text = recomText;
    
    NSArray *shareList = [request objectForKey:@"shareList"];
    NSDictionary *shareDic = [shareList objectAtIndex:0];
    NSString *shareImg = [shareDic objectForKey:@"img"];
    NSString *shareText = [shareDic objectForKey:@"text"];
    NSString *title = [shareDic objectForKey:@"title"];
    NSString *url = [shareDic objectForKey:@"url"];
    
    imagePathString = shareImg;
    titleString = title;
    urlString = url;
    contentString = shareText;
    defaultContentString = shareText;
    descriptionString = shareText;
    
}

- (void)recomError:(NSDictionary *)request {
    DLog(@"error request------->%@",request);
    [super hidenHUD];
} 

- (IBAction)shareBtnPress:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    contentString = @"哈哈哈哈";
    defaultContentString = @"呵呵呵呵";
    titleString = @"去去去";
    urlString = @"http://baidu.com";
    descriptionString = @"来来来";
    imagePathString = @"";
    
    switch (btn.tag) {
        case 0:
        {
            //微信好友
            [super shareapplicationContent:contentString
                            defaultContent:defaultContentString
                                     title:titleString
                                       url:urlString
                               description:descriptionString
                                      type:SSDKPlatformSubTypeWechatSession
                                 imagePath:imagePathString];

        }
            break;
        case 1:
        {
            //QQ好友
            [super shareapplicationContent:contentString
                            defaultContent:defaultContentString
                                     title:titleString
                                       url:urlString
                               description:descriptionString
                                      type:SSDKPlatformSubTypeQQFriend
                                 imagePath:imagePathString];
        }
            break;
        case 2:
        {
            //微信朋友圈
            [super shareapplicationContent:contentString
                            defaultContent:defaultContentString
                                     title:titleString
                                       url:urlString
                               description:descriptionString
                                      type:SSDKPlatformSubTypeWechatTimeline
                                 imagePath:imagePathString];

        }
            break;
        case 3:
        {
            //QQ空间
            [super shareapplicationContent:contentString
                            defaultContent:defaultContentString
                                     title:titleString
                                       url:urlString
                               description:descriptionString
                                      type:SSDKPlatformSubTypeQZone
                                 imagePath:imagePathString];
        }
            break;
        default:
            break;
    }
}

@end
