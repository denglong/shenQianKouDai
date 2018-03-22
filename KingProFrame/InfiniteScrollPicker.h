//
//  InfiniteScrollPicker.h
//  InfiniteScrollPickerExample
//
//  Created by Philip Yu on 6/6/13.
//  Copyright (c) 2013 Philip Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfiniteScrollPicker;

@protocol touchDelegate <NSObject>

- (void)touchHeaderBtnValue:(NSInteger)touchTag;

@end

@interface InfiniteScrollPicker : UIScrollView<UIScrollViewDelegate>
{
    NSMutableArray *imageStore;
    bool snapping;
    float lastSnappingX;
    NSTimer *countDownTimer;
}

@property (nonatomic, strong) NSArray *imageAry;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) float alphaOfobjs;

@property (nonatomic) float heightOffset;
@property (nonatomic) float positionRatio;

@property (nonatomic, retain) id<touchDelegate> touchDelegate;
@property (nonatomic, retain) UIButton *clickbigBtn;
@property (nonatomic, assign) float btnX;
@property (nonatomic, assign) BOOL  firstNew;

- (void)initInfiniteScrollView;
- (void)snapToAnEmotion;
- (void)reloadView:(float)offset;
- (void)stopSuccessed;
- (void)snapToAnEmotionAction:(NSInteger) btnTag;

@end
