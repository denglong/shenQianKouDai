//
//  MyPickerView.m
//  myTest
//
//  Created by denglong on 12/21/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import "MyPickerView.h"

@implementation MyPickerView

@synthesize pickList;
@synthesize cityStr;
@synthesize confirmBtn;
@synthesize pickView;
@synthesize delegate;

- (MyPickerView *)createPickerView:(NSArray *)myPickList {
    pickList = myPickList;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    
    UIView *pickBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, window.frame.size.height)];
    pickBg.backgroundColor = [UIColor blackColor];
    pickBg.alpha = 0.2;
    [self addSubview:pickBg];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPickView)];
    //点击的次数
    singleTapRecognizer.numberOfTapsRequired = 1; // 单击
    [pickBg addGestureRecognizer:singleTapRecognizer];
    
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, window.frame.size.height, self.frame.size.width, 150)];
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.delegate = self;
    pickView.dataSource = self;
    [self addSubview:pickView];
    
    confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pickView.frame) - 80, CGRectGetMinY(pickView.frame), 80, 40)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { //返回列数
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { //返回每列的最大行数
    return pickList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { //每一列中每一行的具体内容
    return pickList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {//选中哪一列哪一行
    cityStr = pickList[row];
}

- (void)confirmAction {
    if (cityStr == nil) {
        cityStr = pickList[0];
    }
    [delegate cityChooseAction:cityStr];
    [self hiddenPickView];
}

- (void)showPickerView {
    self.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        pickView.frame = CGRectMake(0, self.frame.size.height - 150, pickView.frame.size.width, pickView.frame.size.height);
        confirmBtn.frame = CGRectMake(CGRectGetMaxX(pickView.frame) - 80, CGRectGetMinY(pickView.frame), 80, 40);
    }];
}

- (void)hiddenPickView {
    [UIView animateWithDuration:0.4 animations:^{
        pickView.frame = CGRectMake(0, self.frame.size.height, pickView.frame.size.width, pickView.frame.size.height);
        confirmBtn.frame = CGRectMake(CGRectGetMaxX(pickView.frame) - 80, CGRectGetMinY(pickView.frame), 80, 40);
    }];
    
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:0.4];
}

- (void)hiddenView {
    self.hidden = YES;
}

@end
