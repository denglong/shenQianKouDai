//
//  CustomAlertView.m
//  KingProFrame
//
//  Created by JinLiang on 15/8/26.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CustomAlertView.h"
#import "MacroDefinitions.h"
#import "DataCheck.h"
#import "UIColor+HEX.h"
@implementation CustomAlertView
@synthesize middleView;
@synthesize titleBtns;

#define CancelButtonTitle  @"返回"
#define ConfirmButtonTitle @"确认"

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, viewWidth, kViewHeight)];
        [self setMiddleView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[self setMiddleView];
    }
    return self;
}

//初始化自定义alert里面的内容

/**
 * Method name: initWithContent
 * Description: 初始化自定义alert的方法
 * Parameter: contentArray 内容数组
 * Parameter: title 标题
 * Parameter: cancelButtonTitle  取消按钮标题
 * Parameter: confirmButtonTitle 确认按钮标题
 */
-(void)initWithContent:(NSArray *)contentArray
                 title:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
    confirmButtonTitle:(NSString *)confirmButtonTitle{

    [self setFrame:CGRectMake(0, 0, viewWidth, kViewHeight)];
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 14, self.middleView.frame.size.width, 21)];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    titleLabel.text=title;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    titleLabel.backgroundColor=[UIColor clearColor];
    [self.middleView addSubview:titleLabel];
//    
//    CGFloat herDistance=15;
//    CGFloat verDistance=10;
//    CGFloat startX=10;
    CGFloat startY = 10;
//    CGFloat btnWidth=self.middleView.frame.size.width/2-20;
    CGFloat btnHeight=24;
    
    CGFloat bottomBtnHeight=46;
    
    NSString *cancelStr;
    NSString *confirmStr;
    titleBtns = [NSMutableArray array];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.middleView.frame.size.width, 124)];
    self.scrollView.scrollEnabled = YES;
    for (int i=0; i<[contentArray count]; i++) {
        NSInteger titleWidth = titleWidth = self.middleView.frame.size.width/2 - 25;//[[contentArray[i] objectForKey:@"labelText"] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 30)].width + 24;
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake((self.middleView.frame.size.width - titleWidth*2 - 10)/2, startY, titleWidth, btnHeight)];
        if (titleBtns.count > 0) {
            
            UIButton *myBtn = titleBtns[i - 1];
            button.frame = CGRectMake(myBtn.frame.origin.x + myBtn.frame.size.width + 10, myBtn.frame.origin.y, titleWidth, btnHeight);
            if ((button.frame.origin.x + button.frame.size.width) > self.middleView.frame.size.width-20) {
                button.frame = CGRectMake((self.middleView.frame.size.width - titleWidth*2 - 10)/2, button.frame.origin.y + button.frame.size.height + 10, titleWidth, btnHeight);
            }
        }

        [button setTag:i];
        [button addTarget:self action:@selector(contentBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        if (i%2==0) {//偶数 左边
//            startX=10;
//            startY=10+verDistance+startY;
//        }
//        else{ //奇数 右边
//            startX=10+btnWidth+herDistance;
//        }

        [button setTitle:[[contentArray objectAtIndex:i] objectForKey:@"labelText"] forState:UIControlStateNormal];
        [button setTitle:[[contentArray objectAtIndex:i] objectForKey:@"labelText"] forState:UIControlStateHighlighted];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button setTitleColor:RGBACOLOR(245, 125, 110, 1) forState:UIControlStateHighlighted];
//        [button setTitleColor:RGBACOLOR(245, 125, 110, 1) forState:UIControlStateSelected];
        
        if (i==0) {
            button.layer.cornerRadius=btnHeight/2;
            button.backgroundColor = [UIColor_HEX colorWithHexString:@"#f57d6e"];
            //button.layer.borderColor=[RGBACOLOR(245, 125, 110, 1) CGColor];
            //button.layer.borderWidth=0.5f;
            button.selected=YES;
        }
        else{
            button.layer.cornerRadius=btnHeight/2;
            button.backgroundColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
//            button.layer.borderColor=[RGBACOLOR(135, 135, 135, 1) CGColor];
//            button.layer.borderWidth=0.5f;
        }
//        [button setFrame:CGRectMake(startX, startY, btnWidth, btnHeight)];
        //[button setBackgroundColor:[UIColor clearColor]];
        [self.scrollView addSubview:button];
         [titleBtns addObject:button];
    }
    UIButton * lastBtn = [titleBtns lastObject];
    self.scrollView.contentSize = CGSizeMake(0, lastBtn.frame.origin.y+lastBtn.frame.size.height+10);
    [self.middleView addSubview:self.scrollView];
    if (![DataCheck isValidString:confirmButtonTitle]) {
        confirmStr=ConfirmButtonTitle;
    }
    else{
        confirmStr=confirmButtonTitle;
    }
    if (![DataCheck isValidString:cancelButtonTitle]){
        cancelStr=CancelButtonTitle;
    }
    else{
        cancelStr=cancelButtonTitle;
    }
    
//    float cancelBtnY = lastBtn.frame.origin.y+lastBtn.frame.size.height+10;
    float cancelBtnY = 210 - bottomBtnHeight;
    //取消按钮
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, cancelBtnY,
                                                                  self.middleView.frame.size.width/2,
                                                                  bottomBtnHeight)];
    
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:cancelStr forState:UIControlStateNormal];
    [cancelBtn setTitle:cancelStr forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    
    //添加分割线
    UIView *horLine=[[UIView alloc]initWithFrame:CGRectMake(0, cancelBtnY-1,
                                                            self.middleView.frame.size.width,
                                                            1)];
    [horLine setBackgroundColor:RGBACOLOR(233, 233, 233, 1)];
    
    UIView *verLine=[[UIView alloc]initWithFrame:CGRectMake(self.middleView.frame.size.width/2,
                                                            cancelBtnY-1,
                                                            1,
                                                            bottomBtnHeight)];
    [verLine setBackgroundColor:RGBACOLOR(233, 233, 233, 1)];
    
    [self.middleView addSubview:horLine];
    [self.middleView addSubview:verLine];
    
    
    //确认按钮
    UIButton *confirmBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.middleView.frame.size.width/2,
                                                                   cancelBtnY,
                                                                   self.middleView.frame.size.width/2,
                                                                   bottomBtnHeight)];
    
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:confirmStr forState:UIControlStateNormal];
    [confirmBtn setTitle:confirmStr forState:UIControlStateHighlighted];
    [confirmBtn setTitleColor:RGBACOLOR(245, 125, 110, 1) forState:UIControlStateNormal];
    [confirmBtn setTitleColor:RGBACOLOR(245, 125, 110, 1) forState:UIControlStateHighlighted];
    [confirmBtn setBackgroundColor:[UIColor clearColor]];

    [self.middleView addSubview:cancelBtn];
    [self.middleView addSubview:confirmBtn];
    
    CGFloat middleViewH=cancelBtnY+bottomBtnHeight;
    
    [self.middleView setFrame:CGRectMake(25, (self.frame.size.height/2)-(middleViewH/2), self.frame.size.width-25*2, middleViewH)];
}

/**
 * Method name: setMiddleView
 * Description: 设置中间view
 */

-(void)setMiddleView{
    
    self.middleView=[[UIView alloc]initWithFrame:CGRectMake(25, self.frame.size.height/2, self.frame.size.width-25*2, 200)];

    [self addSubview:self.middleView];

    
    self.middleView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.middleView.layer.shadowOpacity = 0.66;
    self.middleView.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.middleView.layer.shadowRadius = 14.0;
    
    [self.middleView setBackgroundColor:[UIColor whiteColor]];
    
    self.middleView.layer.cornerRadius=15;
    self.middleView.layer.borderColor=[[UIColor clearColor]CGColor];
    self.middleView.layer.borderWidth=0.0f;
}

/**
 * Method name: contentBtnTouchAction
 * Description: 内容按钮点击事件
 * Parameter: sender 需要知道哪个点击的
 */
-(void)contentBtnTouchAction:(UIButton *)sender{
    
    for (id view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)view;
            btn.selected=NO;
            btn.layer.borderColor=[RGBACOLOR(135, 135, 135, 1) CGColor];
        }
    }
    [sender setSelected:YES];
    sender.layer.borderColor=[RGBACOLOR(245, 125, 110, 1) CGColor];
    
    [_delegate contentButtonTouch:sender];
}

/**
 * Method name: confirmBtnClick
 * Description: 确认按钮点击事件
 */
-(void)confirmBtnClick{
    
    [_delegate confirmButtonTouch];
    [self cancelBtnClick];
    
}

/**
 * Method name: cancelBtnClick
 * Description: 取消按钮点击事件
 */

-(void)cancelBtnClick{

    if (self) {
        [self removeFromSuperview];
    }
}

@end
