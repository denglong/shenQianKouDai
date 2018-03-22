//
//  EvaluateViewController.m
//  myTest
//
//  Created by denglong on 12/23/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import "EvaluateViewController.h"
#import "EvaluateHeaderCell.h"
#import "EvaluateBodyCell.h"
#import "DLStarRageView.h"
#import "RedEnvelopeView.h"
#import "BusinessInfoViewController.h"
@interface EvaluateViewController ()<DLStarRageViewDelegate, RedEnvelopeViewDelegate,UIActionSheetDelegate, reloadDelegate>
{
    CloudClient *client;
    DLStarRageView *starView;
    DLStarRageView *headerSterView;
    NSMutableArray *starViewList;
    /**创建发红包界面对象*/
    RedEnvelopeView * redEnvelopeView;
    /**点评成功获取的红包信息*/
    NSDictionary * redEnvelopeDic;
    UIView        *noNetWork;        //无网页面
    NSDictionary *responseDic;
    NSString *scoreDelivery; //送货速度
    NSString *scoreGoods;  //商品匹配
    NSString *scoreService;  //商家态度
    UIButton *mySubmitBtn;
    NSDictionary *commentDic;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation EvaluateViewController
@synthesize myTableView, orderNum, indexNum;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    redEnvelopeView.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
    redEnvelopeView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (indexNum == 2) {
        self.title = @"查看点评";
    }
    else
    {
        self.title = @"点评";
    }

    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:241/255.0 alpha:1];
    myTableView.hidden = YES;
    client = [CloudClient getInstance];
    
    [self createTableViewCell];
    if (indexNum == 1) {
        [self createStarView];
    }
    
    [self notificationAndGesture];
    
    [super showHUD];
    [self getEvaluationData];
}

- (void)notificationAndGesture {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden)
                                                 name:@"HIDDENKEYBOARD"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
//    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHidden)];
//    singleTapRecognizer.numberOfTapsRequired = 1;
//    [myTableView addGestureRecognizer:singleTapRecognizer];
}

- (void)createTableViewCell {
    [myTableView registerNib:[UINib nibWithNibName:@"EvaluateHeaderCell" bundle:nil] forCellReuseIdentifier:@"EVALUATEHEADER"];
    [myTableView registerNib:[UINib nibWithNibName:@"EvaluateBodyCell" bundle:nil] forCellReuseIdentifier:@"EVALUATEBODY"];
}

- (void)createStarView {
    starViewList = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i ++) {
        starView = [[DLStarRageView alloc] initWithFrame:CGRectMake(0, 0, 200, 45) EmptyImage:@"emptyStar" StarImage:@"Star" starNum:5];
        starView.tag = i;
        starView.delegate = self;
        [starViewList addObject:starView];
    }
}

- (void)setStarView {
    starViewList = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i ++) {
        NSInteger number;
        switch (i) {
            case 0:
                number = [[commentDic objectForKey:@"scoreDelivery"] integerValue];
                break;
            case 1:
                number = [[commentDic objectForKey:@"scoreGoods"] integerValue];
                break;
            case 2:
                number = [[commentDic objectForKey:@"scoreService"] integerValue];
                break;
            default:
                break;
        }
        
        starView = [[DLStarRageView alloc] initWithFrame:CGRectMake(0, 0, 200, 45) EmptyImage:@"emptyStar" StarImage:@"Star" starNum:number];
        [starView showStarRageAction:number];
        [starViewList addObject:starView];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EvaluateHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EVALUATEHEADER"];
        
        cell.headerStarView = headerSterView;
        cell.responseDic = responseDic;
        
        return cell;
    }
    else {
        EvaluateBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EVALUATEBODY"];
        
        cell.starViewList = starViewList;
        cell.responseDic = responseDic;
        if (indexNum == 2) {
            cell.submitBtn.hidden = YES;
            cell.userEvaluate.hidden = NO;
            
            if (![DataCheck isValidDictionary:commentDic]) {
                cell.oneLab.hidden = YES;
                cell.twoLab.hidden = YES;
                cell.threeLab.hidden = YES;
                cell.nullImage.hidden = NO;
            }
            else
            {
                cell.oneLab.hidden = NO;
                cell.twoLab.hidden = NO;
                cell.threeLab.hidden = NO;
                cell.nullImage.hidden = YES;
            }
            
        }
        mySubmitBtn = cell.submitBtn;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 83;
    }
    else
    {
        return 400;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    headerView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:241/255.0 alpha:1];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BusinessInfoViewController * businessInfoViewcontroller = [[BusinessInfoViewController alloc]init];
        //              businessInfoViewcontroller.comePageTag = -100;
        NSString *str = [NSString stringWithFormat:@"%@", [responseDic objectForKey:@"shopId"]];
        businessInfoViewcontroller.shopId = str;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:businessInfoViewcontroller animated:YES];
    }
}

- (void)starRateViewChooseAction:(NSInteger)starNum starView:(DLStarRageView *)starRageView {
    NSLog(@"%ld-----%ld", starRageView.tag, starNum);
    switch (starRageView.tag) {
        case 0:
            scoreDelivery = [NSString stringWithFormat:@"%ld", starNum];
            break;
            
        case 1:
            scoreGoods = [NSString stringWithFormat:@"%ld", starNum];
            break;
            
        case 2:
            scoreService = [NSString stringWithFormat:@"%ld", starNum];
            break;
        default:
            break;
    }
    
    if ([scoreDelivery integerValue] > 0 && [scoreGoods integerValue] > 0 && [scoreService integerValue] > 0) {
        mySubmitBtn.enabled = YES;
        mySubmitBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#ffe100"];
        [mySubmitBtn setTitleColor:[UIColor_HEX colorWithHexString:@"#6a3906"] forState:UIControlStateNormal];
        [mySubmitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
//        [myTableView reloadData];
    }
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        myTableView.contentOffset = CGPointMake(myTableView.contentOffset.x, myTableView.contentOffset.y + keyboardSize.height);
    }];
}

- (void)keyboardHidden {
    [UIView animateWithDuration:0.3 animations:^{
        myTableView.contentOffset = CGPointMake(myTableView.contentOffset.x, -64);
    }];
    NSNotification *notification = [NSNotification notificationWithName:@"CELLHIDDENKEYBOARD"
                                                                 object:nil
                                                               userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self keyboardHidden];
//}

- (void)submitAction {
    [MobClick endEvent:Confirm_Comment];
    [self submitEvaluationData];
}

//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        myTableView.hidden = YES;
        noNetWork = [NoNetworkView sharedInstance].view;
        [NoNetworkView sharedInstance].reloadDelegate = self;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:noNetWork];
        return YES;
    }
    else
    {
        if (noNetWork) {
            [noNetWork removeFromSuperview];
        }
        return NO;
    }
}

#pragma mark - 重新加载回调
- (void)reloadAgainAction {
    [self getEvaluationData];
}

/**
 * Method name: getEvaluationDataRequest
 * Description: 评价页请求接口处理方法
 * Parameter: 无
 * Parameter: 无
 */
- (void)getEvaluationData {
    if ([self noNetwork]) {
        [super hidenHUD];
        return;
    }
    
    [client requestMethodWithMod:@"order/commentPage"
                          params:nil
                      postParams:@{@"orderNo":orderNum}
                        delegate:self
                        selector:@selector(getEvaluationDataSuccessed:)
                   errorSelector:@selector(getEvaluationDatafiled:)
                progressSelector:nil];
}

- (void)getEvaluationDataSuccessed:(NSDictionary *)response {
    if ([DataCheck isValidDictionary:response]) {
        responseDic = response;
        if (indexNum == 2) {
            commentDic = [response objectForKey:@"comment"];
            if ([DataCheck isValidDictionary:commentDic]) {
                [self setStarView];
            }
        }
        
        myTableView.hidden = NO;
        [myTableView reloadData];
    }
    
    [super hidenHUD];
}

- (void)getEvaluationDatafiled:(NSDictionary *)response {
    [super hidenHUD];
}

/**
 * Method name: submitEvaluationData
 * Description: 评价页提交接口处理方法
 * Parameter: 无
 * Parameter: 无
 */
- (void)submitEvaluationData {
    if ([self noNetwork]) {
        return;
    }
    
    [super showHUD];
    
    NSDictionary *params = @{@"orderNo":orderNum, @"scoreDelivery":scoreDelivery, @"scoreGoods":scoreGoods, @"scoreService":scoreService};
    
    [client requestMethodWithMod:@"order/commentShop"
                          params:nil
                      postParams:params
                        delegate:self
                        selector:@selector(submitEvaluationSuccessed:)
                   errorSelector:@selector(submitEvaluationfiled:)
                progressSelector:nil];
}

- (void)submitEvaluationSuccessed:(NSDictionary *)response {
    if ([DataCheck isValidDictionary:response]) {
        redEnvelopeDic = response;
        [MobClick endEvent:RedPackets];
        
        mySubmitBtn.enabled = NO;
        mySubmitBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#cccccc"];
        [mySubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [super hidenHUD];
        
        //提交成功调红包
        if ([DataCheck isValidArray:[response objectForKey:@"dialogList"]]) {
            if ([UserLoginModel isAverageUser]) {
                redEnvelopeDic = [[response objectForKey:@"dialogList"] objectAtIndex:0];
                if ([[redEnvelopeDic objectForKey:@"packets"] integerValue] > 0) {
                    //发红包
                    [self showRedEnveiopeView];
                    return;
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void)submitEvaluationfiled:(NSDictionary *)response {
    
    mySubmitBtn.enabled = NO;
    mySubmitBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#cccccc"];
    [mySubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [super hidenHUD];
}

#pragma mark - 发红包

/**
 *   弹出发红包界面
 *
 */

-(void)showRedEnveiopeView
{
    redEnvelopeView = [[[NSBundle mainBundle] loadNibNamed:@"RedEnvelopeView" owner:self options:nil] objectAtIndex:0];
    redEnvelopeView.frame = CGRectMake(0, 0, viewWidth, [UIScreen mainScreen].bounds.size.height);
    redEnvelopeView.reEnvelopeCountLabel.text = [redEnvelopeDic objectForKey:@"msg0"];
    redEnvelopeView.textALabel.text = [redEnvelopeDic objectForKey:@"msg1"];
    redEnvelopeView.delegate = self;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:redEnvelopeView];
    CAEmitterLayer * emitterLayer = [self createCAEmitterLayer];
    [redEnvelopeView.layer insertSublayer:emitterLayer atIndex:2];
    CAEmitterCell * cell1 =[self getCAEmitterCell];
    //设置图片
    cell1.contents = (__bridge id)([UIImage imageNamed:@"redLayer1"].CGImage);
    CAEmitterCell * cell2 = [self getCAEmitterCell];
    cell2.contents = (__bridge id)([UIImage imageNamed:@"redLayer2"].CGImage);
    //让CAEmitterCell 与CAEmitterlayer 产生关系
    emitterLayer.emitterCells = @[cell1,cell2];
}

#pragma mark - redEnvelope delegate
-(void)cancelOrSureBtnClick:(NSInteger)tag
{
    [redEnvelopeView removeFromSuperview];
    redEnvelopeView = nil;
    if (tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //发红包
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:@"微信" otherButtonTitles:@"朋友圈",nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - actionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * urlString = [redEnvelopeDic objectForKey:@"packetsUrl"];
    NSString * imgUrl = [redEnvelopeDic objectForKey:@"img"];
    NSString * title = [redEnvelopeDic objectForKey:@"packTitle"];
    NSString * text = [redEnvelopeDic objectForKey:@"packText"];
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


/**
 *   创建红包背景界面
 *
 */
-(CAEmitterLayer *)createCAEmitterLayer
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

-(CAEmitterCell *)getCAEmitterCell
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

@end
