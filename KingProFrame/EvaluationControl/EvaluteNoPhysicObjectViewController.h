//
//  EvaluteNoPhysicObjectViewController.h
//  KingProFrame
//
//  Created by eqbang on 16/1/15.
//  Copyright © 2016年 king. All rights reserved.
//

#import "BaseViewController.h"


@interface EvaluteNoPhysicObjectViewController :BaseViewController

/** 是否是查看点评 */
@property (nonatomic,assign,getter=isCheckOutEvalute) BOOL checkOutEvalute;
/** 订单号 */
@property (nonatomic,copy) NSString *orderNum;

@end
