//
//  CategoryDetailCell.m
//  KingProFrame
//
//  Created by JinLiang on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//



#import "CategoryDetailCell.h"
#import "Headers.h"
#import "CYGoodsTagModel.h"
#import "MyInfoModel.h"

@interface CategoryDetailCell()

/** 按钮标签数组 */
@property (nonatomic , strong) NSMutableArray *tagButtonArray;
/** 左上角的商品标签 */
@property (weak, nonatomic) IBOutlet UIImageView *sellTypeIconImageview;

@end


@implementation CategoryDetailCell
@synthesize desImageView;
@synthesize hotImageView;
@synthesize goodsNameLabel;
@synthesize priceLabel;
@synthesize addBtn;
@synthesize addExtBtn;
@synthesize advImageView;
@synthesize vipPrice;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.desImageView.backgroundColor=[UIColor clearColor];
    self.hotImageView.backgroundColor=[UIColor clearColor];
    self.goodsNameLabel.backgroundColor=[UIColor clearColor];
    self.priceLabel.backgroundColor=[UIColor clearColor];
    self.addBtn.backgroundColor=[UIColor clearColor];
    self.addExtBtn.backgroundColor=[UIColor clearColor];
    self.separateLine.backgroundColor = [UIColor_HEX colorWithHexString:@"CCCCCC"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.buyItRightNow.layer.borderColor = [UIColor_HEX colorWithHexString:@"#ffe100"].CGColor;
    self.buyItRightNow.layer.borderWidth = .5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CYCategoryCellModel *)model
{
    _model = model;
    
    self.addBtn.hidden = NO;
    
    self.advImageView.hidden=YES;
    
    //商品图片
    NSString *urlStr = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_500,w_500", model.goodsPic];
    [self.desImageView setImageWithURL:[NSURL URLWithString:urlStr]
                      placeholderImage:UIIMAGE(@"goods_icon_default.png")];

    
    if (model.sellType != 0)
    {
        //    设置左上角的图片
        if ([DataCheck isValidString:model.sellTypeIcon])
        {
            self.sellTypeIconImageview.hidden = NO;
            
            [self.sellTypeIconImageview setImageWithURL:[NSURL URLWithString:model.sellTypeIcon]
                                       placeholderImage:[UIImage imageNamed:@"zhijiang"]];
            
        }else
        {
            self.sellTypeIconImageview.hidden = YES;
        }
        
        self.buyItRightNow.hidden = NO;
        
        self.addBtn.hidden = YES;
        
        self.minusButton.hidden = YES;

    }else
    {
        self.sellTypeIconImageview.hidden = YES;
        
        self.buyItRightNow.hidden = YES;
        
        self.addBtn.hidden = NO;
        
//        self.minusButton.hidden = NO;
    }
    
    
    //是否热销 0:否 1:是
    self.zhijiangButon.hidden = !model.isHot;

    // 商品名称
    self.goodsNameLabel.text= model.goodsName;
    
    // 商品价格
    MyInfoModel *myInfo = [MyInfoModel sharedInstance];
    if ([myInfo.userType integerValue] == 1) {
        self.priceLabel.text=[NSString stringWithFormat:@"￥%.2f",[model.vipPrice floatValue]];
        
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",model.goodsPrice] attributes:attribtDic];
        vipPrice.attributedText = attribtStr;
    }
    else
    {
        self.priceLabel.text=[NSString stringWithFormat:@"￥%.2f",model.goodsPrice];
        
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"VIP ￥%.2f",[model.vipPrice floatValue]] attributes:attribtDic];
        vipPrice.attributedText = attribtStr;
    }
    
    //中划线
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"vip ￥%@",model.vipPrice] attributes:attribtDic];
    
//    if ([[MyInfoModel sharedInstance].userType integerValue] == 1) {
//        self.priceLabel.text=[NSString stringWithFormat:@"￥%@",model.vipPrice];
//        attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价 ￥%.2f",model.goodsPrice] attributes:attribtDic];
//    }
    
    // 加减号
    if (model.goodsNumber > 0 && model.sellType == 0)
    {
//        self.minusButton.hidden = NO;
//        
//        self.goodsCount.hidden = NO;
        // 商品数量
        self.goodsCount.text = [NSString stringWithFormat:@"%d",model.goodsNumber];
    }else
    {
        self.minusButton.hidden = YES;
        
        self.goodsCount.hidden = YES;
    }
    
    // 加号按钮点击
    self.addBtn.tag= model.indexPathRow;
    
    if ([self.delegate respondsToSelector:@selector(btnTouchAction:)])
    {
        [self.addBtn addTarget:self.delegate
                        action:@selector(btnTouchAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 减号按钮的点击
    self.minusButton.tag = model.indexPathRow;
    
    if ([self.delegate respondsToSelector:@selector(minusGoodsCount:)])
    {
        [self.minusButton addTarget:self.delegate
                             action:@selector(minusGoodsCount:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    // 设置标签按钮
    if ([DataCheck isValidArray: model.goodsTags])
    {
        self.firstTagButton.hidden = YES;
        self.secondTagButton.hidden = YES;
        self.thiredTagButton.hidden = YES;
        
        for (int i = 0; i<model.goodsTags.count ; i++)
        {
            CYGoodsTagModel *tagModel = model.goodsTags[i];

            switch (i)
            {
                case 0:
                {
                    [self setTagButton:self.firstTagButton tagModel:tagModel];
                    break;
                }
                case 1:
                {
                    [self setTagButton:self.secondTagButton tagModel:tagModel];
                    break;
                }
                case 2:
                {
                    [self setTagButton:self.thiredTagButton tagModel:tagModel];
                    break;
                }
                default:
                    break;
            }

        }
    }else
    {
        self.firstTagButton.hidden = YES;
        self.secondTagButton.hidden = YES;
        self.thiredTagButton.hidden = YES;
    }
}


- (void)setTagButton:(UIButton *)tagButton tagModel:(CYGoodsTagModel *)tagModel
{
    if (tagModel != nil)
    {
        tagButton.hidden = NO;
        tagButton.layer.borderColor = [UIColor_HEX colorWithHexString:tagModel.borderColor].CGColor;
        [tagButton setTitle:tagModel.text forState:UIControlStateDisabled];
        [tagButton setTitleColor:[UIColor_HEX colorWithHexString:tagModel.textColor] forState:UIControlStateDisabled];
        [tagButton setBackgroundColor:[UIColor_HEX colorWithHexString:tagModel.bgColor]];

        
        switch (tagModel.borderStyle)
        {
            case 1:
                tagButton.layer.cornerRadius = 0;
                break;
            case 2:
                tagButton.layer.cornerRadius = tagButton.height/4;
                break;
            case 3:
                tagButton.layer.cornerRadius = tagButton.height/2;
                break;
                
            default:
                break;
        }
    }else
    {
        tagButton.hidden = YES;
    }

}


#pragma mark - 点击立即购买之后跳转到H5的商品详情页
- (IBAction)buyItRightNow:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pushToBuyNowWebiew:)])
    {
        [self.delegate pushToBuyNowWebiew:self.model.link];
    }
}



@end
