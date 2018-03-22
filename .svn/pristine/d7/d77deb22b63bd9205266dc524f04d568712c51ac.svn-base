//
//  ShopBtnView.m
//  KingProFrame
//
//  Created by denglong on 2/29/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "ShopBtnView.h"
#import "Headers.h"

@implementation ShopBtnView
@synthesize shopBtn, goodsNumLab;

//初始化单例
+ (ShopBtnView *)shareShopBtnView
{
    static ShopBtnView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)addShopBtnAction {
    self.frame = CGRectMake(0, 0, 65, 65);
    self.center = CGPointMake(viewWidth/2, kViewHeight - self.frame.size.height/2);
    self.layer.cornerRadius = 32.5;
    
    shopBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 65, 65)];
    [shopBtn setImage:[UIImage imageNamed:@"cartBarImage"] forState:UIControlStateNormal];
    [shopBtn setImage:[UIImage imageNamed:@"cartBarImage"] forState:UIControlStateHighlighted];
    [self addSubview:shopBtn];
    
    goodsNumLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shopBtn.frame) - 22, 2, 20, 20)];
    goodsNumLab.hidden = YES;
    goodsNumLab.textAlignment = NSTextAlignmentCenter;
    goodsNumLab.font = [UIFont systemFontOfSize:12];
    goodsNumLab.textColor = [UIColor whiteColor];
    goodsNumLab.backgroundColor = [UIColor_HEX colorWithHexString:@"#ff5a1e"];
    goodsNumLab.layer.cornerRadius = 10;
    goodsNumLab.layer.masksToBounds = YES;
    [self addSubview:goodsNumLab];
}

@end
