//
//  ChangeViewController.h
//  KingProFrame
//
//  Created by 李栋 on 15/7/30.
//  Copyright (c) 2015年 king. All rights reserved.
//
//此类暂时没用
#import "BaseViewController.h"

@interface ChangeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *passwordWayButton;

@property (weak, nonatomic) IBOutlet UIButton *phoneWayButton;

- (IBAction)twoWayButtonPress:(id)sender;

@end
