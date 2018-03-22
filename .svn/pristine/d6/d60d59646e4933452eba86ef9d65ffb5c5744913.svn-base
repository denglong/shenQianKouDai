//
//  eBeansHeaderCell.m
//  KingProFrame
//
//  Created by lihualin on 15/10/29.
//  Copyright © 2015年 king. All rights reserved.
//

#import "eBeansHeaderCell.h"
#import "Headers.h"
@implementation eBeansHeaderCell

- (void)awakeFromNib {
    // Initialization code
    self.eBeansBtn.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setEBeanDetail:(EBeanDetail *)eBeanDetail
{
    self.eBeansCountLAbel.text = [NSString stringWithFormat:@"%@",eBeanDetail.epeaSum];
    if ([DataCheck isValidString:eBeanDetail.shopUrl]) {
        self.eBeansBtn.hidden = NO;
        [self.eBeansBtn setTitle:eBeanDetail.shopBtn forState:UIControlStateNormal];
       
    }else{
        self.eBeansBtn.hidden = YES;
    }
}
@end
