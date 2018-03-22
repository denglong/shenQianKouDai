//
//  AppModel.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/24.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppModel : NSObject

+ (id)sharedModel;
//跳转至登录页面
- (void)presentLoginController:(UIViewController *)parentController;
@end
