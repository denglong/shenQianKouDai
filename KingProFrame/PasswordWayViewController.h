//
//  PasswordWayViewController.h
//  KingProFrame
//
//  Created by 李栋 on 15/7/31.
//  Copyright (c) 2015年 king. All rights reserved.
//
//此类暂时没用
#import "BaseViewController.h"

@interface PasswordWayViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;


@property (weak, nonatomic) IBOutlet UITextField *passwordNewTextField;


@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;

- (IBAction)ConfirmButtonClick:(id)sender;

@end
