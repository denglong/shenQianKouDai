 //
//  CYViewController.m
//  Custom 3D Demo
//
//  Created by eqbang on 16/2/18.
//  Copyright © 2016年 eqbang. All rights reserved.
//

#import "CYShopCartingViewController.h"
#import "CommodityDetailsViewController.h"
#import "HomeViewController.h"
#import "CYCartGoodsModel.h"
#import "CYCartInfoModel.h"
#import "ShopCartTableViewCell.h"
#import "transferGoodsCell.h"

#define TYPE_EDITGOODS  @"1"//增删商品的数量
#define TYPE_DELECELL  @"2"//删掉整个商品
typedef enum{kGoodsNumDecade = -1,kGoodsNumKeep,kGoodsNumUp} goodsNumTrend;
typedef void(^deleteGoodsLayoutBlock)();
typedef void(^clearGoodsLayoutBlock)();

@interface CYShopCartingViewController ()<UITableViewDelegate,UITableViewDataSource,reloadDelegate,
                                        ShopCartCellDelegate,UIViewControllerTransitioningDelegate,transferGoodsCellDelegate>

/** 数据请求对象 */
@property (nonatomic,retain) CloudClient *cloudClient;
/** goodsTabelview */
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
/** 购物车被清空页面 */
@property (nonatomic , weak) IBOutlet UIView *noGoodsView;
/** 进入购物车购物车为空的页面 */
@property (weak, nonatomic) IBOutlet UIView *emptyShoppingCart;
/** 运费信息label */
@property (weak, nonatomic) IBOutlet UILabel *diffPriceLabel;
/** 总价 */
@property (nonatomic , strong) IBOutlet UILabel  *totalGoodsPriceLabel;
/** 货物总数量 */
@property (weak, nonatomic) IBOutlet UIButton *totalGoodsNumberButton;
/** 去下单按钮 */
@property (weak, nonatomic) IBOutlet UIButton *creatOrderButton;
/** 清空购物车按钮 */
@property (weak, nonatomic) IBOutlet UIButton *clearShoppingCartButton;
/** button */
@property (nonatomic , strong) UIButton *button;
/** 无网页面 */
@property (nonatomic , strong) UIView *noNetWork;
/** 教学页 */
@property (nonatomic , strong) UIWindow *studyWindow;
/** 购物车信息 */
@property (nonatomic , strong) NSMutableArray *cartInfoArray;
/** 购物车信息汇总数组 */
@property (nonatomic , strong) NSMutableArray *infoArray;
/** 商品模型数组 */
@property (nonatomic , strong) NSMutableArray *goodsArray;
/** 编辑操作需要上传的参数 */
@property (nonatomic,copy) NSString *mySettlement;
/** 结算返回字典 */
@property (nonatomic,retain) NSDictionary   *settlementDic;
/** 回调之后layoutsubviews */
@property (nonatomic , strong) deleteGoodsLayoutBlock layOutBlok;
/** 清空仅有一个商品的购物车之后回调 */
@property (nonatomic , strong) clearGoodsLayoutBlock clearBlock;
/** 是否是删除了一个商品 */
@property (nonatomic,assign,getter=isDeleteGoods) BOOL deleteGoods;
/** toHome */
@property (nonatomic,assign) BOOL toHome;
/** 菊花 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
/** 正在下单中Label */
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
/** force */
@property (nonatomic,copy) NSString *force;

@end

@implementation CYShopCartingViewController


#pragma mark - view生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [MobClick event:Clik_ShopingCart];
    
    [self setUpTabelview];
    
    [self setUpInitial];
    
    self.transitioningDelegate = self;
    
    self.modalPresentationStyle =  UIModalPresentationCustom;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 友盟统计
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    if (![UserLoginModel isLogged]) {
    
        [[AppModel sharedModel] presentLoginController:self];
        
        return;
    }
    
    self.view.frame = CGRectMake( 0, [UIScreen mainScreen].bounds.size.height - self.height,
                                     [UIScreen mainScreen].bounds.size.width, self.height);
    [self requestShopInfo];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [self.myTableview reloadData];
    
    self.studyWindow.hidden = YES;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 初始化设置
- (void)setUpInitial
{
    _cloudClient=[CloudClient getInstance];
    
    self.noGoodsView.hidden = YES;
    self.emptyShoppingCart.hidden = YES;
    self.noGoodsView.backgroundColor = [UIColor whiteColor];
    
    self.creatOrderButton.backgroundColor = [UIColor_HEX colorWithHexString:@"#ffe100"];
    [self.creatOrderButton setTitleColor:[UIColor colorWithWhite:0.196 alpha:1.000] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissSelf)
                                                 name:NOTIFICATION_LOGINCANCEL
                                               object:nil];
    
    self.activityIndicator.hidden = YES;
    
    self.creatOrderButton.enabled = YES;
    
    self.stateLabel.hidden = YES;
    
    [self.creatOrderButton setTitle:@"正在生成订单" forState:UIControlStateDisabled];
}

- (void)setUpTabelview
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableview.dataSource = self;
    self.myTableview.delegate = self;
    self.myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor= [UIColor clearColor];
    
    self.myTableview.backgroundColor=[UIColor clearColor];
    
    [self.myTableview registerNib:[UINib nibWithNibName:@"ShopCartTableViewCell"
                                                    bundle:nil]
              forCellReuseIdentifier:CYCartCellIdentifier];
    
    [self.myTableview registerNib:[UINib nibWithNibName:@"transferGoodsCell"
                                                    bundle:nil]
              forCellReuseIdentifier:CYTransferGoodsCellIdentifier];
    
    [self.myTableview registerNib:[UINib nibWithNibName:@"ShopCartTableViewCell"
                                                    bundle:nil]
              forCellReuseIdentifier:CYUnshelveGoodsCellIdentifier];

}

/**
 *  dismiss
 *
 *  @param sender
 */
//- (IBAction)dismissButtonClick:(UIButton *)sender
//{
//    [self dismissSemiModalView];
//}


#pragma mark - 懒加载

- (NSMutableArray *)cartInfoArray
{
    if (_cartInfoArray == nil)
    {
        _cartInfoArray = [NSMutableArray array];
    }
    
    return _cartInfoArray;
}

- (NSMutableArray *)infoArray
{
    if (_infoArray == nil)
    {
        _infoArray = [NSMutableArray array];
    }
    
    return _infoArray;
}

- (NSMutableArray *)goodsArray
{
    if (_goodsArray == nil)
    {
        _goodsArray = [NSMutableArray array];
    }
    
    return _goodsArray;
}

#pragma mark - 购物车数据请求相关
/**
 *  请求购物车信息
 */
-(void)requestShopInfo{
    if ([self noNetwork]) {
        return;
    }
    
    NSDictionary *paramsDic=@{};
    
    [_cloudClient requestMethodWithMod:@"cart/getCartInfo"
                                params:nil
                            postParams:paramsDic
                              delegate:self
                              selector:@selector(requestCartInfoSuccess:)
                         errorSelector:@selector(requestCartInfoFail:)
                      progressSelector:nil];
}

/**
 *  请求购物车数据成功
 *
 *  @param response 返回参数
 */
-(void)requestCartInfoSuccess:(NSDictionary*)response{
    
    [response writeToFile:@"/Users/eqbang/Desktop/进入购物车的数据.plist" atomically:NO];
    
    self.cartInfoArray = [[response objectForKey:@"goodsList"] mutableCopy];
    
    ShoppingCartModel *cartModel = [ShoppingCartModel shareModel];
    
    if ([DataCheck isValidArray:[response objectForKey:@"goodsList"]]) {
        
        cartModel.shopInfos = response[@"goodsList"];
        
        // 购物车商品模型数组
        self.goodsArray = [CYCartGoodsModel mj_objectArrayWithKeyValuesArray:self.cartInfoArray];
        
        // 购物车信息模型数组
        self.infoArray = [CYCartInfoModel mj_objectArrayWithKeyValuesArray:@[response[@"cartInfo"]]];
        
        [self updateShoppingCartInfo:self.infoArray.firstObject];

        [self.myTableview reloadData];
        
        self.noGoodsView.hidden=YES;
        self.emptyShoppingCart.hidden = YES;
    }
    // 购物车中没有货物
    else{
        self.noGoodsView.hidden=YES;
        self.emptyShoppingCart.hidden = NO;
        self.cartInfoArray = [NSMutableArray array];
        self.diffPriceLabel.text = nil;
        NSDictionary *cartInfo=@{@"cartNumber":@0,@"cartPrice":@0,@"cartShipping":@""};
        [cartModel updateShoppingCartInfo:cartInfo];
        cartModel.shopInfos = [NSArray array];
    }
    
}

// 刷新失败之后，隐藏HUD
-(void)requestCartInfoFail:(NSDictionary*)response
{
    
}

- (void)updateShoppingCartInfo:(CYCartInfoModel *)cartInfoModel
{
    NSString *totalAcountString = [NSString stringWithFormat:@"合计:￥%.2f",cartInfoModel.cartPrice];
    
    NSMutableAttributedString *attributeTotalAcountString = [[NSMutableAttributedString alloc] initWithString:totalAcountString];
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    
    attribute[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.000 alpha:0.600];
    
    [attributeTotalAcountString setAttributes:attribute range:[totalAcountString rangeOfString:@"合计:"]];
    // 合计
    self.totalGoodsPriceLabel.attributedText = attributeTotalAcountString;
    
    [self.totalGoodsNumberButton setTitle:[NSString stringWithFormat:@"%zd件",cartInfoModel.cartNumber]
                                 forState:UIControlStateNormal];
    self.diffPriceLabel.text = cartInfoModel.cartShipping;
}


#pragma mark - 无网相关页面
//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        self.noNetWork = [NoNetworkView sharedInstance].view;
        [NoNetworkView sharedInstance].backgroundViewColor = [UIColor whiteColor];
        
        self.noNetWork.frame = CGRectMake(0,
                                          28,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height + CYShoppingCartMenuHeight);
        self.noNetWork.hidden = NO;
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:self.noNetWork];
        
        return YES;
    }
    else
    {
        [self.noNetWork removeFromSuperview];
        return NO;
    }
}


/**
 *  重新加载按钮点击
 */
-(void)reloadAgainAction{

    [self requestShopInfo];
}


/**
 *  是否没网
 *
 *  @return
 */
-(BOOL)isNotNetwork{
    
    BOOL isExistenceNetwork = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = YES;
            
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = NO;
            
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = NO;
            
            break;
    }
    
    return isExistenceNetwork;
}



#pragma mark - tableviewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  CYGoodsSectionHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cartInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        //TODO:后边将逻辑改变为先判断是否下架，在判断sellType
        CYCartGoodsModel *model = self.goodsArray[indexPath.row];
        
        // 活动商品 换购、限购
        if (model.sellType == 1 || model.sellType == 3)
        {
            CYCartGoodsModel *model = self.goodsArray[indexPath.row];
            
            transferGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CYTransferGoodsCellIdentifier];
            // 添加tag
            [cell setGoodsButtonTag:indexPath.row];

            cell.goodsModel = model;
            
            cell.delegate = self;
            
            return cell;
        }
        //正常商品
        else
        {
            // 判断商品是否下架，没下架是一种cell，下架用另外一种cell复用标识
            if (model.unshelve == 0)
            {
                CYCartGoodsModel *model = self.goodsArray[indexPath.row];
                ShopCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CYCartCellIdentifier];
                cell.buttonTag = indexPath.row;
                cell.model = model;
                cell.delegate = self;
                return cell;
            }
            // 下架
            else
            {
                ShopCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CYUnshelveGoodsCellIdentifier];
                
                CYCartGoodsModel *model = self.goodsArray[indexPath.row];
                cell.buttonTag = indexPath.row;
                cell.model = model;
                cell.delegate = self;
                return cell;
            }
        }
  }

#pragma mark - tableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 购物车不再跳转商品详情
    NSLog(@"%zd",indexPath.row);
}

#pragma mark - 编辑tableview
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self editGoodsWithSender:indexPath.row goodsNumSerial:kGoodsNumKeep];
    
    
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                      title:@"删除"
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                        
                                                                        [self editGoodsWithSender:indexPath.row
                                                                                   goodsNumSerial:kGoodsNumKeep];
                                                                        
                                                                    }];
    
    delete.backgroundColor = [UIColor_HEX colorWithHexString:@"ff5a1e"];
    
    return @[delete];
}


#pragma mark - 教学页
- (void)setUpStudyview
{
    
    BOOL isNeedStudyView = [[NSUserDefaults standardUserDefaults] boolForKey:@"NEWVERSION"];
    
    if (isNeedStudyView == YES && [UserLoginModel isLogged])
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        self.studyWindow = window;
        
        window.windowLevel = UIWindowLevelAlert;
        
        window.hidden = NO;
        
        window.backgroundColor = [UIColor blackColor];
        
        window.alpha = 0.8;
        
        // 中间图片
        UIImageView *leftSlide = [[UIImageView alloc] init];
        
        leftSlide.image = [UIImage imageNamed:@"购物车-教学页_07"];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat height = self.view.height *0.25;
        
        CGFloat leftSliderY = [UIScreen mainScreen].bounds.size.height * 0.5 - height;
        
        leftSlide.frame = CGRectMake(0, leftSliderY, width, height);
        
        [window addSubview:leftSlide];
        
        
        // 做滑可以删除文字
        UIImageView *slider = [[UIImageView alloc] init];
        
        slider.image = [UIImage imageNamed:@"购物车-教学页_03"];
        
        CGFloat sliderWidth =210;
        
        CGFloat sliderHeight = 45;
        
        CGFloat sliderX = (width - sliderWidth)*0.5;
        
        CGFloat sliderY = leftSlide.y - 50;
        
        slider.frame = CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight);
        
        [window addSubview:slider];
        
        // 知道了按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:@"首页-教学页_05"] forState:UIControlStateNormal];
        
        CGFloat buttonWidth  = 110;
        
        CGFloat buttonHeight = 60;
        
        CGFloat buttonX = ([UIScreen mainScreen].bounds.size.width - buttonWidth)*0.5;
        
        CGFloat buttonY= CGRectGetMaxY(leftSlide.frame) + 62;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        
        [window addSubview:button];
        
        [button addTarget:self
                   action:@selector(dismissStudyWindow)
         forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        self.studyWindow.hidden = YES;
    }
}

- (void)dismissStudyWindow
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.studyWindow.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NEWVERSION"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
}





#pragma mark - ShopCartCellDelegate

//添加商品方法
-(void)addGoodsAction:(UIButton *)sender{
     [self editGoodsWithSender:sender.tag goodsNumSerial:kGoodsNumUp];
}


//删除商品方法
-(void)deleteGoodsAction:(UIButton *)sender{
     [self editGoodsWithSender:sender.tag goodsNumSerial:kGoodsNumDecade];
    
}


- (void)editGoodsWithSender:(NSInteger)sender goodsNumSerial:(goodsNumTrend)goodsNumberTrend
{
    NSMutableDictionary *currentDic= [[self.cartInfoArray objectAtIndex:sender] mutableCopy];
    
    int goodsNumber=[[currentDic objectForKey:@"goodsNumber"] intValue];
    NSString *goodsNumStr=[NSString stringWithFormat:@"%d",goodsNumber + goodsNumberTrend];
    
    int goodsId=[[currentDic objectForKey:@"goodsId"] intValue];
    NSString *goodsIdStr=[NSString stringWithFormat:@"%d",goodsId];
    
    if(goodsNumberTrend != 0)
    {
        self.mySettlement = @"1";
        
        // 减少商品数量
        if (goodsNumber>1 && goodsNumberTrend == -1) {
            [self editCartType:TYPE_EDITGOODS goodsId:goodsIdStr number:goodsNumStr];
        }
        // 商品数量已经为1并且继续点击减号
        else if (goodsNumber == 1 && goodsNumberTrend == -1)
        {
            [SRMessage infoMessage:@"你确定不要我了么？" block:^{
                
                [self editCartType:TYPE_DELECELL goodsId:goodsIdStr number:goodsNumStr];
                
                self.deleteGoods = YES;
            }];
            
            
            __weak __typeof (self) weakSelf = self;
            self.layOutBlok = ^(){
                [UIView animateWithDuration:0.5 animations:^{
                    NSInteger goodsCount = weakSelf.goodsArray.count ;
                    CGFloat height = goodsCount *CYGoodsSectionHeight + CYShoppingCartMenuHeight;
                    if (height >= [UIScreen mainScreen].bounds.size.height *0.9)
                    {
                        weakSelf.view.height = [UIScreen mainScreen].bounds.size.height *0.9;
                    }else{
                        weakSelf.view.frame = CGRectMake(0,
                                                         [UIScreen mainScreen].bounds.size.height - height,
                                                         [UIScreen mainScreen].bounds.size.width,
                                                         height);
                        
                    }
    
                    [weakSelf.view layoutIfNeeded];

                }];
  
            };
        }
        // 商品数量增加
        else if(goodsNumberTrend == 1)
        {
            [self editCartType:TYPE_EDITGOODS goodsId:goodsIdStr number:goodsNumStr];
        }
    }
    // 左滑删除商品
    else
    {
        [self editCartType:TYPE_DELECELL goodsId:goodsIdStr number:goodsNumStr];
        self.deleteGoods = YES;
        
        __weak __typeof (self) weakSelf = self;
        self.layOutBlok = ^(){
            [UIView animateWithDuration:0.5 animations:^{
                NSInteger goodsCount = weakSelf.goodsArray.count ;
                CGFloat height = goodsCount *CYGoodsSectionHeight + CYShoppingCartMenuHeight;
                if (height >= [UIScreen mainScreen].bounds.size.height *0.9)
                {
                    weakSelf.view.height = [UIScreen mainScreen].bounds.size.height *0.9;
                    
                }else{
                    weakSelf.view.frame = CGRectMake(0,
                                                     [UIScreen mainScreen].bounds.size.height - height,
                                                     [UIScreen mainScreen].bounds.size.width,
                                                     height);
                    
                }
                
                [weakSelf.view layoutIfNeeded];
            }];
            
        };
    }
}

#pragma mark - transferCartCellDelegate
- (void)specialGoodsDeleteAction:(UIButton *)button
{
    [self editGoodsWithSender:button.tag goodsNumSerial:kGoodsNumDecade];
}


#pragma mark - 编辑购物车
/**
 *  编辑购物车
 *
 *  @param editType 编辑类型
 *  @param goodsId  商品ID
 *  @param number   商品数量
 */
-(void)editCartType:(NSString *)editType goodsId:(NSString *)goodsId number:(NSString *)number{
    
    if (!self.mySettlement) {
        self.mySettlement = @"1";
    }
    
    NSDictionary *paramsDic=@{@"type":editType,
                              @"goodsId":goodsId,
                              @"number":number,
                              @"settlement":self.mySettlement};
    
    [_cloudClient requestMethodWithMod:@"cart/editCart"
                                params:nil
                            postParams:paramsDic
                              delegate:self
                              selector:@selector(editSuccess:)
                         errorSelector:@selector(editFail:)
                      progressSelector:nil];
}

// 成功
-(void)editSuccess:(NSDictionary*)response{
    
    [response writeToFile:@"/Users/eqbang/Desktop/44444.plist" atomically:YES];
    
    self.infoArray = [CYCartInfoModel mj_objectArrayWithKeyValuesArray:@[response[@"cartInfo"]]];
    ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
    // 多件商品删除其中某件的时候，还有剩余商品
    if ([DataCheck isValidArray:[response objectForKey:@"goodsList"]]) {
        
        self.cartInfoArray=[[response objectForKey:@"goodsList"] mutableCopy];
        self.goodsArray = [CYCartGoodsModel mj_objectArrayWithKeyValuesArray:response[@"goodsList"]];
        cartModel.shopInfos = self.cartInfoArray;
        
        if (self.isDeleteGoods == YES)
        {
            if (self.layOutBlok)
            {
                self.layOutBlok();
                self.deleteGoods = NO;
                
//                [self updateDismissButtonHeight:CYGoodsSectionHeight];
            }
        }
        [self.myTableview reloadData];
        
    }
    // 有且只有一件商品，删除完成之后，直接变成没有商品的情况
    else {
        self.cartInfoArray=[NSMutableArray array];
        cartModel.shopInfos = [NSArray array];
        [self.myTableview reloadData];
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y - 10,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height + 10);
        
        [self.view layoutIfNeeded];
        self.noGoodsView.hidden = NO;
        self.emptyShoppingCart.hidden = YES;
    }

    
    //更新购物车数据
    NSDictionary *cartInfo = response[@"cartInfo"];
    [cartModel updateShoppingCartInfo:cartInfo];
    [self updateShoppingCartInfo:self.infoArray.firstObject];
    
}

// 编辑失败
-(void)editFail:(NSDictionary*)response{
    
    
}


#pragma mark - 清空购物车（批量删除）相关

// 点击清空购物车按钮
- (IBAction)cleanShoppingCartButtonClick:(UIButton *)sender {
    
    NSMutableArray *goodssIdArray = [NSMutableArray array];
    
    for (int i = 0; i <self.cartInfoArray.count; i++)
    {
        [goodssIdArray addObject:[self.cartInfoArray[i] objectForKey:@"goodsId"]];
    }
    
    __weak __typeof (self) weakSelf = self;
    if (goodssIdArray.count == 1)
    {
        self.clearBlock = ^{
            weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x,
                                             weakSelf.view.frame.origin.y - 10,
                                             weakSelf.view.frame.size.width,
                                             weakSelf.view.frame.size.height + 10);
            [weakSelf.view layoutIfNeeded];
        };
    }
    
    [SRMessage infoMessage:@"是否清空购物车？"
                     title:@"温馨提示"
               cancelTitle:@"再想想"
                 sureTitle:@"确认删除"
                     block:^{
        
        [weakSelf deleteCartType:goodssIdArray];
        
    } cancleBlock:^{
        
        [weakSelf requestShopInfo];
    }];
    
    
}

// 清空购物车
-(void)deleteCartType:(NSArray *)goodIds{
    
    NSDictionary *paramsDic=@{@"goodsId":goodIds};
    
    [_cloudClient requestMethodWithMod:@"cart/delete"
                                params:nil
                            postParams:paramsDic
                              delegate:self
                              selector:@selector(deleteCartSuccess:)
                         errorSelector:@selector(deleteCartFail:)
                      progressSelector:nil];
}

// 成功清空
-(void)deleteCartSuccess:(NSDictionary*)response{
    
        //将购物车中所有商品清空
        self.cartInfoArray = [NSMutableArray array];
        // 更新购物车中的数据
    
        // 刷新购物车
        [self.myTableview reloadData];
        if (self.clearBlock)
        {
        self.clearBlock();
        }
        self.noGoodsView.hidden = NO;
        self.emptyShoppingCart.hidden = YES;
    
        // 购物车信息模型数组
        self.infoArray = [CYCartInfoModel mj_objectArrayWithKeyValuesArray:@[response[@"cartInfo"]]];
        NSDictionary *cartInfo = response[@"cartInfo"];
    
        //更新购物车数据（防止别的地方需要使用购物车的信息）
        ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
        [cartModel updateShoppingCartInfo:cartInfo];
        cartModel.shopInfos = [NSArray array];
    
        // 购物车本身的购物车信息
        [self updateShoppingCartInfo:self.infoArray.firstObject];
}

// 失败的删除
-(void)deleteCartFail:(NSDictionary*)response{
    
    
}

#pragma -mark 结算购物车
 
- (IBAction)creatOrderButtonClick:(UIButton *)sender
{
    self.activityIndicator.hidden = NO;
    
    [self.activityIndicator startAnimating];
    
    [self.creatOrderButton setTitle:@"" forState:UIControlStateNormal];
    
    self.stateLabel.hidden = NO;
    
    self.stateLabel.textColor = [UIColor colorWithWhite:0.196 alpha:1.000];
    
//    NSLog(@"%@",self.creatOrderButton.titleLabel.text);                     
    
    self.force = @"0";
    
    [self settlementShoppingCart];
}


-(void)settlementShoppingCart{
    
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
//    [super showHUD];
    
    ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
    
    
    NSDictionary *paramsDic=@{@"goodsList":self.cartInfoArray,
                              @"totalPrice":cartModel.goodsNum,
                              @"couponId":@"0",
                              @"force":self.force
                              };
    
    [_cloudClient requestMethodWithMod:@"order/flow"
                                params:nil
                            postParams:paramsDic
                              delegate:self
                              selector:@selector(settlementSuccess:)
                         errorSelector:@selector(settlementFail:)
                      progressSelector:nil];
}

//成功
-(void)settlementSuccess:(NSDictionary *)response{
//    [super hidenHUD];
    if ([DataCheck isValidDictionary:response]) {
        
        self.settlementDic = [[NSDictionary alloc] initWithDictionary:response];
        
    }
    // 传值
    if ([self.delegate respondsToSelector:@selector(gotoBuy)])
    {
//        [self dismissSemiModalView];
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.passOrderInfo)
        {
            self.passOrderInfo(self.settlementDic);
        }
        
        self.myTableview.userInteractionEnabled = NO;
        
        
        [self.delegate gotoBuy];
    }
}
//失败
-(void)settlementFail:(NSDictionary *)response{
//    [super hidenHUD];
    [self.activityIndicator stopAnimating];
    
    self.activityIndicator.hidden = YES;
    
    self.stateLabel.hidden = YES;
    
    self.creatOrderButton.enabled = YES;
    
    [self.creatOrderButton setTitle:@"去下单" forState:UIControlStateNormal];
    
    [self.creatOrderButton setTitleColor:[UIColor colorWithWhite:0.196
                                                           alpha:1.000]
                                forState:UIControlStateNormal];
    
    NSString *message = (NSString *)response[@"msg"];
    
    
    if ([message isEqualToString:@"您的账号在另一台设备登录。如非本人操作，请修改密码。"])
    {
        return;
    }else
    {
        __weak __typeof (self) weakSelf = self;
        
        if ([message isEqualToString:@"购物车没有商品"])
        {
            [SRMessage infoMessageOk:message block:^{
                [weakSelf requestShopInfo];
            }];
        }else
        {
            [SRMessage infoMessage:message
                             title:@"温馨提示"
                       cancelTitle:@"再想想"
                         sureTitle:@"去下单"
                             block:^{
                                 
                                 weakSelf.force = @"1";
                                 
                                 [weakSelf settlementShoppingCart];
                                 
                                 self.activityIndicator.hidden = NO;
                                 
                                 [self.activityIndicator startAnimating];
                                 
                                 [self.creatOrderButton setTitle:@""
                                                        forState:UIControlStateNormal];
                                 
                                 self.stateLabel.hidden = NO;
                                 
                                 
                             } cancleBlock:^{
                                 [weakSelf requestShopInfo];
                             }];
            
        }
    }
}


- (void)dismissSelf
{
//    [self dismissSemiModalView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
