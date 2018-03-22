//
//  MyPickerView.h
//  myTest
//
//  Created by denglong on 12/21/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cityChooseDelegate <NSObject>

- (void)cityChooseAction:(NSString *)cityStr;

@end

@interface MyPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *pickList;
@property (nonatomic, copy) NSString *cityStr;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) id<cityChooseDelegate> delegate;

- (MyPickerView *)createPickerView:(NSArray *)myPickList;
- (void)showPickerView;
- (void)hiddenPickView;

@end
