//
//  NewAddressViewController.h
//  KingProFrame
//
//  Created by lihualin on 15/8/3.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BaseViewController.h"
#import "MyAddressModel.h"
#import "MapLocation.h"

@protocol newAddressDelegate <NSObject>

- (void)newAddress:(NSDictionary *)values andAddressId:(NSString *)addressId;

@end

@interface NewAddressViewController : BaseViewController
@property (nonatomic ,retain) NSString * type;
@property (nonatomic ,retain) MyAddressModel * addressInfo;

@property (nonatomic, retain) id<newAddressDelegate> addressDelegate;
@property (nonatomic, assign) NSInteger confirmPage;                       /**<确认订单页传值为1*/
@property (nonatomic, assign) BOOL confirmPageList;                       /**<确认订单页到列表，列表到新建*/
@end
