//
//  UIBarButtonItem+CYBarbuttonItem.m
//  KingProFrame
//
//  Created by eqbang on 15/12/22.
//  Copyright © 2015年 king. All rights reserved.
//

#import "UIBarButtonItem+CYExtensioin.h"

@implementation UIBarButtonItem (CYBarbuttonItem)

+ (UIBarButtonItem *)creatItemWithTitle:(NSString *)title normalColorString:(NSString *)normalColor hightLightColorString:(NSString *)hightLightColor addTarget:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button sizeToFit];
    [button setTitleColor:[UIColor_HEX colorWithHexString:normalColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor_HEX colorWithHexString:hightLightColor] forState:UIControlStateHighlighted];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    return rightItem;
}

@end
