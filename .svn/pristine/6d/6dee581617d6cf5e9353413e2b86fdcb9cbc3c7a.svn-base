//
//  LaunchStartController.m
//  KingProFrame
//
//  Created by denglong on 10/28/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "LaunchStartController.h"
#import "LaunchViewController.h"
#import "NavigationController.h"
#import "TabBarController.h"
#import "Headers.h"

@interface LaunchStartController ()
{
    NSTimer *stopTime;
}

@end

@implementation LaunchStartController
@synthesize launchStartImage;

+ (LaunchStartController *)sharedInstance {
    static LaunchStartController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLaunchStartView];
}

-(void)createLaunchStartView {
    UIImage *myImage = [self getSaveImage];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *imageUrl = [userDefaultes objectForKey:@"imageUrlStr"];
    
    if ([DataCheck isValidString:imageUrl]) {
        launchStartImage.image = myImage;
        
        float outTime = [[[NSUserDefaults standardUserDefaults] objectForKey:SHOWPAGEMS] floatValue]/1000;
        if (outTime == 0) {
            outTime = 3.0;
        }
        stopTime = [NSTimer scheduledTimerWithTimeInterval:outTime target:self selector:@selector(stopTimeAction) userInfo:nil repeats:NO];
    }
    else
    {
        [self stopTimeAction];
    }
}

- (void)stopTimeAction {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [TabBarController sharedInstance];
   
}

- (UIImage *)getSaveImage {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [userDefaultes dataForKey:@"imageData"];
    UIImage *myImage = [UIImage imageWithData:imageData];
    return myImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
