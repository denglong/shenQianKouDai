//
//  CategoryController.h
//  KingProFrame
//
//  Created by JinLiang on 15/7/27.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CategoryDetailCell.h"
#import "MenuTableViewCell.h"
#import "ShopCartController.h"
#import "SearchViewController.h"
#import "GeneralShowWebView.h"
#import "ShoppingCartModel.h"
#import "CategoryModel.h"

@interface CategoryController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    
}

#pragma -mark view element
/** 右侧商品tableview */
@property(nonatomic,retain)IBOutlet UITableView *goodsTableView;
/** 左侧菜单tableview */
@property(nonatomic,retain)IBOutlet UITableView *menuTableView;

@property(nonatomic,retain)IBOutlet UIView  *shoppingView;
@property(nonatomic,retain)IBOutlet UIImageView *shopBgImgView;
@property(nonatomic,retain)IBOutlet UIImageView *cartImgView;
@property(nonatomic,retain)IBOutlet UILabel *priceLabel;
@property(nonatomic,retain)IBOutlet UILabel *numLabel;
@property(nonatomic,retain)IBOutlet UILabel *diffPriceLabel;
@property(nonatomic)int pageNum;

#pragma -mark data element

@property(nonatomic,retain)NSMutableArray *menuDataArray;//分类菜单
@property(nonatomic,retain)NSMutableArray *goodsDataArray;//展示的商品
@property (strong, nonatomic) IBOutlet UIView *tableViewBgView;


#pragma -mark shopping element
@property(nonatomic,retain)NSMutableArray *shoppingArray;//添加进购物车的商品

@property(nonatomic,retain)NSMutableArray *cartInfoArray;
@property(nonatomic,retain)NSString *typeId;//类别ID

//搜索
@property(nonatomic,retain)IBOutlet UIView *searchView;
@property(nonatomic,retain)IBOutlet UITextField *searchTextField;


@property(nonatomic,retain)CloudClient *cloudClient;

@property(nonatomic)NSInteger whichCellFlag;


/** 传入的id */
@property (nonatomic,copy) NSString *transportID;

/** homePagePushFlag */
@property (nonatomic,assign,getter=isHomePagePushed) BOOL homePagePushed;

@end
