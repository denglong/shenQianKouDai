//
//  BusinessInfoViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/12/23.
//  Copyright © 2015年 king. All rights reserved.
//

#import "BusinessInfoViewController.h"
#import "BusinessInfoCell.h"
#import "BusinessInfoHeaderCell.h"
#import "DLStarRageView.h"
#import "BusinessInfo.h"
@interface BusinessInfoViewController ()<UITableViewDataSource,UITableViewDelegate,reloadDelegate>
{
    /**无网页面*/
    UIView * noNetWork;
    /**请求对象*/
    CloudClient * _cloudClient;
    BusinessInfo * businessInfoModel;
}
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**头部view*/
@property (weak, nonatomic) IBOutlet UIView *headerView;
/**店主图像*/
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
/**店铺名称*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**已完成订单数*/
@property (weak, nonatomic) IBOutlet UILabel *finishedOrderNumLabel;

/**账户信息页下商家评级 */
@property (weak, nonatomic) IBOutlet UIView *shopAllGradeView;
/**账户信息页下的商家不是评级系统提示 */
@property (weak, nonatomic) IBOutlet UILabel *isNOtGradeZoneLabel;
/**账户信息页下的商家评级数 */
@property (weak, nonatomic) IBOutlet DLStarRageView *userAllGradeStar;
/**账户信息页下的商家本周接单量 */
@property (weak, nonatomic) IBOutlet UILabel *weakNumLabel;
/**账户信息页下的商家本周接单率 */
@property (weak, nonatomic) IBOutlet UILabel *weekRateLabel;
/**送货速度 */
@property (weak, nonatomic) IBOutlet DLStarRageView *sendSpeedStar;
/**商家匹配 */
@property (weak, nonatomic) IBOutlet DLStarRageView *shopAccouplementAtar;
/**商家态度 */
@property (weak, nonatomic) IBOutlet DLStarRageView *shopMannerStar;
/** 商户接单率约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopInfoConstant;

/**店铺主页下的评价列表*/
@property (weak, nonatomic) IBOutlet UITableView *BusinessInfotableView;
/**账户信息页具体评价等级view*/
@property (strong, nonatomic) IBOutlet UIView *BusinessInfoHeaderView;
/**店铺详情页下的具体评价等级view*/
@property (strong, nonatomic) IBOutlet UIView *shopInfoHeaderView;

/**点评部分*/
@property (weak, nonatomic) IBOutlet UIView *BottomView;
/**无点评时空界面*/
@property (weak, nonatomic) IBOutlet UIButton *nullBTn;



@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

- (IBAction)phoneAction:(UIButton *)sender;
- (IBAction)businessBackAction:(UIButton *)sender;

@end

@implementation BusinessInfoViewController
#pragma mark - 无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        [super hidenHUD];
        return YES;
    }
    else
    {
        [noNetWork removeFromSuperview];
        return NO;
    }
}

-(void)reloadAgainAction
{
    [super showHUD];
    [self getMyInfoData];
    
}

#pragma mark - 数据请求以及页面赋值
/**获取个人资料详情*/
-(void)getMyInfoData
{
    if ([self noNetwork]) {
        return;
    }
    if ([DataCheck isValidString:self.shopId]) {
        [_cloudClient requestMethodWithMod:@"shop/getShopInfo"
                                    params:nil
                                postParams:@{@"shopId":self.shopId}
                                  delegate:self
                                  selector:@selector(getMyInfoSuccessed:)
                             errorSelector:@selector(getMyInfoError:)
                          progressSelector:nil];
  
    }else{
        [_cloudClient requestMethodWithMod:@"shop/getShopInfo"
                                    params:nil
                                postParams:nil
                                  delegate:self
                                  selector:@selector(getMyInfoSuccessed:)
                             errorSelector:@selector(getMyInfoError:)
                          progressSelector:nil];
    }
    
}
-(void)getMyInfoSuccessed:(NSDictionary *)response
{
    [super hidenHUD];
    businessInfoModel = [BusinessInfo mj_objectWithKeyValues:response];
    
    [self refreshView];
//    [self.BusinessInfotableView reloadData];
}
-(void)getMyInfoError:(NSDictionary *)response
{
    [super hidenHUD];
}


/**
 * Method name: refreshView
 * Description: 页面赋值
 * Parameter: nil
 * Parameter: nil
 */

-(void)refreshView
{
    [self.headerImageView setImageWithURL:[NSURL URLWithString:businessInfoModel.imgUrl] placeholderImage:[UIImage imageNamed:@"ShopImage"]];
    if ([businessInfoModel isCheck] == 1) {
        // NSTextAttachment - 附件
        NSTextAttachment *attachMent = [[NSTextAttachment alloc] init];
        // 为附件设置图片
        attachMent.image = [UIImage imageNamed: @"approve_img"];
        // 键附件添加到图文混排
        NSMutableAttributedString * nameStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ",businessInfoModel.name]];
        NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attachMent];
        [nameStr appendAttributedString:str];
        // 设置 label 内容
        self.nameLabel.attributedText = nameStr;
    }else{
        self.nameLabel .text = businessInfoModel.name;
    }
    self.finishedOrderNumLabel.text = [NSString stringWithFormat:@"已完成%ld单",(long)businessInfoModel.finishOrder];
    
    if (businessInfoModel.scoreDelivery == 0) {
        self.BottomView.hidden = YES;
        self.nullBTn.hidden = NO;
    }else{
        self.BottomView.hidden = NO;
        self.nullBTn.hidden = YES;
    }
    //用户评价
    [self.sendSpeedStar showStarRageAction:businessInfoModel.scoreDelivery];
    [self.shopAccouplementAtar showStarRageAction:businessInfoModel.scoreGoods];
    [self.shopMannerStar showStarRageAction:businessInfoModel.scoreService];
    //账户信息页商家星级部分
    if (![DataCheck isValidString:self.shopId]) {
         //商家星级评级
        if (businessInfoModel.shopLevel < 0) {
            self.userAllGradeStar .hidden = YES;
            self.isNOtGradeZoneLabel.hidden = NO;
        }else{
            [self.userAllGradeStar showStarRageAction:businessInfoModel.shopLevel];
        }
        self.weakNumLabel.text = [self.weakNumLabel.text stringByAppendingString:businessInfoModel.weekAcceptOrders];
        self.weekRateLabel.text = [self.weekRateLabel.text stringByAppendingString:businessInfoModel.weekAcceptRate];
    }

    
}

#pragma mark - view
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    if ([DataCheck isValidString:self.shopId]) {
        self.titleLabel.text = @"店铺详情";
    }else{
        self.titleLabel.text = @"账户信息";
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [super setExtraCellLineHidden:self.BusinessInfotableView];
//    [self registerTableViewCell];
//    self.HeaderBottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"businessInfoHeader"]];
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.height/2;
    self.headerImageView.layer.borderColor = [UIColor_HEX colorWithHexString:@"#6a3906"].CGColor;
    self.headerImageView.layer.borderWidth = 1;
    if ([DataCheck isValidString:self.shopId]) {
//        self.BusinessInfotableView.tableHeaderView = self.shopInfoHeaderView;
        self.shopAllGradeView.hidden = YES;
        self.shopInfoConstant.constant = 0;
        self.phoneBtn.hidden = NO;
//        self.navigationItem.rightBarButtonItem = [super createRightItem:self itemStr:nil itemImage:UIIMAGE(@"icon_phone") itemImageHG:nil selector:@selector(rightAction:)];
    }else{
//        self.BusinessInfotableView.tableHeaderView = self.BusinessInfoHeaderView;
        self.shopAllGradeView.hidden = NO;
       self.shopInfoConstant.constant = 56;
         self.phoneBtn.hidden = YES;
    }

    _cloudClient = [CloudClient getInstance];
    [super showHUD];
    [self getMyInfoData];
   
}

#pragma mark - 初始化
-(void)registerTableViewCell
{
    [self.BusinessInfotableView registerNib:[UINib nibWithNibName:@"BusinessInfoCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BusinessInfoCell class])];
    [self.BusinessInfotableView registerNib:[UINib nibWithNibName:@"BusinessInfoHeaderCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BusinessInfoHeaderCell class])];
}

/**
 * Method name: rightAction
 * Description: 店铺详情，拨打店主电话事件
 * Parameter: 点击对象
 * Parameter: nil
 */
- (void)rightAction:(id)sender {
    
//    phoneNum = [respData objectForKey:@"mobile"];
    
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return businessInfoModel.shopLabelList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if ([DataCheck isValidString:self.shopId]) {
            return 110;
        }
        return 160;
    }
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        BusinessInfoHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BusinessInfoHeaderCell class])];
        if ([DataCheck isValidString:self.shopId]) {
            cell.userAllGreadeLabel.hidden = YES;
            cell.theTotalRate.hidden = YES;
        }
        return cell;
    }
    BusinessInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BusinessInfoCell class])];
    if ([DataCheck isValidString:self.shopId]) {
        cell.complainBtn.hidden = YES;
    }else{
        cell.complainBtn.enabled = YES; //未申诉
        [cell.complainBtn addTarget:self action:@selector(commplainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.evalateInfo = [businessInfoModel.shopLabelList objectAtIndex:indexPath.section];
    return cell;
}

#pragma mark - 申诉按钮事件
-(void)commplainBtnClick:(UIButton *)sender
{
    sender.enabled = NO;
    sender.backgroundColor = RGB_COLOR(204, 204, 204);
    [SRMessage infoMessageWithTitle:nil message:@"已提交申诉"];
}
#pragma mark - 拨打用户电话
- (IBAction)phoneAction:(UIButton *)sender {
    //拨打用户电话
    [SRMessage infoMessage:[NSString stringWithFormat:@"是否拨打电话 %@?", businessInfoModel.mobile] block:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", businessInfoModel.mobile]]];
    }];

}
#pragma mark - 返回
- (IBAction)businessBackAction:(UIButton *)sender {
    [super backAction:sender];
     self.navigationController.navigationBarHidden = NO;
}
@end
