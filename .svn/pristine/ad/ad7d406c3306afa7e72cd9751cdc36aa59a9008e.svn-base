//
//  WLZ_ShoppIngCarModel.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ShoppIngCarModel.h"

@implementation WLZ_ShoppIngCarModel



- (void)setVm:(WLZ_ShopViewModel *)vm
{
    _vm = vm;
    [self addObserver:vm forKeyPath:@"isSelect" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

-(void)dealloc
{
    if (_vm) {
        [self removeObserver:_vm forKeyPath:@"isSelect"];
    }
}

@end
