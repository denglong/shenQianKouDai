//
//  ResponseModel.m
//  Model_test
//
//  Created by denglong on 14-11-19.
//  Copyright (c) 2014年 denglong. All rights reserved.
//

#import "ResponseModel.h"


@implementation ResponseModel

//初始化单例
+ (ResponseModel *)sharedInstance
{
    static ResponseModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//用来遍历子类中个属性并赋值（传入参数为类名字和需要存入的数据），返回存数据的类对象
//传入类名：inClass
//传入字典：dic
+(id) class:(NSString *)inClass dic:(NSDictionary *)Dic
{
    Class superClass = NSClassFromString(@"ResponseModel");
    Class class = NSClassFromString(inClass);
    
    id myClass;
    if ([class isSubclassOfClass:superClass]) {
        myClass = [class sharedInstance];
    }
    else
    {
        myClass = [[class alloc] init];
    }
    
    //取一个类中的方法名
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList(class, &count);
    for (int i=0; i<count; i++)
    {
        objc_property_t property = propertys[i];
        //取出方法的属性名
        NSString *key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        //将属性名首字母大写
        NSString *b =[key substringToIndex:1].uppercaseString;
        
        NSString *setString =[[NSString alloc]initWithFormat:@"set%@%@:",b,[key substringFromIndex:1]];
        //        NSString *getString =[[NSString alloc]initWithFormat:@"get%@%@",b,[key substringFromIndex:1]];
        
        SEL setS=NSSelectorFromString(setString);
        //        SEL getS=NSSelectorFromString(getString);
        
        if ([myClass respondsToSelector:setS])
        {
            //如果是set方法就写入数据
            [myClass performSelector:setS withObject:[Dic objectForKey:key]];
        }
        //        if ([myClass respondsToSelector:getS])
        //        {
        //            //如果是get方法就取出数据
        //            DLog(@"输出--------->%@",[myClass performSelector:getS]);
        //        }
    }
    return myClass;
}

//用来遍历子类中个属性并赋值（传入参数为类名字和需要存入的数据），返回存数据的类对象
//传入类名：inClass
//传入字典：dic
+(void) setClassEmue:(NSString *)inClass dic:(NSDictionary *)dic
{
    Class class = NSClassFromString(inClass);
    id myClass = [class sharedInstance];
    NSString *key = [dic objectForKey:@"type"];
    NSString *b =[key substringToIndex:1].uppercaseString;
    NSString *setString =[[NSString alloc]initWithFormat:@"set%@%@:",b,[key substringFromIndex:1]];
    
    SEL setS=NSSelectorFromString(setString);
    //        SEL getS=NSSelectorFromString(getString);
    if ([myClass respondsToSelector:setS])
    {
        //如果是set方法就写入数据
        [myClass performSelector:setS withObject:[dic objectForKey:@"value"]];
    }
}

@end
