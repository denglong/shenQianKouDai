//
//  AppDelegate.m
//  KingProFrame
//
//  Created by JinLiang on 15/6/26.
//  Copyright (c) 2015年 king. All rights reserved.
//

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
//                  众多服务汇集地，开发者服务商店。

#import "AppDelegate.h"
#import "Headers.h"
#import "LaunchViewController.h"
#import "AFNetworking.h"
#import <AlipaySDK/AlipaySDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "LocationReportModel.h"
#import "LoadViewController.h"
#import "NavigationController.h"
#import "MobClick.h"
#import "GeTuiSdk.h"
#import "LaunchStartController.h"
#import "TabBarController.h"
#import "MessageViewController.h"
#import "OrderDetailController.h"
#import "OrderDetailViewController.h"
#import "CouponViewController.h"
#import "BalanceViewController.h"
#import "EBeansViewController.h"
#import "WeChatPayController.h"
#import "GeneralShowWebView.h"
#import "CategoryController.h"
#import "ConfirmOrderController.h"
#import "CommodityDetailsViewController.h"
#import "RecommendFriendsViewController.h"
#import "MyOrderController.h"
#import "BusinessOrderController.h"
#import "DistributionViewController.h"
#import "LoginViewController.h"
#import "MsgSortViewController.h"

NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

@interface AppDelegate ()<clickDelegate, GeTuiSdkDelegate, IFlySpeechSynthesizerDelegate>
{
    TAlertView *tAlertView;
    NSDictionary *pushData;
    BOOL         procedureAction;
    BOOL         procedureCome;
    IFlySpeechSynthesizer       * _iFlySpeechSynthesizer;
    AVAudioPlayer *player;
}
@end

@implementation AppDelegate

- (void)initShareSDK {
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:ShareSDK_Key
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:WeiBo_key
                                           appSecret:WeiBo_appSecret
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WeiXi_Key
                                       appSecret:WeiXi_appSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQ_Key
                                      appKey:QQ_appSecret
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
}

- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
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
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化ShareSDK
    [self initShareSDK];
    
    //配置友盟统计
//    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:nil];
//    [MobClick setAppVersion:AppStore_VERSION];
//    [MobClick setLogEnabled:NO];
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    //修改状态栏字体颜色为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.window.rootViewController.view.backgroundColor=[UIColor whiteColor];
    
    //设置自动登录
    [UserLoginModel setAutoLogin];
    
//    NSInteger oldbundle = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Bundle"] integerValue];
//    NSInteger newBundle = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
//    if (newBundle > oldbundle) {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
//        //判断购物车是否显示教学蒙层
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NEWVERSION"];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"Bundle"];
//    }
    
    //判断程序第一次启动或清除缓存启动
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
//        self.window.rootViewController = [[LoadViewController sharedInstance] loadViewController];
//        
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        DLog(@"第一次启动");
//    }
//    else
//    {
        DLog(@"第二次启动");
//        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//        NSString *imageUrl = [userDefaultes objectForKey:@"imageUrlStr"];
//        if ([DataCheck isValidString:imageUrl]) {
//            self.window.rootViewController = [LaunchStartController sharedInstance];
//        }
//        else
//        {
            self.window.rootViewController = [TabBarController sharedInstance];
//        }
        [[CommClass sharedCommon] setObject:self.window.rootViewController forKey:@"windowRootView"];
//    }
    
    [self.window makeKeyAndVisible];

    [self checkingNetworkState];
    
//    [MAMapServices sharedServices].apiKey = LBS_Key;
//    [AMapLocationServices sharedServices].apiKey = LBS_Key;
    [AMapServices sharedServices].apiKey = LBS_Key;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    
    //定位获取经纬度
    [self geolocationRepordAction];
    //获取声音方法
//    self.playGround = [[MyPlayGround alloc] initSystemSoundWithName:@"sms-received1" SoundType:@"caf"];
    
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
//    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    // [2]:注册APNSs
//    [self registerRemoteNotification];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    procedureAction = NO;
    
    //初始化api接口（上线前需要注释此行代码）
//    if (![DataCheck isValidString:[[NSUserDefaults standardUserDefaults] objectForKey:@"APINAME"]]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"http://test.eqb.com/api/" forKey:@"APINAME"];
//    }
    
    return YES;
}

- (void)geolocationRepordAction {
    [[LocationReportModel reportSharedModel] fixAndReport];
    //[self performSelector:@selector(geolocationRepordAction) withObject:nil afterDelay:180.0];
}

- (void) onCompleted:(IFlySpeechError *) error{}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // [3]:向个推服务器注册deviceToken
    NSString *token = [[deviceToken description]
                       stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    DLog(@"deviceToken:%@",token);
    [[CommClass sharedCommon] setObject:token forKey:@"deviceToken"];
    if ([DataCheck isValidString:token]) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
    }
    
    NSString *phoneNum = [[CommClass sharedCommon] objectForKey:LOGGED_USERNAME];
    if (phoneNum) {
        [GeTuiSdk registerDeviceToken:token];
    }
    else
    {
        [GeTuiSdk registerDeviceToken:@""];
    }
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:@""];
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    DLog(@"%@",str);
    
    if (![DataCheck isValidString:[[CommClass sharedCommon] objectForKey:@"deviceToken"]]) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        [[CommClass sharedCommon] setObject:token forKey:@"deviceToken"];
    }
    
    [self registerRemoteNotification];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (procedureCome == NO) {
        procedureAction = YES;
        pushData = [userInfo objectForKey:@"pushData"];
        [self goToMessageView];
    }
}

//接收消息处理方法
- (void)conductAction:(NSDictionary*)userInfo {
    NSString *phoneNum = [[CommClass sharedCommon] objectForKey:LOGGED_USERNAME];
    if (![DataCheck isValidString:phoneNum]) {
        [GeTuiSdk setPushModeForOff:YES];
        return;
    }
    
    //点击消息后清空通知栏
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if ([DataCheck isValidDictionary:userInfo]) {
        pushData = [userInfo objectForKey:@"pushData"];
        
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
            DLog(@"程序正在运行");
            
            NSInteger msgType = [[pushData objectForKey:@"msgType"] integerValue];
            NSString *textMessage = [pushData objectForKey:@"shop_new_order"];
            
            if (msgType == 301 && textMessage) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_iFlySpeechSynthesizer startSpeaking:textMessage];
//                });
                [player play];
                NSString *orderNo = [pushData objectForKey:@"orderNo"];
                [[SoundModel shareSoundModel] setSoundApiData:orderNo from:@"1"];
            }
            else
            {
                [self.playGround play];
            }
            
            if (msgType == 200) {
                NSString *orderNo = [pushData objectForKey:@"orderNo"];
                NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_TIMEOUTORDER
                                                                             object:nil
                                                                           userInfo:@{@"orderNo":orderNo}];
                
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            
            NSString *alertMessage = [pushData objectForKey:@"content"];
            
            if (tAlertView) {
                [tAlertView removeFromSuperview];
            }
            tAlertView = [[TAlertView alloc] initWithTitle:alertMessage andMessage:nil];
            [tAlertView showAsMessage];
            tAlertView.delegate = self;
            procedureAction = NO;
            //e豆，优惠券推送红点  lihualin
            if (msgType == 510 || msgType == 600) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyRed" object:[pushData objectForKey:@"msgType"]];
            }
            //end
        }
        else
        {
            [self goToMessageView];
        }
    }
}

- (void)clickheaderTitleAction {
    [self goToMessageView];
}

//点击确定跳转消息列表
- (void)goToMessageView {
    [[CommClass sharedCommon] setObject:@"100" forKey:@"GeTuiTag"];
    procedureAction = NO;
    NSInteger msgType = [[pushData objectForKey:@"msgType"] integerValue];
    
    switch (msgType) {
        case 101://系统消息
        {
            MessageViewController *messageView = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
            messageView.indexXG = XGTAG;
            NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:messageView];
            [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
        }
            break;
        case 102://广告消息
        {
            NSString *urlLink = [pushData objectForKey:@"url"];
            GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
            advShowWebView.geTuiTag = XGTAG;
            advShowWebView.advUrlLink=urlLink;
            //NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:advShowWebView];
            //[self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
             NavigationController *navigation = (NavigationController *)self.window.rootViewController;
            [navigation pushViewController:advShowWebView animated:YES];
        }
            break;
        case 200://订单详情界面(顾客)
        {
            NSString *orderNo = [pushData objectForKey:@"orderNo"];
            if (orderNo) {
                NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_GOTOORDERDETAIL
                                                                             object:nil
                                                                           userInfo:nil];
                
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
                orderDetail.xgTag = XGTAG;
                orderDetail.orderNum = [pushData objectForKey:@"orderNo"];
                NavigationController *navigation = (NavigationController *)self.window.rootViewController;//[[NavigationController alloc] initWithRootViewController:orderDetail];
                [navigation pushViewController:orderDetail animated:YES];
//                [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
            }
        }
            break;
        case 300://订单详情界面(店主)
        {
            NSString *orderNo = [pushData objectForKey:@"orderNo"];
            if (orderNo) {
                OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
                orderDetail.xgTag = XGTAG;
                orderDetail.orderNum = [pushData objectForKey:@"orderNo"];
                NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:orderDetail];
                [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
            }
        }
            break;
        case 301://抢单详情界面
        {
            NSString *orderNo = [pushData objectForKey:@"orderNo"];
            if (orderNo) {
                OrderDetailController *neardyOrderDetail = [[OrderDetailController alloc] initWithNibName:@"OrderDetailController" bundle:nil];
                neardyOrderDetail.xgTag = XGTAG;
                neardyOrderDetail.orderNum = [pushData objectForKey:@"orderNo"];
                NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:neardyOrderDetail];
                [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
            }
        }
            break;
        case 360://余额列表界面
        {
            BalanceViewController *balanceView = [[BalanceViewController alloc] initWithNibName:@"BalanceViewController" bundle:nil];
            balanceView.xgTag = XGTAG;
            NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:balanceView];
            [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
        }
            break;
        case 400://订单详情界面(配送员)
        {
            NSString *orderNo = [pushData objectForKey:@"orderNo"];
            if (orderNo) {
                OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
                orderDetail.xgTag = XGTAG;
                orderDetail.orderNum = [pushData objectForKey:@"orderNo"];
                NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:orderDetail];
                [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
            }
        }
            break;
        case 510://优惠券列表界面
        {
            CouponViewController *coupon = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
            coupon.xgTag = XGTAG;
            NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:coupon];
            [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
        }
            break;
        case 600://e豆列表界面
        {
            EBeansViewController *eBeans = [[EBeansViewController alloc] initWithNibName:@"EBeansViewController" bundle:nil];
            eBeans.xgTag = XGTAG;
            NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:eBeans];
            [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
            
        }
            break;

        case 9999:
        {
            MessageViewController *messageView = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
            messageView.indexXG = XGTAG;
            NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:messageView];
            [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_RECEVIEDNOTIFICATION
                                                                 object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_ENTERBACKGROUND
                                                                 object:nil
                                                               userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSNotification *notification = [NSNotification notificationWithName:@"tongzhi" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   [LocationReportModel fixLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

//检测网络状况
-(void)checkingNetworkState{
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DLog(@"%ld",(long)status);
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                DLog(@"网络状态----------:未知状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"网络状态----------:无网络连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"网络状态----------:移动蜂窝");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"网络状态----------:wifi");
                break;
            default:
                break;
        }
    }];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "king.KingProFrame" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KingProFrame" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KingProFrame.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return YES;
}

/**
 * Method name: application
 * Description: 微信支付宝回调方法
 * Parameter: applecation
 * Parameter: 无
 */
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
////    if ([[url scheme] isEqualToString:@"eqbang"]) {
////        [self schemeCallBackAction:url];
////        return YES;
////    }
//    NSInteger payType = [[[CommClass sharedCommon] objectForKey:@"PAYTYPE"] integerValue];
//    if (payType == 2) {
//        return [WXApi handleOpenURL:url delegate:self];
//    }
//    if (payType == 2) {
//    //跳转支付宝钱包进行支付，处理支付结果
//    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        DLog(@"result = %@",resultDic);
//    }];
//    
//        return YES;
//    }
//    
//    return nil;
//}

//微信支付回调
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                DLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                NSNotification *notification = [NSNotification notificationWithName:@"ALIPAYSESSUED" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
                break;
                
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                DLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                NSNotification *notification = [NSNotification notificationWithName:@"ALIPAYFILED" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
                break;
        }
    }
}

//个推----------------------------------
- (void)startSdkWith:(NSString *)appID appKey:(NSString*)appKey appSecret:(NSString *)appSecret

{
    
    NSError *err =nil;
    
    //[1-1]:通过 AppId、appKey 、appSecret 启动SDK
    
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self error:&err];
    
    //[1-2]:设置是否后台运行开关
    
    [GeTuiSdk runBackgroundEnable:YES];
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [GeTuiSdk resume];  // 恢复个推SDK运行
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)GeTuiSdkDidReceivePayload:(NSString*)payloadId andTaskId:(NSString*)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId

{
    procedureCome = YES;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // [4]: 收到个推消息
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId]; //根据payloadId取回Payload
    NSDictionary *payloadDic = nil;
    if (payload) {
       payloadDic = [NSJSONSerialization JSONObjectWithData:payload
                                                            options:NSJSONReadingMutableContainers
                                                            error:nil];
    }
    
    if (![DataCheck isValidDictionary:[payloadDic objectForKey:@"pushData"]]) {
        return;
    }
    
    pushData = [payloadDic objectForKey:@"pushData"];
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        //设置多少秒之后推送
        NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:0];
        //一个本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        if (notification) {
            //设置推送时间
            notification.fireDate = pushDate;
            //设置时区
            notification.timeZone = [NSTimeZone defaultTimeZone];
            //设置重复间隔
            notification.repeatInterval = NSWeekCalendarUnit;
            //推送声音
            NSInteger msgType = [[pushData objectForKey:@"msgType"] integerValue];
            if (msgType == 301 && [UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
                [player play];
                NSString *orderNo = [pushData objectForKey:@"orderNo"];
                [[SoundModel shareSoundModel] setSoundApiData:orderNo from:@"2"];
            }
            else
            {
                notification.soundName = UILocalNotificationDefaultSoundName;
            }
            
            //内容
            NSDictionary *infoData = [payloadDic objectForKey:@"pushData"];
            notification.alertBody = [infoData objectForKey:@"content"];
            //显示在icon上的红色圈中的数子
            notification.applicationIconBadgeNumber = 0;
            //设置userinfo 方便在之后需要撤销的时候使用
            notification.userInfo = payloadDic;
            
            //添加推送到uiapplication
            UIApplication *app = [UIApplication sharedApplication];
            [app scheduleLocalNotification:notification];
            
           // NSInteger msgType = [[infoData objectForKey:@"msgType"] integerValue];
            if (msgType == 510 || msgType == 600) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyRed" object:[pushData objectForKey:@"msgType"]];
            }
        }
    }
    else
    {
        [self conductAction:payloadDic];
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    [self conductAction:notification.userInfo];
}

- (void)GeTuiSdkDidOccurError:(NSError *)error

{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    
    DLog(@"出错了");
}

//外部链接回调app方法
- (void)schemeCallBackAction:(NSURL *)url {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", url];
    urlStr = [self decodeFromPercentEscapeString:urlStr];
    
    NSArray *urls = [urlStr componentsSeparatedByString:@"url="];
    if (urls.count >= 2) {
        [[CommClass sharedCommon] setObject:urls[1] forKey:@"WebUrlStr"];
    }
    NSArray *urlStrs = [urlStr componentsSeparatedByString:@"?"];
    urlStr = [urlStr componentsSeparatedByString:@"?"][0];
    NSMutableArray *values = [NSMutableArray array];
    if (urlStrs.count >= 2) {
        urlStrs = [urlStrs[1] componentsSeparatedByString:@"&"];
        for (NSString *str in urlStrs) {
            NSArray *keyValues = [str componentsSeparatedByString:@"="];
            [values addObject:@{keyValues[0]:keyValues[1]}];
        }
    }
    
//    TabBarController *tabbar = [TabBarController sharedInstance];
    NavigationController *navigation = (NavigationController *)self.window.rootViewController.childViewControllers[0].navigationController;
    GeneralShowWebView *generalView = nil;
    for (UIViewController *controller in navigation.childViewControllers) {
        if ([controller isKindOfClass:[GeneralShowWebView class]]) {
            generalView = (GeneralShowWebView *)controller;
        }
    }
    
    NSArray *urlArrs = @[LINKLOGIN, COUPONLINK, EBEANLINK, CATEGORY, HOME, CART, GOODS, INVITE];
    for (NSString *str in urlArrs) {
        if ([str isEqualToString:urlStr]) {
            switch ([urlArrs indexOfObject:str]) {
                case 0:
                    [[AppModel sharedModel]  presentLoginController:self.window.rootViewController];
                    break;
                case 1://H5跳优惠券
                {
                    [[CommClass sharedCommon] setObject:@"100" forKey:@"GeTuiTag"];
                    CouponViewController *coupon = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
                    coupon.xgTag = XGTAG;
                    NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:coupon];
                    [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
                }
                    break;
                case 2://H5跳e豆
                {
                    [[CommClass sharedCommon] setObject:@"100" forKey:@"GeTuiTag"];
                    EBeansViewController *eBeans = [[EBeansViewController alloc] initWithNibName:@"EBeansViewController" bundle:nil];
                    eBeans.xgTag = XGTAG;
                    NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:eBeans];
                    [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
                }
                    break;
                case 3://H5跳分类
                {
                    for (UIViewController *controller in generalView.navigationController.childViewControllers) {
                            //  有分类控制器
                            if ([controller isKindOfClass:[CategoryController class]]) {
                            CategoryController *categoryView = (CategoryController *)controller;
                            if (urlStrs.count >= 2) {
                                if ([urlStrs[1] isEqualToString:@"-1"]) {
                                    categoryView.transportID = @"";
                                }
                                else
                                {
                                    categoryView.transportID = urlStrs[1];
                                }
                                categoryView.homePagePushed = YES;
                                
                                [generalView.navigationController pushViewController:categoryView animated:YES];
                                
                                break;
                            }
                        }
                    }
                    
                   
                        CategoryController *categoryViewController = [[CategoryController alloc] initWithNibName:NSStringFromClass( [CategoryController class] ) bundle:nil];
                        categoryViewController.homePagePushed = YES;
                    
                        if (values.count >= 1)
                        {
                            NSDictionary *keyValues = values[0];
                        
                            NSString *idKey = [keyValues allKeys].firstObject;
                        
                            if ([idKey isEqualToString:@"id"])
                            {
                                NSString *transID = [keyValues objectForKey:@"id"];
                            
                                categoryViewController.transportID = transID;
                            
                                [generalView.navigationController pushViewController:categoryViewController animated:YES];
                            }
                        }
                    }
                    
                    break;
                case 4://H5跳首页
                {
                    TabBarController *tabbar = [TabBarController sharedInstance];
                    tabbar.selectedIndex = 0;
                    
                    NSNotification *notification = [NSNotification notificationWithName:@"SHOPNOTIFICATION" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                    break;
                case 5://H5跳购物车
                {
                    ShopCartController *shopCart = [[ShopCartController alloc] init];
                    NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:shopCart];
                    [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
                }
                    break;
                case 6://H5跳商品详情
                {
                    CommodityDetailsViewController *commodDetail = [[CommodityDetailsViewController alloc] init];
                    if (values.count >= 1) {
                        for (NSDictionary *dic in values) {
                            if ([dic objectForKey:@"id"]) {
                                commodDetail.goodsId = [dic objectForKey:@"id"];
                            }
                        } 
                    }
                    else {
                        commodDetail.goodsId = @"";
                    }
                    generalView.hidesBottomBarWhenPushed = YES;
                    generalView.navigationController.interactivePopGestureRecognizer.enabled = NO;
                    [generalView.navigationController pushViewController:commodDetail animated:NO];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSMutableArray *controllers = [generalView.navigationController.viewControllers mutableCopy];
                        [controllers removeObject:generalView];
                        generalView.navigationController.viewControllers = controllers;
                        commodDetail.navigationController.interactivePopGestureRecognizer.enabled = YES;
                    });
                }
                    break;
                case 7://H5跳分享
                {
                    RecommendFriendsViewController *recommend = [[RecommendFriendsViewController alloc] init];
                    generalView.hidesBottomBarWhenPushed = YES;
                    [generalView.navigationController pushViewController:recommend animated:YES];
                }
                    break;
                default:
                    break;
            }
            return;
        }
    }
}

- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    [self quickActionWithShortcutItem:shortcutItem];
    completionHandler(YES);
}

- (void)quickActionWithShortcutItem:(UIApplicationShortcutItem *)shortcutItem
{
    NSLog(@"%@",shortcutItem.type);
    if ([shortcutItem.type isEqualToString:@"cateory"]) {
        TabBarController *tabBar = [TabBarController sharedInstance];
        tabBar.selectedIndex = 2;
        return;
    }
    
    if (![UserLoginModel isLogged]) {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:loginView];
        [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
        return;
    }
    
    if ([shortcutItem.type isEqualToString:@"shopCart"]) {
        if ([UserLoginModel isAverageUser]) {
            ShopCartController *shopCart = [[ShopCartController alloc] init];
            NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:shopCart];
            [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
            return;
        }
        else
        {
            TabBarController *tabBar = [TabBarController sharedInstance];
            tabBar.selectedIndex = 0;
            return;
        }
    }
    
    TabBarController *tabBar = [TabBarController sharedInstance];
    NavigationController *controller = tabBar.viewControllers[tabBar.selectedIndex];
    UIViewController *myController = controller.viewControllers[0];
    myController.hidesBottomBarWhenPushed = YES;
    
    if ([shortcutItem.type isEqualToString:@"orderItem"]) {
        if ([UserLoginModel isAverageUser]) {
            MyOrderController *theOrder = [[MyOrderController alloc] init];
            [controller pushViewController:theOrder animated:YES];
        }
        else if ([UserLoginModel isShopOwner]){
            BusinessOrderController *business = [[BusinessOrderController alloc] init];
            [controller pushViewController:business animated:YES];
        }
        else {
            DistributionViewController *distribution = [[DistributionViewController alloc] init];
            [controller pushViewController:distribution animated:YES];
        }
        myController.hidesBottomBarWhenPushed = NO;
        return;
    }
    
    if ([shortcutItem.type isEqualToString:@"messgeItem"]) {
        MsgSortViewController *message = [[MsgSortViewController alloc] init];
        [controller pushViewController:message animated:YES];
        myController.hidesBottomBarWhenPushed = NO;
        return;
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    if ([[url absoluteString] rangeOfString:@"wxe68819a570c073c8://pay"].location == 0) {
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    if ([[url absoluteString] rangeOfString:@"wxe68819a570c073c8://pay"].location == 0) {
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

@end
