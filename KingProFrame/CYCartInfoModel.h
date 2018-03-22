//
//  CYCartInfoModel.h
//  KingProFrame
//
//  Created by eqbang on 15/12/3.
//  Copyright © 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYCartInfoModel : NSObject

/** 购物车中商品数量 */
@property (nonatomic,assign) int cartNumber;
/** 购物车货物总价 */
@property (nonatomic,assign) float cartPrice;
/** 差多少钱免邮费文案 */
@property (nonatomic,copy) NSString *cartShipping;

@end
