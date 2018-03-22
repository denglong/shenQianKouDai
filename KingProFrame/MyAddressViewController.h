//
//  MyAddressViewController.h
//  KingProFrame
//
//  Created by lihualin on 15/8/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^addressNumBlock)(NSUInteger addressNum);
@protocol PassTrendValueDelegate

-(void)passTrendValues:(NSDictionary *)values andAddressId:(NSString *)addressId;//1.1定义协议与方法

@end

@interface MyAddressViewController : BaseViewController 

@property (retain,nonatomic) id <PassTrendValueDelegate> trendDelegate;
@property (nonatomic, assign) NSInteger confirmPage;                 /**<结算页面获取地址，传值为1*/
@property (nonatomic , retain) NSString * selectedID;  //已经选择的地址id
 @property (nonatomic , retain) id delegate;
@property (nonatomic, assign) NSInteger addressnum; //地址总个数
-(void)setAddressNumBlock:(addressNumBlock) block;
@end
