//
//  HomePageCell.h
//  KingProFrame
//
//  Created by denglong on 11/27/15.
//  Copyright © 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLCollectionView.h"

@interface HomePageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *AdImageView;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) NSInteger number;

@end
