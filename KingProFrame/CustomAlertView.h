//
//  CustomAlertView.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/26.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CustomAlertView;
@protocol CustomAlertViewDelegate <NSObject>
@optional
-(void)contentButtonTouch:(UIButton *)sender;//选择内容点击事件
-(void)confirmButtonTouch;//确认按钮点击事件
@end

@interface CustomAlertView : UIView


@property (nonatomic, weak) id<CustomAlertViewDelegate> delegate;
@property(nonatomic,retain)UIView *middleView;
@property(nonatomic,retain)UIScrollView * scrollView;
@property(nonatomic,retain)NSMutableArray *titleBtns;
//初始化自定义alert里面的内容
-(void)initWithContent:(NSArray *)contentArray
                 title:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
    confirmButtonTitle:(NSString *)confirmButtonTitle;
@end
