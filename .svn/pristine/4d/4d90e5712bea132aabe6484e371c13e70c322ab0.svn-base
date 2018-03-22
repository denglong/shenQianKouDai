//
//  confirmGoodsCell.m
//  KingProFrame
//
//  Created by lihualin on 15/10/26.
//  Copyright © 2015年 king. All rights reserved.
//

#import "confirmGoodsCell.h"
#import "Headers.h"
@implementation confirmGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.goodsImage.layer.borderColor = [UIColor_HEX colorWithHexString:@"#cccccc"].CGColor;
    self.groudGoodLabel.hidden = YES;
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
    NSURL * url = [NSURL URLWithString:goods.goodsPic];
    [self.goodsImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"orderShopHeader"]];
    self.goodsNameLabel.text = goods.goodsName;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"x%ld",(long)goods.goodsNumber];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",goods.goodsPrice];
    CGSize size =[CommClass getSuitSizeWithString:goods.goodsName font:12 bold:NO sizeOfX:viewWidth-160];
    if(size.height+8 > self.goodsImage.frame.size.height){
        self.frame = CGRectMake(0, 0, self.frame.size.width, size.height+self.goodsNameLabel.frame.origin.y+18);
    }
    
    if (goods.groupDetail.count > 0) {
        [self setGroupGoods:goods.groupDetail];
    }
    
}

- (void)setGroupGoods:(NSArray *)groupGoods {
    if (groupGoods.count > 0) {
        CGSize size =  [self sizeWithString:self.goodsNameLabel.text font:self.goodsNameLabel.font];
        
        NSMutableArray *groups = [NSMutableArray array];
        for (NSInteger i = 0; i < groupGoods.count; i ++) {
            CGRect rect = self.groudGoodLabel.frame;
            UILabel *goodLabel = nil;
            if (groups.count > 0) {
                UILabel *label = groups[i - 1];
                goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x,  CGRectGetMaxY(label.frame) + 5, viewWidth - 150, rect.size.height)];
            }
            else
            {
                goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x,  self.goodsNameLabel.frame.origin.y + size.height + 10, viewWidth - 150, rect.size.height)];
            }
            goodLabel.numberOfLines = 0;
            goodLabel.textColor = self.groudGoodLabel.textColor;
            goodLabel.font = self.groudGoodLabel.font;
            goodLabel.text = groupGoods[i];
            CGSize size =  [self sizeWithString:goodLabel.text font:goodLabel.font];
            goodLabel.frame = CGRectMake(goodLabel.frame.origin.x, goodLabel.frame.origin.y, viewWidth - 150, size.height);
            
            self.groudGoodLabel = goodLabel;
            [self addSubview:goodLabel];
            
            self.frame = CGRectMake(0, 0, self.frame.size.width, goodLabel.frame.origin.y + goodLabel.frame.size.height + 10);
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
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect;
    if ([[UIScreen mainScreen] bounds].size.width > 320) {
        rect = [string boundingRectWithSize:CGSizeMake(viewWidth - 150, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    else
    {
        rect = [string boundingRectWithSize:CGSizeMake(viewWidth - 150, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    
    
    return rect.size;
}

@end
