//
//  WLZ_ShoppingCartEndView.h
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/15.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WLZ_ShoppingCartEndViewDelegate;

@interface WLZ_ShoppingCartEndView : UIView


@property(nonatomic,assign)BOOL isEdit;
@property(weak,nonatomic)id<WLZ_ShoppingCartEndViewDelegate> delegate;
@property(nonatomic,strong)UILabel *Lab;
@property(nonatomic,strong)UILabel *vipLab;
@property(nonatomic,strong)UIButton *pushBt;

+(CGFloat)getViewHeight;

@end



@protocol WLZ_ShoppingCartEndViewDelegate <NSObject>

-(void)clickALLEnd:(UIButton *)bt;

-(void)clickRightBT:(UIButton *)bt;
@end
