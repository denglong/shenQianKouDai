//
//  EvaluteNoPhysicObjectViewController.m
//  KingProFrame
//
//  Created by eqbang on 16/1/15.
//  Copyright © 2016年 king. All rights reserved.
//

#import "EvaluteNoPhysicObjectViewController.h"
#import "DLStarRageView.h"
#import "UIBarButtonItem+CYExtensioin.h"
#import "CYPlaceholderTextView.h"
#import "CYConst.h"
#import "Headers.h"
#import "NoNetworkView.h"
#import "RedEnvelopeView.h"



@interface EvaluteNoPhysicObjectViewController ()<DLStarRageViewDelegate,UITextViewDelegate,reloadDelegate,RedEnvelopeViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>

/** 商家态度星级 */
@property (weak, nonatomic) DLStarRageView *shopAttributeStartView;
/** 推荐星级 */
@property (weak, nonatomic) DLStarRageView *recommandStartView;
/** 评价textview */
@property (weak, nonatomic) IBOutlet CYPlaceholderTextView *evaluteTextview;
/** 提交评价按钮 */
@property (weak, nonatomic) IBOutlet UIButton *submitEvaluteButton;
/** 还能输入多少个字 */
@property (weak, nonatomic) IBOutlet UILabel *stillCanEnterWordsNumberLabel;
/** starList */
@property (nonatomic , strong) NSMutableArray *starViewList;
/**  商家态度 */
@property (nonatomic,copy) NSString *shopAttribute;
/** 推荐程度 */
@property (nonatomic,copy) NSString *recommand;
/** 商家态度label */
@property (weak, nonatomic) IBOutlet UILabel *shopAttributeLabel;
/** 推荐程度标签 */
@property (weak, nonatomic) IBOutlet UILabel *recommandLabel;
/** 请求对象 */
@property (nonatomic , strong) CloudClient *client;
/** 无网页面 */
@property (nonatomic , strong) UIView *noNetWork;
/** 商家态度view */
@property (weak, nonatomic) IBOutlet UIView *shopAttributeView;
/** 推荐星级view */
@property (weak, nonatomic) IBOutlet UIView *recommandView;
/** 提交评论之后返回参数 */
@property (nonatomic,copy) NSMutableDictionary *redEnvelopeDic;
/** 发红包view */
@property (nonatomic , strong) RedEnvelopeView *redEnvelopeView;
/** 评价response */
@property (nonatomic , strong) NSDictionary *comment;
/** 评价dictionary */
@property (nonatomic , strong) NSDictionary *commentDictionary;

@end

@implementation EvaluteNoPhysicObjectViewController

#pragma mark - view生命周期相关
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSelfView];
    
    [self setUpNavigationItem];
    
    [self setUpTextview];
    
    [self createStarView];
    
    [self setUpSubmitButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [MobClick beginLogPageView:NSStringFromClass([self class])];
    if (self.isCheckOutEvalute == YES)
    {
        [self requestEvaluationData];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 页面初始化设置
- (void)setUpSelfView
{
    self.client = [CloudClient getInstance];
    
    self.view.backgroundColor = [UIColor_HEX colorWithHexString:@"#eeeeee"];
}

- (void)setUpNavigationItem
{
    if (self.isCheckOutEvalute == YES)
    {
        self.navigationItem.title = @"查看点评";
    }else
    {
        self.navigationItem.title = @"商品评价";
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textviewResignFirstResponse:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(textviewResignFirstResponse:)];
        
        [self.view addGestureRecognizer:tap];
        [self.view addGestureRecognizer:pan];
    }
}

- (void)setUpTextview
{
    if (self.isCheckOutEvalute == YES)
    {
        self.evaluteTextview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.stillCanEnterWordsNumberLabel.hidden = YES;
        self.evaluteTextview.placeholder = nil;
    }
    else
    {
        self.evaluteTextview.contentInset = UIEdgeInsetsMake(0, 0,20, 0);
        self.evaluteTextview.placeholder = @"写下对宝贝的感受吧，对他人帮助很大哦";
        self.evaluteTextview.placeholderColor = [UIColor_HEX colorWithHexString:@"#999999" ];
        self.evaluteTextview.delegate = self;
        self.stillCanEnterWordsNumberLabel.hidden = NO;
        self.stillCanEnterWordsNumberLabel.text = [NSString stringWithFormat:@"还可输入%.0f个字",CYStillCanInputWordsNumber];
        // 使用通知监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textviewTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
}

- (void)setUpSubmitButton
{
    [self.submitEvaluteButton.layer setMasksToBounds:YES];
    self.submitEvaluteButton.layer.cornerRadius = 5;
    if (self.isCheckOutEvalute == YES)
    {
        self.submitEvaluteButton.hidden = YES;
    }else
    {
        self.submitEvaluteButton.hidden = NO;
//        self.submitEvaluteButton.backgroundColor = [UIColor_HEX colorWithHexString:@"#ffe100"];
        [self.submitEvaluteButton setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateDisabled];
        [self.submitEvaluteButton setTitleColor:[UIColor_HEX colorWithHexString:@"#6a3906"] forState:UIControlStateNormal];
        [self.submitEvaluteButton addTarget:self action:@selector(submitEvaluteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.submitEvaluteButton.enabled = NO;
    }

}

- (void)submitEvaluteButtonClicked:(id)sender
{
    DLog(@"submit");
    [self commentEvaluationData];
    
}


- (void)createStarView
{
    DLStarRageView *shopAttributeStar = [[DLStarRageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shopAttributeLabel.frame) + 28, self.shopAttributeLabel.frame.origin.y - 5,200, 45) EmptyImage:@"emptyStar" StarImage:@"Star" starNum:5];
    shopAttributeStar.delegate = self;
    shopAttributeStar.tag = 1;
    self.shopAttributeStartView = shopAttributeStar;
    
    DLStarRageView *recommadStar = [[DLStarRageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.recommandLabel.frame) + 28, self.recommandLabel.frame.origin.y - 5, 200, 45) EmptyImage:@"emptyStar" StarImage:@"Star" starNum:5];
    recommadStar.delegate = self;
    recommadStar.tag = 2;
    self.recommandStartView = recommadStar;
    
    [self.shopAttributeView addSubview:shopAttributeStar];
    [self.recommandView addSubview:recommadStar];
}

#pragma mark - 网络请求相关

/** 请求页面参数 */
- (void)requestEvaluationData
{
    if ([self noNetwork]) {
        return;
    }
    
    [self.client requestMethodWithMod:@"order/commentPage"
                          params:nil
                      postParams:@{@"orderNo":self.orderNum}
                        delegate:self
                        selector:@selector(requestEvaluationDataSuccessed:)
                   errorSelector:@selector(requestEvaluationDatafiled:)
                progressSelector:nil];

}


// 请求成功回调
- (void)requestEvaluationDataSuccessed:(NSDictionary *)response {
    
    
    if ([DataCheck isValidDictionary:response]) {
        
            
        self.comment = response;
            
        self.commentDictionary = [response objectForKey:@"comment"];
            
        if ([DataCheck isValidDictionary:self.commentDictionary]) {
            
                    
            [[self.commentDictionary objectForKey:@"scoreDelivery"] intValue];
                    
            self.evaluteTextview.text = self.commentDictionary[@"commentContent"];
                    
            NSString *scoreService = (NSString *)[self.commentDictionary objectForKey:@"scoreService"];
            
            NSString *scoreRecommand =  (NSString *)[self.commentDictionary objectForKey:@"scoreRecom"];
                    
            self.evaluteTextview.editable = NO;
                    
            [self.recommandStartView showStarRageAction:[scoreRecommand intValue]];
                    
            [self.shopAttributeStartView showStarRageAction:[scoreService intValue]];
            
            }
        }
        
    [super hidenHUD];

}

// 失败回调
- (void)requestEvaluationDatafiled:(NSDictionary *)response
{
}

// 上传评价
- (void)commentEvaluationData
{
    
    if ([self noNetwork]) {
        return;
    }
    
    DLog(@"%@",self.evaluteTextview.text);
    
    [self.evaluteTextview resignFirstResponder];
    
    if (self.orderNum != nil)
    {
        
        NSDictionary *params = @{@"orderNo":self.orderNum,
                                 @"scoreService":[NSString stringWithFormat:@"%zd",[self.shopAttribute intValue]],
                                 @"commentContent":self.evaluteTextview.text,
                                 @"scoreRecom":[NSString stringWithFormat:@"%zd",[self.recommand intValue]]};
        
        
        [self.client requestMethodWithMod:@"order/commentShop"
                                   params:nil
                               postParams:params
                                 delegate:self
                                 selector:@selector(commitEvaluationSuccessed:)
                            errorSelector:@selector(commitEvaluationfiled:)
                         progressSelector:nil];
    }

}

- (void)commitEvaluationSuccessed:(NSDictionary *)response
{
    if ([DataCheck isValidDictionary:response]) {
        self.redEnvelopeDic = [NSMutableDictionary dictionary];
        [MobClick endEvent:RedPackets];
        
        self.submitEvaluteButton.enabled = NO;
//        self.submitEvaluteButton.backgroundColor = [UIColor_HEX colorWithHexString:@"#cccccc"];
//        [self.submitEvaluteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [super hidenHUD];
        
        //提交成功调红包
        if ([DataCheck isValidArray:[response objectForKey:@"dialogList"]]) {
            if ([UserLoginModel isAverageUser]) {
                self.redEnvelopeDic = [[response objectForKey:@"dialogList"] objectAtIndex:0];
                if ([[self.redEnvelopeDic objectForKey:@"packets"] integerValue] > 0) {
                    //发红包
                    [self preSellGoodsShowRedEnveiopeView];
                    return;
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }

}

- (void)commitEvaluationfiled:(NSDictionary *)response
{
    self.submitEvaluteButton.enabled = NO;
}

#pragma mark - 发红包
- (void)preSellGoodsShowRedEnveiopeView
{
    self.redEnvelopeView = [[[NSBundle mainBundle] loadNibNamed:@"RedEnvelopeView" owner:self options:nil] objectAtIndex:0];
     self.redEnvelopeView.frame = CGRectMake(0, 0, viewWidth, [UIScreen mainScreen].bounds.size.height);
     self.redEnvelopeView.reEnvelopeCountLabel.text = [self.redEnvelopeDic objectForKey:@"msg0"];
     self.redEnvelopeView.textALabel.text = [self.redEnvelopeDic objectForKey:@"msg1"];
     self.redEnvelopeView.delegate = self;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.redEnvelopeView];
    CAEmitterLayer * emitterLayer = [self LHLCreateCAEmitterLayer];
    [self.redEnvelopeView.layer insertSublayer:emitterLayer atIndex:2];
    CAEmitterCell * cell1 =[self LHLGetCAEmitterCell];
    //设置图片
    cell1.contents = (__bridge id)([UIImage imageNamed:@"redLayer1"].CGImage);
    CAEmitterCell * cell2 = [self LHLGetCAEmitterCell];
    cell2.contents = (__bridge id)([UIImage imageNamed:@"redLayer2"].CGImage);
    //让CAEmitterCell 与CAEmitterlayer 产生关系
    emitterLayer.emitterCells = @[cell1,cell2];
}

/**
 *   创建红包背景界面
 *
 */
-(CAEmitterLayer *)LHLCreateCAEmitterLayer
{
    //创建出layer
    CAEmitterLayer * emitterlayer =[CAEmitterLayer layer];
    //给定尺寸
    //    emitterlayer.frame = CGRectMake(100, 100, 30, 30);
    //发射点
    emitterlayer.emitterPosition = CGPointMake(self.view.bounds.size.width/2, -30);
    emitterlayer.emitterSize = CGSizeMake(self.view.bounds.size.width * 2, self.view.bounds.size.height/2);
    
    //显示边框
    //    emitterlayer.borderWidth = 0.5;
    
    //发射模式
    emitterlayer.emitterMode = kCAEmitterLayerSurface;
    
    //发射形状
    emitterlayer.emitterShape = kCAEmitterLayerLine;
    
    emitterlayer.shadowOpacity = 1.0;
    emitterlayer.shadowRadius  = 0.0;
    emitterlayer.shadowOffset  = CGSizeMake(0.0, 1.0);
    emitterlayer.shadowColor   = [[UIColor grayColor] CGColor];
    return emitterlayer;
}

-(CAEmitterCell *)LHLGetCAEmitterCell
{
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    
    //粒子产生率
    cell.birthRate = 0.5f;
    
    //粒子生命周期
    cell.lifetime = 60.0f;
    
    //速度值
    cell.velocity = -10;
    
    //速度值的微调度
    cell.velocityRange = 10.f;
    
    //y轴加速度
    cell.yAcceleration = 5.f;
    
    //发射角度
    cell.emissionRange = 0.5*M_PI;
    
    cell.spinRange = 0.25 * M_PI;
    
    return cell;
}


#pragma mark - redEnvelope delegate
-(void)cancelOrSureBtnClick:(NSInteger)tag
{
    [self.redEnvelopeView removeFromSuperview];
    self.redEnvelopeView = nil;
    if (tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //发红包
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"返回"
                                                   destructiveButtonTitle:@"微信"
                                                        otherButtonTitles:@"朋友圈",nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - actionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * urlString = [self.redEnvelopeDic objectForKey:@"packetsUrl"];
    NSString * imgUrl = [self.redEnvelopeDic objectForKey:@"img"];
    NSString * title = [self.redEnvelopeDic objectForKey:@"packTitle"];
    NSString * text = [self.redEnvelopeDic objectForKey:@"packText"];
    [self.navigationController popViewControllerAnimated:YES];
    switch (buttonIndex) {
        case 0:
        {
//            //微信好友
//            [super shareapplicationContent:text
//                            defaultContent:nil
//                                     title:title
//                                       url:urlString
//                               description:nil
//                                      type:ShareTypeWeixiSession
//                                 imagePath:imgUrl];
        }
            break;
        case 1:
        {
//            //微信朋友圈
//            [super shareapplicationContent:text
//                            defaultContent:nil
//                                     title:title
//                                       url:urlString
//                               description:nil
//                                      type:ShareTypeWeixiTimeline
//                                 imagePath:imgUrl];
        }
            break;
            //        case 2:
            //        {
            //            //QQ好友
            //            [super shareapplicationContent:text
            //                            defaultContent:nil
            //                                     title:title
            //                                       url:urlString
            //                               description:nil
            //                                      type:ShareTypeQQ
            //                                 imagePath:imgUrl];
            //
            //        }
            //            break;
            //        case 3:
            //        {
            //            //QQ空间
            //            [super shareapplicationContent:text
            //                            defaultContent:nil
            //                                     title:title
            //                                       url:urlString
            //                               description:nil
            //                                      type:ShareTypeQQSpace
            //                                 imagePath:imgUrl];
            //        }
            //            break;
        default:
            
            break;
    }
    
}


#pragma mark - 无网相关方法和代理
// 无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        self.noNetWork = [NoNetworkView sharedInstance].view;
        [NoNetworkView sharedInstance].reloadDelegate = self;
        self.noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:self.noNetWork];
        return YES;
    }
    else
    {
        if (self.noNetWork) {
            [self.noNetWork removeFromSuperview];
        }
        return NO;
    }
}

// 无网点击按钮之后的代理
- (void)reloadAgainAction
{
    if (self.isCheckOutEvalute == YES)
    {
        [self requestEvaluationData];
    }else
    {
        if (![self isNotNetwork]) {
            
            self.noNetWork.hidden = YES;
        }
    }
}


#pragma mark - DLStartRangeViewDelegate
- (void)starRateViewChooseAction:(NSInteger)starNum starView:(DLStarRageView *)starRageView
{
    if (starRageView.tag == 1)
    {
        self.shopAttribute = [NSString stringWithFormat:@"%zd", starNum];
        
        self.submitEvaluteButton.enabled = [self checkOutSubmitEnable];
    }else
    {
        self.recommand = [NSString stringWithFormat:@"%zd", starNum];
        
        self.submitEvaluteButton.enabled = [self checkOutSubmitEnable];
    }


}

#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= CYStillCanInputWordsNumber && text.length > range.length) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
//    int length = [self countWord:self.evaluteTextview.text];
//    if (self.evaluteTextview.text.length >= CYStillCanInputWordsNumber) {
//        textView.text = [textView.text substringToIndex:CYStillCanInputWordsNumber];
//        self.stillCanEnterWordsNumberLabel.text = [NSString stringWithFormat:@"还可输入0个字"];
//    }
    
    NSString *toBeString = self.evaluteTextview.text;
    
    [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        //emoji length is 2  replace emoji with emptyString
        if (substring.length == 2) {
            //过滤表情符号
            self.evaluteTextview.text = [self.evaluteTextview.text stringByReplacingOccurrencesOfString:substring withString:@""];
        }
    }];
    
    if (textView.markedTextRange == nil && CYStillCanInputWordsNumber - self.evaluteTextview.text.length <= 0 && self.evaluteTextview.text.length > CYStillCanInputWordsNumber) {
        textView.text = [textView.text substringToIndex:CYStillCanInputWordsNumber];
        self.stillCanEnterWordsNumberLabel.text = [NSString stringWithFormat:@"还可输入0个字"];
    }
    else
    {
        float stillInpute = CYStillCanInputWordsNumber - self.evaluteTextview.text.length;
        
        if (stillInpute <= 0)
        {
            stillInpute = 0;
        }
        self.stillCanEnterWordsNumberLabel.text = [NSString stringWithFormat:@"还可输入%.0f个字", stillInpute];
    }
    
    self.submitEvaluteButton.enabled = [self checkOutSubmitEnable];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    self.stillCanEnterWordsNumberLabel.hidden = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.stillCanEnterWordsNumberLabel.hidden = NO;
}


#pragma mark - textview放弃第一响应者
- (void)textviewResignFirstResponse:(UITapGestureRecognizer *)tap
{
    [self.evaluteTextview resignFirstResponder];
}

- (void)textviewTextDidChange:(CYPlaceholderTextView *)textview
{
    self.submitEvaluteButton.enabled = [self checkOutSubmitEnable];
    
}

#pragma mark - 计算相关方法
- (int)countWord:(NSString *)strtemp
{
    int i,n=(int)strtemp.length,l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[strtemp characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

#pragma mark - 页面dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - submitButton 按钮的enable状态判断

- (BOOL)checkOutSubmitEnable
{
    if ([self.shopAttribute integerValue] > 0 && [self.recommand integerValue] > 0 && [self countWord:self.evaluteTextview.text] > 0)
    {
        return YES;
    }else
    {
        return NO;
    }
}

//- (void)textViewDidBeginEditing:(UITextView *)inView
//{
//    [self performSelector:@selector(setCursorToBeginning:) withObject:self.evaluteTextview afterDelay:0.01];
//}
//
//- (void)setCursorToBeginning:(UITextView *)inView
//{
//    //you can change first parameter in NSMakeRange to wherever you want the cursor to move
//    inView.selectedRange = NSMakeRange(10, 0);
//}


@end
