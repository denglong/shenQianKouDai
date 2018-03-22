//
//  EvaluateBodyCell.h
//  myTest
//
//  Created by denglong on 12/23/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRageView.h"

@protocol EvaluateBtnDelegate

- (void)evaluateBtnAction:(UIButton *)sender;

@end

@interface EvaluateBodyCell : UITableViewCell

@property(nonatomic, strong) id<EvaluateBtnDelegate> delegate;
@property(nonatomic, strong) NSArray *starViewList;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *userEvaluate;
@property (nonatomic, strong) NSDictionary *responseDic;
@property (weak, nonatomic) IBOutlet UILabel *oneLab;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UIButton *nullImage;

@end
