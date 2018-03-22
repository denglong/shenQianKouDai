//
//  transferGoodsCell.m
//  KingProFrame
//
//  Created by eqbang on 15/12/3.
//  Copyright © 2015年 king. All rights reserved.
//

#import "transferGoodsCell.h"
#import "Headers.h"

@interface transferGoodsCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;


/** 多少钱换购（限购商品） */
@property (weak, nonatomic) IBOutlet UIButton *imageTip;
/** 换购商品价格 */
@property (weak, nonatomic) IBOutlet UILabel *transferPrice;
/** 满多少钱能够换购 */
@property (weak, nonatomic) IBOutlet UILabel *howToTransfer;
/** 商品数量 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLable;
/** 左边删除button */
@property (weak, nonatomic) IBOutlet UIButton *leftMinusButton;
/** 商品数量label */
@property (weak, nonatomic) IBOutlet UILabel *goodsNumberLabel;
/** 增加商品数量button */
@property (weak, nonatomic) IBOutlet UIButton *addGoodsNumberButton;

/** 下架商品的maskview（包含下架标识）*/
@property (weak, nonatomic) IBOutlet UIView *maskView;
/** 名字的右边约束 contentview的右边大于等于商品名称的右边加上本约束 本约束需要可以改变（根据屏幕宽度）*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameLabelRightConstraint;
/** 屏幕宽度的85% */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transferPriceLeftConstraint;
/** 加减号和商品数量的整体 */
@property (weak, nonatomic) IBOutlet UIView *operationGoodsNumberView;
/** 限时抢购label */
@property (weak, nonatomic) IBOutlet UILabel *limitTimeGoodsLabel;

@end



@implementation transferGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.howToTransfer.textColor = [UIColor_HEX colorWithHexString:@"#ff5a1e"];
    
    self.transferPrice.textColor = [UIColor_HEX colorWithHexString:@"#ff5a1e"];
    
    self.leftMinusButton.enabled = YES;
    
    self.goodsNameLabelRightConstraint.constant = ([UIScreen mainScreen].bounds.size.width - 20) * 0.8;
    
    self.transferPriceLeftConstraint.constant = ([UIScreen mainScreen].bounds.size.width - 20) * 0.25;
    
    self.imageTip.layer.masksToBounds = YES;
    
    self.imageTip.layer.cornerRadius = 3;
    
    self.imageTip.backgroundColor = [UIColor_HEX colorWithHexString:@"ff724d"];
    
    // 商品图片边框
//    self.goodsImage.layer.masksToBounds = YES;
//    self.goodsImage.layer.cornerRadius = 4;
//    self.goodsImage.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#cccccc"] CGColor];
//    self.goodsImage.layer.borderWidth = 0.5f;

}

- (void)setGoodsButtonTag:(NSInteger)goodsButtonTag
{
    self.leftMinusButton.tag = goodsButtonTag;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoodsModel:(CYCartGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    // 公共设置 商品图片，商品名称
    [self.goodsImage setImageWithURL:[NSURL URLWithString:goodsModel.goodsPic]
                    placeholderImage:[UIImage imageNamed:@"goods_icon_default"]];
    self.goodsNameLable.text = goodsModel.goodsName;
    
    // --unshelve	是否下架，1=下架，0=正常
    if (goodsModel.unshelve == 1)
    {
        self.maskView.hidden = NO;
        self.goodsNameLable.textColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        MyInfoModel *myInfo = [MyInfoModel sharedInstance];
        if ([myInfo.userType integerValue] == 1) {
            self.transferPrice.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.vipPrice];
        }
        else
        {
            self.transferPrice.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.goodsPrice];
        }
        
        self.transferPrice.textColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        self.goodsNumberLabel.textColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        // 右边满多钱换购隐藏
        self.howToTransfer.hidden = YES;
        // 换购，限购标致隐藏
        self.imageTip.hidden = YES;
        // 限购商品，数量有限label隐藏
        self.limitTimeGoodsLabel.hidden = YES;
    }
    // 没下架
    else
    {   self.maskView.hidden = YES;
        self.goodsNameLable.textColor = [UIColor colorWithWhite:0.000 alpha:0.800];
        self.goodsNumberLabel.textColor = [UIColor blackColor];

        // 换购
        if (goodsModel.sellType == 1)
        {
            self.limitTimeGoodsLabel.hidden = NO;
            self.limitTimeGoodsLabel.text = goodsModel.giftInfo;
            // 是否满足换购条件
            // 不满足
            if ([DataCheck isValidString:goodsModel.tip])
            {
                // 加减号全部隐藏
                self.operationGoodsNumberView.hidden = YES;
                // 显示满多少钱换购
                self.howToTransfer.hidden = NO;
                self.howToTransfer.text = [NSString stringWithFormat:@"%@",goodsModel.imgTip];
                [self.howToTransfer sizeToFit];
                // 不显示换购标识
                self.imageTip.hidden = YES;
                // 显示原价 并且置灰 原价
                self.transferPrice.textColor = [UIColor colorWithWhite:0.000 alpha:0.500];
                MyInfoModel *myInfo = [MyInfoModel sharedInstance];
                if ([myInfo.userType integerValue] == 1) {
                    self.transferPrice.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.vipPrice];
                }
                else
                {
                    self.transferPrice.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.goodsPrice];
                }
            }
            // 满足换购条件
            else
            {
                // 加减号全部不隐藏
                self.operationGoodsNumberView.hidden = NO;
                // 不显示满多少钱换购
                self.howToTransfer.hidden = YES;
                // 显示换购标识
                self.imageTip.hidden = NO;
                // 多少钱的换购活动
                [self.imageTip  setTitle:[NSString stringWithFormat:@"%@",goodsModel.imgTip]
                                forState:UIControlStateNormal];
                [self.imageTip sizeToFit];
                // 显示换购价格并且颜色为红色
                self.transferPrice.textColor = [UIColor colorWithRed:1.000 green:0.447 blue:0.302 alpha:1.000];
                MyInfoModel *myInfo = [MyInfoModel sharedInstance];
                if ([myInfo.userType integerValue] == 1) {
                    self.transferPrice.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.vipPrice];
                }
                else
                {
                    self.transferPrice.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.goodsPrice];
                }
            }
        }
        // 限购
        else
        {
            self.limitTimeGoodsLabel.hidden = NO;
            self.limitTimeGoodsLabel.text = goodsModel.giftInfo;
            self.imageTip.hidden = NO;
            [self.imageTip setTitle:@"限时抢购" forState:UIControlStateNormal];
            [self.imageTip sizeToFit];
            // 不隐藏加减号
            self.operationGoodsNumberView.hidden = NO;
            // 不显示满多少钱换购
            self.howToTransfer.hidden = YES;
            // 显示限购价格并且颜色为红色
            self.transferPrice.textColor = [UIColor colorWithRed:1.000 green:0.447 blue:0.302 alpha:1.000];
            MyInfoModel *myInfo = [MyInfoModel sharedInstance];
            if ([myInfo.userType integerValue] == 1) {
                self.transferPrice.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.vipPrice];
            }
            else
            {
                self.transferPrice.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.goodsPrice];
            }
        }
        

    }
}

- (IBAction)leftMinusButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(specialGoodsDeleteAction:)])
    {
        [self.delegate specialGoodsDeleteAction:sender];
    }
}


@end
