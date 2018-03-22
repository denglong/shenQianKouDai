//
//  BaseViewController.h
//  KingProFrame
//
//  Created by JinLiang on 15/7/1.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"
#import "CloudClient.h"
#import "CloudClientRequest.h"
#import "CustomAlertView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, retain) MJRefreshHeader *refreshHeaderView;
@property (nonatomic, retain) MJRefreshFooter *refreshFooterView;
@property (nonatomic, retain) MBProgressHUD        *HUD;
@property (nonatomic, retain) NSTimer                *myTimer;
@property (nonatomic, retain) NSMutableArray *myTitleBtns;
@property (nonatomic, assign) NSInteger cancleTag;

-(void)backAction:(id)sender;
//时间转换成时间戳
-(NSString*)formatTime:(NSString*)standardTime;
//时间戳转换成时间 timeFormat是要转换成的时间格式
-(NSString*)formatTimeStamp:(NSString *)timeStamp timeFormat:(NSString *)timeFormat;
//获取当前的时间戳
-(NSString *)getCurrentTimeStamp;
//清除tableview多余的空白行
-(void)setExtraCellLineHidden: (UITableView *)tableView;
//导航栏添加右item  lihualin
-(UIBarButtonItem *)createRightItem: (id)sender itemStr:(NSString *)itemString itemImage:(UIImage *)itemImage itemImageHG:(UIImage *)itemImageHG selector:(SEL)selector;
//导航栏添加左item  lihualin
-(UIBarButtonItem *)createLeftItem: (id)sender itemStr:(NSString *)itemString itemImage:(UIImage *)itemImage itemImageHG:(UIImage *)itemImageHG selector:(SEL)selector;
//MD5加密 add lihualin
-(NSString *)md5:(NSString *)str;
//正泽用来判断是否为正确的手机号 add lihualin
- (BOOL)checkTel:(NSString *)str;
//密码规则
-(BOOL)checkPassWord:(NSString *)passWord;
//拼接字符串
-(NSString *)getPhoneStr :(NSString *)str fromIndex:(NSInteger)index Ranglength:(NSInteger)length subString:(NSString *)subString;


//刷新加载方法
- (void)setupRefresh:(id)tableView;
- (void)setupHeaderRefresh:(id)tableView;
- (void)setUpFooterRefresh:(id)tableView;
- (void)setUpNoAutoRefreshHeader:(id)tableView;
- (void)headerRereshing;
- (void)footerRereshing;

//时间戳去掉多余零
- (NSString *)subStringlostZero:(NSString *)str;
//显示或隐藏时间进度圈
- (void)showHUD;
- (void)hidenHUD;

//弹出动画
- (void)popupAnimation:(UIView*)outView duration:(CFTimeInterval)duration;



//分享 传入你要分享对应的参数即可
- (void)shareapplicationContent:(NSString *)content
                 defaultContent:(NSString *)defaultContentString
                          title:(NSString *)titleString
                            url:(NSString *)urlString
                    description:(NSString *)descriptionString
                           type:(SSDKPlatformType)type
                      imagePath:(NSString *)imagePath;
//纯文字的分享
- (void)sharetextContent:(NSString *)content type:(SSDKPlatformType)type;

- (UIView *)createTitle:(NSDictionary *)titleDic andViewWidth:(NSInteger)width;
- (void)titleAction:(UIButton *)sender;

- (NSDictionary*)formatSpecialArray:(NSArray*)specialArray;//格式化特殊数组为可用字典  type  value

//检测网络状况
-(BOOL)isNotNetwork;

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
      borderWidth:(CGFloat)borderWidth;

//个推注册
- (void)registerRemoteNotification;

@end
