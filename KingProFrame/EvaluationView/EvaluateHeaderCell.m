//
//  EvaluateHeaderCell.m
//  myTest
//
//  Created by denglong on 12/23/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import "EvaluateHeaderCell.h"
#import "Headers.h"

@interface EvaluateHeaderCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *completeNum;
@property (weak, nonatomic) IBOutlet UIImageView *approveImage;

@end

@implementation EvaluateHeaderCell
@synthesize headerImageView, shopName, completeNum, headerStarView, approveImage;

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setResponseDic:(NSDictionary *)responseDic {
    NSString *str = [responseDic objectForKey:@"imgUrl"];
    NSURL *url = [NSURL URLWithString:str];
    [headerImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ShopImage"]];
    completeNum.text = [NSString stringWithFormat:@"已完成%@单", [responseDic objectForKey:@"finishOrder"]];
    
    shopName.text = [responseDic objectForKey:@"name"];
    
    headerImageView.layer.cornerRadius = headerImageView.frame.size.height/2;
    headerImageView.layer.borderWidth = 1;
    headerImageView.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#6a3906"] CGColor];
    
    CGSize sz = [shopName.text sizeWithFont:shopName.font constrainedToSize:CGSizeMake(MAXFLOAT, 21)];
    if (sz.width > shopName.frame.size.width) {
        approveImage.frame = CGRectMake(viewWidth - 64, 0, 43, 13);
    }
    else
    {
        approveImage.frame = CGRectMake(shopName.frame.origin.x + sz.width + 10, 0, 43, 13);
    }
    approveImage.center = CGPointMake(approveImage.center.x, shopName.center.y);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
