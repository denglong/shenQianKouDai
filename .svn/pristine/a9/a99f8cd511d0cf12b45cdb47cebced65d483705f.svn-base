//
//  CYActivityView.m
//  1.网易彩票基本骨架搭建
//
//  Created by lucifer on 15/10/4.
//  Copyright (c) 2015年 lucifer. All rights reserved.
//

#import "CYActivityView.h"
#import "Headers.h"

@interface CYActivityView ()

@property (strong,nonatomic) closeBlock block;

@property (weak, nonatomic) IBOutlet UIImageView *ADImageView;


@end

@implementation CYActivityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.width = [UIScreen mainScreen].bounds.size.width;
    self.height = [UIScreen mainScreen].bounds.size.height - 64 ;
    
    self.ADImageView.layer.masksToBounds = YES;
    self.ADImageView.layer.cornerRadius = 5;
    
    self.ADImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    [self.ADImageView addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonClicked)];
    [self addGestureRecognizer:viewTap];
}


- (IBAction)closeButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(buttonClickedCloseActivity:)])
    {
        [self.delegate buttonClickedCloseActivity:self];
    }
    
      if (self.block) {
        self.block();
    }
    
//    self.block();
    
}

+ (instancetype)shoeInPoint:(CGPoint)point
{
    CYActivityView *view = [CYActivityView viewFromXib];
    
    view.center =  CGPointMake(point.x, point.y - 32);

    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    return view;
}

- (void)hideInPoint:(CGPoint)point completion:(void (^)())completion
{
    [UIView animateWithDuration:0.35 animations:^{
        self.center = point;
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        if (completion)
        {
            completion();
        }
    }];
}

- (void)closeBlock:(closeBlock)block
{
    self.block = block;
}

- (void)imageViewTapped
{
    if ([self.delegate respondsToSelector:@selector(pushToDestionViewController)])
    {
//        [self hideInPoint:CGPointMake(([UIScreen mainScreen].bounds.size.width - 30), 40) completion:^{
//        self.hidden = YES;
        [self removeFromSuperview];
        
        [self.delegate pushToDestionViewController];

//        }];
        
    }
}

- (void)setADImageUrl:(NSString *)ADImageUrl
{
    _ADImageUrl = ADImageUrl;
    
    [self.ADImageView setImageWithURL:[NSURL URLWithString:ADImageUrl] placeholderImage:[UIImage imageNamed:@"ADDefault"]];

}

@end
