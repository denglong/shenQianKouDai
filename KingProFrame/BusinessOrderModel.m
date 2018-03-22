//
//  BusinessOrderModel.m
//  KingProFrame
//
//  Created by denglong on 8/12/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "BusinessOrderModel.h"

@implementation BusinessOrderModel
@synthesize orderList, orderNum, myOrderNum, deviceToken;

+ (BusinessOrderModel *)sharedInstance {
    static BusinessOrderModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)setOrderList:(NSArray *)myOrderList {
    orderList = myOrderList;
}
- (NSArray *)getOrderList {
    return orderList;
}

- (void)setOrderNum:(NSString *)isOrderNum {
    orderNum = isOrderNum;
}
- (NSString *)getOrderNum {
    return orderNum;
}

- (void)setMyOrderNum:(NSString *)isMyOrderNum {
    myOrderNum = isMyOrderNum;
}
- (NSString *)getMyOrderNum {
    return myOrderNum;
}

- (void)setDeviceToken:(NSData *)myDeviceToken {
    deviceToken = myDeviceToken;
}
- (NSData *)getDeviceToken {
    return deviceToken;
}

@end
