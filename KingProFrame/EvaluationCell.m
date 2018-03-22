//
//  EvaluationCell.m
//  KingProFrame
//
//  Created by denglong on 8/14/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "EvaluationCell.h"

@implementation EvaluationCell
@synthesize rightLab, leftLab, commentRefesh;

- (void)awakeFromNib {
    rightLab.hidden = YES;
    commentRefesh.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
