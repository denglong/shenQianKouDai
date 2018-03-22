//
//  MessageViewController.h
//  KingProFrame
//
//  Created by lihualin on 15/8/5.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageViewController : BaseViewController
@property (nonatomic, assign) NSInteger indexXG;       /**<信鸽跳转信息列表传1*/
@property (nonatomic , retain) NSString * msgType;  /**对应目录页面返回的Id*/
@end
