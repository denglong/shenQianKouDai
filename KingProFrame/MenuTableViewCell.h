//
//  MenuTableViewCell.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *rightLine;

@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;
@property(nonatomic,retain)IBOutlet UIImageView *desImgView;
@property(nonatomic,retain)IBOutlet UILabel *typeLabel;
@end
