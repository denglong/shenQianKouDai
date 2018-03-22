//
//  FullTimeView.h
//  ios2688webshop
//
//  Created by wangchan on 16/2/23.
//  Copyright © 2016年 zhangzl. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
//获取的GMT时间，要想获得某个时区的时间，以下代码可以解决这个问题  详情：http://blog.csdn.net/chan1142131456/article/details/50237343

         NSTimeZone *zone = [NSTimeZone systemTimeZone];
         NSInteger interval = [zone secondsFromGMTForDate: date];
         NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
         NSLog(@"%@",date);
         NSLog(@"%@", localeDate);

 */


@protocol FinishPickView <NSObject>
-(void)didFinishPickView:(NSInteger)row;
@end
@interface FullTimeView : UIView
@property(nonatomic,strong)NSDate*curDate;
@property(nonatomic, strong) NSArray *allTimes;
@property(nonatomic,strong)id<FinishPickView>delegate;
@end
