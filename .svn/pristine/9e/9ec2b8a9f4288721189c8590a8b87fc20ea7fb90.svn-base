//
//  SHBQRView.h
//  QRCode_Demo
//
//  Created by 沈红榜 on 15/11/17.
//  Copyright © 2015年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHBQRView;

@protocol SHBQRViewDelegate <NSObject>

- (void)qrView:(SHBQRView *)view ScanResult:(NSString *)result;

@end

@interface SHBQRView : UIView

@property (nonatomic, assign) id<SHBQRViewDelegate> delegate;

@property (nonatomic, assign, readonly) CGRect scanViewFrame;
- (void)initView;
- (void)startScan;
- (void)stopScan;

@end
