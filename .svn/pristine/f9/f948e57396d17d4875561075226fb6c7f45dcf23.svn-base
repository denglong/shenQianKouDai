//
//  CYSearchTableViewCell.m
//  KingProFrame
//
//  Created by eqbang on 15/12/9.
//  Copyright © 2015年 king. All rights reserved.
//

#import "CYSearchTableViewCell.h"
#import "Headers.h"
#import "CYGoodsTagModel.h"
#import "EvaluteNoPhysicObjectViewController.h"



@interface CYSearchTableViewCell()

@property(nonatomic,retain)IBOutlet UIImageView *desImageView;
@property(nonatomic,retain)IBOutlet UIButton *hotImageView;
@property(nonatomic,retain)IBOutlet UILabel *goodsNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyItRightNow;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *separateLine;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *firstTagButton;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *secondTagButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *thirdTagButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *sellTypeIconImageview;

@end

@implementation CYSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separateLine.backgroundColor =[UIColor_HEX colorWithHexString:@"#eeeeee"];
    
    
    self.buyItRightNow.layer.borderColor = [UIColor_HEX colorWithHexString:@"#ffe100"].CGColor;
    self.buyItRightNow.layer.borderWidth = .5;
    
//    self.firstTagButton.enabled = NO;
//    self.secondTagButton.enabled = NO;
//    self.thirdTagButton.enabled = NO;
//    
//    self.firstTagButton.hidden = YES;
//    self.secondTagButton.hidden = YES;
//    self.thirdTagButton.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CYSearchResultGoodsModel *)model
{
    _model = model;
    NSString *urlStr = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_500,w_500", model.goodsPic];
    [self.desImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:UIIMAGE(@"goods_icon_default.png")];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.goodsPrice];
//    self.hotImageView.hidden = !model.isHot;
    self.goodsNameLabel.text = model.goodsName;
    
    // 左上角的typeIcon
    if (model.sellType != 0)
    {
        //    设置左上角的图片
        if (model.sellTypeIcon)
        {
            self.sellTypeIconImageview.hidden = NO;
            
            [self.sellTypeIconImageview setImageWithURL:[NSURL URLWithString:model.sellTypeIcon] placeholderImage:[UIImage imageNamed:@"zhijiang"]];
            
        }else
        {
            self.sellTypeIconImageview.hidden = YES;
        }
    }else
    {
        self.sellTypeIconImageview.hidden = YES;
    }
//    else
//    {
        //是否热销 0:否 1:是
    if (model.isHot == 0)
    {
        self.hotImageView.hidden = YES;
    }else
    {
        self.hotImageView.hidden = NO;
    }
    
    
//        self.hotImageView.hidden = !model.isHot;
//        [self.hotImageView setTitle:@"HOT" forState:UIControlStateNormal];
//    }

    
    if (model.sellType == 0)
    {
        self.addBtn.hidden = YES;
        self.buyItRightNow.hidden = YES;
    }else
    {
        self.buyItRightNow.hidden = YES;
        self.addBtn.hidden = YES;
    }
    
    // 设置标签按钮
    if ([DataCheck isValidArray: model.goodsTags])
    {
        for (int i = 0; i<model.goodsTags.count ; i++)
        {
            CYGoodsTagModel *tagModel = model.goodsTags[i];
            
            switch (i)
            {
                case 0:
                {
                    [self setTagButton:self.firstTagButton withTagModel:tagModel];
                    self.firstTagButton.hidden = NO;
                    break;
                }
                case 1:
                {
                    [self setTagButton:self.secondTagButton withTagModel:tagModel];
                    self.secondTagButton.hidden = NO;
                    break;
                }
                case 2:
                {
                    [self setTagButton:self.thirdTagButton withTagModel:tagModel];
                    self.thirdTagButton.hidden = NO;
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
        self.thirdTagButton.hidden = YES;
    }
}

- (void)setButtonTag:(NSInteger)buttonTag
{
    self.addBtn.tag = buttonTag;
    self.buyItRightNow.tag = buttonTag;
}
- (IBAction)buyItRIghtNowClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pushToBuyItRightNowWebiew:)])
    {
        [self.delegate pushToBuyItRightNowWebiew:self.model.link];
    }
}



- (void)setTagButton:(UIButton *)tagButton withTagModel:(CYGoodsTagModel *)tagModel
{
    if (tagModel != nil)
    {
        tagButton.layer.borderColor = [UIColor_HEX colorWithHexString:tagModel.borderColor].CGColor;
        [tagButton setTitle:tagModel.text forState:UIControlStateDisabled];
        [tagButton setTitleColor:[UIColor_HEX colorWithHexString:tagModel.textColor] forState:UIControlStateDisabled];
        [tagButton setBackgroundColor:[UIColor_HEX colorWithHexString:tagModel.bgColor]];
        tagButton.layer.borderWidth = .5;
        
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
    }
    
}


@end
