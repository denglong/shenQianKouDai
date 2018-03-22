//
//  LaunchStartController.h
//  KingProFrame
//
//  Created by denglong on 10/28/15.
//  Copyright © 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchStartController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *launchStartImage;

+ (LaunchStartController *)sharedInstance;

@end
