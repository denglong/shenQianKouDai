//
//  HeaderClassifyView.h
//  MeykiEFarm
//
//  Created by meyki on 11/1/16.
//  Copyright © 2016 邓龙. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 按钮点击类型 */
enum ClickButtonType {
    firstButton = 0,
    secondButton
};

typedef void(^ClassffyClickBlock)(NSInteger);

@interface HeaderClassifyView : UIView

/** 点击按钮Block */
@property (nonatomic, copy) ClassffyClickBlock clickBlock;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UILabel *addressLab;

+ (HeaderClassifyView *)createHeaderClassifyView:(NSArray *)models address:(NSString *)address block:(ClassffyClickBlock)block;
- (void)setAddressString:(NSString *)str;

@end
