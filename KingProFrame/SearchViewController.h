//
//  SearchViewController.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/27.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BaseViewController.h"
#import "CategoryDetailCell.h"
#import "CommodityDetailsViewController.h"
#import "ShopCartController.h"
#import "ShoppingCartModel.h"
#import "CYSearchTableViewCell.h"

@interface SearchViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (nonatomic,retain)NSString *searchKey;
@property (strong,nonatomic)NSMutableArray *searchInfoArray;//搜索数组
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;//搜索tableview
@property (strong, nonatomic) IBOutlet UIView *navSearchView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic,retain) CloudClient *cloudClient;
@property (strong, nonatomic) IBOutlet UIView *noSearchView;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (strong, nonatomic) IBOutlet UILabel *goodsNumLabel;//数量
@property (strong, nonatomic) IBOutlet UILabel *shippingLabel;//运费

@property (strong, nonatomic) IBOutlet UIButton *chooseOkBtn;//选好了
@property (strong, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIImageView *shopCartImage;


@end
