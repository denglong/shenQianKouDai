//
//  HomeCateoryCell.m
//  KingProFrame
//
//  Created by denglong on 12/7/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "HomeCateoryCell.h"
#import "Headers.h"
#import "HomeModel.h"

@implementation HomeCateoryCell
@synthesize BtnList;

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellStyleDefault;
    self.backgroundColor = [UIColor_HEX colorWithHexString:@"#eeeeee"];
    
    BtnList = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i ++)
    {
        UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * viewWidth/4, 0, viewWidth/4, 91)];
        clickBtn.tag = i;
        clickBtn.hidden = YES;
        clickBtn.enabled = NO;
        [self.contentView addSubview:clickBtn];
        [BtnList addObject:clickBtn];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((clickBtn.frame.size.width - 45)/2, 12, 45, 45)];
        
        [clickBtn addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 91 - 12 - 16, clickBtn.frame.size.width, 16)];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        
        [clickBtn addSubview:titleLabel];
    }
}

- (void)setImages:(NSArray *)images {
    if (images.count == 0)
    {
        self.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    }
    else
    {
        self.frame = CGRectMake(0, 0, self.frame.size.width, 91);
        self.backgroundColor = [UIColor_HEX colorWithHexString:@"#ffffff"];
    }
    
    for (NSInteger i=0; i < images.count; i++)
    {
        UIButton *btn = BtnList[i];
        btn.enabled = YES;
        HotCategoriesModel *hotModel = (HotCategoriesModel *)images[i];
        for (id obj in btn.subviews)
        {
            if ([obj isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageView = (UIImageView *)obj;
                [imageView setImageWithURL:[NSURL URLWithString:hotModel.imageUrl] placeholderImage:UIIMAGE(@"icon_homeDef")];
            }
            
            if ([obj isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)obj;
                label.text = hotModel.name;
            }
        }
    }
}

- (void)dealloc {
    [BtnList removeAllObjects];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
