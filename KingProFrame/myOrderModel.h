//
//  myOrderModel.h
//  KingProFrame
//
//  Created by denglong on 1/18/16.
//  Copyright © 2016 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myOrderModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *addressName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) NSArray *goodsResponses;
@property (nonatomic, copy) NSString *isCancel;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *receiveCode;
@property (nonatomic, copy) NSString *totalNumber;
@property (nonatomic, copy) NSString *totalPay;
@property (nonatomic, copy) NSString *yushou;
@property (nonatomic, copy) NSString *again;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *goodsNumber;
@property (nonatomic, copy) NSString *realPrice;

@end

