//
//  OrderDetailHeaderCell.m
//  KingProFrame
//
//  Created by lihualin on 15/8/6.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "OrderDetailHeaderCell.h"
#import "Headers.h"
#import "OrderDetail.h"
@implementation OrderDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    self.zhifuBtn.layer.cornerRadius = 3;
    self.sureOrder.layer.cornerRadius = 3;
    
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBarBackground"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 *  打赏一下301 再来一单302 付款101 确认收货102 点评103 联系商家200 查看点评201 "逛一逛 500
 *
 *  @param orderDetail cell赋值
 */
-(void)setOrderDetail:(OrderDetail *)orderDetail
{
    if (orderDetail == nil) {
        return;
    }
   
    self.titleLable2.font = [UIFont systemFontOfSize:12];
    self.titleLable2.text = orderDetail.orderTextB;
    self.titleLabel3.text = orderDetail.orderTextC;
    if (orderDetail.orderStatus == 4) {
        self.titleLable2.text = [NSString stringWithFormat:@"收货码：%@",orderDetail.receiveCode];
    }
    CGSize size = [CommClass getSuitSizeWithString:self.titleLabel3.text font:11 bold:NO sizeOfX:viewWidth - 90];
    NSInteger status = orderDetail.orderStatus;
    NSString *shippingType = orderDetail.shippingType;
    self.btnConstraint.constant = 0;
    self.labelBtnLeftConstraint.constant = 8;
   
    //顾客
    self.zhifuBtn.hidden = NO;
    self.zhifuBtn.tag = 301; //打赏一下
    self.sureOrder.hidden = YES;
    self.titleLabel3.hidden = YES;
    self.orderType = orderDetail.orderStatus;
    switch (status) {
        case 2:
        {
            //待抢单
            self.titleLable2.text = [self getShengyushijian:_shengTime state:1];
            self.titleLable2.font = [UIFont systemFontOfSize:24];
            self.zhifuBtn.hidden = YES;
            if (orderDetail.tipPrice > 0) {
                self.titleLabel3.hidden = NO;
                self.titleLabel3.text =[NSString stringWithFormat:@"已打赏%.f元",orderDetail.tipPrice];
                size = [CommClass getSuitSizeWithString:self.titleLabel3.text font:11 bold:NO sizeOfX:viewWidth - 90];
                float w = size.width+self.zhifuBtn.frame.size.width-4;
                self.labelBtnLeftConstraint.constant = - (w+8)/2;
            }else{
                // 根据订单号存储打赏小费
                NSString * hasTipped = [[CommClass sharedCommon] localObjectForKey:orderDetail.orderNo];
                
                if ([hasTipped isEqualToString:@"YES"])
                {
                    self.zhifuBtn.hidden = NO;
                }
            }
            self.stateImgView.image = [UIImage imageNamed:@"orderState1"];
        }
            break;
        case 1:
        {
            //支付
          
            [self.zhifuBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            self.zhifuBtn.tag = 101;
            self.stateLabel1.textColor = [UIColor_HEX colorWithHexString:@"#FF5757"];
            self.stateLabel1.text = @"订单已提交";
            self.stateLabel2.text = @"待支付";
            self.stateLabel2.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.stateLabel3.text = @"配送";
            self.stateLabel3.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.titleLabel3.hidden = NO;
            self.titleLabel3.text = [self getShengyushijian:_shengTime state:2];
            size = [CommClass getSuitSizeWithString:self.titleLabel3.text font:11 bold:NO sizeOfX:viewWidth - 90];
            float w = size.width;
            self.btnConstraint.constant = (w+self.zhifuBtn.frame.size.width)/4+10;
            self.labelBtnLeftConstraint.constant = - (w + self.zhifuBtn.frame.size.width +10);
            self.stateImgView.image = [UIImage imageNamed:@"待支付"];
            self.orderStateIcon.image = [UIImage imageNamed:@"待支付Icon"];
            self.orderStateLable.text = @"订单已生成，请尽快支付";
            self.headerTextConstraint.constant = 23;
            
            _myTime = ([orderDetail.serverTime integerValue]- [orderDetail.createTime integerValue])/1000;
            if (_myTime < 900) {
                _myTime = 900 - _myTime;
                [self timeAction];
            }
        }
            break;
        case 3:
        {//待配送
            self.orderStateLable.text = @"订单已支付，正在处理中";
            self.orderStateDetLab.text = nil;
            [self.zhifuBtn setTitle:@"联系商家" forState:UIControlStateNormal];
            self.zhifuBtn.tag = 200;
            
            self.stateLabel1.text = @"待支付";
            self.stateLabel1.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.stateLabel2.text = @"已支付";
            self.stateLabel3.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.stateLabel3.text = @"待配送";
            self.stateLabel2.textColor = [UIColor_HEX colorWithHexString:@"#FF5757"];
            self.stateImgView.image = [UIImage imageNamed:@"正在处理"];
        }
            break;
        case 4:
        {//待收货
            [self.zhifuBtn setTitle:@"联系商家" forState:UIControlStateNormal];
            self.zhifuBtn.tag = 200;
            self.btnConstraint.constant = -50;
            self.sureOrder.tag = 102; //确认收货
            self.sureOrder.hidden = NO;
            self.stateLabel1.text = @"订单已提交";
            self.stateLabel1.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.stateLabel1.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.stateLabel2.text = @"已支付";
            self.stateLabel2.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            if([shippingType integerValue] == 1) {
                self.stateLabel3.text = @"配送中";
            }
            else{
                self.stateLabel3.text = @"等待自提";
            }
            self.stateLabel3.textColor = [UIColor_HEX colorWithHexString:@"#FF5757"];
            self.stateImgView.image = [UIImage imageNamed:@"待收货"];
            self.orderStateIcon.image = [UIImage imageNamed:@"待收货Icon"];
            self.orderStateLable.text = @"配送中，请注意接听电话";
            self.orderStateDetLab.text = nil;
            self.headerTextConstraint.constant = 27;
        }
            break;
        case 5:
        {  //已完成
           
            self.stateLabel1.text = @"订单已提交";
            self.stateLabel1.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.stateLabel2.text = @"已支付";
            self.stateLabel3.text = @"已完成";
            self.titleLabel3.hidden = NO;
            [self.zhifuBtn setTitle:@"查看点评" forState:UIControlStateNormal];
            self.zhifuBtn.tag = 201;
            float w = size.width;
            self.btnConstraint.constant = (w+self.zhifuBtn.frame.size.width)/4+10;
            self.labelBtnLeftConstraint.constant = - (w + self.zhifuBtn.frame.size.width +10);
            self.stateImgView.image = [UIImage imageNamed:@"订单已完成"];
            self.orderStateIcon.image = [UIImage imageNamed:@"订单已完成Icon"];
            self.orderStateLable.text = @"欢迎下次光临";//@"您在3月22日 12:32:23 确认送达";
            self.orderStateDetLab.text = nil;
            self.headerTextConstraint.constant = 27;
        }
            break;
        case 6:
        {//已取消
            self.stateLabel1.text = @"订单已提交";
            self.stateLabel1.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.stateLabel1.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.stateLabel2.text = @"订单已处理";
            self.stateLabel2.textColor = [UIColor_HEX colorWithHexString:@"#000000" alpha:0.4];
            self.stateLabel3.text = @"订单取消";
            self.stateLabel3.textColor = [UIColor_HEX colorWithHexString:@"#FF5757"];
            self.stateImgView.image = [UIImage imageNamed:@"待收货"];
            self.orderStateIcon.image = [UIImage imageNamed:@"订单已取消"];
            self.orderStateLable.text = @"订单取消";
            self.orderStateDetLab.text = nil;
            self.headerTextConstraint.constant = 27;
            
            [self refreshCancelHeaderView:orderDetail size:size];
        }
            break;
        case 7:
        {
            //待评价
            
            self.titleLabel3.hidden = NO;
            [self.zhifuBtn setTitle:@"点击评价" forState:UIControlStateNormal];
            self.zhifuBtn.tag = 103;
            self.stateLabel1.text = @"已付款";
            self.stateLabel2.text = @"订单已受理";
            self.stateLabel3.text = @"已送达";
            float w = size.width+self.zhifuBtn.frame.size.width+8;
            self.btnConstraint.constant = - w/4;
            self.stateImgView.image = [UIImage imageNamed:@"订单已完成"];
            self.orderStateIcon.image = [UIImage imageNamed:@"订单已完成Icon"];
            self.orderStateLable.text = @"欢迎下次光临";
            self.orderStateDetLab.text = nil;
        }
            break;
            
        default:
            
            break;
    }
    return;
}



-(NSString *)getShengyushijian:(NSInteger)shengTime state:(NSInteger)state
{
    if (state == 1) {
        NSInteger min =(30*60 - shengTime)/60;
        NSInteger second = (30*60 - shengTime)%60;
        if (min < 60) {
            if (second < 10) {
                return [NSString stringWithFormat: @"%ld:0%ld",(long)min,(long)second];
            }
            return [NSString stringWithFormat: @"%ld:%ld",(long)min,(long)second];
        }else{
            NSInteger h = min/60;
            min = min%60;
            if (second < 10) {
                return [NSString stringWithFormat: @"%ld:%ld:0%ld",(long)h,(long)min,(long)second];
            }
            return [NSString stringWithFormat: @"%ld:%ld:%ld",(long)h,(long)min,(long)second];
        }
    }
    NSInteger min = shengTime/60;
    NSInteger second = shengTime%60;
    if (min < 60) {
        if (second < 10) {
            return [NSString stringWithFormat: @"%ld:0%ld",(long)min,(long)second];
        }
        return [NSString stringWithFormat: @"%ld:%ld",(long)min,(long)second];
    }else{
        NSInteger h = min/60;
        min = min%60;
        if (second < 10) {
            return [NSString stringWithFormat: @"%ld:%ld:0%ld%@",(long)h,(long)min,(long)second,self.titleLabel3.text];
        }
        return [NSString stringWithFormat: @"%ld:%ld:%ld%@",(long)h,(long)min,(long)second,self.titleLabel3.text];
    }
    
}

-(void)showTipBtn:(OrderDetail *)orderDetail ifshow:(BOOL)ifshow shengTime:(NSInteger)sheng
{
    if (ifshow == YES) {
        self.zhifuBtn.hidden = NO;
    }else{
        self.zhifuBtn.hidden = YES;
        if (orderDetail.tipPrice > 0) {
            self.titleLabel3.hidden = NO;
            self.titleLabel3.text =[NSString stringWithFormat:@"已打赏%.f元",orderDetail.tipPrice];
            CGSize size = [CommClass getSuitSizeWithString:self.titleLabel3.text font:11 bold:NO sizeOfX:viewWidth - 90];
            float w = size.width+self.zhifuBtn.frame.size.width-4;
            self.labelBtnLeftConstraint.constant = - (w+8)/2;
        }
    }
    
}

/**取消状态 1 超时未支付取消 2 商家取消 3 未支付客户取消 4 无人接单取消 5 支付后客户取消*/
-(void)refreshCancelHeaderView:(OrderDetail *)orderDetail size:(CGSize)size
{
    self.stateLabel1.text = @"订单已提交";
    switch (orderDetail.cancelStatus) {
        case 1:
        {//超时未支付
            self.stateLabel2.text = @"";
            self.stateLabel3.text = @"已取消";
            if (orderDetail.again == 1) {
                [self.zhifuBtn setTitle:@"再来一单" forState:UIControlStateNormal];
                self.zhifuBtn.tag = 302;
            }else{
                self.zhifuBtn.hidden = YES;
            }
            self.stateImgView.image = [UIImage imageNamed:@"orderState5"];
        }
            break;
        case 2:
        {//商家取消订单
            self.stateLabel2.text = @"";
            self.stateLabel3.text = @"已取消";
            [self.zhifuBtn setTitle:@"联系商家" forState:UIControlStateNormal];
            self.zhifuBtn.tag = 200;
            self.stateImgView.image = [UIImage imageNamed:@"orderState5"];
        }
            break;
        case 3:
        {//未支付客户取消
            self.stateLabel2.text = @"";
            self.stateLabel3.text = @"已取消";
            self.titleLabel3.hidden = NO;
            [self.zhifuBtn setTitle:@"逛一逛" forState:UIControlStateNormal];
            self.zhifuBtn.tag = 500;
            float w = size.width;
            self.btnConstraint.constant = (w+self.zhifuBtn.frame.size.width)/4+10;
            self.labelBtnLeftConstraint.constant = - (w + self.zhifuBtn.frame.size.width +10);
            self.stateImgView.image = [UIImage imageNamed:@"orderState5"];
        }
            break;
        case 4:
        { //无人接单取消
            self.stateLabel2.text = @"";
            self.stateLabel3.text = @"已取消";
            if (orderDetail.again == 1) {
                [self.zhifuBtn setTitle:@"再来一单" forState:UIControlStateNormal];
                self.zhifuBtn.tag = 302;
            }else{
                self.zhifuBtn.hidden = YES;
            }
            self.stateImgView.image = [UIImage imageNamed:@"orderState5"];
        }
            break;
        case 5:
        {// 支付后客户取消
            self.stateLabel1.text = @"商家已接单";
            self.zhifuBtn.hidden = YES;
            self.titleLabel3.hidden = NO;
            self.stateLabel2.text = @"已支付";
            if (orderDetail.refundStatus == 1 || orderDetail.refundStatus == 3) {
                self.stateLabel3.text = @"退款中";
            }
            if (orderDetail.refundStatus == 2) {
                self.stateLabel3.text = @"已处理";
            }
            float w = size.width+self.zhifuBtn.frame.size.width;
            self.labelBtnLeftConstraint.constant = - (w/2);
            self.stateImgView.image = [UIImage imageNamed:@"orderState3"];
        }
            break;
        default:
            break;
    }
}

-(void)timeAction {
    if (self.orderType == 1) {
        _myTime --;
        if (_myTime > 0) {
            [self performSelector:@selector(timeAction) withObject:nil afterDelay:1];
            NSString *time = [self getShengyushijian:_myTime state:2];
            self.orderStateDetLab.text = [NSString stringWithFormat:@"订单将于%@后失效", time];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"timeOut" object:nil];
        }
    }
}
@end
