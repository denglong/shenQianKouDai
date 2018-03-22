//
//  NSString+Extension.m
//  KingProFrame
//
//  Created by 邓龙 on 11/25/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
//返回字符串所占用的尺寸.
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
