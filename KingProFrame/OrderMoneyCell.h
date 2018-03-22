//
//  OrderMoneyCell.h
//  KingProFrame
//
//  Created by denglong on 3/7/16.
//  Copyright © 2016 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet UILabel *allTotle;
@property (weak, nonatomic) IBOutlet UILabel *coupon;
@property (weak, nonatomic) IBOutlet UILabel *glucoside;
@property (weak, nonatomic) IBOutlet UILabel *allMoney;

@end
