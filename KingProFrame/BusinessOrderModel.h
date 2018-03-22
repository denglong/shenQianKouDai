//
//  BusinessOrderModel.h
//  KingProFrame
//
//  Created by denglong on 8/12/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "ResponseModel.h"

@interface BusinessOrderModel : ResponseModel

@property (nonatomic, retain) NSArray *orderList;
@property (nonatomic, retain) NSString *orderNum;
@property (nonatomic, retain) NSString *myOrderNum;
@property (nonatomic, retain) NSData *deviceToken;

+ (BusinessOrderModel *)sharedInstance;

- (void)setOrderList:(NSArray *)myOrderList;
- (NSArray *)getOrderList;

- (void)setOrderNum:(NSString *)isOrderNum;
- (NSString *)getOrderNum;

- (void)setMyOrderNum:(NSString *)isMyOrderNum;
- (NSString *)getMyOrderNum;

- (void)setDeviceToken:(NSData *)myDeviceToken;
- (NSData *)getDeviceToken;

@end
