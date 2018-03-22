//
//  GetFilePath.m
//  image
//
//  Created by lihualin on 14-11-27.
//  Copyright (c) 2014年 lihualin. All rights reserved.
//

#import "GetFilePath.h"

@implementation GetFilePath

//获取沙盒路径
//参数：无
//返回：路径
+(NSString *)getFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory=[paths objectAtIndex:0];
    return documentsDirectory;
}

@end
