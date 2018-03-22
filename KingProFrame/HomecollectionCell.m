//
//  HomecollectionCell.m
//  KingProFrame
//
//  Created by denglong on 12/25/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "HomecollectionCell.h"
#import "Headers.h"

@implementation HomecollectionCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellStyleDefault;
}

- (void)setCollectionView:(DLCollectionView *)collectionView {
    
    [self addSubview:collectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
