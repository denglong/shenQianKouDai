//
//  HeaderHurdleVIew.h
//  KingProFrame
//
//  Created by denglong on 2/25/16.
//  Copyright © 2016 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderHurdleVIew : UIView

@property (strong, nonatomic) UIView *addressView;
@property (strong, nonatomic) UIView *msgHelperView;
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UIButton *myBtn;
@property (strong, nonatomic) UIButton *myBtnClick;
@property (strong, nonatomic) UIButton *helperBtn;
@property (nonatomic, strong) UIButton *categoryBtn;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *scanningBtn;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIView *redPoint;
@property (nonatomic, strong) UILabel *myAddressLab;
@property (nonatomic, strong) UIImageView *addImg;
@property (nonatomic, strong) UIButton *addressClick;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UILabel *animiteView;
@property (nonatomic, strong) UIButton *clickHelper;
@property (nonatomic, strong) UILabel *hViewLabel;
@property (nonatomic, strong) UILabel *noNetworkLab;
@property (nonatomic, strong) UIImageView *tableHrImg;
@property (nonatomic, strong) UIButton *tableHbutton;
@property (nonatomic, strong) NSString *myTime;
@property (nonatomic, strong) NSTimer *timer;

- (void)addViewAction;
- (void)setHelperLabAction:(NSString *)msg time:(NSString *)timeNum andtype:(NSInteger)type;
- (void)setMYAddressLabText:(NSString *)address;
- (UIView *)createTableViewHeaderView;
- (void)setTableViewHeaderViewMsg:(NSString *)tableHeightMsg;

@end
