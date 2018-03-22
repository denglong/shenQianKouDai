//
//  CYViewController.h
//  Custom 3D Demo
//
//  Created by eqbang on 16/2/18.
//  Copyright © 2016年 eqbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ConfirmOrderController.h"
#import "ShopCartTableViewCell.h"

typedef void(^passOrderInfoBlock)(NSDictionary *orderInfo);

@protocol CYShopCartingViewControllerDelegate <NSObject>

@optional

- (void)gotoBuy;
-(void)getGoods:(NSString *)goodsId;

@end

@interface CYShopCartingViewController : UIViewController

/** delegate */
@property (nonatomic , weak) id <CYShopCartingViewControllerDelegate> delegate;
/** 页面高度 */
@property (nonatomic,assign) CGFloat height;
/** passOrderInfoBlock */
@property (nonatomic , strong) passOrderInfoBlock passOrderInfo;

@end
