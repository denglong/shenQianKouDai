//
//  TheOrderRespModel.m
//  KingProFrame
//
//  Created by denglong on 8/10/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "TheOrderRespModel.h"

@implementation TheOrderRespModel
@synthesize orderList, handleList, finishList, evaluationList;

//初始化单例
+ (ResponseModel *)sharedInstance
{
    static ResponseModel *sharedAccountManagerInstance = nil;
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

- (void)setHandleList:(NSArray *)myHandleList {
    handleList = myHandleList;
}
- (NSArray *)getHandleList {
    return handleList;
}

- (void)setFinishList:(NSArray *)myFinishList {
    finishList = myFinishList;
}
- (NSArray *)getFinishList {
    return finishList;
}

- (void)setEvaluationList:(NSArray *)myEvaluationList {
    evaluationList = myEvaluationList;
}
- (NSArray *)getEvaluationList {
    return evaluationList;
}

@end
