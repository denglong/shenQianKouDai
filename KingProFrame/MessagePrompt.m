//
//  MessagePrompt.m
//  KingProFrame
//
//  Created by denglong on 12/2/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "MessagePrompt.h"
#import "Headers.h"
#import "TabBarController.h"

@implementation MessagePrompt
@synthesize headerMsgView;
@synthesize msgLabel;

- (void)createMyMsgView:(UIViewController *)controller msg:(NSString *)msg state:(NSInteger)state{
    if (headerMsgView) {
        [headerMsgView removeFromSuperview];
    }
    
    headerMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    headerMsgView.hidden = YES;
    headerMsgView.backgroundColor = [UIColor_HEX colorWithHexString:@"#ff5a1e"];
    
    msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    msgLabel.center = CGPointMake(viewWidth/2, msgLabel.center.y);
    msgLabel.font = [UIFont systemFontOfSize:16];
    msgLabel.text = msg;
    CGSize sz = [msgLabel.text sizeWithFont:msgLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 21)];
    msgLabel.frame = CGRectMake(0, 35, sz.width, 20);
    msgLabel.center = CGPointMake(headerMsgView.center.x + 10, msgLabel.center.y);
    msgLabel.textColor = [UIColor_HEX colorWithHexString:@"#ffffff"];
    [headerMsgView addSubview:msgLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(msgLabel.frame.origin.x - 14 - 15, 0, 23, 23)];
    imageView.center = CGPointMake(imageView.center.x, headerMsgView.center.y + 13);
    if (state == 1) {
        imageView.image = UIIMAGE(@"witeMsg1");
        imageView.animationImages = [NSArray arrayWithObjects:
                                     UIIMAGE(@"witeMsg1"),
                                     UIIMAGE(@"witeMsg2"),
                                     UIIMAGE(@"witeMsg1"),
                                     UIIMAGE(@"witeMsg2"),nil];
    }
    else
    {
        imageView.image = UIIMAGE(@"orderMsg1");
        imageView.animationImages = [NSArray arrayWithObjects:
                                     UIIMAGE(@"orderMsg1"),
                                     UIIMAGE(@"orderMsg2"),
                                     UIIMAGE(@"orderMsg1"),
                                     UIIMAGE(@"orderMsg2"),nil];
    }
    [imageView setAnimationDuration:2.0f];
    [imageView setAnimationRepeatCount:0];
    [imageView startAnimating];
    [headerMsgView addSubview:imageView];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(headerMsgView.frame.size.width - 53, headerMsgView.center.y - 10, 64, 44)];
    [closeBtn setImage:[UIImage imageNamed:@"icon_msgDelete"] forState:UIControlStateNormal];
    [closeBtn addTarget:controller action:@selector(closeMsgViewAction) forControlEvents:UIControlEventTouchUpInside];
    [headerMsgView addSubview:closeBtn];
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerMsgView.frame.size.width - 64, 64)];
    [selectBtn addTarget:controller action:@selector(selectMsgAction) forControlEvents:UIControlEventTouchUpInside];
    [headerMsgView addSubview:selectBtn];
    
    UIImageView *downImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, headerMsgView.frame.size.width, 11)];
    downImage.image = [UIImage imageNamed:@"homeMsgDown"];
    [headerMsgView addSubview:downImage];
    
    TabBarController *tabbar = [TabBarController sharedInstance];
    [tabbar.view addSubview:headerMsgView];
}

- (void)closeMsgViewAction{}
- (void)selectMsgAction{}

@end
