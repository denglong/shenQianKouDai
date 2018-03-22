//
//  TheOrderCell.m
//  KingProFrame
//
//  Created by denglong on 7/28/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "TheOrderCell.h"
#import "Headers.h"
#import "GoodsImgModel.h"

@implementation TheOrderCell
@synthesize payBtn, cancleBtn, myScrollView, line, downImage, goodsNum, goodsField, backOrderBtn, confirmBtn;
@synthesize imageUrls, date, yushouSign;

- (void)awakeFromNib {
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 1);
    
    yushouSign.hidden = YES;
    goodsNum.hidden = YES;
    goodsField.hidden = YES;
    backOrderBtn.hidden = YES;
    confirmBtn.hidden = YES;
    payBtn.layer.cornerRadius      = 3;
    confirmBtn.layer.cornerRadius = 3;
    cancleBtn.layer.cornerRadius  = 3;
    cancleBtn.layer.borderColor   = [[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1] CGColor];
    cancleBtn.layer.borderWidth   =0.5f;
    
    backOrderBtn.layer.cornerRadius = 3;
    backOrderBtn.layer.borderColor = [[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1] CGColor];
    backOrderBtn.layer.borderWidth = 0.5f;
    
    yushouSign.layer.cornerRadius = 4;
    
//    self.downLine.frame = CGRectMake(10, 92, self.downLine.frame.size.width, 0.5);
    
    UIImage *orderLine               = [UIImage imageNamed:@"icon_orderLine.png"];
    line.backgroundColor            = [UIColor colorWithPatternImage:orderLine];
    self.downLine.backgroundColor = [UIColor colorWithPatternImage:orderLine];
    
    UIImage *image                    = [UIImage imageNamed:@"icon_orderBg.png"];
    downImage.backgroundColor      = [UIColor colorWithPatternImage:image];
    
    myScrollView.showsVerticalScrollIndicator   = FALSE;
    myScrollView.showsHorizontalScrollIndicator = FALSE;
    [myScrollView setFrame:CGRectMake(0, myScrollView.frame.origin.y, myScrollView.frame.size.width, myScrollView.frame.size.height)];
    
    self.address.hidden = YES;
    self.phoneImg.hidden = YES;
    self.downLine.hidden = YES;
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    for (NSInteger i = 0; i < imageUrls.count; i ++) {
//        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * myScrollView.frame.size.height + 9 + (i * 9), 0, myScrollView.frame.size.height, myScrollView.frame.size.height)];
//        imgV.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        imgV.layer.borderWidth =0.5f;
//        NSURL * url = [NSURL URLWithString:[imageUrls[i] objectForKey:@"goodsPic"]];
//        [imgV setImageWithURL:url placeholderImage:[UIImage imageNamed:@"orderShopHeader"]];
//        [myScrollView addSubview:imgV];
//    }
//    
//    [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.height * imageUrls.count + imageUrls.count * 9 + 10, 0)];
}

- (void)setShopImage {
    for (NSInteger i = 0; i < imageUrls.count; i ++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * myScrollView.frame.size.height + 9 + (i * 9), 0, myScrollView.frame.size.height, myScrollView.frame.size.height)];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        imgV.layer.borderWidth =0.5f;
        NSURL * url = [NSURL URLWithString:[imageUrls[i] objectForKey:@"goodsPic"]];
        [imgV setImageWithURL:url placeholderImage:[UIImage imageNamed:@"orderShopHeader"]];
        [myScrollView addSubview:imgV];
    }
    
    [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.height * imageUrls.count + imageUrls.count * 9 + 10, 0)];
}

- (void)setOrderModel:(myOrderModel *)orderModel {
    for (UIView *subView in myScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    imageUrls = orderModel.goodsResponses;
    for (NSInteger i = 0; i < imageUrls.count; i ++) {
        GoodsImgModel *goodImgModel = imageUrls[i];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * myScrollView.frame.size.height + 9 + (i * 9), 0, myScrollView.frame.size.height, myScrollView.frame.size.height)];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        imgV.layer.borderWidth =0.5f;
        imgV.layer.cornerRadius = 5;
        NSString *urlStr = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_500,w_500", goodImgModel.goodsPic];
        NSURL * url = [NSURL URLWithString:urlStr];
        [imgV setImageWithURL:url placeholderImage:[UIImage imageNamed:@"orderShopHeader"]];
        [myScrollView addSubview:imgV];
    }
    
    [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.height * imageUrls.count + imageUrls.count * 9 + 10, 0)];
    
    NSString *myDate = [NSString stringWithFormat:@"%@", orderModel.createTime];
    date.text = [self formatTimeStamp:[myDate substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"];
    self.amount.text = [NSString stringWithFormat:@"合计：￥%.2f", [orderModel.realPrice floatValue]];
    self.sum.text = [NSString stringWithFormat:@"共%@件商品", orderModel.goodsNumber];
    
    if ([orderModel.orderStatus integerValue] == 6) {
        payBtn.hidden = YES;
        cancleBtn.hidden = NO;
        line.hidden = NO;
        self.frame = CGRectMake(0, 0, self.frame.size.width, 125);
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, 169);
        self.bgView.frame = CGRectMake(0, 0, self.frame.size.width, 163);
        downImage.frame = CGRectMake(0, 163, self.frame.size.width, 6.5);
    }
    else
    {
        payBtn.hidden = NO;
        cancleBtn.hidden = NO;
        line.hidden = NO;
        self.frame = CGRectMake(0, 0, self.frame.size.width, 125);
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, 169);
        self.bgView.frame = CGRectMake(0, 0, self.frame.size.width, 125);
        downImage.frame = CGRectMake(0, 163, self.frame.size.width, 6.5);
    }
    confirmBtn.hidden = YES;
    switch ([orderModel.orderStatus integerValue]) {
        case 1:
            self.state.text = @"待付款";
            [cancleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            payBtn.hidden = YES;
            break;
            
        case 2:
            self.state.text = @"待付款";
            [payBtn setTitle:@"立即付款" forState:UIControlStateNormal];
            payBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
            [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            payBtn.layer.borderWidth = 0.0;
            break;
            
        case 3:
            self.state.text = @"配货中";
            [cancleBtn setTitle:@"联系商家" forState:UIControlStateNormal];
            payBtn.hidden = YES;
            break;
            
        case 4:
        {
            self.state.text = @"配送中";
            confirmBtn.hidden = NO;
            confirmBtn.frame = cancleBtn.frame;
            payBtn.hidden = YES;
        }
            break;
        case 5:
        {
            self.state.text = @"已完成";
            [cancleBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            payBtn.hidden = NO;
            [payBtn setTitle:@"查看点评" forState:UIControlStateNormal];
            payBtn.backgroundColor = [UIColor whiteColor];
            [payBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            payBtn.layer.borderColor   = [[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1] CGColor];
            payBtn.layer.borderWidth   =0.5f;
        }
            break;
        case 6:
        {
            self.state.text = @"已取消";
            payBtn.hidden = YES;
            [cancleBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        }
            break;
        case 7:
        {
            self.state.text = @"已完成";
            
            [payBtn setTitle:@"点评" forState:UIControlStateNormal];
            payBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#EB6F67"];
            payBtn.layer.borderWidth = 0.0;
            [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancleBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            cancleBtn.hidden = NO;
        }
            break;
        default:
            break;
    }
}

//时间戳转换成时间 timeFormat是要转换成的时间格式
-(NSString*)formatTimeStamp:(NSString *)timeStamp timeFormat:(NSString *)timeFormat{
    
    
    //NSTimeInterval time=[timeStamp doubleValue]+28800;//因为时差问题要加8小时 == 28800
    NSTimeInterval time=[timeStamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //DLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:timeFormat];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}


@end
