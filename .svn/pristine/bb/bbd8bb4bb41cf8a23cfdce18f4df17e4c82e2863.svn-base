//
//  CommClass.h
//  KingProFrame
//
//  Created by JinLiang on 15/8/5.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "Headers.h"

@interface CommClass : NSObject

@property (nonatomic, retain) NSMutableDictionary *data;


//单例对外方法
+ (CommClass *)sharedCommon;
//MD5加密
+(NSString *)md5:(NSString *)str;
//获取当前时间戳
+(NSString *)getCurrentTimeStamp;
//获取当前系统时间 add by jinliang
+(NSString *)getCurrentTime;


//内存数据的存取
- (void)setObject:(id)aObject forKey:(id)aKey;
- (id)objectForKey:(id)aKey;
-(void)removeObjectForKey:(id)aKey;
//本地数据的存取
- (void)localObject:(id)aObject forKey:(id)aKey;
- (id)localObjectForKey:(id)aKey;

//判断安装包是否首次安装运行
+ (BOOL) isFirstRun;

//获取手机的型号 实际获取到得时iPhone7,1 需要比对获取手机型号 例如：iPhone5，iPhone5s
+ (NSString *) getPhonePlatform;
//根据字数和字体的大小获取这一行字的size
+(CGSize)getSuitSizeWithString:(NSString *)text font:(float)fontSize bold:(BOOL)bold sizeOfX:(float)x;
//CST格式的时间字符串转换成时间
+(NSDate*)formatCSTTime:(NSString*)standardTime;
//时间转换成时间字符串 timeFormat是要转换成的时间格式
+(NSString*)formatCSTTimeStamp:(NSDate *)timeDate timeFormat:(NSString *)timeFormat;
//时间戳转换成时间 timeFormat是要转换成的时间格式
+(NSString*)formatIntiTimeStamp:(NSString *)timeStamp timeFormat:(NSString *)timeFormat;
+(NSDictionary*)formatSpecialArray:(NSArray*)specialArray;
//时间戳转换成时分，那年那月那日
+(NSString *)formatYMDOrToday:(NSString *)timeStamp;
@end
