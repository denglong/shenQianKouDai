//
//  EvaluationViewController.m
//  KingProFrame
//
//  Created by denglong on 8/14/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "EvaluationViewController.h"
#import "ShopDetailsController.h"
#import "HeaderViewCell.h"
#import "EvaluationCell.h"
#import "RedEnvelopeView.h"
@interface EvaluationViewController ()<RedEnvelopeViewDelegate,UIActionSheetDelegate, reloadDelegate>
{
    CloudClient *client;
    NSDictionary *titleNameNum;
    NSDictionary *titleName;
    NSDictionary *respData;
    NSMutableArray *titleLists;
    RedEnvelopeView * redEnvelopeView;  //创建发红包界面对象
    NSDictionary * redEnvelopeDic; //点评成功获取的红包信息
    UIView        *noNetWork;        //无网页面
    UIButton *evaluationBtn;
}

@end

@implementation EvaluationViewController
@synthesize orderNum, type, myTableView, indexNum;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点评";
    
    titleLists = [NSMutableArray array];
    
    client = [CloudClient getInstance];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self getEvaluationDataRequest];
    
    redEnvelopeView.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
    redEnvelopeView.hidden = YES;
}

/**
 * Method name: tableView
 * Description: tableView相关实现方法
 * Parameter: 无
 
 * Parameter: 无
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else
    {
        if (indexNum == 1) {
            return 6;
        }
        else
        {
            return 5;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section == 0) {
        HeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HeaderViewCell" owner:self options:nil];
            cell = [views objectAtIndex:0];
            cell.selectionStyle = UITableViewCellStyleDefault;
        }
        
        if ([type integerValue] == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.shopName.text = [respData objectForKey:@"name"];
            [cell.shopName sizeToFit];
            cell.shopName.frame = CGRectMake(cell.shopName.frame.origin.x, cell.shopName.frame.origin.y, viewWidth - cell.shopImage.frame.size.width - 100, cell.shopName.frame.size.height);
            cell.certify.frame = CGRectMake(cell.shopName.frame.size.width + cell.shopName.frame.origin.x, cell.certify.frame.origin.y, cell.certify.frame.size.width, cell.certify.frame.size.height);
            
            cell.totalNum.text = [NSString stringWithFormat:@"已完成%@单", [respData objectForKey:@"finishOrder"]];
            NSURL *url = [NSURL URLWithString:[respData objectForKey:@"imgUrl"]];
            
            if ([UserLoginModel isAverageUser]) {
                [cell.shopImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ShopImage"]];
            }
            else
            {
               [cell.shopImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"header"]];
            }
        }
        else
        {
            cell.certify.hidden = YES;
            cell.shopName.text = [respData objectForKey:@"name"];
            [cell.shopName sizeToFit];
            NSURL *url = [NSURL URLWithString:[respData objectForKey:@"imgUrl"]];
            [cell.shopImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"header"]];
            cell.totalNum.text = [NSString stringWithFormat:@"省钱口袋下单%@次", [respData objectForKey:@"finishOrder"]];
            cell.totalNum.textColor = [UIColor grayColor];
        }
        
        return cell;
    }
    else
    {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5) {
            EvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EvaluationCell" owner:self options:nil];
                cell = [views objectAtIndex:0];
                cell.selectionStyle = UITableViewCellStyleDefault;
            }
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.rightLab.hidden = NO;
                    cell.leftLab.text = [NSString stringWithFormat:@"订单号：%@", [respData objectForKey:@"orderNo"]];
                    cell.rightLab.text = [NSString stringWithFormat:@"￥%.2f", [[respData objectForKey:@"payPrice"] floatValue]];
                    cell.backgroundColor = [UIColor whiteColor];
                }
                    break;
                case 1:
                {
                    if ([DataCheck isValidDictionary:titleName]) {
                        cell.leftLab.text = @"| 我对他/她的印象";
                        cell.leftLab.hidden = NO;
                        if (indexNum == 1) {
                            cell.commentRefesh.hidden = NO;
                            [cell.commentRefesh addTarget:self action:@selector(commentRefeshAction:) forControlEvents:UIControlEventTouchUpInside];
                        }
                    }
                    else
                    {
                        cell.leftLab.hidden = YES;
                        cell.frame = CGRectMake(0, 0, 0, 0);
                    }
                }
                    break;
                case 3:
                {
                    if ([DataCheck isValidDictionary:titleNameNum]) {
                        cell.leftLab.text = @"| 他/她对我的印象";
                        cell.leftLab.hidden = NO;
                    }
                    else
                    {
                        cell.leftLab.hidden = YES;
                        cell.frame = CGRectMake(0, 0, 0, 0);
                    }
                }
                    break;
                case 5:
                {
                    cell.leftLab.hidden = YES;
                    cell.frame = CGRectMake(0, 0, cell.frame.size.width, 120);
                    
                    evaluationBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, viewWidth - 20, 40)];
                    [evaluationBtn setTitle:@"点评" forState:UIControlStateNormal];
                    [evaluationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [evaluationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                    evaluationBtn.backgroundColor = RGBACOLOR(242, 199, 72, 1);
                    evaluationBtn.layer.cornerRadius = 6;
                    [cell.contentView addSubview:evaluationBtn];
                    
                    [evaluationBtn addTarget:self action:@selector(evaluationAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                default:
                    break;
            }
            
            return cell;
        }
        else
        {
            HeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HeaderViewCell" owner:self options:nil];
                cell = [views objectAtIndex:0];
                cell.selectionStyle = UITableViewCellStyleDefault;
            }
            
            cell.shopImage.hidden = YES;
            cell.shopName.hidden = YES;
            cell.totalNum.hidden = YES;
            cell.certify.hidden = YES;
            
            switch (indexPath.row) {
                case 2:
                {
                    UIView *titleView =  [self createTitle:titleName andViewWidth:viewWidth];
                    titleView.frame = CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height);
                    cell.frame = CGRectMake(0, 0, cell.frame.size.width, titleView.frame.size.height);
                    [cell.contentView addSubview:titleView];
                    
                    if (indexNum == 1) {
                        if (self.myTitleBtns.count > 0) {
                            for (UIButton *btn in self.myTitleBtns) {
                                btn.layer.borderColor = [[UIColor clearColor] CGColor];
                                btn.backgroundColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
                                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            }
                        }
                    }
                    
                }
                    break;
                    
                case 4:
                {
                    UIView *titleView =  [self createTitle:titleNameNum andViewWidth:viewWidth];
                    titleView.frame = CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height);
                    NSArray * btns = [titleView subviews];
                    for (UIButton *btn in btns) {
                        btn.enabled = NO;
                        btn.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#f57d6e"] CGColor];
                        [btn setTitleColor:[UIColor_HEX colorWithHexString:@"#f57d6e"] forState:UIControlStateNormal];
                    }
                    cell.frame = CGRectMake(0, 0, cell.frame.size.width, titleView.frame.size.height);
                    [cell.contentView addSubview:titleView];
                    
                }
                    break;
                default:
                    break;
            }
            
            return cell;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 16)];
    footView.backgroundColor = [UIColor clearColor];
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0 && [type integerValue] == 2) {
        ShopDetailsController *shopDetail = [[ShopDetailsController alloc] init];
        shopDetail.shopId = [respData objectForKey:@"shopId"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopDetail animated:YES];
    }

}

//点击换一批处理事件
- (void)commentRefeshAction:(id)sender {
    if ([self noNetwork]) {
        return;
    }
    
    [titleLists removeAllObjects];
    [client requestMethodWithMod:@"order/assessAgain"
                          params:nil
                      postParams:@{@"orderNo":orderNum, @"type":type, @"userType":@"0"}
                        delegate:self
                        selector:@selector(getListLabelSuccessed:)
                   errorSelector:@selector(getListLabelDatafiled:)
                progressSelector:nil];
}

- (void)getListLabelSuccessed:(NSDictionary *)response {
    if ([DataCheck isValidDictionary:response]) {
        
        NSArray *lists = [response objectForKey:@"userLabelList"];
        NSArray *listNames = [response objectForKey:@"labelList"];
        if ([type integerValue] == 1) {
            listNames = [response objectForKey:@"userLabelList"];
            lists = [response objectForKey:@"labelList"];
        }
        if (lists.count > 0) {
            NSMutableArray *listName = [NSMutableArray array];
            for (NSInteger i = 0; i < lists.count; i ++) {
                NSString *name = [lists[i] objectForKey:@"name"];
                [listName addObject:name];
            }
            
            if (indexNum == 1) {
                titleNameNum = @{@"titleName":listName};
            }
            else
            {
                titleNameNum = @{@"titleName":listName, @"indexNum":@"2"};
            }
            
        }
        
        if (listNames.count > 0) {
            NSMutableArray *names = [NSMutableArray array];
            NSMutableArray *labelIds = [NSMutableArray array];
            for (NSInteger i = 0; i < listNames.count; i ++) {
                NSString *name = [listNames[i] objectForKey:@"name"];
                NSString *labelId = [listNames[i] objectForKey:@"id"];
                [names addObject:name];
                [labelIds addObject:labelId];
            }
            
            if (indexNum == 1) {
                titleName = @{@"titleName":names, @"labelId":labelIds};
            }
            else
            {
                titleName = @{@"titleName":names, @"labelId":labelIds, @"indexNum":@"2"};
            }
        }
    }
    myTableView.hidden = NO;
    [myTableView reloadData];
}

- (void)getListLabelDatafiled:(NSDictionary *)response {
    [SRMessage infoMessage:[response objectForKey:@"msg"]];
}

//点击标签处理事件
- (void)titleAction:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        //sender.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#f57d6e"] CGColor];
        sender.backgroundColor = [UIColor_HEX colorWithHexString:@"#f57d6e"];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [titleLists addObject:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    }
    else
    {
        sender.selected = NO;
        sender.backgroundColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [titleLists removeObject:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    }
    
}

//点评提交方法
- (void)evaluationAction:(UIButton *)sender {
    evaluationBtn.enabled = NO;
    [self setEvaluationDataRequest];
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

- (void)reloadAgainAction {

    [self getEvaluationDataRequest];
}

/**
 * Method name: getEvaluationDataRequest
 * Description: 评价页请求接口处理方法
 * Parameter: 无
 * Parameter: 无
 */
- (void)getEvaluationDataRequest {
    if ([self noNetwork]) {
        return;
    }
    
    [super showHUD];

    [client requestMethodWithMod:@"order/assessPage"
                          params:nil
                      postParams:@{@"orderNo":orderNum, @"type":type}
                        delegate:self
                        selector:@selector(getEvaluationDataSuccessed:)
                   errorSelector:@selector(getEvaluationDatafiled:)
                progressSelector:nil];
}

- (void)getEvaluationDataSuccessed:(NSDictionary *)response {

    if ([DataCheck isValidDictionary:response]) {
        respData = response;
        
        
        NSArray *lists = [response objectForKey:@"userLabelList"];
        NSArray *listNames = [response objectForKey:@"labelList"];
        if ([type integerValue] == 1) {
            listNames = [response objectForKey:@"userLabelList"];
            lists = [response objectForKey:@"labelList"];
        }
        if (lists.count > 0) {
            NSMutableArray *listName = [NSMutableArray array];
            for (NSInteger i = 0; i < lists.count; i ++) {
                NSString *name = [lists[i] objectForKey:@"name"];
                [listName addObject:name];
            }
            
            if (indexNum == 1) {
                titleNameNum = @{@"titleName":listName};
            }
            else
            {
                titleNameNum = @{@"titleName":listName, @"indexNum":@"2"};
            }
            
        }
        
        if (listNames.count > 0) {
            NSMutableArray *names = [NSMutableArray array];
            NSMutableArray *labelIds = [NSMutableArray array];
            for (NSInteger i = 0; i < listNames.count; i ++) {
                NSString *name = [listNames[i] objectForKey:@"name"];
                NSString *labelId = [listNames[i] objectForKey:@"id"];
                [names addObject:name];
                [labelIds addObject:labelId];
            }
            
            if (indexNum == 1) {
                titleName = @{@"titleName":names, @"labelId":labelIds};
            }
            else
            {
                titleName = @{@"titleName":names, @"labelId":labelIds, @"indexNum":@"2"};
            }
        }
    }
    myTableView.hidden = NO;
    [myTableView reloadData];
    [super hidenHUD];
}

- (void)getEvaluationDatafiled:(NSDictionary *)response {
    
    [super hidenHUD];
}

/**
 * Method name: setEvaluationDataRequest
 * Description: 评价页请求接口处理方法
 * Parameter: 无
 * Parameter: 无
 */
- (void)setEvaluationDataRequest {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [super showHUD];
    NSString *shopId = [respData objectForKey:@"shopId"];
    NSMutableArray *titles = [NSMutableArray array];
    for (NSString *titleId in titleLists) {
        NSDictionary *dic = @{@"id":titleId};
        [titles addObject:dic];
    }
    
    NSDictionary *params = @{@"orderNo":orderNum, @"type":type, @"shopId":shopId, @"labelList":titles};
    
    [client requestMethodWithMod:@"order/assess"
                          params:nil
                      postParams:params
                        delegate:self
                        selector:@selector(setEvaluationDataSuccessed:)
                   errorSelector:@selector(setEvaluationDatafiled:)
                progressSelector:nil];
}

- (void)setEvaluationDataSuccessed:(NSDictionary *)response {
    [super hidenHUD];
    if ([DataCheck isValidArray:[response objectForKey:@"dialogList"]]) {
        indexNum = 2;
        if ([UserLoginModel isAverageUser]) {
            
            redEnvelopeDic = [[response objectForKey:@"dialogList"] objectAtIndex:0];
            if ([[redEnvelopeDic objectForKey:@"packets"] integerValue] > 0) {
                //发红包
                [self showRedEnveiopeView];
                return;
            }
             [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self getEvaluationDataRequest];
        }
    }
}

- (void)setEvaluationDatafiled:(NSDictionary *)response {
    [SRMessage infoMessage:[response objectForKey:@"msg"]];
    [super hidenHUD];
    evaluationBtn.enabled = YES;
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
