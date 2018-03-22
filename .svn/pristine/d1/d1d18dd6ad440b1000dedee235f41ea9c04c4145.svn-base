//
//  DLStarRageView.m
//  myTest
//
//  Created by denglong on 12/22/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import "DLStarRageView.h"

#define imageW  self.bounds.size.width/10

@interface DLStarRageView ()
{
    float imageW1;
    float imageH;
}
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation DLStarRageView
@synthesize starNum;
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.tag == 10) {
            starNum = 5;
            self.starBackgroundView = [self buidlStarViewWithImageName:@"businessInfo_GradeEmptyStar"];
            self.starForegroundView = [self buidlStarViewWithImageName:@"businessInfo_GradeStar"];
        }
        [self addSubview:self.starBackgroundView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star starNum:(NSInteger)num {
    
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        starNum = num;
        
        self.starBackgroundView = [self buidlStarViewWithImageName:Empty];
        self.starForegroundView = [self buidlStarViewWithImageName:Star];
        [self addSubview:self.starBackgroundView];
        
        self.userInteractionEnabled = YES;
        
        /**点击手势*/
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:tapGR];
        
        /**滑动手势*/
//        
//        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
//        [self addGestureRecognizer:panGR];
        
    }
    return self;
    
}

//- (UIView *)buidlStarViewWithImageName1:(NSString *)imageName
//{
//    CGRect frame = self.bounds;
//    
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.clipsToBounds = YES;
//    
//    
//    for (int j = 0; j < starNum; j ++)
//    {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:];
//        imageView.frame = CGRectMake(2*j*imageW, 0, imageW, imageW);
//        [view addSubview:imageView];
//    }
//    
//    return view;
//}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    
    
    for (int j = 0; j < starNum; j ++)
    {
        UIImage * image = [UIImage imageNamed:imageName];
        imageW1 = image.size.width;
        imageH = image.size.height;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        if (self.tag == 10) {
            imageView.frame = CGRectMake(1.5*j*imageW1, 0, imageW1, imageH);
        }else{
            imageView.frame = CGRectMake(2*j*imageW, 0, imageW, imageW);
        }
       
        [view addSubview:imageView];
    }
    
    return view;
}

-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    CGPoint point =[tapGR locationInView:self];
    if (point.x<0) {
        point.x = 0;
    }
    
    int X = (int) point.x/(2*imageW);
    if (self.tag == 10) {
        X = (int) point.x/(1.5*imageW1);
        self.starForegroundView.frame = CGRectMake(0, 0, (X+1)*1.5*imageW1, imageH);
    }else{
        
        self.starForegroundView.frame = CGRectMake(0, 0, (X+1)*2*imageW, imageW);
    }
    [self addSubview:self.starForegroundView];
    [self.delegate starRateViewChooseAction:X+1 starView:self];
}

- (void)showStarRageAction:(NSInteger)starNumber {
    self.userInteractionEnabled = NO;
    if (self.tag == 10) {
        self.starForegroundView.frame = CGRectMake(0, 0, starNumber*1.5*imageW1, imageH);
    }else{
        if(self.tag == 20){
            starNum = starNumber;
            self.starForegroundView = [self buidlStarViewWithImageName:@"Star"];
        }
        self.starForegroundView.frame = CGRectMake(0, 0, starNumber*2*imageW, imageW);
    }
    [self addSubview:self.starForegroundView];
}

@end
