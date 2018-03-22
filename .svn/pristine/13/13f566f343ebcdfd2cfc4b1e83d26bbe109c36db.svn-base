//
//  ShoppingCartModel.h
//  KingProFrame
//
//  Created by JinLiang on 15/9/8.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Headers.h"
#import "MBProgressHUD.h"
#import "CloudClient.h"

@class CloudClient;

@protocol shopingCartDelegate <NSObject>

- (void)shopingCartAction;
- (void)shopingAddFiled;

@end

@interface ShoppingCartModel : NSObject
{
    
}

@property (nonatomic, strong) id<shopingCartDelegate> delegate;
@property (nonatomic, retain) NSDictionary *shoppingCartInfo;
@property (nonatomic, retain) CloudClient *client;
@property (nonatomic, retain) NSArray *shopInfos;
@property (nonatomic, assign) BOOL homeEditShop;

+(id)shareModel;

- (void)getCartInfo;
-(void)addWithGoodsId:(NSString *)goodsId;
- (void)editWithGoodsId:(NSString *)goodsId andNumber:(NSString *)number;

//更新购物车信息
-(void)updateShoppingCartInfo:(NSDictionary *)shoppingCartInfo;

-(NSString *)goodsNum;//商品数量
-(NSString *)goodsPrice;//商品价格
-(NSString *)goodsShipping;//商品运费差价信息

@end
