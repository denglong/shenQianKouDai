//
//  AppModel.m
//  KingProFrame
//
//  Created by JinLiang on 15/8/24.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "AppModel.h"
#import "LaunchViewController.h"
#import "UserLoginModel.h"

@implementation AppModel

+(id)sharedModel{
    
    static id sharedModel;
    @synchronized(self){
        if (!sharedModel) {
            sharedModel=[[self alloc] init];
        }
        return sharedModel;
    }
}

//跳转至登录页面
- (void)presentLoginController:(UIViewController *)parentController{
    
//    if ([UserLoginModel isConscious]) {
//        
//    }
//    
//    NSInteger autoNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AUTODISMISS"] integerValue];
//    if (autoNum == 1) {
//        parentController = nil;
//    }
    
    [MobClick event:Clik_Login];
    UIViewController *controller=[LaunchViewController creatLoginController];
    //退出登录清理数据操作
    [UserLoginModel setLoginOut];
    [parentController presentViewController:controller animated:YES completion:nil];
    
}

@end
