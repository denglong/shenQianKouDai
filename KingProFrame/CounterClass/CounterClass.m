//
//  CounterClass.m
//  myTest
//
//  Created by denglong on 12/16/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import "CounterClass.h"
#import "Headers.h"

@implementation CounterClass
@synthesize numLabel;
@synthesize subBtn;
@synthesize addBtn;

- (UIView *)createCounterView:(CGRect)rect {
    self.frame = rect;
    self.backgroundColor = [UIColor whiteColor];
    subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subBtn.frame = CGRectMake(10, 0, 48, 48);
    [subBtn setImage:[UIImage imageNamed:@"minusIcon"] forState:UIControlStateNormal];
    [subBtn setImage:[UIImage imageNamed:@"minusIcon"] forState:UIControlStateHighlighted];
    [subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:subBtn];
    
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subBtn.frame) - 15, 0, 35, 20)];
    numLabel.center = CGPointMake(numLabel.center.x, subBtn.center.y);
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:15];
    numLabel.textColor = [UIColor_HEX colorWithHexString:@"#6a3906"];
    numLabel.text = @"1";
    [self addSubview:numLabel];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(63, 0, 48, 48);
    [addBtn setImage:[UIImage imageNamed:@"ADIcon"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"ADIcon"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    
    return self;
}

- (void)subAction:(UIButton *)sender {
    [self.delegate counterAddAndSubAction:0 andBtn:sender];
    NSInteger num = [numLabel.text integerValue];
    if (num == 1) {
        self.hidden = YES;
    }
    else
    {
        num -= 1;
        numLabel.text = [NSString stringWithFormat:@"%ld", num];
    }
}

- (void)addAction:(UIButton *)sender {
    NSInteger num = [numLabel.text integerValue];
    num += 1;
    if (num == 100) {
        num = 99;
    }
    
    [self.delegate counterAddAndSubAction:1 andBtn:sender];
    numLabel.text = [NSString stringWithFormat:@"%ld", num];
}

@end
