//
//  HomeCollectionViewCell.m
//  KingProFrame
//
//  Created by meyki on 11/24/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "Headers.h"

@interface HomeCollectionViewCell()
{
    UILabel *namelabel;//商品名字
    UIImageView  *goodImageView;//商品图片
    UILabel *goodPrice;//商品原价
    UILabel *vipGoodPrice;//会员价格
}
@end

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
    [self createInfoAction];
}

- (void)createInfoAction {
    
    namelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280/2+25,  (viewWidth-5)/2-20, 16)];
    namelabel.textColor = [UIColor_HEX colorWithHexString:@"111112"];
    namelabel.font=[UIFont systemFontOfSize:12];
    
    namelabel.text = [NSString stringWithFormat:@"新鲜进口柠檬"];
//    namelabel.lineBreakMode = NSLineBreakByWordWrapping;
//    namelabel.numberOfLines = 1;
    
    for (id subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [self.contentView addSubview:namelabel];
    
    goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (viewWidth-1)/2,280/2+20)];
    goodImageView.backgroundColor = [UIColor whiteColor];
    goodImageView.contentMode = UIViewContentModeScaleAspectFit;
    [goodImageView setImage:[UIImage imageNamed:@"2.jpg"]];
    [self.contentView addSubview: goodImageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 280/2+20, (viewWidth-5)/2-20, 0.5)];
    lineView.backgroundColor = [UIColor_HEX colorWithHexString:@"CCCCCC"];
    [self.contentView addSubview:lineView];
    
    goodPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 280/2+22*2,  ((viewWidth-1)/2)/3, 25)];
    goodPrice.textColor = [UIColor_HEX colorWithHexString:@"111112"];
    goodPrice.font=[UIFont systemFontOfSize:13];
    goodPrice.textAlignment = NSTextAlignmentLeft;
    goodPrice.text = [NSString stringWithFormat:@"¥ 35"];
    [self.contentView addSubview:goodPrice];
    
    vipGoodPrice = [[UILabel alloc] initWithFrame:CGRectMake(((viewWidth-1)/2)/3+10, 280/2+22*2,  ((viewWidth-1)/2)/3+15, 25)];
    vipGoodPrice.textColor = [UIColor_HEX colorWithHexString:@"FF5757"];
    vipGoodPrice.font=[UIFont systemFontOfSize:12];
    vipGoodPrice.textAlignment = NSTextAlignmentCenter;
    vipGoodPrice.text = [NSString stringWithFormat:@"VIP ¥ 28"];
    [self.contentView addSubview:vipGoodPrice];
    
    self.addCartBtn=[[UIButton alloc]initWithFrame:CGRectMake(((viewWidth-1)/2)/4+viewWidth/3.5, 280/2+22*2+2,  20, 20)];
//    self.addCartBtn.backgroundColor = [UIColor redColor];
//    self.addCartBtn.layer.cornerRadius = 10;
//    self.addCartBtn.layer.masksToBounds = YES;
//    self.addCartBtn.layer.borderWidth=1.0;//描边粗细
//    self.addCartBtn.layer.borderColor=[[UIColor redColor] CGColor];//描边颜色
//    self.addCartBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.addCartBtn setBackgroundImage:[UIImage imageNamed:
                                   @"icon_addCartImg"]
                         forState:UIControlStateNormal];
//    [self.addCartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView  addSubview:self.addCartBtn];
}

- (void)setCellDataAction:(goodsListModel *)model {
    
    namelabel.text = model.goodsName;
    NSString *urlStr = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_500,w_500", model.goodsPic];
    NSURL *imgUrl = [NSURL URLWithString:urlStr];
    [goodImageView setImageWithURL:imgUrl placeholderImage:UIIMAGE(@"goods_icon_default.png")];
    goodPrice.text = [NSString stringWithFormat:@"￥ %@", model.goodsPrice];
    vipGoodPrice.text = [NSString stringWithFormat:@"VIP ¥ %@", model.vipPrice];
}

@end
