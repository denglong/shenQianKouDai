//
//  InfiniteScrollPicker.m
//  InfiniteScrollPickerExample
//
//  Created by Philip Yu on 6/6/13.
//  Copyright (c) 2013 Philip Yu. All rights reserved.
//

#import "InfiniteScrollPicker.h"
#import "UIView+viewController.h"
#import "UIColor+HEX.h"

@implementation InfiniteScrollPicker

@synthesize imageAry = _imageAry;
@synthesize itemSize = _itemSize;
@synthesize alphaOfobjs;
@synthesize heightOffset;
@synthesize positionRatio;
@synthesize clickbigBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        alphaOfobjs = 1.0;
        heightOffset = 0.0;
        positionRatio = 1.0;
        
        _imageAry = [[NSMutableArray alloc] init];
        imageStore = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initInfiniteScrollView
{
    if (_itemSize.width == 0 && _itemSize.height == 0) {
//        if (_imageAry.count > 0) _itemSize = [(UIImage *)[_imageAry objectAtIndex:0] size];
//        else _itemSize = CGSizeMake(self.frame.size.height/2, self.frame.size.height/2);
        _itemSize = CGSizeMake(self.frame.size.height/2, self.frame.size.height/2);
    }
    
    NSAssert((_itemSize.height < self.frame.size.height), @"item's height must not bigger than scrollpicker's height");

    self.pagingEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    if (_imageAry.count > 0)
    {
        // Init 5 set of images, 3 for user selection, 2 for
        for (int i = 0; i < (_imageAry.count*5); i++)
        {
            NSDictionary *myDic = _imageAry[i % _imageAry.count];
            
            // Place images into the bottom of view
            UIButton *temp = [[UIButton alloc] initWithFrame:CGRectMake(i * _itemSize.width, self.frame.size.height - _itemSize.height, _itemSize.width, _itemSize.height)];
            
            temp.backgroundColor = [UIColor_HEX colorWithHexString:[myDic objectForKey:@"bgColor"]];

            NSString *myName = [myDic objectForKey:@"name"];
            if (myName.length > 4) {
                myName = [myName substringToIndex:4];
            }
            [temp setTitle:myName forState:UIControlStateNormal];
            temp.titleLabel.font = [UIFont systemFontOfSize:13];
            [temp setTitleColor:[UIColor_HEX colorWithHexString:[myDic objectForKey:@"fColor"]] forState:UIControlStateNormal];
            temp.tag = i;
            
            [temp addTarget:self action:@selector(tempTouchAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [imageStore addObject:temp];
            [self addSubview:temp];
        }
        
        self.contentSize = CGSizeMake(_imageAry.count * 5 * _itemSize.width, self.frame.size.height);
        
        float viewMiddle = _itemSize.width * _imageAry.count * 2;
        [self setContentOffset:CGPointMake(viewMiddle, 0)];
        
        self.delegate = self;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^ {
            [self reloadView:viewMiddle-10];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self snapToAnEmotion];
            });
        });
    }
}

- (void)tempTouchAction:(UIButton *)sender {
    clickbigBtn = sender;
    [self.touchDelegate touchHeaderBtnValue:sender.tag ];
    [self snapToAnEmotion];
    clickbigBtn = nil;
}

- (void)setImageAry:(NSArray *)imageAry
{
    _imageAry = imageAry;
    [self initInfiniteScrollView];
}

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    [self initInfiniteScrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.contentOffset.x > 0)
    {
        float sectionSize = _imageAry.count * _itemSize.width;
        
        if (self.contentOffset.x <= (sectionSize - sectionSize/2))
        {
            self.contentOffset = CGPointMake(sectionSize * 2 - sectionSize/2, 0);
        } else if (self.contentOffset.x >= (sectionSize * 3 + sectionSize/2)) {
            self.contentOffset = CGPointMake(sectionSize * 2 + sectionSize/2, 0);
        }

        [self reloadView:self.contentOffset.x];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == 0 && !snapping) [self snapToAnEmotion];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!snapping) [self snapToAnEmotion];
}

- (void)reloadView:(float)offset
{
    float biggestSize = 0;
    id biggestView;

    for (int i = 0; i < imageStore.count; i++) {
        
        UIButton *view = [imageStore objectAtIndex:i];
        
        if (view.center.x > (offset - _itemSize.width ) && view.center.x < (offset + self.frame.size.width + _itemSize.width))
        {
            float tOffset = (view.center.x - offset) - self.frame.size.width/4;
            
            if (tOffset < 0 || tOffset > self.frame.size.width) tOffset = 0;
            float addHeight = (-1 * fabsf((tOffset)*2 - self.frame.size.width/2) + self.frame.size.width/2)/4;
            
            if (addHeight < 0) addHeight = 0;
            
            view.frame = CGRectMake(view.frame.origin.x,
                                    self.frame.size.height - _itemSize.height - heightOffset - (addHeight/positionRatio),
                                    _itemSize.width + addHeight,
                                    _itemSize.height + addHeight);

            if (((view.frame.origin.x + view.frame.size.width) - view.frame.origin.x) > biggestSize)
            {
                biggestSize = ((view.frame.origin.x + view.frame.size.width) - view.frame.origin.x);
                
                if (view.tag%_imageAry.count == 0 && view.tag > _imageAry.count) {
                    biggestView = view;
                }
                else
                {
                   biggestView = view;
                }
            }
            
        } else {
//            view.frame = CGRectMake(view.frame.origin.x, self.frame.size.height, _itemSize.width, _itemSize.height);
//            for (UIButton *imageView in view.subviews)
//            {
//                imageView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//            }
        }
    }
    
    for (int i = 0; i < imageStore.count; i++)
    {
        UIButton *cBlock = [imageStore objectAtIndex:i];
        cBlock.alpha = alphaOfobjs;

        if (i > 0)
        {
            UIButton *pBlock = [imageStore objectAtIndex:i-1];
            cBlock.frame = CGRectMake(pBlock.frame.origin.x + pBlock.frame.size.width + 10, cBlock.frame.origin.y, cBlock.frame.size.width, cBlock.frame.size.height);
        }
        
        cBlock.layer.cornerRadius = cBlock.frame.size.height/2;
    }

    [(UIButton *)biggestView setAlpha:1.0];
    
    //修改中间大图标大小
    UIButton *bigBtn = (UIButton *)biggestView;
    
    bigBtn.frame = CGRectMake(bigBtn.frame.origin.x + 10, bigBtn.frame.origin.y + 10, bigBtn.frame.size.width - 20, bigBtn.frame.size.height - 20);
    bigBtn.layer.cornerRadius = bigBtn.frame.size.height/2;
}

- (void)snapToAnEmotion
{
    float biggestSize = 0;
    UIButton *biggestView;
    
    snapping = YES;
    
    float offset = self.contentOffset.x;
    UIButton *oldBigBtn = nil;
    
    for (int i = 0; i < imageStore.count; i++) {
        UIButton *view = [imageStore objectAtIndex:i];
    
        if (view.center.x > offset && view.center.x < (offset + self.frame.size.width))
        {
            if (((view.center.x + view.frame.size.width) - view.center.x) > biggestSize)
            {
                biggestSize = ((view.frame.origin.x + view.frame.size.width) - view.frame.origin.x);
                oldBigBtn = view;
                if (clickbigBtn) {
                    biggestView = clickbigBtn;
                }
                else
                {
                    if (self.firstNew == YES) {
                        if (view.tag%_imageAry.count == 0 && view.tag > _imageAry.count) {
                            biggestView = view;
                        }
                    }
                    else
                    {
                        biggestView = view;
                    }
                }
            }
        }
    }
    
    float biggestViewX = biggestView.frame.origin.x + biggestView.frame.size.width/2 - self.frame.size.width/2;
    
    if (fabs(clickbigBtn.frame.origin.x - oldBigBtn.frame.origin.x) <= 20 + oldBigBtn.frame.size.width) {
        
    }
    else
    {
        if (clickbigBtn) {
            if (clickbigBtn.frame.origin.x < oldBigBtn.frame.origin.x + biggestView.frame.size.width){
                biggestViewX = biggestView.frame.origin.x - self.frame.size.width/2;
                
            }
            else if ( clickbigBtn.frame.origin.x >  oldBigBtn.frame.origin.x + biggestView.frame.size.width) {
                biggestViewX = biggestView.frame.origin.x + biggestView.frame.size.width - self.frame.size.width/2;
            }
        }
    }
    
    float dX = self.contentOffset.x - biggestViewX;
    float newX = self.contentOffset.x - dX/1.4;

    // Disable scrolling when snapping to new location
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^ {
        [self setScrollEnabled:NO];
        [self setUserInteractionEnabled:NO];
        [self scrollRectToVisible:CGRectMake(newX, 0, self.frame.size.width, 1) animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            SEL selector = @selector(infiniteScrollPicker:didSelectAtView:);
            if ([[self firstAvailableUIViewController] respondsToSelector:selector])
            {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [[self firstAvailableUIViewController] performSelector:selector withObject:self withObject:biggestView];
                #pragma clang diagnostic pop
            }
            [self setScrollEnabled:YES];
            snapping = 0;
        });
        DLog(@"%f", self.contentOffset.x);
    });
}

- (void)snapToAnEmotionAction:(NSInteger) btnTag
{
    float biggestSize = 0;
    UIButton *biggestView;
    
    snapping = YES;
    
    float offset = self.contentOffset.x;
    UIButton *oldBigBtn = nil;
    
    for (int i = 0; i < imageStore.count; i++) {
        UIButton *view = [imageStore objectAtIndex:i];
        
        if (view.center.x > offset && view.center.x < (offset + self.frame.size.width))
        {
            if (((view.center.x + view.frame.size.width) - view.center.x) > biggestSize)
            {
                biggestSize = ((view.frame.origin.x + view.frame.size.width) - view.frame.origin.x);
                oldBigBtn = view;

                biggestView = [imageStore objectAtIndex:btnTag];
            }
        }
    }
    
    float biggestViewX = biggestView.frame.origin.x + biggestView.frame.size.width/2 - self.frame.size.width/2;
    
    if (fabs(clickbigBtn.frame.origin.x - oldBigBtn.frame.origin.x) <= 20 + oldBigBtn.frame.size.width) {
        
    }
    else
    {
        if (clickbigBtn) {
            if (clickbigBtn.frame.origin.x < oldBigBtn.frame.origin.x + biggestView.frame.size.width){
                biggestViewX = biggestView.frame.origin.x - self.frame.size.width/2;
                
            }
            else if ( clickbigBtn.frame.origin.x >  oldBigBtn.frame.origin.x + biggestView.frame.size.width) {
                biggestViewX = biggestView.frame.origin.x + biggestView.frame.size.width - self.frame.size.width/2;
            }
        }
    }
    
    float dX = self.contentOffset.x - biggestViewX;
    float newX = self.contentOffset.x - dX/1.4;
    
    // Disable scrolling when snapping to new location
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^ {
        [self setScrollEnabled:NO];
        [self setUserInteractionEnabled:NO];
        [self scrollRectToVisible:CGRectMake(newX, 0, self.frame.size.width, 1) animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            SEL selector = @selector(infiniteScrollPicker:didSelectAtView:);
            if ([[self firstAvailableUIViewController] respondsToSelector:selector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [[self firstAvailableUIViewController] performSelector:selector withObject:self withObject:biggestView];
#pragma clang diagnostic pop
            }
            [self setScrollEnabled:YES];
            snapping = 0;
        });
        DLog(@"%f", self.contentOffset.x);
    });
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.firstNew = NO;
}

@end
