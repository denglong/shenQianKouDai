
//
//  SettingsViewController.m
//  KingProFrame
//
//  Created by 李栋 on 15/7/28.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChangeViewController.h"
#import "AboutViewController.h"
#import "RegisterViewController.h"
#import "ApiViewController.h"
#import "TabBarController.h"

@interface SettingsViewController ()
{
//    NSArray  *images;
    NSArray  *titles;
    NSString *cacheString;
    UILabel  *cacheLabel;
//    UISwitch *messageSwitch;
}
@end

@implementation SettingsViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    self.title = @"设置";
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self getCacheSize];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSInteger NUM = SETNUMBER;
    if (NUM == 6) {
        if ([UserLoginModel isLogged]) {
            titles = [NSArray arrayWithObjects:@"清除缓存",
                      @"关于省钱口袋",
                      @"投诉电话",
                      @"评价省钱口袋",
                      @"退出当前账号",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"APINAME"], nil];
        }else{
            titles = [NSArray arrayWithObjects:@"清除缓存",
                      @"关于省钱口袋",
                      @"投诉电话",
                      @"评价省钱口袋",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"APINAME"], nil];
        }

        
        [self.settingsTableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

/**
 * Method name:getCacheSize
 * Description:获取缓存大小
 */
- (void)getCacheSize
{
    unsigned long long size = 0;
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            size += [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error].fileSize;
            //DLog(@"%llu",size);
        }
    }
    //DLog(@"%0.1fMB",(float)size/1024/1024);
    cacheString = [NSString stringWithFormat:@"%0.1fM",(float)size/1024/1024];
    // DLog(@"cache ------%@",_cacheStr);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setExtraCellLineHidden:self.settingsTableView];
//    images = [NSArray arrayWithObjects:@"setup_changePW",
//                                       @"setup_clearCache",
//                                       @"setup_message",
//                                       @"setup_aboutEQB",
//                                       @"",
//                                       @"",nil];
    if ([UserLoginModel isLogged]) {
        titles = [NSArray arrayWithObjects:@"清除缓存",
                  @"投诉电话",
                  @"评价省钱口袋",
                  @"退出当前账号",nil];
    }else{
        titles = [NSArray arrayWithObjects:@"清除缓存",
                  @"关于省钱口袋",
                  @"投诉电话",
                  @"评价省钱口袋",nil];
    }
   
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserLoginModel isLogged] && SETNUMBER == 1) {
        return titles.count + 1;
    }
    
    return titles.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *Contentidentifier = @"_ContentCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Contentidentifier];
    if (cell == nil){
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Contentidentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrows"]];
//    cell.imageView.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    if (indexPath.row != 5) {
         cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    

    if (indexPath.row == 0) {
        if (cacheLabel == nil) {
             cacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth-35-150, 0, 150, cell.frame.size.height)];
            cacheLabel.textAlignment = NSTextAlignmentRight;
            cacheLabel.textColor = [UIColor grayColor];
            cacheLabel.font = [UIFont systemFontOfSize:12.f];
            [cell.contentView addSubview:cacheLabel];
        }
       
        cacheLabel.text = [NSString stringWithFormat:@"已使用%@",cacheString];
    }
    if (indexPath.row == 1) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth-35-150, 0, 150, cell.frame.size.height)];
        label.text = @"点击拨打";
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:13.f];
        [cell.contentView addSubview:label];
    }
    
    if (indexPath.row == 5) {
        NSString *apiStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"APINAME"];
        if ([DataCheck isValidString:apiStr]) {
            cell.textLabel.text = apiStr;
        }
        else
        {
            cell.textLabel.text = @"环境切换";
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
        switch (indexPath.row) {
            case 0:
            {//清除缓存
                [SRMessage infoMessage:@"您确定清除所有的的缓存数据吗？" block:^{
                    [self clearCache];
                }];
            }
                break;
//            case 1:
//            {
//                //关于eqbang
//                AboutViewController *aboutViewController = [[AboutViewController alloc]init];
//                self.navigationController.navigationBarHidden = YES;
//                [self.navigationController pushViewController:aboutViewController animated:YES];
//            }
                break;
            case 1:
            {  //投诉电话
                [SRMessage infoMessage:[NSString stringWithFormat:@"是否拨打投诉电话 %@?",@"13310953123"] block:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"13310953123"]]];
                }];
            }
                break;
            case 2:
            {  //评价省钱口袋
                 [self goAppStorePing];
            }
                break;
            case 3:
            {//退出登录
                if ([UserLoginModel isLogged]) {
                     [self LogOutPress:nil];
                }
            }
                break;
            case 5:
            {//设置api环境
                ApiViewController *apiView = [[ApiViewController alloc] init];
                [self.navigationController pushViewController:apiView animated:YES];
            }
                break;
            default:
                break;
        }
    
}

////表尾 高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 60;
//}
//
////设置表尾View
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
//    footView.backgroundColor = [UIColor clearColor];
//    UIButton *LogOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    LogOutButton.frame = CGRectMake(10, 20, self.view.frame.size.width - 20, 40);
//    LogOutButton.backgroundColor = RGBACOLOR(239, 189, 57, 1.0);
//    LogOutButton.layer.borderColor = RGBACOLOR(239, 189, 57, 1.0).CGColor;
//    LogOutButton.layer.borderWidth = 0.5;
//    LogOutButton.layer.cornerRadius = 5;
//    [LogOutButton setBackgroundImage:[UIImage imageNamed:@"nextBtn_bg.png"]forState:UIControlStateNormal];
//    [LogOutButton setBackgroundImage:[UIImage imageNamed:@"nextBtn_bg_pressed.png"]forState:UIControlStateHighlighted];
//    [LogOutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
//    LogOutButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [LogOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [LogOutButton addTarget:self action:@selector(LogOutPress:) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:LogOutButton];
//    if ([UserLoginModel isLogged]) {
//        return footView;
//    }else{
//        return nil;
//    }
//    
//}

// 退出登录
- (void)LogOutPress:(id)sender
{
    [SRMessage infoMessage:@"确认退出当前账号？" block:^{
        [MobClick event:Logout];
        [[CommClass sharedCommon]setObject:@"YES" forKey:@"switchstatus"];
        
        [UserLoginModel setLoginOut];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//清理缓存的方法
- (void)clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                   });
    
}
//缓存清理成功调用的方法
- (void)clearCacheSuccess
{
    [SRMessage infoMessage:@"清理缓存成功" delegate:self];
    cacheLabel.text = @"已使用0.0M";
    
    [self saveUpdataTime:@"0"];
}

- (void)saveUpdataTime:(NSString *)nextDate {
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:@"myOldTime.plist"];
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    [data setObject:nextDate forKey:@"nextDate"];
    
    //输入写入
    [data writeToFile:filename atomically:YES];
}

////开关按钮的响应事件
//- (void)messageSwitchAction:(id)sender
//{
//    UISwitch *messageswitch = (UISwitch *)sender;
//    if (messageswitch.on == YES) {
//        [SRMessage infoMessage:@"消息已开启，您可以收到消息通知" delegate:self];
//
//        [[CommClass sharedCommon]setObject:@"YES" forKey:@"switchstatus"];
//        
//        //打开个推推送
//        [GeTuiSdk setPushModeForOff:NO];
//        
//    }else{
//        //关闭个推推送
//        [GeTuiSdk setPushModeForOff:YES];
//        
//        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
//        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"switchstatus"];
//        [[CommClass sharedCommon]setObject:@"NO" forKey:@"switchstatus"];
//         [SRMessage infoMessage:@"消息已关闭，您将无法收到消息通知" delegate:self];
//    }
//}
//跳转到AppStore 评分页面
-(void)goAppStorePing
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    NSString *appid=@"1216722392";
    NSString *str;
    
    if (IOS7) {
        str = [NSString stringWithFormat:
               @"itms-apps://itunes.apple.com/app/id%@", appid];
    }
    else{
        str = [NSString stringWithFormat:
               @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appid];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
