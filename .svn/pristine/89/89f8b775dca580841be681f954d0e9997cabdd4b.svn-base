//
//  CommClass.m
//  KingProFrame
//
//  Created by JinLiang on 15/8/5.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CommClass.h"
#import <sys/sysctl.h>

static NSMutableDictionary  *commonDict;

@implementation CommClass

@synthesize data = _data;

//初始化
- (id)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableDictionary dictionary];
    }
    return self;
}


//单例对外方法
+ (CommClass *)sharedCommon
{
    static CommClass *sharedCommon;
    
    @synchronized(self) {
        if (!sharedCommon) {
            sharedCommon = [[self alloc] init];
        }
        return sharedCommon;
    }
}



//MD5加密
+(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ]lowercaseString];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     DLog("%02X", 0x888);  //888
     DLog("%02X", 0x4); //04
     */
}

//获取当前时间戳
+(NSString *)getCurrentTimeStamp{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    DLog(@"当前的时间戳:%lld", date);
    
    NSString *valTime=[NSString stringWithFormat:@"%lld",date];
    
    return valTime;
}

//获取当前系统时间 add by jinliang
+(NSString *)getCurrentTime{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    DLog(@"locationString:%@",locationString);
    return locationString;
}


#pragma -mark 保存在内存中的方法
//非空赋值
- (void)setObject:(id)aObject forKey:(id)aKey
{
    if (aObject != nil && aKey != nil) {
        [_data setObject:aObject forKey:aKey];
    }
}
//取值
- (id)objectForKey:(id)aKey
{
    return [_data objectForKey:aKey];
}

-(void)removeObjectForKey:(id)aKey
{
    NSArray * keys = [_data allKeys];
    if (keys != nil && keys.count != 0 && [keys containsObject:aKey]) {
        [_data removeObjectForKey:aKey];
    }
}

#pragma -mark 保存在本地

//非空赋值
- (void)localObject:(id)aObject forKey:(id)aKey
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (aObject != nil && aKey != nil) {
        [defaults setObject:aObject forKey:aKey];
    }
    [defaults synchronize];
}
//取值
- (id)localObjectForKey:(id)aKey
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:aKey];
}


//判断安装包是否首次安装运行
+ (BOOL) isFirstRun
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL  hasRunBefore = [defaults boolForKey:@"runIdentifier"];
    if(!hasRunBefore)
    {
        //DLog(@"这是第一次运行");
        [defaults setBool:YES forKey:@"runIdentifier"];
        [defaults synchronize];
        return YES;
    }
    return NO;
}

//获取手机的型号 实际获取到得时iPhone7,1 需要比对获取手机型号 例如：iPhone5，iPhone5s
+ (NSString *) getPhonePlatform
{
    size_t size;
    sysctlbyname("hw.machine",NULL, &size, NULL,0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size,NULL, 0);
    NSString*platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
//根据字数和字体的大小获取这一行字的size
+(CGSize)getSuitSizeWithString:(NSString *)text font:(float)fontSize bold:(BOOL)bold sizeOfX:(float)x
{
    UIFont *font ;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
        
    }else{
        font = [UIFont systemFontOfSize:fontSize];
    }
//
//    CGSize constraint = CGSizeMake(x, MAXFLOAT);
//    NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
////    NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text attributes:attributes] ;
//    // 返回文本绘制所占据的矩形空间。
//    CGRect rect =  [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
////    CGRect rect = [attributedText boundingRectWithSize:constraint
////                                               options:NSStringDrawingUsesLineFragmentOrigin
////                                               context:nil];
//
    CGRect rect;
    if ([[UIScreen mainScreen] bounds].size.width > 320) {
        rect = [text boundingRectWithSize:CGSizeMake(x, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    else
    {
        rect = [text boundingRectWithSize:CGSizeMake(x, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    CGSize contentSize = rect.size;
    return contentSize;
}



//CST格式的时间字符串转换成时间
+(NSDate*)formatCSTTime:(NSString*)standardTime{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss 'CST' yyyy"];
    inputFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    NSDate *timeDate = [inputFormatter dateFromString:standardTime];
    
    return timeDate;
}


//时间戳转换成时间 timeFormat是要转换成的时间格式
+(NSString*)formatCSTTimeStamp:(NSDate *)timeDate timeFormat:(NSString *)timeFormat{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:timeFormat];
    NSString *currentDateStr = [dateFormatter stringFromDate: timeDate];
    
    return currentDateStr;
}


//时间戳转换成时间 timeFormat是要转换成的时间格式
+(NSString*)formatIntiTimeStamp:(NSString *)timeStamp timeFormat:(NSString *)timeFormat{
    
    timeStamp = [[NSString stringWithFormat:@"%@", timeStamp] substringToIndex:10];
    NSTimeInterval time=[timeStamp doubleValue];//因为时差问题要加8小时 == 28800
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //DLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:timeFormat];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}


/**
 * Method name: formatCartInfo
 * Description: 格式化特殊数组为可用字典  type  value
 * Parameter: specialArray
 */
+(NSDictionary*)formatSpecialArray:(NSArray*)specialArray{
    
    NSMutableDictionary *mutableInfo = [NSMutableDictionary dictionary];
    
    NSDictionary *resultsDic=[NSDictionary dictionary];
    
    if (![DataCheck isValidArray:specialArray]) {
        return resultsDic;
    }
    
    NSString *newKey=nil;
    NSString *newValue=nil;
    
    for (int i=0; i<[specialArray count]; i++) {
        
        NSDictionary * cartDic=[specialArray objectAtIndex:i];
        
        for (NSString* key in cartDic) {
            
            NSString*value=[cartDic objectForKey:key];
            
            if ([DataCheck isValidNumber:value]) {
                value=[NSString stringWithFormat:@"%@",value];
            }
            if (![DataCheck isValidString:value] &&![DataCheck isValidArray:value]) {
                value = @"";
            }
            
            if ([key isEqualToString:@"type"]) {
                
                newKey=value;
            }
            else if([key isEqualToString:@"value"]){
                newValue=value;
            }
            
            if (newKey!=nil &&newValue!=nil) {
                
                [mutableInfo setObject:newValue forKey:newKey];
                newValue=nil;
                newKey=nil;
            }
        }
        resultsDic=(NSDictionary*)mutableInfo;
    }
    
    return resultsDic;
}
/**
 * Method name: formatYMDOrToday
 * Description: 当时间为当天则返回时分，若时间为非今天则返回那年那月那日
 * Parameter: 时间戳
 */

+(NSString *)formatYMDOrToday:(NSString *)timeStamp
{
    timeStamp = [[NSString stringWithFormat:@"%@", timeStamp] substringToIndex:10];
    NSTimeInterval time=[timeStamp doubleValue];//因为时差问题要加8小时 == 28800
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *coms =  [calendar components:unitFlags fromDate:detaildate];
  
    NSDateComponents *nowComs =  [calendar components:unitFlags fromDate:[NSDate date]];
    
    if (coms.year == nowComs.year && coms.month == nowComs.month && coms.day == nowComs.day) {
        if (coms.minute < 10) {
            return [NSString stringWithFormat:@"%ld:0%ld",coms.hour,coms.minute];
        }
        return [NSString stringWithFormat:@"%ld:%ld",coms.hour,coms.minute];
    }
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",coms.year,coms.month,coms.day];
    
}

@end
