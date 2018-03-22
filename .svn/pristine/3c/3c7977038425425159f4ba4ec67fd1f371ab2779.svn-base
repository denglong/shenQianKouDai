//
//  ShoppingCartModel.m
//  KingProFrame
//
//  Created by JinLiang on 15/9/8.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "ShoppingCartModel.h"
#import "TabBarController.h"

@implementation ShoppingCartModel

+(id)shareModel{
    
    static id shareModel;
    @synchronized(self){
        if (!shareModel) {
            shareModel=[[self alloc] init];
        }
        return shareModel;
    }
}


#pragma -mark 添加购物车

-(void)addWithGoodsId:(NSString *)goodsId{
    [[CommClass sharedCommon]setObject:@"" forKey:CART_GOODSID];
    
    _client=[CloudClient getInstance];
    
    NSDictionary *paramsDic=@{@"goodsId":goodsId,@"number":@"1"};
    
    [_client requestMethodWithMod:@"cart/addCart"
                           params:nil
                       postParams:paramsDic
                         delegate:self
                         selector:@selector(editShoppingSuccess:)
                    errorSelector:@selector(editShoppingFail:)
                 progressSelector:nil];
    
}

- (void)editWithGoodsId:(NSString *)goodsId andNumber:(NSString *)number {
    [[CommClass sharedCommon]setObject:@"" forKey:CART_GOODSID];
    
    _client=[CloudClient getInstance];
    
    NSDictionary *paramsDic = nil;
    if ([number integerValue] > 0) {
        paramsDic=@{@"type":@"1", @"goodsId":goodsId,@"number":number};
    }
    else
    {
        paramsDic=@{@"type":@"2", @"goodsId":goodsId,@"number":number};
    }
    
    [_client requestMethodWithMod:@"cart/editCart"
                           params:nil
                       postParams:paramsDic
                         delegate:self
                         selector:@selector(editShoppingSuccess:)
                    errorSelector:@selector(editShoppingFail:)
                 progressSelector:nil];
}

-(void)editShoppingSuccess:(NSDictionary *)response{

    if ([DataCheck isValidDictionary:[response objectForKey:@"cartInfo"]]) {
        
        NSString *number = response[@"cartInfo"][@"cartNumber"];
        [[TabBarController sharedInstance] setShopCartNumberAction:number];
        
        NSDictionary *cartInfo=[response objectForKey:@"cartInfo"];
        [self updateShoppingCartInfo:cartInfo];
        
        NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_UPDATESHOPPINGCARTINFO
                                                                     object:nil
                                                                   userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self.delegate shopingCartAction];
        
        self.shopInfos = [response objectForKey:@"goodsList"];
    }
}

-(void)editShoppingFail:(NSDictionary *)response{
    
    [[CommClass sharedCommon]setObject:@"" forKey:CART_GOODSID];
}

- (void)getCartInfo {
    _client=[CloudClient getInstance];
    
    NSDictionary *paramsDic=@{};
    
    [_client requestMethodWithMod:@"cart/getCartInfo"
                                params:nil
                            postParams:paramsDic
                              delegate:self
                              selector:@selector(addShoppingSuccess:)
                         errorSelector:@selector(addShoppingFail:)
                      progressSelector:nil];
}

-(void)addShoppingSuccess:(NSDictionary *)response{
    
    if ([DataCheck isValidDictionary:[response objectForKey:@"cartInfo"]]) {
        
        NSDictionary *cartInfo=[response objectForKey:@"cartInfo"];
        [self updateShoppingCartInfo:cartInfo];
        
        NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_UPDATESHOPPINGCARTINFO
                                                                     object:nil
                                                                   userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
         self.shopInfos = [response objectForKey:@"goodsList"];
        [self.delegate shopingCartAction];
        
       
    }
}

- (void)addShoppingFail:(NSDictionary *)response{
    
    [[CommClass sharedCommon]setObject:@"" forKey:CART_GOODSID];
}

//更新购物车信息
-(void)updateShoppingCartInfo:(NSDictionary *)shoppingCartInfo{

    _shoppingCartInfo=[NSDictionary dictionaryWithDictionary:shoppingCartInfo];
}

//数量
-(NSString *)goodsNum{
    return [_shoppingCartInfo objectForKey:@"cartNumber"];
}

//价格
-(NSString *)goodsPrice{
    return [_shoppingCartInfo objectForKey:@"cartPrice"];
}

//差价
-(NSString *)goodsShipping{
    return [_shoppingCartInfo objectForKey:@"cartShipping"];
}
@end
