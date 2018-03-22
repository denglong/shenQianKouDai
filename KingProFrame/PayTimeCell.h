//
//  PayTimeCell.h
//  KingProFrame
//
//  Created by denglong on 7/29/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *time;   /**<支付剩余时间*/

- (void)timeDown:(NSInteger)secondTime;

@end
