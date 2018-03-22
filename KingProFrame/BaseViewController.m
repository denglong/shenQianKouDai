///
//  BaseViewController.m
//  KingProFrame
//
//  Created by JinLiang on 15/7/1.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BaseViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "BusinessOrderController.h"
#import "DistributionViewController.h"
#import "MyOrderController.h"
#import "TabBarController.h"
#import "NavigationController.h"
#import "AddressMapViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "CategoryController.h"
#import "MJRefresh/MJRefresh.h"


NSString* const NotificationCategoryIdent1  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent2 = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent3 = @"ACTION_TWO";

@interface BaseViewController ()<UIAlertViewDelegate, UIGestureRecognizerDelegate>
{
//    id<ISSCAttachment> image;
}
@end

@implementation BaseViewController
@synthesize myTitleBtns;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //设置导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor blackColor], NSForegroundColorAttributeName,
                                                                     nil]];
    //设置titleText字体颜色
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor_HEX colorWithHexString:@"#323232"] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.view.backgroundColor = [UIColor_HEX colorWithHexString:@"ECECEC"];
    NSInteger count = [self.navigationController.viewControllers count];
    if (count >= 2) {
        
        //去掉push后返回上一视图title
        UIBarButtonItem *backbutton = [self createLeftItem:self itemStr:nil itemImage:UIIMAGE(@"back.png") itemImageHG:UIIMAGE(@"back_p.png") selector:@selector(backAction:)];

        self.navigationItem.leftBarButtonItem = backbutton;
    }
    else{
        self.tabBarController.tabBar.hidden = NO;
        
    }
    
    [self addProgRessHUD];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![self isKindOfClass:[AddressMapViewController class]]) {
        [[CommClass sharedCommon] setObject:self forKey:@"windowRootController"];
    }
    //开启ios右滑返回
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 如果当前显示的是第一个子控制器,就应该禁止掉[返回手势]
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

/**
 * Method name: doback
 * Description: 处理返回事件
 * Parameter: sender
 */

-(void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取当前的时间戳
-(NSString *)getCurrentTimeStamp{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    DLog(@"当前的时间戳:%lld", date);
    
    NSString *valTime=[NSString stringWithFormat:@"%lld",date];
    NSString *formatTime= [self formatTimeStamp:valTime timeFormat:@"YYYY-MM-dd HH:mm:ss"];
    DLog(@"转换后的标准时间:%@",formatTime);
    
    return valTime;
}

//时间转换成时间戳
-(NSString*)formatTime:(NSString*)standardTime{
    
    DLog(@"%ld",standardTime.length);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (standardTime.length<19) {
        standardTime=[NSString stringWithFormat:@"%@ 00:00:00",standardTime];
    }
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* acceptdate = [formatter dateFromString:standardTime]; //------------将字符串按formatter转成nsdate
    //NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    //时间转时间戳的方法:
    NSString *timeStamp = [NSString stringWithFormat:@"%d", (int)[acceptdate timeIntervalSince1970]];
    //DLog(@"timeSp:%@",timeStamp); //时间戳的值
    
    return timeStamp;
}


//时间戳转换成时间 timeFormat是要转换成的时间格式
-(NSString*)formatTimeStamp:(NSString *)timeStamp timeFormat:(NSString *)timeFormat{
    
    
    //NSTimeInterval time=[timeStamp doubleValue]+28800;//因为时差问题要加8小时 == 28800
    NSTimeInterval time=[timeStamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //DLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:timeFormat];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}
//清除tableview多余的空白行
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
//导航栏添加右item 
-(UIBarButtonItem *)createRightItem: (id)sender itemStr:(NSString *)itemString itemImage:(UIImage *)itemImage itemImageHG:(UIImage *)itemImageHG selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    CGSize size = [CommClass getSuitSizeWithString:itemString font:14 bold:NO sizeOfX:MAXFLOAT];
    if (itemString) {
        button.frame = CGRectMake(0, 15, size.width+10, 24);
    }
    else
    {
        button.frame = CGRectMake(0, 0, itemImage.size.width, itemImage.size.height);
    }
    
    [button setTitle:itemString forState:UIControlStateNormal];
    [button setImage:itemImage forState:UIControlStateNormal];
    [button setImage:itemImageHG forState:UIControlStateHighlighted];
    [button addTarget:sender action:selector forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textAlignment= NSTextAlignmentCenter;
   
    
    [button setTitleColor:defaultColor forState:UIControlStateNormal];
    [button setTitleColor:defaultColor forState:UIControlStateHighlighted];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return rightItem;
}

//导航栏添加左item
-(UIBarButtonItem *)createLeftItem: (id)sender itemStr:(NSString *)itemString itemImage:(UIImage *)itemImage itemImageHG:(UIImage *)itemImageHG selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundColor:[UIColor blackColor]];
    button.frame = CGRectMake(0, 0,itemImage.size.width, itemImage.size.height);
    [button setTitle:itemString forState:UIControlStateNormal];
    [button setImage:itemImage forState:UIControlStateNormal];
    [button setImage:itemImageHG forState:UIControlStateHighlighted];
    [button addTarget:sender action:selector forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textAlignment= NSTextAlignmentLeft;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return rightItem;
    
}
//MD5加密 add lihualin
-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ]lowercaseString];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     DLog("%02X", 0x888);  //888
     DLog("%02X", 0x4); //04
     */
}
//正泽用来判断是否为正确的手机号 add lihualin
- (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0) {
        
        [SRMessage infoMessage:@"请输入手机号码" delegate:self];
        return NO;
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    // NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSString *regex = @"[1][34578]\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        [SRMessage infoMessage:@"您输入的手机号码有误，请重新输入" delegate:self];
        return NO;
    }else{
        
    }
    return YES;
}
#pragma mark - 密码规则
-(BOOL)checkPassWord:(NSString *)passWord
{
    //数字
    NSString * tempStr =@"0123456789";
    NSRange range = [tempStr rangeOfString:passWord];//判断字符串是否包含连续的数字
    
    NSString *passStr = @"9876543210";
    NSRange rangeStr = [passStr rangeOfString:passWord];//判断字符串是否包含连续的数字
    
    //小写  正序
    NSString * lowerStr = @"abcdefghijklmnopqrstuvwxyz";
    NSRange rangeLower = [lowerStr rangeOfString:passWord];//判断字符串是否包含连续的小写字母
    //大写  正序
    NSString * capitalStr =[lowerStr uppercaseString];
    NSRange rangeCap = [capitalStr rangeOfString:passWord];//判断字符串是否包含连续的大写字母
    
    //小写  倒序
    NSString *string = @"zyxwvutsrqponmlkjihgfedcba";
    NSRange rangeLowerDaoxu = [string rangeOfString:passWord];//判断字符串是否包含连续的小写字母
    
    //大写  倒序
    NSString * capitalStrDaoxu =[string uppercaseString];
    NSRange rangeCapDaoxu = [capitalStrDaoxu rangeOfString:passWord];//判断字符串是否包含连续的大写字母
    
    if (range.location !=NSNotFound || rangeStr.location !=NSNotFound || rangeLower.location != NSNotFound || rangeCap.location != NSNotFound||rangeLowerDaoxu.location != NSNotFound||rangeCapDaoxu.location != NSNotFound)//包含
    {
        //        [SRMessage infoMessage:REGISTRATION_10];
        return NO;
    }
    
    
    return YES;
}
#pragma mark - 拼接字符串
/***************************************************************************************
 参数：str 要改变的字符串 如 @"1234567890"
 fromIndex 要改变的部分的起始位置  如 3 从第三位开始
 Ranglength 要改变的长度         如 4 4位将被替换
 subString 替换的字符串 长度为3     如 @"***" 该字符串将替换原字符串中从第三位开始共4位字符
 返回：拼接的字符串  如 @"123***7890"
 ***************************************************************************************/
-(NSString *)getPhoneStr :(NSString *)str fromIndex:(NSInteger)index Ranglength:(NSInteger)length subString:(NSString *)subString
{
    if ([DataCheck isValidString:str]) {
        NSMutableString * phoneStr=[[NSMutableString alloc]initWithString:str];
        [phoneStr replaceCharactersInRange:NSMakeRange(index,length) withString:subString];
        str=[NSString stringWithString:phoneStr];
    }
    return str;
}
/**
 * Method name: setupRefresh
 * Description: 集成刷新控件
 * Parameter: 传入需要刷新的页面tableView
 * Parameter: 无
 */
- (void)setupRefresh:(id)tableView
{
    //    MJRefreshHeader *header = [[MJRefreshHeader alloc] init];
    UITableView *refreshTableview = (UITableView *)tableView;
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf headerRereshing];
    }];
    
    refreshTableview.mj_header = header;
    
    [refreshTableview.mj_header beginRefreshing];
    
    [header setTitle:@"正在为您努力刷新!" forState:MJRefreshStateRefreshing];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerRereshing];
    }];
    
    refreshTableview.mj_footer = footer;
    
    //    [footer beginRefreshing];
    
    [footer setTitle:@"正在为您努力加载!" forState:MJRefreshStateRefreshing];
    
//    [footer beginRefreshing];
    //    header.refreshingBlock = ^(MJRefreshBaseView *refreshView)
    //    {
    //        [self headerRereshing];
    //    };
    //    _refreshHeaderView = header;
    
    
    //    // 添加传统的下拉刷新
    //    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    //    [refreshTableview addLegendHeaderWithRefreshingBlock:^{
    //        [weakSelf headerRereshing];
    //    }];
    //
    //
    //    // 马上进入刷新状态
    //    [refreshTableview.legendHeader beginRefreshing];
    ////    refreshTableview.legendHeader.automaticallyRefresh = NO;
    //
    //
    //
    //    // 添加传统的下拉刷新
    //    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    //    [refreshTableview addLegendFooterWithRefreshingBlock:^{
    //        [weakSelf footerRereshing];
    //    }];
    //
    //    // 马上进入刷新状态
    //    [refreshTableview.legendFooter beginRefreshing];
    
    self.refreshHeaderView = refreshTableview.mj_header;
    self.refreshFooterView = refreshTableview.mj_footer;
}

- (void)setupHeaderRefresh:(id)tableView
{
    UITableView *refreshTableview = (UITableView *)tableView;
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf headerRereshing];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    header.arrowView.image = nil;
    
    refreshTableview.mj_header = header;
    
    [header beginRefreshing];
    
    [header setTitle:@"正在为您努力刷新!" forState:MJRefreshStateRefreshing];
    
    self.refreshHeaderView = refreshTableview.mj_header;
    
    // 设置字体
    //    refreshTableview.legendHeader.font = [UIFont systemFontOfSize:15];
    //
    //    // 设置颜色
    //    refreshTableview.legendHeader.textColor = [UIColor redColor];
}

- (void)setUpFooterRefresh:(id)tableView
{
    UITableView *refreshTableview = (UITableView *)tableView;
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerRereshing];
    }];
    
    refreshTableview.mj_footer = footer;
    
    //    [footer beginRefreshing];
    
    [footer setTitle:@"正在为您努力加载！" forState:MJRefreshStateRefreshing];
    
    refreshTableview.mj_footer.automaticallyChangeAlpha = YES;
    
    self.refreshFooterView = refreshTableview.mj_footer;

    
    // 马上进入刷新状态 
    //    [refreshTableview.legendFooter beginRefreshing];
}


- (void)setUpNoAutoRefreshHeader:(id)tableView
{
    UITableView *refreshTableview = (UITableView *)tableView;
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf headerRereshing];
    }];
    
    refreshTableview.mj_header = header;
        
    [header setTitle:@"正在为您努力刷新!" forState:MJRefreshStateRefreshing];
    
    self.refreshHeaderView = refreshTableview.mj_header;
}

//刷新加载调用方法
-(void)headerRereshing{};
-(void)footerRereshing{};

//时间戳去掉多余零
- (NSString *)subStringlostZero:(NSString *)str {
    NSString *myDate = [[NSString stringWithFormat:@"%@", str] substringToIndex:10];
    return myDate;
}

//添加时间进度圈
- (void)addProgRessHUD{
    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_HUD];
}

- (void)showHUD {
    [_HUD show:YES];
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(timeOutAction:) userInfo:nil repeats:NO];
}

- (void)timeOutAction:(id)sender {
    [self hidenHUD];
}

- (void)hidenHUD {
    [_HUD hide:YES];
    [_myTimer invalidate];
    _myTimer = nil;
}

/**
 * Method name: popupAnimation
 * Description: 弹框动画
 * Parameter: outView 传入view
 * Parameter: duration 传入时间
 */
- (void)popupAnimation:(UIView*)outView duration:(CFTimeInterval)duration{

    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration= duration;
    animation.removedOnCompletion= NO;
    animation.fillMode= kCAFillModeForwards;
    
    animation.timingFunction= [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    NSMutableArray* values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];

    animation.values= values;
    
    [outView.layer addAnimation:animation forKey:nil];
}

/**
 * Method name: shareapplication
 * Description: 集成分享
 * Parameter: 传入要分享对应的参数
 content:分享的内容  defaultContent:默认内容  title:分享的标题 url:分享的链接 description:分享的描述
 type:要分享的平台   新浪微博 :ShareTypeSinaWeibo  微信好友:ShareTypeWeixiSession  微信朋友圈:ShareTypeWeixiTimeline QQ: ShareTypeQQ
 QQ空间:ShareTypeQQSpace            短信:ShareTypeSMS
 * Parameter: 无
 */
- (void)shareapplicationContent:(NSString *)content
                 defaultContent:(NSString *)defaultContentString
                          title:(NSString *)titleString
                            url:(NSString *)urlString
                    description:(NSString *)descriptionString
                           type:(SSDKPlatformType)type
                      imagePath:(NSString *)imagePath
{
    //[[CommClass getCommonDict]setObject:@"share" forKey:@"isShare"];
    [[CommClass sharedCommon]setObject:@"share" forKey:@"isShare"];
    //    if (![DataCheck isValidString:imagePath]) {
    //        imagePath = [[NSBundle mainBundle] pathForResource:@"icon@2x" ofType:@"png"];
    //        image = [ShareSDK imageWithPath:imagePath];
    //    }else{
    //        image = [ShareSDK imageWithUrl:[NSString stringWithFormat:@"%@%@",CLOUD_API_URL,imagePath]];
    //    }

//    image = [ShareSDK imageWithUrl:imagePath];
//    
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:content
//                                       defaultContent:defaultContentString
//                                                image:image
//                                                title:titleString
//                                                  url:urlString
//                                          description:descriptionString
//                                            mediaType:SSPublishContentMediaTypeNews];
    
//    //自定义UI分享
//    [ShareSDK shareContent:publishContent
//                      type:type
//               authOptions:nil
//              shareOptions:nil
//             statusBarTips:YES
//                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                        switch (state) {
//                            case SSPublishContentStateSuccess:
//                                DLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
//                                break;
//                            case SSPublishContentStateCancel:
//                                DLog(NSLocalizedString(@"TEXT_SHARE_Cancel", @"取消发表"));
//                                break;
//                            case SSResponseStateFail:
//                            {
//                                DLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
//                                if (type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline) {
//                                    [SRMessage infoMessage:[error errorDescription] delegate:self];
//                                }else if (type == ShareTypeQQ ||type == ShareTypeQQSpace){
//                                    [SRMessage infoMessage:[error errorDescription] delegate:self];
//                                }
//                            }
//                                break;
//                            default:
//                                break;
//                        }
//                    }];
    //SSResponseStateBegan = 0, /**< 开始 */
    //SSResponseStateSuccess = 1, /**< 成功 */
    //SSResponseStateFail = 2, /**< 失败 */
    // = 3 /**< 取消 */
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"哈哈哈哈" images:nil url:[NSURL URLWithString:@"http://baidu.com"] title:@"呵呵呵呵" type:SSDKContentTypeAuto];
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
    }];
}
/**
 * Method name: sharetextContent
 * Description: 纯文字分享
 * Parameter:   传入要分享对应的参数
 content:分享的内容
 type:要分享的平台  新浪微博 :ShareTypeSinaWeibo  微信好友:ShareTypeWeixiSession  微信朋友圈:ShareTypeWeixiTimeline QQ: ShareTypeQQ
 QQ空间:ShareTypeQQSpace            短信:ShareTypeSMS
 * Parameter: 无
 */

- (void)sharetextContent:(NSString *)content type:(SSDKPlatformType)type
{
    [[CommClass sharedCommon]setObject:@"share" forKey:@"isShare"];
    
//    id<ISSContent> publishContent = [ShareSDK content:content
//                                       defaultContent:nil
//                                                image:nil
//                                                title:nil
//                                                  url:nil
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeText];
    
//    //自定义UI分享
//    [ShareSDK shareContent:publishContent
//                      type:type
//               authOptions:nil
//              shareOptions:nil
//             statusBarTips:YES
//                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                        if (state == SSPublishContentStateSuccess)
//                        {
//                            DLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
//                        }
//                        else if (state == SSPublishContentStateFail)
//                        {
//                            DLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
//                            if (type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline) {
//                                //[SRMessage infoMessage:MY_25];
//                            }else if (type == ShareTypeQQ ||type == ShareTypeQQSpace){
//                                //[SRMessage infoMessage:MY_26];
//                            }
//                        }
//                        
//                    }];
    
}

/**
 * Method name: createTitle
 * Description: 创建标签方法
 * Parameter: titleDic（传入标签内容）
 * Parameter: width（传入设置view宽度）
 */
- (UIView *)createTitle:(NSDictionary *)titleDic andViewWidth:(NSInteger)width {
    
    NSArray *titleNameList = [titleDic objectForKey:@"titleName"];
    NSArray *titleNumList = [titleDic objectForKey:@"titleNum"];
    NSArray *labelIds = [titleDic objectForKey:@"labelId"];
    NSString *indexNum = [titleDic objectForKey:@"indexNum"];
    NSMutableArray *titleList = [NSMutableArray array];
    
    if (titleNumList.count > 0) {
        for (NSInteger i = 0; i < titleNumList.count; i ++) {
            NSString *titleName = [NSString stringWithFormat:@"%@ %@", titleNameList[i], titleNumList[i]];
            [titleList addObject:titleName];
        }
    }
    else
    {
        titleList = [titleNameList mutableCopy];
    }
    
    myTitleBtns = [NSMutableArray array];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    
    for (NSInteger i = 0; i < titleList.count; i ++) {
        
        CGSize size =CGSizeMake(MAXFLOAT, 30); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        NSInteger titleWidth = [titleList[i] boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.width+24;
        
//        NSInteger titleWidth = [titleList[i] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 30)].width + 24;
        if (self.cancleTag == 1) {
            titleWidth = width/2 - 25;
        }
        
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, titleWidth, 24)];
        
        if (self.cancleTag == 1) {
            titleBtn.frame = CGRectMake((width - titleWidth*2 - 10)/2, 10, titleWidth, 24);
        }
        
        if (myTitleBtns.count > 0) {
            
            UIButton *myBtn = myTitleBtns[i - 1];
            titleBtn.frame = CGRectMake(myBtn.frame.origin.x + myBtn.frame.size.width + 10, myBtn.frame.origin.y, titleWidth, 24);
        }
        
        if ((titleBtn.frame.origin.x + titleBtn.frame.size.width) > width) {
            
            if (self.cancleTag == 1) {
                titleBtn.frame = CGRectMake((width - titleWidth*2 - 10)/2, titleBtn.frame.origin.y + titleBtn.frame.size.height + 10, titleWidth, 24);
            }
            else
            {
                titleBtn.frame = CGRectMake(10, titleBtn.frame.origin.y + titleBtn.frame.size.height + 10, titleWidth, 24);
            }
        }
        
        [titleBtn setTitle:titleList[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        titleBtn.backgroundColor = [UIColor clearColor];
        titleBtn.layer.cornerRadius = 12;
        titleBtn.layer.borderWidth = 0.5f;
        if ([indexNum integerValue] == 2) {
            titleBtn.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#f57d6e"] CGColor];
            [titleBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#f57d6e"] forState:UIControlStateNormal];
            titleBtn.enabled = NO;
        }
        else
        {
            titleBtn.layer.borderColor = [[UIColor blackColor] CGColor];
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        if (labelIds.count > 0) {
            titleBtn.tag = [labelIds[i] integerValue];
        }
        
        [titleBtn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleView addSubview:titleBtn];
        [myTitleBtns addObject:titleBtn];
    }
    
    if (titleList.count > 0) {
        UIButton *lastBtn = myTitleBtns[titleList.count - 1];
        NSInteger viewHeight = lastBtn.frame.origin.y + lastBtn.frame.size.height + 10;
        titleView.frame = CGRectMake(0, 0, width, viewHeight);
    }
    
    return titleView;
}

- (void)titleAction:(UIButton *)sender {}

/**
 * Method name: formatCartInfo
 * Description: 格式化特殊数组为可用字典  type  value
 * Parameter: specialArray
 */
-(NSDictionary*)formatSpecialArray:(NSArray*)specialArray{
    
    NSMutableDictionary *mutableInfo = [NSMutableDictionary dictionary];
    
    NSDictionary *resultsDic=[NSDictionary dictionary];
    
    if (![DataCheck isValidArray:specialArray]) {
        return resultsDic;
    }
    
    NSString *newKey=nil;
    NSString *newValue=nil;
    
    for (int i=0; i<[specialArray count]; i++) {
        
        NSDictionary * cartDic=[specialArray objectAtIndex:i];
        
        for (NSString* key in cartDic) {
            
            NSString*value=[cartDic objectForKey:key];
            
            if ([DataCheck isValidNumber:value]) {
                value=[NSString stringWithFormat:@"%@",value];
            }
            if (![DataCheck isValidString:value] &&![DataCheck isValidArray:value]) {
                value = @"";
            }
            
            if ([key isEqualToString:@"type"]) {
                
                newKey=value;
            }
            else if([key isEqualToString:@"value"]){
                newValue=value;
            }
            
            if (newKey!=nil &&newValue!=nil) {
                
                [mutableInfo setObject:newValue forKey:newKey];
                newValue=nil;
                newKey=nil;
            }
        }
        resultsDic=(NSDictionary*)mutableInfo;
    }
    
    return resultsDic;
}

//检测网络状况
-(BOOL)isNotNetwork{
    
    BOOL isExistenceNetwork = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = YES;
            
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = NO;
            
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = NO;
            
            break;
    }
    
    return isExistenceNetwork;
}

/**
 * Method name: circleView
 * Description: 对视图进行画圆
 * Parameter: view 需要画圆的视图
 * Parameter: sizeHeight 视图的高
  * Parameter: bgColor 视图的背景颜色
 */
-(void)circleView:(UIView*)view
       sizeHeight:(float)sizeHeight
      borderColor:(UIColor*)borderColor
      borderWidth:(CGFloat)borderWidth{
    
    view.layer.cornerRadius = sizeHeight/2;
    view.layer.borderColor  = [borderColor CGColor];
    view.layer.borderWidth  = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerRemoteNotification {
    
//#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent2];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent3];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent1];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
//#else
//    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
//                                                                   UIRemoteNotificationTypeSound|
//                                                                   UIRemoteNotificationTypeBadge);
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
//#endif
}

// 去除多余的HUD
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenHUD];
//
//    for (UIView *HUDView in self.navigationController.view.subviews)
//    {
//        if ([HUDView isKindOfClass:[MBProgressHUD class]])
//        {
//            [HUDView removeFromSuperview];
//        }
//    }
}


@end
