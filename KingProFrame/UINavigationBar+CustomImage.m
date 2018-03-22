//
//  UINavigationBar+CustomImage.m
//  SixFeetLanePro
//
//  Created by JinLiang on 14/11/13.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import "UINavigationBar+CustomImage.h"
#import "Headers.h"

@implementation UINavigationBar (CustomImage)

-(UIImage *)barBackground{
    
    return [[UIImage imageNamed:@"navigationBgImg"] stretchableImageWithLeftCapWidth:5 topCapHeight:32];
}

-(void)drawRect:(CGRect)rect{
    [[self barBackground]drawInRect:rect];
}

-(void)didMoveToSuperview{

    if([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
    }
}
@end
