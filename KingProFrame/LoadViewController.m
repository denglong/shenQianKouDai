//
//  LoadViewController.m
//  KingProFrame
//
//  Created by denglong on 8/25/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "LoadViewController.h"
#import "LaunchViewController.h"
#import "NavigationController.h"
#import "XQNewFeatureVC.h"
#import "TabBarController.h"

@interface LoadViewController ()

@end

@implementation LoadViewController

+ (LoadViewController *)sharedInstance {
    static LoadViewController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (UIViewController *)loadViewController {
    // Init the pages texts, and pictures.
    
    NSArray *images=[NSArray array];
    
    if (iPhone4) {
        images = @[@"iPhone4_load_0.png", @"iPhone4_load_1.png", @"iPhone4_load_2.png"];
    }
    if (iPhone5) {
        images = @[@"iPhone5_load_0.png", @"iPhone5_load_1.png", @"iPhone5_load_2.png"];
    }
    if (iPhone6) {
        images = @[@"iPhone6_load_0.png", @"iPhone6_load_1.png", @"iPhone6_load_2.png"];
    }
    if (iPhone6P) {
        images = @[@"iPhone6p_load_0.png", @"iPhone6p_load_1.png", @"iPhone6p_load_2.png"];
    }
    if (iPhone6Ps) {
        images = @[@"iPhone6ps_load_0.png", @"iPhone6ps_load_1.png", @"iPhone6ps_load_2.png"];
    }
    
    XQNewFeatureVC *newVc = [[XQNewFeatureVC alloc] initWithFeatureImagesNameArray:images];
    newVc.completeBlock = ^{
        [self loadAction];
    };
    
    return newVc;
}

- (void)loadAction {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = [TabBarController sharedInstance];

}


@end
