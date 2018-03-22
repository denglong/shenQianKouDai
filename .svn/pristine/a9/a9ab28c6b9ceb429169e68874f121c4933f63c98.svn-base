//
//  DistributionWayCell.m
//  KingProFrame
//
//  Created by 邓龙 on 10/12/2016.
//  Copyright © 2016 king. All rights reserved.
//

#import "DistributionWayCell.h"
#import "Headers.h"

@implementation DistributionWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
    self.deliverButton.layer.cornerRadius = 3;
    self.deliverButton.layer.borderWidth = 0.5;
    self.deliverButton.layer.borderColor = [UIColor_HEX colorWithHexString:@"FF5A1E"].CGColor;
    self.yourSelfButton.layer.cornerRadius = 3;
    self.yourSelfButton.layer.borderWidth = 0.5;
    self.yourSelfButton.layer.borderColor = [UIColor_HEX colorWithHexString:@"000000"].CGColor;
}

- (void)showDeliver {
    self.deliverButton.hidden = NO;
    self.yourSelfButton.hidden = NO;
}

- (void)createDateViewAction
{
    self.deliverButton.hidden = YES;
    self.yourSelfButton.hidden = YES;

    NSArray *dateList = @[@"今天", @"明天", @"12月10日", @"12月11日", @"12月12日", @"12月13日", @"12月14日"];
    for (NSInteger i = 0; i < 7; i ++)
    {
        UIButton *dateBtn = [[UIButton alloc] init];
        dateBtn.layer.cornerRadius = 3;
        dateBtn.layer.borderWidth = 0.5;
        dateBtn.layer.borderColor = [UIColor_HEX colorWithHexString:@"000000"].CGColor;
        [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dateBtn setTitleColor:[UIColor_HEX colorWithHexString:@"FF5A1E"] forState:UIControlStateSelected];
        dateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        if (viewWidth == 320) {
            dateBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        }
        
        [dateBtn setTitle:dateList[i] forState:UIControlStateNormal];
        [self addSubview:dateBtn];
        
        dateBtn.frame = CGRectMake(10+(viewWidth- 75 - 50)/4*i + i*10, 13, (viewWidth- 75 - 50)/4, 33);
        if (i > 3) {
            NSInteger index = i - 4;
            dateBtn.frame = CGRectMake(10+(viewWidth- 75 - 50)/4*index + index*10, 56, (viewWidth- 75 - 50)/4, 33);
        }
    }
}

- (void)createTimeAction
{
    self.deliverButton.hidden = YES;
    self.yourSelfButton.hidden = YES;
    
    NSArray *timeList = @[@"立即配送", @"上午6点-12点", @"中午12点-16点", @"下午16点-19点"];
    for (NSInteger i = 0; i < 4; i ++)
    {
        UIButton *timeButton = [[UIButton alloc] init];
        timeButton.layer.cornerRadius = 3;
        timeButton.layer.borderWidth = 0.5;
        timeButton.layer.borderColor = [UIColor_HEX colorWithHexString:@"000000"].CGColor;
        [timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [timeButton setTitleColor:[UIColor_HEX colorWithHexString:@"FF5A1E"] forState:UIControlStateSelected];
        timeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [timeButton setTitle:timeList[i] forState:UIControlStateNormal];
        [self addSubview:timeButton];
        
        timeButton.frame = CGRectMake(10, 13+33*i+10*i, 209, 33);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
