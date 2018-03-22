
//
//  ShopDetailsController.m
//  KingProFrame
//
//  Created by denglong on 7/30/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "ShopDetailsController.h"

@interface ShopDetailsController ()
{
    CloudClient              *client;            /**<网络请求类*/
    NSDictionary             *respData;
    NSString                  *phoneNum;
}

@end

@implementation ShopDetailsController
@synthesize myScrollView, headerImgView, shopName, certify, orderNum, shopId;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";
    [self createView];
}

/**
 * Method name: createView
 * MARK: - 设置页面元素
 */
- (void)createView {
    
    self.navigationItem.rightBarButtonItem = [super createRightItem:self itemStr:nil itemImage:UIIMAGE(@"icon_phone") itemImageHG:nil selector:@selector(rightAction:)];
    
    myScrollView.frame = CGRectMake(0, 0, viewWidth, self.myScrollView.frame.size.height );
    myScrollView.contentSize = CGSizeMake(0, myScrollView.frame.size.height + 1);
    
    client = [CloudClient getInstance];
    [self getShopInfoData];
}

- (void)rightAction:(id)sender {
    
    phoneNum = [respData objectForKey:@"mobile"];
    
    //拨打用户电话
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"是否拨打电话 %@?", phoneNum] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 100) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]]];
        }
        
    }
}

/**
 * Method name: getShopInfoData
 * Description: 获取店主详情处理方法
 */
- (void)getShopInfoData {
    [client requestMethodWithMod:@"shop/getShopInfo"
                          params:nil
                      postParams:@{@"shopId":shopId}
                        delegate:self
                        selector:@selector(getShopInfoDataSuccessed:)
                   errorSelector:@selector(getShopInfoDatafiled:)
                progressSelector:nil];
}

- (void)getShopInfoDataSuccessed:(NSDictionary *)response {
    if ([DataCheck isValidDictionary:response]) {
        respData = response;
        
        shopName.text = [response objectForKey:@"name"];
        [shopName sizeToFit];
        shopName.frame = CGRectMake(shopName.frame.origin.x, shopName.frame.origin.y, viewWidth - (viewWidth - orderNum.frame.origin.x) - certify.frame.size.width - shopName.frame.origin.x, shopName.frame.size.height);
        certify.frame = CGRectMake(shopName.frame.origin.x + shopName.frame.size.width, certify.frame.origin.y, certify.frame.size.width, certify.frame.size.height);
        orderNum.text = [NSString stringWithFormat:@"已完成%@单", [response objectForKey:@"finishOrder"]];
        
        NSURL * url = [NSURL URLWithString:[response objectForKey:@"imgUrl"]];
        [headerImgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dizhuInfoHeader"]];
        
        NSArray *shopLabelList = [response objectForKey:@"shopLabelList"];
        NSMutableArray *names = [NSMutableArray array];
        NSMutableArray *numbers = [NSMutableArray array];
        if (shopLabelList.count > 0) {
            for (NSInteger i = 0; i < shopLabelList.count; i ++) {
                NSString *name = [shopLabelList[i] objectForKey:@"name"];
                NSString *number = [shopLabelList[i] objectForKey:@"number"];
                [names addObject:name];
                [numbers addObject:number];
            }
        }
        
        UIView *titleView =  [self createTitle:@{@"titleName":names, @"titleNum":numbers} andViewWidth:viewWidth - 60];
        titleView.frame = CGRectMake(20, 0, titleView.frame.size.width, titleView.frame.size.height);
        titleView.backgroundColor = [UIColor whiteColor];
        if (titleView.subviews.count > 0) {
            self.bgView.frame = CGRectMake(0, 320, viewWidth, titleView.frame.size.height);
            myScrollView.contentSize = CGSizeMake(0, 320 + titleView.frame.size.height + 20);
        }
        else
        {
            self.bgView.frame = CGRectZero;
        }
        [self.bgView addSubview:titleView];
    }
}

- (void)getShopInfoDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

@end
