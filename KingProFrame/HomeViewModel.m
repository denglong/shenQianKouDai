//
//  HomeViewModel.m
//  KingProFrame
//
//  Created by meyki on 11/24/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "HomeViewModel.h"
#import "MacroDefinitions.h"
#import "HomeCateoryCell.h"
#import "Headers.h"

@implementation HomeViewModel

//初始化单例
+ (HomeViewModel *)sharedInstance
{
    static HomeViewModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

#pragma mark - 创建首页广告轮播图
+ (JGInfiniteScrollView *)createHomePageAdAction {
    
    CGRect rect = CGRectMake(0, 0, viewWidth, viewWidth*0.66);
    NSArray *imgList = @[
                         @"http://hiphotos.baidu.com/shirl/pic/item/f7e7b21bf09afd218718bf9d.jpg"
                         ];
    
    JGInfiniteScrollView *jGInfin = [[JGInfiniteScrollView alloc] init];
    jGInfin.frame = rect;
    jGInfin.images = imgList;
    
    jGInfin.pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    jGInfin.pageControl.pageIndicatorTintColor = [UIColor clearColor];
    
    return jGInfin;
}

+ (UIButton *)createSearchViewAction:(UIView *)superView {
    
    UIButton *searchBtn = [[UIButton alloc] init];
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.layer.cornerRadius = 14;
    [superView addSubview:searchBtn];
    
    [[searchBtn layer] setShadowOffset:CGSizeMake(1, 1)]; // 阴影的范围
    [[searchBtn layer] setShadowRadius:1]; // 阴影扩散的范围控制
    [[searchBtn layer] setShadowOpacity:0.5]; // 阴影透明度
    [[searchBtn layer] setShadowColor:[UIColor blackColor].CGColor]; // 阴影的颜色
    
    UIImageView *searchImg = [[UIImageView alloc] init];
    searchImg.image = UIIMAGE(@"icon_search");
    [searchBtn addSubview:searchImg];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor_HEX colorWithHexString:@"#323232"];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.text = @"请输入商品名称";
    [searchBtn addSubview:titleLab];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(superView).with.offset(30);
        make.left.equalTo(superView).with.offset(17);
        make.right.equalTo(superView).with.offset(-17);
        make.height.equalTo(@28);
    }];
    
    [searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(searchBtn).with.offset(15);
        make.centerY.equalTo(searchBtn.mas_centerY);
        make.width.equalTo(@17);
        make.height.equalTo(@16);
    }];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 44, 0, 0);
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(searchBtn).insets(edge);
    }];
    
    return searchBtn;
}

@end
