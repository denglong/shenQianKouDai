//
//  OrderDetailGoodsCell.m
//  KingProFrame
//
//  Created by lihualin on 15/10/26.
//  Copyright © 2015年 king. All rights reserved.
//

#import "OrderDetailGoodsCell.h"
#import "Headers.h"
@implementation OrderDetailGoodsCell

- (void)awakeFromNib {
//    // Initialization code
    self.goodsImage.layer.borderColor = [UIColor_HEX colorWithHexString:@"#cccccc"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**商品赋值*/

-(void)setGoods:(goodsModel *)goods
{
    if (goods == nil) {
        return;
    }
//    NSURL * url = [NSURL URLWithString:goods.goodsPic];
//    [self.goodsImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"orderShopHeader"]];
    self.goodsNameLabel.text = goods.goodsName;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"x%ld",(long)goods.goodsNumber];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",goods.goodsPrice];
    CGSize size =[CommClass getSuitSizeWithString:goods.goodsName font:12 bold:NO sizeOfX:viewWidth-123];
//    if(size.height+8 > self.goodsImage.frame.size.height){
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.goodsNameLabel.frame.origin.y+size.height);
//    }
    [self.goodsNameLabel sizeToFit];
    if (goods.groupDetail.count > 0) {
        self.zuheLine.hidden = NO;
        [self setGroupGoods:goods.groupDetail];
    }else{
        self.zuheLine.hidden = YES;
    }
}

- (void)setGroupGoods:(NSArray *)groupGoods  {
    if (groupGoods.count > 0) {
//        CGSize size =  [self sizeWithString:self.goodsNameLabel.text font:self.goodsNameLabel.font width:viewWidth - 123];
        
        NSMutableArray *groups = [NSMutableArray array];
        for (NSInteger i = 0; i < groupGoods.count; i ++) {
            CGRect rect = CGRectMake(self.goodsNameLabel.frame.origin.x, CGRectGetMaxY(self.goodsNameLabel.frame), viewWidth - 123, 11);
            UILabel *goodLabel = nil;
            if (groups.count > 0) {
                UILabel *label = groups[i - 1];
                goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x,  CGRectGetMaxY(label.frame) + 5, rect.size.width, rect.size.height)];
            }
            else
            {
                goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x,  rect.origin.y +5, rect.size.width, rect.size.height)];
            }
            
            goodLabel.numberOfLines = 0;
            goodLabel.lineBreakMode = NSLineBreakByCharWrapping;
            goodLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
            goodLabel.font = [UIFont systemFontOfSize:11];
            goodLabel.text = groupGoods[i];
            CGSize size =  [self sizeWithString:goodLabel.text font:goodLabel.font width:rect.size.width];
            goodLabel.frame = CGRectMake(goodLabel.frame.origin.x, goodLabel.frame.origin.y, CGRectGetMaxX(goodLabel.frame), size.height);
            [self addSubview:goodLabel];
            self.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(goodLabel.frame)+4);
            [groups addObject:goodLabel];
        }
    }
}

/**
 * Method name: sizeWithString
 * MARK: - 根据label内容计算label高度
 * Parameter: label内容
 * Parameter: label字体大小
 */
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(float)width
{
    CGRect rect;
    if ([[UIScreen mainScreen] bounds].size.width > 320) {
        rect = [string boundingRectWithSize:CGSizeMake(width, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    else
    {
        rect = [string boundingRectWithSize:CGSizeMake(width, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    
    
    return rect.size;
}

@end
