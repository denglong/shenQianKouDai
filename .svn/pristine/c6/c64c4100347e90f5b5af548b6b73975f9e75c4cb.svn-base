//
//  DLStarRageView.h
//  myTest
//
//  Created by denglong on 12/22/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLStarRageView;
@protocol DLStarRageViewDelegate <NSObject>

/**
 *  通知代理改变评分到某一特定的值
 *
 *  @param starRateViewChooseAction 指当前评分view
 *  @param starNum   新的评分值
 */
- (void)starRateViewChooseAction:(NSInteger)starNum starView:(DLStarRageView *)starRageView;

@end

@interface DLStarRageView : UIView

@property(nonatomic, strong) id<DLStarRageViewDelegate> delegate;
@property(nonatomic, assign) NSInteger starNum;

- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star starNum:(NSInteger)num;
- (void)showStarRageAction:(NSInteger)starNumber;

@end