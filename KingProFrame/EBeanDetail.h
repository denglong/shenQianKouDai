//
//  EBeanDetail.h
//  KingProFrame
//
//  Created by lihualin on 15/8/11.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface EBeanDetail : NSObject

@property(nonatomic,retain) NSString * epeaSum; //当前e豆数量
@property(nonatomic,retain) NSString * epeaUrl; //e豆规则连接
@property(nonatomic,retain) NSArray * detailList;
@property(nonatomic,retain) NSString * shopBtn; //e豆商城按钮名称
@property(nonatomic,retain) NSString * shopUrl; //e豆商城url

@end
