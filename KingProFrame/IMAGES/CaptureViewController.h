//
//  CaptureViewController.h
//  image
//
//  Created by lihualin on 14-11-28.
//  Copyright (c) 2014年 lihualin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PassImageDelegate <NSObject>

-(void)passImage:(UIImage *)image;

@end
@interface CaptureViewController : UIViewController
@property(nonatomic , retain) UIImage * image;

@property(nonatomic , retain) id<PassImageDelegate> delegate;
@end
