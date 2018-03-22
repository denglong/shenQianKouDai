//
//  WLZ_ShoppIngCarModel.h
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WLZ_ShopViewModel.h"
#import "WLZ_CommodityModel.h"

@class WLZ_CommodityModel;

@interface WLZ_ShoppIngCarModel : NSObject





@property(nonatomic,copy)NSString *item_id;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *item_size;
@property(nonatomic,strong)WLZ_CommodityModel *item_info;
@property(nonatomic,assign)BOOL isSelect;



@property(nonatomic,assign)NSInteger type;

@property(nonatomic,weak)WLZ_ShopViewModel *vm;
@end
