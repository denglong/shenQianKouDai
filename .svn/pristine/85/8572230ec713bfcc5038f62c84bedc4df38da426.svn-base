//
//  NoNetworkView.m
//  KingProFrame
//
//  Created by denglong on 8/31/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#define IOS8 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0)

#import "NoNetworkView.h"

@interface NoNetworkView ()

@end

@implementation NoNetworkView

+ (NoNetworkView *)sharedInstance {
    static NoNetworkView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });

    return sharedAccountManagerInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

//设置tableView与底部对齐
-(UIView *)setConstraint:(NSInteger)height{
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:1.0f
                                                                      constant:height];
    
    
    [self.view addConstraints:@[topConstraint]];
    if (IOS8) {
        topConstraint.active = YES;
    }
    
    return self.view;
}

- (IBAction)reloadAgain:(id)sender {
    [self.reloadDelegate reloadAgainAction];
}

-(void)setBackgroundViewColor:(UIColor *)backgroundViewColor
{
    if (backgroundViewColor) {
        self.viewbackground.backgroundColor = backgroundViewColor;
    }else{
        self.viewbackground.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    }
}
@end
