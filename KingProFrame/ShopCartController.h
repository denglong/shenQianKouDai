//
//  ShopCartController.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BaseViewController.h"
#import "ConfirmOrderController.h"
#import "ShopCartTableViewCell.h"

@protocol ShopCartControllerDelegate <NSObject>

-(void)getGoods:(NSString *)goodsId;

@end


@interface ShopCartController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) CloudClient    * cloudClient;
@property (nonatomic,retain) NSMutableArray *cartInfoArray;
@property (nonatomic,retain) NSMutableArray *editArray;
@property (nonatomic,retain) NSDictionary   *settlementDic;
@property(nonatomic,retain)IBOutlet UITableView *goodsTableView;

@property (weak, nonatomic  ) IBOutlet UIButton *selecedAllBtn;

@property (nonatomic,retain ) IBOutlet UILabel  *priceLabel;
@property (nonatomic,retain ) IBOutlet UILabel  *numLabel;
@property (nonatomic,retain ) IBOutlet UILabel  *diffPriceLabel;

@property (nonatomic,retain ) IBOutlet UIButton *choseOkBtn;
@property (weak, nonatomic  ) IBOutlet UIView   *  shopCartBtnView;
@property (strong, nonatomic) IBOutlet UIView   *emptyView;
@property(nonatomic,assign)NSInteger commodityTag;
@property(nonatomic,retain) id<ShopCartControllerDelegate> delegate;

/** 全选删除整体view */
@property (weak, nonatomic) IBOutlet UIView   *deleteAllView;
/** 全选整体按钮 */
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
/** 删除所有按钮 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, assign) BOOL isOtherPush;

@end
