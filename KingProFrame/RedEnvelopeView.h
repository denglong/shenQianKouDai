//
//  RedEnvelopeView.h
//  KingProFrame
//
//  Created by lihualin on 15/8/22.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedEnvelopeViewDelegate <NSObject>

-(void)cancelOrSureBtnClick:(NSInteger)tag;

@end

@interface RedEnvelopeView : UIView
@property (nonatomic ,retain) id<RedEnvelopeViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *reEnvelopeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *textALabel;
@property (weak, nonatomic) IBOutlet UIButton *sendRedBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelOrOkBtnClick:(UIButton *)sender;

@end
