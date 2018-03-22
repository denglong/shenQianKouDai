//
//  CYActivityView.h
//  1.网易彩票基本骨架搭建
//
//  Created by lucifer on 15/10/4.
//  Copyright (c) 2015年 lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYActivityView;
@protocol CYActivityViewDelegate <NSObject>

@optional

- (void)buttonClickedCloseActivity:(CYActivityView *)activity;
@required
- (void)pushToDestionViewController;

@end

typedef void(^closeBlock)();

@interface CYActivityView : UIView

@property (weak,nonatomic) id <CYActivityViewDelegate> delegate;

/** 图片URL */
@property (nonatomic,copy) NSString *ADImageUrl;


+ (instancetype)shoeInPoint:(CGPoint)point;

- (void)hideInPoint:(CGPoint)point completion:(void(^)())completion;

- (void)closeBlock:(closeBlock)block;

@end
