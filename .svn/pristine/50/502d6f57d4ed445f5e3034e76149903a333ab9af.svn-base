//
//  ChangeNameViewController.h
//  KingProFrame
//
//  Created by lihualin on 16/2/24.
//  Copyright © 2016年 king. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^backBlock)(NSString * showText);
@interface ChangeNameViewController : BaseViewController
/** 0 修改姓名 3注册账号 1 账户安全 2 修改密码*/
@property (nonatomic , assign) NSInteger viewtag;
/**注册账号*/
@property (nonatomic , retain) NSString * accountNumber;
-(void)setBackBlock:(backBlock) block;
@end
