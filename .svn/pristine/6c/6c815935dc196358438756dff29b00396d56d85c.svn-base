//
//  BusinessInfo.h
//  KingProFrame
//
//  Created by lihualin on 15/12/28.
//  Copyright © 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessInfo : NSObject
/**商户名称*/
@property (nonatomic , retain) NSString * name;
/**店铺图片*/
@property (nonatomic , retain) NSString * imgUrl;
/**已完成订单数量*/
@property (nonatomic , assign) NSInteger  finishOrder;
/**联系人电话*/
@property (nonatomic , retain) NSString * mobile;
/**是否认证 ，0=否，1=是*/
@property (nonatomic , assign) NSInteger  isCheck;
/**接单分 ，1-5的整数*/
@property (nonatomic , assign) NSInteger  scoreAccept;
/**配送分（送货速度），1-5的整数*/
@property (nonatomic , assign) NSInteger  scoreDelivery;
/**服务分(商家态度)，1-5的整数*/
@property (nonatomic , assign) NSInteger  scoreService;
/**商品匹配分，1-5的整数*/
@property (nonatomic , assign) NSInteger  scoreGoods;
/**综合分，1-5的整数*/
@property (nonatomic , assign) NSInteger  scoreAvg;
/**好评率，有数据时返回 90% ,无数据时返回--*/
@property (nonatomic , retain) NSString * goodRate;
/**周好评率，商家身份时返回，有数据时返回 90% ,无数据时返回--*/
@property (nonatomic , retain) NSString * weekGoodRate;
/**周接单率，商家身份时返回，有数据时返回 90% ,无数据时返回 --*/
@property (nonatomic , retain) NSString * weekAcceptRate;
/**周接单率，周接单数，有数据时返回单数，无数据时返回 --*/
@property (nonatomic , retain) NSString * weekAcceptOrders;
/**商家星级, -1 表示该商家未参与星级评级系统*/
@property (nonatomic , assign) NSInteger  shopLevel ;
/**用户评价列表*/
@property (nonatomic , retain) NSArray * shopLabelList;

@end
