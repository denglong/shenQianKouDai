//
//  CategoryModel.m
//  KingProFrame
//
//  Created by JinLiang on 15/9/9.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CategoryModel.h"
#import "SRMessage.h"

@implementation CategoryModel
@synthesize goodsDataArray;
@synthesize advDataArray;

+(id)shareModel{
    
    static id shareModel;
    @synchronized(self){
        if (!shareModel) {
            shareModel=[[self alloc] init];
        }
        return shareModel;
    }
}

/**
 * Method name: updateCategoryGoods
 * Description: 更新分类广告和广告数据
 */
-(void)updateCategoryGoods:(NSDictionary *)goodsDataInfo page:(int)page{
    
    if (page==1) {//刷新数据
        //广告赋值
        if ([DataCheck isValidArray:[goodsDataInfo objectForKey:@"advList"]]){
            
            self.goodsDataArray=[goodsDataInfo objectForKey:@"goodsList"];
            
            NSMutableArray *totalList=[[goodsDataInfo objectForKey:@"advList"] mutableCopy];
            [totalList addObjectsFromArray:self.goodsDataArray];
            self.goodsDataArray=totalList;
        }
        else {
            self.goodsDataArray=[goodsDataInfo objectForKey:@"goodsList"];
        }
    }
    else{//加载更多
    
        if ([[goodsDataInfo objectForKey:@"goodsList"] count] == 0) {
            
            [SRMessage infoMessage:@"没有更多了" delegate:[UIApplication sharedApplication].keyWindow.rootViewController];
            return;
        }
        NSMutableArray *oldList = [self.goodsDataArray mutableCopy];
        [oldList addObjectsFromArray:[goodsDataInfo objectForKey:@"goodsList"]];
        self.goodsDataArray = oldList;
    }

}

@end
