//
//  SRMessage.m
//  Discuz2
//
//  Created by rexshi on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SRMessage.h"
#import "BaseViewController.h"
#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)
#define IOS8 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0)
#define IOS9 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0)
@implementation SRMessage

+ (void) errorMessage:(NSString *)message
{
    BaseViewController * base = [[CommClass sharedCommon] objectForKey:@"windowRootController"];
    [self errorMessage:message delegate:base];
}

+ (void) errorMessage:(NSString *)message delegate:(id)delegate
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                     message:message
                                                    delegate:delegate
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

+ (void) successMessage:(NSString *)message
{
    [self successMessage:message delegate:nil];
}

+ (void) successMessage:(NSString *)message delegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

//+ (void) infoMessage:(NSString *)message {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                    message:message
//                                                   delegate:nil
//                                          cancelButtonTitle:nil
//                                          otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
//    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(remove:) userInfo:alert repeats:NO];
//}

+ (void) infoMessage:(NSString *)message
{
    [self infoMessage:message delegate:nil];
}

+ (void)infoMessage:(NSString *)message block:(void (^)())block
{
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"返回";
    cancelItem.action = ^{};
    RIButtonItem *buttonItem = [RIButtonItem item];
    buttonItem.label = @"确定";
    buttonItem.action = block;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示!"
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:buttonItem,nil];
    [alertView show];
    [alertView release];
}

+ (void)orderBusinessMessage:(NSString *)message block:(void (^)())block
{
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"返回,联系用户";
    cancelItem.action = ^{};
    RIButtonItem *buttonItem = [RIButtonItem item];
    buttonItem.label = @"已协商,确定取消";
    buttonItem.action = block;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示!"
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:buttonItem,nil];
    [alertView show];
    [alertView release];
}

+ (void)loginInfoMessage:(NSString *)message block:(void (^)())block
{
    RIButtonItem *buttonItem = [RIButtonItem item];
    buttonItem.label = @"知道了";
    buttonItem.action = block;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示!"
                                                        message:message
                                               cancelButtonItem:nil
                                               otherButtonItems:buttonItem,nil];
    [alertView show];
    [alertView release];
}

+ (void)infoMessageOk:(NSString *)message block:(void (^)())block
{
    RIButtonItem *buttonItem = [RIButtonItem item];
    buttonItem.label = @"确定";
    buttonItem.action = block;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                               cancelButtonItem:nil
                                               otherButtonItems:buttonItem,nil];
    [alertView show];
    [alertView release];
}

+ (void) infoMessageWithTitle:(NSString *)title message:(NSString *)message
{
    [self infoMessageWithTitle:title message:message delegate:nil];
}

+ (void) infoMessage:(NSString *)message delegate:(id)delegate
{
    if (IOS9) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [delegate presentViewController:alertController animated:YES completion:nil];
       
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(remove:) userInfo:alertController repeats:NO];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(remove:) userInfo:alert repeats:NO];
}
}


+ (void) infoMessageWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示!"
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

+ (void)myInfoMessage:(NSString *)message delegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"去看看", nil];
    [alert show];
    [alert release];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeApp:) userInfo:alert repeats:NO];
}

+(void)remove:(NSTimer *)timer
{
    if (IOS9) {
        UIAlertController * alert = [timer userInfo];
        [alert dismissViewControllerAnimated:NO completion:nil];
    }else{
        UIAlertView *alert=[timer userInfo];
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }
}

+(void)removeApp:(NSTimer *)timer
{
    UIAlertView *alert=[timer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

+ (void)infoMessage:(NSString *)message title:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle block:(void (^)())block
{
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = cancelTitle;
    cancelItem.action = ^{};
    RIButtonItem *buttonItem = [RIButtonItem item];
    buttonItem.label = sureTitle;
    buttonItem.action = block;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示!"
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:buttonItem,nil];
    [alertView show];
    [alertView release];
}

+ (void)infoMessage:(NSString *)message title:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle block:(void (^)())block cancleBlock:(void(^)())cancleBlock
{
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = cancelTitle;
    cancelItem.action = cancleBlock;
    RIButtonItem *buttonItem = [RIButtonItem item];
    buttonItem.label = sureTitle;
    buttonItem.action = block;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示!"
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:buttonItem,nil];
    [alertView show];
    [alertView release];
}

+ (void)infoDLMessage:(NSString *)message title:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle block:(void (^)())block cancleBlock:(void(^)())cancleBlock
{
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = cancelTitle;
    cancelItem.action = cancleBlock;
    RIButtonItem *buttonItem = [RIButtonItem item];
    buttonItem.label = sureTitle;
    buttonItem.action = block;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:buttonItem,nil];
    [alertView show];
    [alertView release];
}

@end
