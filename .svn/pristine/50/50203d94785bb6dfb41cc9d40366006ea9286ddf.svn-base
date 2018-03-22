//
//  RequestModel.m
//  Model_test
//
//  Created by denglong on 14-11-19.
//  Copyright (c) 2014年 denglong. All rights reserved.
//

#import "RequestModel.h"
#import <objc/runtime.h>

@implementation RequestModel

//初始化单例
+ (RequestModel *)sharedInstance
{
    static RequestModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//用来遍历子类中个属性，返回字典
//传入类名：inClass
+(NSDictionary *)class:(NSString *)inClass
{
    Class class = NSClassFromString(inClass);
    id myClass = [class sharedInstance];
    
    //取一个类中的方法名
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList(class, &count);
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < count; i ++)
    {
        objc_property_t property = propertys[i];
        //取出方法的属性名
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        //将属性名首字母大写
        NSString *b =[key substringToIndex:1].uppercaseString;
        
        NSString *getString =[[NSString alloc]initWithFormat:@"get%@%@",b,[key substringFromIndex:1]];

        SEL getS = NSSelectorFromString(getString);
        
        NSString *value = [myClass performSelector:getS];
        //判断取出后是否有值，如果没有执行
        if (!value) {
            value = @"";
        }
        //将取出的值封装成字典
        NSDictionary *dic = @{key:value};
        [infoDic addEntriesFromDictionary:dic];
    }
    return infoDic;
}

+(NSArray *)createdArrayWithClass:(NSString *)inClass
{
    Class class = NSClassFromString(inClass);
    id myClass = [class sharedInstance];
    
    //取一个类中的方法名
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList(class, &count);
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i ++)
    {
        objc_property_t property = propertys[i];
        
        //取出方法的属性名
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        //将属性名首字母大写
        NSString *b =[key substringToIndex:1].uppercaseString;
        
        NSString *getString =[[NSString alloc]initWithFormat:@"get%@%@",b,[key substringFromIndex:1]];
        
        SEL getS = NSSelectorFromString(getString);
        
        NSString *value = [myClass performSelector:getS];
        //判断取出后是否有值，如果没有执行
        if (value) {
            //将取出的值封装成字典
            NSDictionary *dic = @{@"type":key,@"value":value};
            [infoArray addObject:dic];
        }
    }
    return infoArray;

}
+(void)clearModel:(NSString *)inClass
{
    Class class = NSClassFromString(inClass);
    id myClass = [class sharedInstance];
    //取一个类中的方法名
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList(class, &count);
    for (int i = 0; i < count; i ++)
    {
        objc_property_t property = propertys[i];
        //取出方法的属性名
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        //将属性名首字母大写
        NSString *b =[key substringToIndex:1].uppercaseString;
        
        NSString *setString =[[NSString alloc]initWithFormat:@"set%@%@:",b,[key substringFromIndex:1]];
        
        SEL setS=NSSelectorFromString(setString);
        
        if ([myClass respondsToSelector:setS])
        {
            //如果是set方法就写入数据
            [myClass performSelector:setS withObject:nil];
        }
    }

}
@end
