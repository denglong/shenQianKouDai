//
//  HeaderCell.h
//  KingProFrame
//
//  Created by denglong on 7/29/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView    *headerImage;   /**<商家头像*/
@property (weak, nonatomic) IBOutlet UILabel         *totalNum;       /**<店家已完成单数*/
@property (weak, nonatomic) IBOutlet UIButton         *shopName;       /**<商家名称*/

@end
