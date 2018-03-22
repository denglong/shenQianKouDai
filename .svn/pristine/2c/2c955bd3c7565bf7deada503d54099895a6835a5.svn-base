//
//  NoNetworkView.h
//  KingProFrame
//
//  Created by denglong on 8/31/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reloadDelegate <NSObject>

- (void)reloadAgainAction;

@end

@interface NoNetworkView : UIViewController

@property (nonatomic, retain) id<reloadDelegate> reloadDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *nullImage;

@property (weak, nonatomic) IBOutlet UIView *viewbackground;
+(NoNetworkView *)sharedInstance;
-(UIView *)setConstraint:(NSInteger)height;
@property (nonatomic, retain) UIColor * backgroundViewColor;
@end
