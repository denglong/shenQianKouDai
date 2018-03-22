//
//  HomeApiModel.h
//  KingProFrame
//
//  Created by denglong on 3/2/16.
//  Copyright © 2016 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Headers.h"
#import "HomeModel.h"
#import "ShoppingCartModel.h"
#import "ShopBtnView.h"

@protocol HomeApiDelegate <NSObject>

- (void)homeResponseData:(BOOL)isSuccessed Response:(NSDictionary *)response model:(NSObject *)model type:(NSInteger)type;/** type标识，1.首页数据，*/

@end

@interface HomeApiModel : NSObject
@property (nonatomic, strong) id<HomeApiDelegate> delegate;
@property (nonatomic, strong) CloudClient *client;
@property (nonatomic, strong) HomeModel *homeModel;
@property (nonatomic, strong) ShoppingCartModel *cartModel;
@property (nonatomic, strong) ShopBtnView *shopBtnView;
@property (nonatomic, retain) MBProgressHUD        *HUD;
@property (nonatomic, retain) NSTimer                *myTimer;

+ (HomeApiModel *)sharedInstance;
- (void)getHomeInfoRequest; //获取首页信息的请求
- (void)getCartTotalData;   //获取购物车合计数据
- (void)getUpData;
- (void)orderLoopAction;   //订单状态轮询接口
- (void)setUserLocation;  //用户位置信息接口
- (void)addCartGoodAction:(NSString *)goodsId;   //加入购物车接口
-(void)getMyInfoData;

//显示或隐藏时间进度圈
- (void)showHUD;
- (void)hidenHUD;

@end
