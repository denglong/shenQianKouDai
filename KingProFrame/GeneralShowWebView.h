//
//  GeneralShowWebView.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/31.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BaseViewController.h"

@interface GeneralShowWebView : BaseViewController<UIWebViewDelegate>

@property(nonatomic,strong)NSString *advUrlLink;

@property (strong, nonatomic) IBOutlet UIWebView *showWebView;//展示webview
@property (nonatomic, assign) NSInteger geTuiTag;
@property (nonatomic, assign) BOOL isNotShare;

@end
