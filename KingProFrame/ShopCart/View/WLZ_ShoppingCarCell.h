//
//  WLZ_ShoppingCarCell.h
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLZ_ShoppIngCarModel.h"
#import "WLZ_ChangeCountView.h"

@protocol WLZ_ShoppingCarCellDelegate ;

@interface WLZ_ShoppingCarCell : UITableViewCell


@property(nonatomic,strong)WLZ_ShoppIngCarModel *model;
@property(nonatomic,assign)NSInteger choosedCount;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,weak)id<WLZ_ShoppingCarCellDelegate> delegate;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView;

+(CGFloat)getHeight;
@end


@protocol WLZ_ShoppingCarCellDelegate <NSObject>

-(void)singleClick:(WLZ_ShoppIngCarModel *)models row:(NSInteger )row;

@end