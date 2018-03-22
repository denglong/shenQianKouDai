//
//  YourSelfInfoCell.h
//  KingProFrame
//
//  Created by 邓龙 on 11/06/2017.
//  Copyright © 2017 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourSelfInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

- (void)setYourSelfInfoAction:(NSDictionary *)dic;
- (void)colorSelectAction;
- (void)defColorAction;

@end
