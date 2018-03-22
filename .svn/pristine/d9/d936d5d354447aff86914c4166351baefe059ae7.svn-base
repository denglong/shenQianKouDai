//
//  CYMask.m
//  1.网易彩票基本骨架搭建
//
//  Created by lucifer on 15/10/4.
//  Copyright (c) 2015年 lucifer. All rights reserved.
//

#import "CYMask.h"

@implementation CYMask

+(void)show
{
    CYMask *mask = [[self alloc] init];
    
    mask.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    [[UIApplication sharedApplication].keyWindow addSubview:mask];
}

+ (void)hidden
{
    for (UIView *mask in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([mask isKindOfClass:self])
        {
            [mask removeFromSuperview];
        }
    }
}


@end
