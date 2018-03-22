//
//  BusinessInfoViewController.h
//  KingProFrame
//
//  Created by lihualin on 15/12/23.
//  Copyright © 2015年 king. All rights reserved.
//

#import "BaseViewController.h"

@interface BusinessInfoViewController : BaseViewController
//@property (nonatomic , assign) NSInteger comePageTag; /** -100 从我的进入 -200 从顾客订单详情或评价界面，或支付界面进入*/
/**商铺ID*/
@property (nonatomic , copy) NSString * shopId;
@end
