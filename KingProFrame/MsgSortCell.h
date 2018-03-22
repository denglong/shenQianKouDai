//
//  MsgSortCell.h
//  KingProFrame
//
//  Created by lihualin on 15/11/19.
//  Copyright © 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgSort.h"
@interface MsgSortCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *msgSortImage;

@property (weak, nonatomic) IBOutlet UILabel *msgSortTitle;
@property (weak, nonatomic) IBOutlet UILabel *msgSortTime;
@property (weak, nonatomic) IBOutlet UILabel *msgSortContent;

@property (nonatomic , retain) MsgSort * msgSort;
@end
