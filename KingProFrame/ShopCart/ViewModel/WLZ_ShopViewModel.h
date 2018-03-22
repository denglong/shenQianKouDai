//
//  WLZ_ShopViewModel.h
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^NumPriceBlock)();

@interface WLZ_ShopViewModel : NSObject


@property(nonatomic,copy)NumPriceBlock priceBlock;

- (void)getShopData:(void (^)(NSArray * commonArry, NSArray * kuajingArry))shopDataBlock  priceBlock:(void (^)()) priceBlock;

- (void)getNumPrices:(void (^)()) priceBlock;

-(void)clickAllBT:(NSMutableArray *)carDataArrList bt:(UIButton *)bt;

- (NSDictionary *)verificationSelect:(NSMutableArray *)arr type:(NSString *)type;



- (void)pitchOn:(NSMutableArray *)carDataArrList;

@end
