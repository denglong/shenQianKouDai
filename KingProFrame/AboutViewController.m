//
//  AboutViewController.m
//  KingProFrame
//
//  Created by 李栋 on 15/7/30.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "AboutViewController.h"
#import "TeasingViewController.h"
#import "UserAgreementViewController.h"


@interface AboutViewController ()
{
    NSArray *titles;
//    NSArray *images;
}
@end

@implementation AboutViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setExtraCellLineHidden:self.aboutTableView];
    
    titles = [NSArray arrayWithObjects:@"当前版本",
                                       @"新版介绍",
                                       @"帮助中心",
                                       @"商务合作",
                                       nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title = @"关于省钱口袋";
    //self.navigationController.navigationBarHidden = YES;
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
//返回
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//评价
- (IBAction)evaluationButtonPress:(id)sender {
    [self goAppStorePing];
}
//吐槽
- (IBAction)teasingButtonPress:(id)sender {
    TeasingViewController *teasingViewController = [[TeasingViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teasingViewController animated:YES];
}


#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth-15-150, 0, 150, cell.frame.size.height)];
        label.text = [NSString stringWithFormat:@"V%@",AppStore_VERSION];
        label.textColor = [UIColor_HEX colorWithHexString:@"#8fc31f"];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14.f];
        [cell.contentView addSubview:label];
    }else{
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrows"]];
    }
    if (indexPath.row == titles.count-1) {
         cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth-15-150, 0, 150, cell.frame.size.height)];
        label.text = @"029-63363702";
        label.textColor = [UIColor_HEX colorWithHexString:@"#8fc31f"];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14.f];
        [cell.contentView addSubview:label];
    }

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
//            UserAgreementViewController *userViewController = [[UserAgreementViewController alloc]init];
//            userViewController.titleString = @"省钱口袋用户协议";
//            NSString *url = [NSString stringWithFormat:@"%@user.jhtml", CLOUD_API_URL];
//            userViewController.urlString = url;
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:userViewController animated:YES];
        }
            break;
        case 1:
        {
            UserAgreementViewController *userViewController = [[UserAgreementViewController alloc]init];
            userViewController.titleString = @"新版介绍";
            NSString *url = [NSString stringWithFormat:@"%@intr.jhtml", CLOUD_API_URL];
            userViewController.urlString = url;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userViewController animated:YES];
        }
            break;
        case 2:
        {
            UserAgreementViewController *userViewController = [[UserAgreementViewController alloc]init];
            userViewController.titleString = @"帮助中心";
            NSString *url = [NSString stringWithFormat:@"%@help.jhtml", CLOUD_API_URL];
            userViewController.urlString = url;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userViewController animated:YES];
        }
            break;
//        case 3:
//        {
//            [SRMessage infoMessage:[NSString stringWithFormat:@"是否拨打投诉电话 %@?",@"400-999-1191"] block:^{
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"400-999-1191"]]];
//            }];
//
//        }
//            break;
        case 3:
        {
            [SRMessage infoMessage:[NSString stringWithFormat:@"是否拨打商务合作电话 %@?",@"029-63363702"] block:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"029-63363702"]]];
            }];
            
        }
            break;
        default:
            break;
    }
    
}

//跳转到AppStore 评分页面
-(void)goAppStorePing
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }

    NSString *appid=@"911766077";
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
