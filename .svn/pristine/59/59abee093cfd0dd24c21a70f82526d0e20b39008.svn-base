//
//  WLZ_ShoppingCartEndView.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/15.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ShoppingCartEndView.h"

#import "WLZ_ShoppingCarController.h"
#import "UIColor+WLZ_HexRGB.h"
#import "Masonry.h"

@interface WLZ_ShoppingCartEndView ()


@property(nonatomic,strong)UIButton *deleteBt;


@end

static CGFloat VIEW_HEIGHT =50;

@implementation WLZ_ShoppingCartEndView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addObserver:self forKeyPath:@"isEdit" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self initView];
    }
    return self;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"isEdit"]) {
        
        if (self.isEdit) {
            _Lab.hidden=YES;
            _deleteBt.hidden=NO;
            _pushBt.hidden=YES;
        }
        else
        {
            _Lab.hidden=NO;
            _deleteBt.hidden=YES;
            _pushBt.hidden=NO;
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isEdit"];
}

-(void)initView
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 0.5)];
    line.backgroundColor=[UIColor colorFromHexRGB:@"e2e2e2"];
    [self addSubview:line];
    UIImage *btimg = [UIImage imageNamed:@"Unselected.png"];
    UIImage *selectImg = [UIImage imageNamed:@"Selected.png"];
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(5, self.frame.size.height/2-btimg.size.height/2, btimg.size.width+60, btimg.size.height)];
    bt.selected=YES;
    [bt addTarget:self action:@selector(clickAllEnd:) forControlEvents:UIControlEventTouchUpInside];
    [bt setImage:btimg forState:UIControlStateNormal];
    [bt setImage:selectImg forState:UIControlStateSelected];
    
    [bt setTitle:@"全选" forState:UIControlStateNormal];
    bt.titleLabel.font =[UIFont systemFontOfSize:13];
    [bt setTitle:@"取消全选" forState:UIControlStateSelected];
    [bt setTitleColor:[UIColor colorFromHexRGB:@"666666"] forState:UIControlStateNormal];
    
//    [self addSubview:bt];
    
    _Lab =[[UILabel alloc]initWithFrame:CGRectMake(10, 3, 150, self.frame.size.height/2)];
    
    _Lab.textColor=[UIColor colorFromHexRGB:@"666666"];
    _Lab.text=[NSString stringWithFormat:@"合计: ￥ 0"];
    _Lab.font=[UIFont systemFontOfSize:14];
    
    [self addSubview:_Lab];
    
    _vipLab =[[UILabel alloc]initWithFrame:CGRectMake(10, self.frame.size.height/2-3, 150, self.frame.size.height/2)];
    
    _vipLab.textColor=[UIColor colorFromHexRGB:@"666666"];
    _vipLab.text=[NSString stringWithFormat:@"会员共节省0元"];
    _vipLab.font=[UIFont systemFontOfSize:12];
    
    [self addSubview:_vipLab];
    
    _pushBt = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth-130, 0, 130, self.frame.size.height)];
    _pushBt.hidden=NO;
    _pushBt.tag=18;
    [_pushBt setTitle:@"去下单 (共0件)" forState:UIControlStateNormal];
    _pushBt.titleLabel.font=[UIFont systemFontOfSize:14];
    _pushBt.backgroundColor=[UIColor colorFromHexRGB:@"33BDF9"];
    [_pushBt addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    [_pushBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_pushBt];
    
    [_pushBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        make.width.greaterThanOrEqualTo(@(120));
    }];
 
    _deleteBt = [[UIButton alloc]initWithFrame:_pushBt.frame];
    _deleteBt.hidden=YES;
    [_deleteBt setTitleColor:[UIColor colorFromHexRGB:@"fb5d5d"] forState:UIControlStateNormal];
    _deleteBt.tag=19;
    [_deleteBt setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBt.titleLabel.font=[UIFont systemFontOfSize:14];
    _deleteBt.backgroundColor=[UIColor whiteColor];
    [[_deleteBt layer]setCornerRadius:3.0];
    [_deleteBt.layer setBorderWidth:0.5];
    [_deleteBt addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBt.layer.borderColor = [[UIColor colorFromHexRGB:@"fb5d5d"] CGColor];
    
    
    [self addSubview:_deleteBt];
    
}

-(void)clickRightBT:(UIButton *)bt
{
    [self.delegate clickRightBT:bt];
}


-(void)clickAllEnd:(UIButton *)bt
{
    
    
    [self.delegate clickALLEnd:bt];
    
}
- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
}


+ (CGFloat)getViewHeight
{
    return VIEW_HEIGHT;
}
@end
