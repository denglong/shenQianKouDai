//
//  HeaderHurdleVIew.m
//  KingProFrame
//
//  Created by denglong on 2/25/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "HeaderHurdleVIew.h"
#import "Headers.h"

@implementation HeaderHurdleVIew
@synthesize addressView, msgHelperView, searchView, helperBtn, categoryBtn, searchBtn, scanningBtn, myBtn, leftImageView, redPoint, myAddressLab, addImg, addressClick, msgLabel, animiteView, clickHelper, tableHrImg, hViewLabel, tableHbutton;

- (void)addViewAction {
    addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    addressView.backgroundColor = [UIColor clearColor];
    msgHelperView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addressView.frame), viewWidth, 0)];
    msgHelperView.hidden = YES;
    msgHelperView.layer.cornerRadius = 5;
    msgHelperView.backgroundColor = [UIColor clearColor];
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(msgHelperView.frame), viewWidth, 36
                                                          )];
    searchView.backgroundColor = self.backgroundColor;
    [self addSubview:addressView];
    [self addSubview:msgHelperView];
    [self addSubview:searchView];
    
    [self addHeaderBtnAction];
    [self addCategoryBtn];
    [self addMsgLabAndImage];
    [self addSearchView];
    [self addAdressLabAction];
}

- (void)addHeaderBtnAction {
    helperBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth - 82, 27, 26, 26)];
    [helperBtn setBackgroundImage:[UIImage imageNamed:@"icon_zhushou1"] forState:UIControlStateNormal];
    helperBtn.hidden = YES;
    [addressView addSubview:helperBtn];
    
    myBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth - 41, 27, 26, 26)];
    _myBtnClick = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth - 41, 20, 40, 40)];
    helperBtn.layer.cornerRadius = 13;
    myBtn.layer.cornerRadius = 13;
    // myBtn.layer.borderWidth = 1;
    myBtn.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.400].CGColor;
    
    leftImageView = [[UIImageView alloc] initWithFrame:myBtn.frame];
    leftImageView.image = UIIMAGE(@"icon_homeLeft");
    leftImageView.layer.masksToBounds = YES;
    leftImageView.layer.cornerRadius = 13;
    [addressView addSubview:leftImageView];
    [addressView addSubview:myBtn];
    [addressView addSubview:_myBtnClick];
    
    redPoint = [[UIView alloc] initWithFrame:CGRectMake(myBtn.frame.size.width - 6, 0, 8, 8)];
    redPoint.layer.cornerRadius = 4;
    redPoint.backgroundColor = RGB_COLOR(235, 111, 103);
    redPoint.hidden = YES;
    [myBtn addSubview:redPoint];
}

- (void)addCategoryBtn {
    categoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 72, 36)];
    [categoryBtn setTitle:@"分类" forState:UIControlStateNormal];
    categoryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchView addSubview:categoryBtn];
    
    categoryBtn.tag = 2;
    [categoryBtn setImage:[UIImage imageNamed:@"icon_category"] forState:UIControlStateNormal];//给button添加image
    categoryBtn.imageEdgeInsets = UIEdgeInsetsMake(0,10,3,30);
    categoryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [categoryBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#323232"] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [categoryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    categoryBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 8, 5);
}

- (void)addSearchView {
    //头部搜索
    searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, viewWidth - 83, 30)];
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.alpha = 0.76;
    searchBtn.layer.cornerRadius = 6;
    
    UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 6, 18, 18)];
    searchImg.image = [UIImage imageNamed:@"icon_homeSearch"];
    
    UILabel *searchLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImg.frame) + 4, 9, searchBtn.frame.size.width - 80, 12)];
    searchLab.font = [UIFont systemFontOfSize:12];
    searchLab.textColor = [UIColor_HEX colorWithHexString:@"cfa972"];
    searchLab.text = @"请输入商品名称";
    
    scanningBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchBtn.frame.size.width - 42, 0, 42, 30)];
    [scanningBtn setImage:[UIImage imageNamed:@"icon_homeSweep"] forState:UIControlStateNormal];
    
    [searchBtn addSubview:searchImg];
    [searchBtn addSubview:searchLab];
    [searchBtn addSubview:scanningBtn];
    [searchView addSubview:searchBtn];
}

- (void)addAdressLabAction {
    myAddressLab = [[UILabel alloc] initWithFrame:CGRectMake(23, 32, helperBtn.frame.origin.x - 50, 20)];
    myAddressLab.textAlignment = NSTextAlignmentLeft;
    myAddressLab.font = [UIFont systemFontOfSize:14];
    myAddressLab.textColor = [UIColor_HEX colorWithHexString:@"#000000"];
    [addressView addSubview:myAddressLab];
    
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 36, 10, 13)];
    locationView.image = [UIImage imageNamed:@"icon_location"];
    [addressView addSubview:locationView];
    
    addImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7.5, 11)];
    addImg.hidden = YES;
    addImg.image = [UIImage imageNamed:@"icon_choseAdd"];
    [addressView addSubview:addImg];
    
    addressClick = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, myAddressLab.frame.size.width + 15, 44)];
    [addressView addSubview:addressClick];
    
    NSArray *addList = [[NSUserDefaults standardUserDefaults] objectForKey:AUTOLOCATIONADDRESS];
    if (addList.count > 1) {
        NSString *myAddress = addList.lastObject;
        [self setMYAddressLabText:myAddress];
    }
    else
    {
        [self setMYAddressLabText:@"西安小寨"];
    }
}

- (void)setMYAddressLabText:(NSString *)address {
    myAddressLab.text = address;
    addImg.hidden = NO;
    CGSize size = [self boundingRectWithSize:CGSizeMake(CGRectGetMaxX(helperBtn.frame) - 40, 0)];
    if (helperBtn.frame.origin.x - 50 < size.width) {
        myAddressLab.frame = CGRectMake(23, 32, helperBtn.frame.origin.x - 50, 20);
    }
    else
    {
        myAddressLab.frame = CGRectMake(23, 32, size.width, 20);
    }
    
    addImg.frame = CGRectMake(myAddressLab.frame.size.width + 27, 36.5, 7.5, 11);
    addressClick.frame = CGRectMake(0, 20, myAddressLab.frame.size.width + 15, 44);
}

- (void)addMsgLabAndImage {
    clickHelper = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, viewWidth - 20, 34)];
    clickHelper.backgroundColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.76];
    clickHelper.layer.cornerRadius = 8;
    [msgHelperView addSubview:clickHelper];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(clickHelper.frame.size.width - 22, 0, 7, 12)];
    imgView.center = CGPointMake(imgView.center.x, clickHelper.center.y);
    imgView.image = [UIImage imageNamed:@"icon_helperRImg"];
    [clickHelper addSubview:imgView];
    
    UIImage *img = [UIImage imageNamed:@"icon_arrowsHome"];
    UIImageView *arrowsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -img.size.height, img.size.width, img.size.height)];
    arrowsView.image = img;
    arrowsView.center = CGPointMake(helperBtn.center.x - 10, arrowsView.center.y + 0.2);
    [clickHelper addSubview:arrowsView];
    
    msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    msgLabel.font = [UIFont systemFontOfSize:13];
    msgLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    [clickHelper addSubview:msgLabel];
    
    animiteView = [[UILabel alloc] initWithFrame:CGRectZero];
    animiteView.font = msgLabel.font;
    animiteView.textAlignment = NSTextAlignmentRight;
    animiteView.textColor = [UIColor redColor];
    [clickHelper addSubview:animiteView];
}

- (void)takeCountOfHelperAction {
    NSInteger minute = [_myTime integerValue]/60;
    NSInteger second = [_myTime integerValue]%60;
    
    NSString *minuteStr = nil;
    NSString *secondStr = nil;
    if (minute > 9) {
        minuteStr = [NSString stringWithFormat:@"%ld", minute];
    }
    else
    {
        minuteStr = [NSString stringWithFormat:@"0%ld", minute];
    }
    
    if (second > 9) {
        secondStr = [NSString stringWithFormat:@"%ld", second];
    }
    else
    {
        secondStr = [NSString stringWithFormat:@"0%ld", second];
    }
    
    animiteView.text = [NSString stringWithFormat:@"%@:%@", minuteStr, secondStr];
    animiteView.frame = CGRectMake(msgLabel.frame.origin.x - 100, 7, 80, 20);
    
    NSInteger oldTime = [_myTime integerValue];
    oldTime++;
    _myTime = [NSString stringWithFormat:@"%ld", oldTime];
}

- (void)setHelperLabAction:(NSString *)msg time:(NSString *)timeNum andtype:(NSInteger)type {
    msgLabel.text = msg;
    
    CGSize sz = [msgLabel.text sizeWithFont:msgLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    msgLabel.frame = CGRectMake(0, 7, sz.width, 20);
    msgLabel.center = CGPointMake(clickHelper.center.x, msgLabel.center.y);
    
    if (type == 1) {
        _myTime = timeNum;
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(takeCountOfHelperAction) userInfo:nil repeats:YES];
    }
    else
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: myAddressLab.font};
    
    CGSize retSize = [myAddressLab.text boundingRectWithSize:size
                                                 options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil].size;
    
    return retSize;
}

- (UIView *)createTableViewHeaderView {
    UIView *tableHView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0)];
    hViewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    hViewLabel.font = [UIFont systemFontOfSize:12];
    hViewLabel.textColor = [UIColor_HEX colorWithHexString:@"#ff611e"];
    [tableHView addSubview:hViewLabel];
    
    tableHrImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    tableHrImg.image = [UIImage imageNamed:@"icon_tableHRImg"];
    tableHrImg.center = CGPointMake(tableHrImg.center.x, tableHView.center.y);
    [tableHView addSubview:tableHrImg];
    
    tableHbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    [tableHView addSubview:tableHbutton];
    
    return tableHView;
}

- (void)setTableViewHeaderViewMsg:(NSString *)tableHeightMsg {
    hViewLabel.text = tableHeightMsg;
    hViewLabel.text = [hViewLabel.text stringByReplacingOccurrencesOfString:@"," withString:@"，"];
    CGSize sz = [hViewLabel.text sizeWithFont:hViewLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    hViewLabel.frame = CGRectMake(0, 0, sz.width, 20);
    hViewLabel.center = CGPointMake(self.center.x, 18);
    tableHrImg.frame = CGRectMake(CGRectGetMaxX(hViewLabel.frame) + 5, 0, 6, 10);
    tableHrImg.center = CGPointMake(tableHrImg.center.x, hViewLabel.center.y);
    tableHbutton.frame = CGRectMake(hViewLabel.frame.origin.x + hViewLabel.frame.size.width/2, 0, hViewLabel.frame.size.width/2, 36);
    tableHbutton.center = CGPointMake(tableHbutton.center.x, hViewLabel.center.y);
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:hViewLabel.text];
    NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"，"].location + 1);
    UIColor *color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [noteStr addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    [hViewLabel setAttributedText:noteStr] ;
}

@end
