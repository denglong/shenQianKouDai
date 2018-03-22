//
//  WLZ_ShopViewModel.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ShopViewModel.h"
#import "WLZ_ShoppIngCarModel.h"
#import "MJExtension.h"
@implementation WLZ_ShopViewModel

//


- (void)getNumPrices:(void (^)()) priceBlock
{
    _priceBlock = priceBlock;
}


- (void)getShopData:(void (^)(NSArray * commonArry, NSArray * kuajingArry))shopDataBlock  priceBlock:(void (^)()) priceBlock
{
    //访问网络 获取数据 block回调失败或者成功 都可以在这处理
    
    //本demo 直接读 本地数据了
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSMutableDictionary *strategyDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    
    NSArray *commonList = [strategyDic objectForKey:@"common"];
    
    NSArray *kuajingList = [strategyDic objectForKey:@"kuajing"];
    
    NSMutableArray *commonMuList = [NSMutableArray array];
    
    NSMutableArray *kuajingMuList = [NSMutableArray array];
    
    
    for (int i = 0; i<commonList.count; i++) {
        WLZ_ShoppIngCarModel *model = [WLZ_ShoppIngCarModel mj_objectWithKeyValues:[commonList objectAtIndex:i]];
        model.vm =self;
        model.type=1;
        model.isSelect=YES;
        [commonMuList addObject:model];
        
    }
    for (int i = 0; i<kuajingList.count; i++) {
        WLZ_ShoppIngCarModel *model = [WLZ_ShoppIngCarModel mj_objectWithKeyValues:[kuajingList objectAtIndex:i]];
        model.vm =self;
        model.type=2;
        model.isSelect=YES;
        [kuajingMuList addObject:model];
    }
    if (commonMuList.count>0) {
        
        [commonMuList addObject:[self verificationSelect:commonMuList type:@"1"]];
        
    }
    if (kuajingMuList.count>0) {
        
        [kuajingMuList addObject:[self verificationSelect:kuajingMuList type:@"2"]];
    }
    _priceBlock = priceBlock;
    shopDataBlock(commonMuList,kuajingMuList);
}
- (NSDictionary *)verificationSelect:(NSMutableArray *)arr type:(NSString *)type
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"YES" forKey:@"checked"];
    [dic setObject:type forKey:@"type"];
    for (int i =0; i<arr.count; i++) {
        WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[arr objectAtIndex:i];
        if (!model.isSelect) {
            [dic setObject:@"NO" forKey:@"checked"];
            break;
        }
    }
    
    return dic;
}


- (void)pitchOn:(NSMutableArray *)carDataArrList
{
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        NSMutableDictionary *dic = [dataList lastObject];
         [dic setObject:@"YES" forKey:@"checked"];
        for (int j=0; j<dataList.count-1; j++) {
            WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[dataList objectAtIndex:j];
            if (model.type==1 ) {
                if (!model.isSelect && ![model.item_info.sale_state isEqualToString:@"3"]) {
                    [dic setObject:@"NO" forKey:@"checked"];
                    break;
                }
                
            }
            else if(model.type==2 )
            {
            
                if (!model.isSelect &&![model.item_info.sale_state isEqualToString:@"3"]) {
                    [dic setObject:@"NO" forKey:@"checked"];
                    break;
                }
            }
        }
    }
}


-(void)clickAllBT:(NSMutableArray *)carDataArrList bt:(UIButton *)bt
{
    
    
    
    bt.selected = !bt.selected;
    
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        NSMutableDictionary *dic = [dataList lastObject];
        for (int j=0; j<dataList.count-1; j++) {
            WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[dataList objectAtIndex:j];
            if (model.type==1 && bt.tag==100) {
                if (bt.selected) {
                    [dic setObject:@"YES" forKey:@"checked"];
                }
                else
                {
                    [dic setObject:@"NO" forKey:@"checked"];
                }
                if ([model.item_info.sale_state isEqualToString:@"3"]) {
                    continue;
                }
                else{
                    model.isSelect=bt.selected;
                }
                
            }
            else if(model.type==2 &&bt.tag==101)
            {
                if (bt.selected) {
                    [dic setObject:@"YES" forKey:@"checked"];
                }
                else
                {
                    [dic setObject:@"NO" forKey:@"checked"];
                }
                if ([model.item_info.sale_state isEqualToString:@"3"]) {
                    continue;
                }
                else{
                    model.isSelect=bt.selected;
                }
            }
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"开始计算价钱");
    if ([keyPath isEqualToString:@"isSelect"]) {
        if (_priceBlock!=nil) {
             _priceBlock();
        }
       
    }
}



@end
