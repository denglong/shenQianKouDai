//
//  CounterClass.h
//  myTest
//
//  Created by denglong on 12/16/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol counterClassDelegate <NSObject>

- (void)counterAddAndSubAction:(NSInteger)type andBtn:(UIButton *)sender;//1:添加商品， 0:减除商品

@end

@interface CounterClass : UIView

@property (nonatomic, strong) id<counterClassDelegate> delegate;
@property (nonatomic, strong) UILabel *numLabel;//计数数量
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *addBtn;

- (UIView *)createCounterView:(CGRect)rect;

@end
