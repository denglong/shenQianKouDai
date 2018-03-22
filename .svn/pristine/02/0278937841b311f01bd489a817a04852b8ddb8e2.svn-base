//
//  HomeGoodsCell.m
//  KingProFrame
//
//  Created by denglong on 11/27/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "HomeGoodsCell.h"
#import "Headers.h"
#import "SignModel.h"

@implementation HomeGoodsCell
@synthesize goodImage;
@synthesize goodName;
@synthesize goodPrice;
@synthesize signImage;
@synthesize signLabel;
@synthesize addBtn;
@synthesize counterView;
@synthesize purchaseLab;
@synthesize markBtn1, markBtn2, markBtn3;

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellStyleDefault;
    
    signLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 28, 16)];
    signLabel.textColor = [UIColor whiteColor];
    signLabel.font = [UIFont systemFontOfSize:10];
    signLabel.text = @"HOT";
    signLabel.textAlignment = NSTextAlignmentCenter;
    [signImage addSubview:signLabel];
    
    purchaseLab.layer.cornerRadius = 11;
    purchaseLab.layer.borderWidth = 1.0;
    purchaseLab.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#ffe100"] CGColor];
    purchaseLab.hidden = YES;
    
    counterView = [[CounterClass alloc] init];
    UIView *countView = [counterView createCounterView:CGRectMake(viewWidth - 111, self.frame.size.height - 48, 111, 48)];
    counterView.hidden = YES;
    [self.contentView addSubview:countView];
}

- (void)setGoodModel:(goodsListModel *)goodModel {
    //判断普通商品左标是否显示
    if ([goodModel.isHot integerValue] == 1 && [goodModel.sellType integerValue] == 0)
    {
        signImage.hidden = NO;
    }
    else
    {
        signImage.hidden = YES;
    }
    
    //判断特殊商品左标是否显示
    if ([goodModel.sellType integerValue] != 0)
    {
        if ([DataCheck isValidString: goodModel.sellTypeIcon])
        {
            signImage.hidden = NO;
            signLabel.hidden = YES;
            [signImage setImageWithURL:
                   [NSURL URLWithString:goodModel.sellTypeIcon]
                        placeholderImage:UIIMAGE(@"zhijiang")];
        }
        else
        {
            signImage.hidden = YES;
        }
        
        purchaseLab.hidden = NO;
        counterView.hidden = YES;
        addBtn.hidden = YES;
    }
    else
    {
        if ([goodModel.isHot integerValue] == 0) {
            signImage.hidden = YES;
        }
        else
        {
            signImage.hidden = NO;
        }
        purchaseLab.hidden = YES;
        counterView.hidden = NO;
        addBtn.hidden = NO;
    }
    
    goodName.text = goodModel.goodsName;
    float price = [goodModel.goodsPrice floatValue];
    goodPrice.text = [NSString stringWithFormat:@"￥%.2f", price];
    [goodImage setImageWithURL:
           [NSURL URLWithString:goodModel.goodsPic]
                placeholderImage:UIIMAGE(@"orderShopHeader")];
    
    if ([goodModel.sellType integerValue] == 0) {
        //遍历购物车数据设置计数器
        ShoppingCartModel *shopCartInfo = [ShoppingCartModel shareModel];
        for (NSInteger i = 0; i < shopCartInfo.shopInfos.count; i ++)
        {
            NSDictionary *goodDic = shopCartInfo.shopInfos[i];
            if ([goodModel.goodsId integerValue] == [[goodDic objectForKey:@"goodsId"] integerValue])
            {
                goodModel.num = [[goodDic objectForKey:@"goodsNumber"] integerValue];
            }
        }
        
        if (goodModel.num > 0 && shopCartInfo.shopInfos.count > 0 && [UserLoginModel isAverageUser] && [UserLoginModel isLogged])
        {
            counterView.hidden = NO;
            counterView.numLabel.text = [NSString stringWithFormat:@"%ld", goodModel.num];
        }
        else
        {
            goodModel.num = 0;
            counterView.hidden = YES;
            counterView.numLabel.text = @"1";
        }
    }
    else
    {
        counterView.hidden = YES;
    }
    
    markBtn1.hidden = YES;
    markBtn2.hidden = YES;
    markBtn3.hidden = YES;
    //设置标签
    for (NSInteger i = 0; i < goodModel.goodsTags.count; i ++)
    {
        SignModel *signModel = goodModel.goodsTags[i];
        switch (i) {
            case 0:
                [self setMarkBtn:markBtn1 andModel:signModel];
                break;
                
            case 1:
                [self setMarkBtn:markBtn2 andModel:signModel];
                break;
                
            case 2:
                [self setMarkBtn:markBtn3 andModel:signModel];
                break;
            default:
                break;
        }
    }
}

- (void)setMarkBtn:(UIButton *)markBtn andModel:(SignModel *)signModel {
    markBtn.hidden = NO;
    if ([signModel.borderStyle integerValue] == 1)
    {
        markBtn.layer.cornerRadius = 0;
    }
    else if ([signModel.borderStyle integerValue] == 2)
    {
        markBtn.layer.cornerRadius = 4;
    }
    else
    {
        markBtn.layer.cornerRadius = 8;
    }
    
    markBtn.backgroundColor = [UIColor_HEX colorWithHexString:signModel.bgColor];
    markBtn.layer.borderColor = [[UIColor_HEX colorWithHexString:signModel.borderColor] CGColor];
    markBtn.layer.borderWidth = 0.5;
    [markBtn setTitle:signModel.text forState:UIControlStateDisabled];
    [markBtn setTitleColor:[UIColor_HEX colorWithHexString:signModel.textColor] forState:UIControlStateDisabled];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [goodImage removeFromSuperview];
    [goodName removeFromSuperview];
    [goodPrice removeFromSuperview];
    [signImage removeFromSuperview];
    [addBtn removeFromSuperview];
    [counterView removeFromSuperview];
    [signLabel removeFromSuperview];
}

@end
