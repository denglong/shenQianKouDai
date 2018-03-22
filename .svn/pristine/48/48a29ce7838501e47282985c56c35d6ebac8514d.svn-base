//
//  WLZ_ShoppingCarCell.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ShoppingCarCell.h"
#import "UIImageView+WebCache.h"
#import "WLZ_ShoppingCarController.h"
#import "UIColor+WLZ_HexRGB.h"
#import "Headers.h"
static CGFloat CELL_HEIGHT = 80;


@interface WLZ_ShoppingCarCell () <UITextFieldDelegate>


@property(nonatomic,strong)UIButton *selectBt;
@property(nonatomic,strong)UIImageView *shoppingImgView;
@property(nonatomic,strong)UIImageView *spuImgView;
@property(nonatomic,strong)UILabel *title ;
@property(nonatomic,strong)WLZ_ChangeCountView *changeView;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *sizeLab;

@property(nonatomic,assign)CGRect tableVieFrame;


@property(nonatomic,strong)UILabel *soldoutLab;

@end

@implementation WLZ_ShoppingCarCell


- (void)prepareForReuse
{
    [super prepareForReuse];
    _soldoutLab.hidden=YES;
    [_shoppingImgView setImageWithURL:nil];
    [_changeView removeFromSuperview];
    _spuImgView.image = nil;
    _changeView = nil;
    _sizeLab.text = nil;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _tableView = tableView;
        [self initCellView];
    }
    return self;
}
- (void)initCellView
{
    
    
    UIImage *btimg = [UIImage imageNamed:@"ic_cb_normal.png"];
    UIImage *selectImg = [UIImage imageNamed:@"ic_cb_checked"];
    
    _selectBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btimg.size.width+20, CELL_HEIGHT)];
    [_selectBt addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_selectBt setImage:btimg forState:UIControlStateNormal];
    [_selectBt setImage:selectImg forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBt];
    
    
    
    _shoppingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_selectBt.frame), 5, 70, 70)];
    [self.contentView addSubview:_shoppingImgView];
    
    _spuImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_shoppingImgView addSubview:_spuImgView];
    
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shoppingImgView.frame)+10, 15, APPScreenWidth-CGRectGetMaxX(_shoppingImgView.frame)-15, 21)];
    _title.font=[UIFont systemFontOfSize:15];
    _title.textColor=[UIColor colorFromHexRGB:@"666666"];
    
    [self.contentView addSubview:_title];
    
    
    _sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_title.frame), 200, 0)];
    _sizeLab.font=[UIFont systemFontOfSize:12];
    _sizeLab.textColor=[UIColor colorFromHexRGB:@"666666"];
    [self.contentView addSubview:_sizeLab];

    _soldoutLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 53, 70, 17)];
    _soldoutLab.hidden =YES;
    _soldoutLab.text=@"无货";
    _soldoutLab.textAlignment = NSTextAlignmentCenter;
    _soldoutLab.font =  [UIFont systemFontOfSize:14];
    _soldoutLab.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    _soldoutLab.textColor=[UIColor colorFromHexRGB:@"999999"];
    [_shoppingImgView addSubview:_soldoutLab];
    
    
    _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_sizeLab.frame)+5+5, 100, 17)];
    _priceLab.textAlignment=NSTextAlignmentLeft;
    _priceLab.textColor=[UIColor colorFromHexRGB:@"666666"];
    _priceLab.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLab];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _changeView.numberFD = textField;
    if ([self isPureInt:_changeView.numberFD.text]) {
        if ([_changeView.numberFD.text integerValue]<0) {
            _changeView.numberFD.text=@"1";
        }
        
    }
    else
    {
        _changeView.numberFD.text=@"1";
    }
    
    
    if ([_changeView.numberFD.text isEqualToString:@""] || [_changeView.numberFD.text isEqualToString:@"0"]) {
        self.choosedCount = 1;
        _changeView.numberFD.text=@"1";
        
    }
    NSString *numText = _changeView.numberFD.text;
    if ([numText intValue]>[_model.item_info.stock_quantity  intValue]) {
        _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",[_model.item_info.stock_quantity  intValue]];
        
        
    }
    
    if ([numText intValue] >99) {
      //  [SVProgressHUD showErrorWithStatus:@"最多支持购买99个"];
        _changeView.numberFD.text = @"99";
    }
    
    _changeView.addButton.enabled=YES;
    _changeView.subButton.enabled=YES;
    self.choosedCount = [_changeView.numberFD.text integerValue];
    _model.count = _changeView.numberFD.text;
    _model.isSelect = _selectBt.selected;
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}




- (void)setModel:(WLZ_ShoppIngCarModel *)model
{
    _model = model;
    _selectBt.selected=model.isSelect;
    if (_changeView.numberFD.text) {
        self.choosedCount = [_changeView.numberFD.text integerValue];
    }
    else{
        self.choosedCount =[model.count integerValue] ;
    }
    
    
//    _shoppingImgView.layer.cornerRadius = 2;
//    _shoppingImgView.layer.borderWidth = 1;
//    _shoppingImgView.layer.borderColor = [UIColor colorFromHexRGB:@"e2e2e2"].CGColor;
    [_shoppingImgView setImageWithURL:[NSURL URLWithString:model.item_info.icon] placeholderImage:[UIImage imageNamed:@"default"]];

    if ([model.item_info.is_spu intValue] == 1) {
        UIImage *img = [UIImage imageNamed:@"spuIcon"];
        _spuImgView.image = img;
      //  _spuImgView.size = img.size;
        _priceLab.text=[NSString stringWithFormat:@"套装价￥%@",model.item_info.sale_price];
    } else {
        
        UIImage *level = [UIImage imageNamed:@"level2"];
        if (model.item_info.type == 5) {
            _spuImgView.image = [UIImage imageNamed:@"level3"];
         //   _spuImgView.size = level.size;
        } else if (model.item_info.type == 6) {
          //  _spuImgView.size = level.size;
            _spuImgView.image = level;
        }
        
        
        
        if (![model.item_size isEqualToString:@"SINGLE"]) {
            _sizeLab.text = [NSString stringWithFormat:@"规格:%@",model.item_size];
        }
        
        _priceLab.text=[NSString stringWithFormat:@"￥%@",model.item_info.sale_price];
    }
    
    
    _title.text= model.item_info.full_name;
    
    
    if ([model.item_info.sale_state isEqualToString:@"3"]) {
        _soldoutLab.hidden=NO;
        _selectBt.enabled=NO;

        if (self.isEdit) {
            //编辑状态
            _selectBt.enabled=YES;
        }
    }
    else{
        _selectBt.enabled=YES;
        _changeView = [[WLZ_ChangeCountView alloc] initWithFrame:CGRectMake(viewWidth - 120, CGRectGetMaxY(_sizeLab.frame)+5, 160, 35) chooseCount:self.choosedCount totalCount: [model.item_info.stock_quantity integerValue]];
        
        [_changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _changeView.numberFD.delegate = self;
        
        [_changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_changeView];
    }
    
}
//加
- (void)addButtonPressed:(id)sender
{
    
    if (self.choosedCount<99) {
        [self addCar];
    }
    
    ++self.choosedCount ;
    if (self.choosedCount>0) {
        _changeView.subButton.enabled=YES;
    }
    
    
    if ([_model.item_info.stock_quantity integerValue]<self.choosedCount) {
        self.choosedCount  = [_model.item_info.stock_quantity  intValue];
        _changeView.addButton.enabled = NO;
    }
    else
    {
        _changeView.subButton.enabled = YES;
    }
    
    if(self.choosedCount>=99)
    {
        self.choosedCount  = 99;
        _changeView.addButton.enabled = NO;
    }
    
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    _model.count = _changeView.numberFD.text;
    
    _model.isSelect=_selectBt.selected;
    
    
    
    
    
}

-(void)addCar
{
   
}


-(void)clickSelect:(UIButton *)bt
{
    
    
    //  _selectBt.selected = !_selectBt.selected;
    if (!_soldoutLab.hidden && !self.isEdit) {
        return;
    }
    _selectBt.selected = !_selectBt.selected;
    _model.isSelect = _selectBt.selected;
    
    if (_changeView.numberFD.text!=nil) {
        _model.count = _changeView.numberFD.text;
    }
    
    [self.delegate singleClick:_model row:self.row];
}

//减
- (void)subButtonPressed:(id)sender
{
    
    if (self.choosedCount >1) {
        [self deleteCar];
    }
    
   -- self.choosedCount ;
    
    if (self.choosedCount==0) {
        self.choosedCount= 1;
        _changeView.subButton.enabled=NO;
    }
    else
    {
        _changeView.addButton.enabled=YES;
        
    }
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    _model.count = _changeView.numberFD.text;
    
    _model.isSelect=_selectBt.selected;
    
    
    
}


-(void)deleteCar
{

    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+(CGFloat)getHeight
{
    return CELL_HEIGHT;
}

@end
