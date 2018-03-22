//
//  goodsListModel.h
//  KingProFrame
//
//  Created by denglong on 12/2/15.
//  Copyright © 2015 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodsListModel : NSObject

@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *goodsId;
@property (nonatomic, retain) NSString *goodsName;
@property (nonatomic, retain) NSString *goodsPrice;
@property (nonatomic, retain) NSString *goodsPic;
@property (nonatomic, retain) NSString *isHot;
@property (nonatomic, retain) NSString *buy;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *goodsNumber;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *sellType;
@property (nonatomic, strong) NSArray *goodsTags;
@property (nonatomic, copy) NSString *sellTypeIcon;
@property (nonatomic, copy) NSString *vipPrice;

@end
