//
//  EvaluationCell.h
//  KingProFrame
//
//  Created by denglong on 8/14/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UIButton *commentRefesh;

@end
