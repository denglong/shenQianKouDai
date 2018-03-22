//
//  DistributionWayController.h
//  KingProFrame
//
//  Created by denglong on 3/7/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChooseDistributionDelegate <NSObject>

- (void)chooseDistributionAction:(NSString *)str;

@end

@interface DistributionWayController : BaseViewController

@property (nonatomic, strong) id<ChooseDistributionDelegate> delegate;
@property (nonatomic, strong) NSArray *chooseTimes;
@property (nonatomic, assign) BOOL isImmediately;   //是否即时配送

@end
