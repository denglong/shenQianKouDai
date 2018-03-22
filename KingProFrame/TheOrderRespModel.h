//
//  TheOrderRespModel.h
//  KingProFrame
//
//  Created by denglong on 8/10/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "ResponseModel.h"

@interface TheOrderRespModel : ResponseModel

@property (nonatomic, retain) NSArray *orderList;
@property (nonatomic, retain) NSArray *handleList;
@property (nonatomic, retain) NSArray *finishList;
@property (nonatomic, retain) NSArray *evaluationList;

+ (TheOrderRespModel *)sharedInstance;

- (void)setOrderList:(NSArray *)myOrderList;
- (NSArray *)getOrderList;

- (void)setHandleList:(NSArray *)myHandleList;
- (NSArray *)getHandleList;

- (void)setFinishList:(NSArray *)myFinishList;
- (NSArray *)getFinishList;

- (void)setEvaluationList:(NSArray *)myEvaluationList;
- (NSArray *)getEvaluationList;

@end
