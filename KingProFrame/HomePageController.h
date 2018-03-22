//
//  HomePageController.h
//  KingProFrame
//
//  Created by JinLiang on 15/6/26.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIColor+FlatColors.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ShopCartController.h"
#import "MyViewController.h"
#import "MacroDefinitions.h"
#import "RegisterViewController.h"
#import "SearchViewController.h"
#import "GeneralShowWebView.h"
#import "CategoryController.h"
#import "TabBarController.h"
#import "MyOrderController.h"
#import "UIViewController+KNSemiModal.h"
#import "AddressMapViewController.h"

@interface HomePageController : BaseViewController<SGFocusImageFrameDelegate, AddressMapViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
