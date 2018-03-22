//
//  HomePageController.m
//  KingProFrame
//
//  Created by JinLiang on 15/6/26.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "HomePageController.h"

#import "HomePageCell.h"
#import "HomeGoodsCell.h"
#import "HomeHeaderCell.h"
#import "HomeCateoryCell.h"
#import "HomecollectionCell.h"
#import "HomeADCell.h"
#import "HomeModel.h"
#import "HeaderHurdleVIew.h"
#import "ShopBtnView.h"
#import "HomeApiModel.h"

#import "CYActivityView.h"
#import "CYMask.h"
#import "MessagePrompt.h"
#import "GeTuiSdk.h"
#import "MapLocation.h"
#import "MyPickerView.h"
#import "DLCollectionView.h"
#import "TempViewController.h"
#import "CYShopCartingViewController.h"
#import "OrderDetailViewController.h"
@interface HomePageController ()<CYActivityViewDelegate, reloadDelegate, counterClassDelegate, DLCollectionDelegate,CYShopCartingViewControllerDelegate, HomeApiDelegate>
{
    BOOL msgHidden;                       //订单消息是否显示
    BOOL showRegHidden;                  //是否是注册引导浮层
    BOOL isViewDidLoad;
    BOOL isRefHeader;
    BOOL isHidden;                      //订单助手是否显示
    BOOL isClickBtn;                    //是否点击助手按钮
    BOOL clickAddBtn;                   //是否点击地址选择
    BOOL isHiddenCity;                  //是否显示附近商家
    float oldOffset;                     //tableView历史offset
    NSInteger headerHeight;              //头部高度
    NSInteger helperViewHeight;          //订单助手高度
    NSInteger goodNum;                   //商品id
    NSInteger myState;                   //头部订单状态
    NSInteger cellHeight;               //腰部cell的高度
    NSString *headerMsg;                //顶部消息内容
    NSArray *labelModels;
    UIView *middleTableView;           //中间白线遮挡view
    UIView *upTableView;               //上面白线遮挡view
    BOOL animationFinish;              //加入购物车动画是否完成
    
    UIView *noNetWork;                   //无网页面
    UIView *redPoint;                    //红点
    UIView *headerView;                //tableView头部view

    HeaderHurdleVIew *headerHurdleView; //头部view
    ShopBtnView *shopBtnView;          //购物车按钮
    SGFocusImageFrame *bannerView;    //滚动广告
    DLCollectionView *myCollection;   //腰部活动view
    SGFocusImageFrame *sgFocus;
    HomeModel *homeModel;
    BannersModel *bannerModel;
    HotCategoriesModel *hotCategModel;
    labelListModel *labelModel;
    goodsListModel *goodsModel;
    ShoppingCartModel *cartModel;
    PinsModel *pinsModel;
    MyPickerView *pickView;
    HomeApiModel *apiModel;
}

/** 接收购物车提供的订单信息，下单用 */
@property (nonatomic , strong) NSDictionary *orderInfoDictionary;
@property (nonatomic, assign) BOOL isOut;//是否在当前controller
@property (nonatomic, assign) BOOL isClosedMsg; //是否关闭订单提示

@end

@implementation HomePageController
@synthesize myTableView, isOut, isClosedMsg;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    if ([UserLoginModel isAverageUser] && [UserLoginModel isLogged])
    {
        [cartModel getCartInfo];
    }
    
    if (isViewDidLoad == NO) {
        [self getHomeInfoRequest];
    }
    isViewDidLoad = NO;
    [self refrashRed];
    
    NSString *userImage = [[CommClass sharedCommon] objectForKey:@"USERIMAGE"];
    if ([DataCheck isValidString:userImage])
    {
        [headerHurdleView.leftImageView setImageWithURL:[NSURL URLWithString:userImage]
                                       placeholderImage:UIIMAGE(@"icon_homeLeft")];
        [[CommClass sharedCommon] setObject:@"" forKey:@"USERIMAGE"];
    }
    isOut = NO;
    
    if (![UserLoginModel isLogged]) {
        headerHurdleView.helperBtn.hidden = YES;
        headerHurdleView.frame = CGRectMake(0, 0, viewWidth, DEFAULTHEIGHT);
        headerHurdleView.searchView.frame = CGRectMake(0, 64, viewWidth, 36);
        headerHurdleView.msgHelperView.frame = CGRectMake(0, CGRectGetMaxY(headerHurdleView.addressView.frame), viewWidth, 0);
        headerHurdleView.msgHelperView.hidden = YES;
        if (helperViewHeight != 0) {
            [self showAndHiddenHelperView:nil];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    isOut = YES;
    msgHidden = NO;
    for (UIView *cyview in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([cyview isKindOfClass:[CYActivityView class]])
        {
            [cyview removeFromSuperview];
            break;
        }
    }
    [CYMask hidden];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([UserLoginModel isAverageUser] && [UserLoginModel isLogged])
    {
        [self orderLoopAction];
    }

    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"AUTODISMISS"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isViewDidLoad = YES;
    [self setupHeaderRefresh:myTableView];
    
    [self getUpdateTimeAction];
    [self showHUD];
    [self addHeaderViewAction];
    [self setUpTableViewRegist];
    
    cartModel=[ShoppingCartModel shareModel];
    
    apiModel = [HomeApiModel sharedInstance];
    apiModel.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newOrderNotigation:)
                                                 name:NEWORDER_UPDATINFO
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelOrderAction)
                                                 name:CANCELORDER_UPDATIONFO
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderStateAction)
                                                 name:NOTIFICATION_TIMEOUTORDER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoLocationAction:)
                                                 name:LOCATIONLATANDLNG
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeAddress:)
                                                 name:CHANGELOCATIONLATANDLNG
                                               object:nil];
    //红点通知
    if ([UserLoginModel isAverageUser])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redDian:) name:@"MyRed" object:nil];
    }
    
//    NSArray *addList = [[CommClass sharedCommon] localObjectForKey:AUTOLOCATIONADDRESS];
//    if (addList.count > 2) {
//        [headerHurdleView setMYAddressLabText:addList.lastObject];
//        [apiModel noShopAtNearbyAction:addList[1]];
//    }
//    else
//    {
//        [headerHurdleView setMYAddressLabText:@"西安小寨"];
//        [apiModel noShopAtNearbyAction:@{@"lat":@"34.22", @"lng":@"108.978 "}];
//    }
}

#pragma mark - 添加头部
- (void)addHeaderViewAction {
    headerHeight = DEFAULTHEIGHT;
    headerHurdleView = [[[NSBundle mainBundle] loadNibNamed:@"HeaderHurdleVIew" owner:self options:nil] firstObject];
    headerHurdleView.frame = CGRectMake(0, 0, viewWidth, headerHeight);
    [self.view addSubview:headerHurdleView];
    
    headerView = [headerHurdleView createTableViewHeaderView];
    headerView.frame = CGRectMake(0, 0, viewWidth, 0);
    headerView.hidden = YES;
    myTableView.tableHeaderView = headerView;
    middleTableView = [[UIView alloc] initWithFrame:CGRectZero];
    middleTableView.hidden = YES;
    [headerView addSubview:middleTableView];
    
    upTableView = [[UIView alloc] initWithFrame:CGRectZero];
    upTableView.hidden = YES;
    [headerHurdleView addSubview:upTableView];
    
    [headerHurdleView addViewAction];
    [headerHurdleView.myBtnClick addTarget:self action:@selector(goToMyViewControllerAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerHurdleView.helperBtn addTarget:self action:@selector(showAndHiddenHelperView:) forControlEvents:UIControlEventTouchUpInside];
    [headerHurdleView.clickHelper addTarget:self action:@selector(clickHelperAction) forControlEvents:UIControlEventTouchUpInside];
    [headerHurdleView.categoryBtn addTarget:self action:@selector(categoryViewBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerHurdleView.scanningBtn addTarget:self action:@selector(sweepBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerHurdleView.searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerHurdleView.addressClick addTarget:self action:@selector(toAddressViewAction) forControlEvents:UIControlEventTouchUpInside];
    [headerHurdleView.tableHbutton addTarget:self action:@selector(toAddressViewAction) forControlEvents:UIControlEventTouchUpInside];
    
    shopBtnView = [ShopBtnView shareShopBtnView];
    [shopBtnView addShopBtnAction];
    [shopBtnView.shopBtn addTarget:self action:@selector(goToShopCartAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shopBtnView];
}

#pragma mark - 跳转购物车
- (void)goToShopCartAction {
    DLog(@"点击了按钮");
    if (![UserLoginModel isLogged]) {
        [[AppModel sharedModel] presentLoginController:self];
        return;
    }
    CYShopCartingViewController *shoppingCartController = [[CYShopCartingViewController alloc]initWithNibName:@"CYShopCartingViewController" bundle:nil];
    
    shoppingCartController.passOrderInfo = ^(NSDictionary *dictionary){
        
        self.orderInfoDictionary = dictionary;
        
    };
    
    shoppingCartController.delegate = self;
    
    NSInteger cartGoodsNumber = cartModel.shopInfos.count;
    
    CGFloat height = CYGoodsSectionHeight * cartGoodsNumber + CYShoppingCartMenuHeight;
    
    if (cartGoodsNumber == 0) {
        height = CYEmptyShoppingCartHeight;
    }
    
    if (height >= [UIScreen mainScreen].bounds.size.height *0.9)
    {
        height = [UIScreen mainScreen].bounds.size.height *0.9;
    }
    
    shoppingCartController.height = height;
    
    [self presentSemiViewController:shoppingCartController
                        withOptions:@{
                                      KNSemiModalOptionKeys.pushParentBack : @(NO),
                                       KNSemiModalOptionKeys.parentAlpha : @(0.5)
                                     }
                        completion:nil
                       dismissBlock:^{
                                     [self.myTableView reloadData];
                           if ([cartModel.goodsNum integerValue] > 0)
                           {
                               if ([cartModel.goodsNum integerValue] > 99) {
                                   shopBtnView.goodsNumLab.text = [NSString stringWithFormat:@"···"];
                               }
                               else
                               {
                                   shopBtnView.goodsNumLab.text = [NSString stringWithFormat:@"%@", cartModel.goodsNum];
                               }
                           }else
                           {
                               shopBtnView.goodsNumLab.hidden = YES;
                           }
                           
                                     }];
    
    
}

#pragma mark - CYShopCartingViewControllerDelegate
// just for fun
- (void)gotoBuy
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CYShopCartingViewController class]]) {
            [controller removeFromParentViewController];
        }
    }
    
    ConfirmOrderController *confirmControll=[[ConfirmOrderController alloc]
                                             initWithNibName:@"ConfirmOrderController"
                                             bundle:nil];
    confirmControll.orderInfoDic=[[NSDictionary alloc]initWithDictionary:self.orderInfoDictionary];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:confirmControll animated:YES];
    });
    
}


- (void)orderStateAction {
    if ([UserLoginModel isAverageUser] && [UserLoginModel isLogged])
    {
        if (isClosedMsg == YES)
        {
            isClosedMsg = NO;
        }
        
        [self orderLoopAction];
    }
}

- (void)setUpTableViewRegist {
    [myTableView registerNib:[UINib nibWithNibName:@"HomePageCell" bundle:nil] forCellReuseIdentifier:@"HOMEPAGECELL"];
    [myTableView registerNib:[UINib nibWithNibName:@"HomeHeaderCell" bundle:nil] forCellReuseIdentifier:@"HOMEHEADERCELL"];
    [myTableView registerNib:[UINib nibWithNibName:@"HomeCateoryCell" bundle:nil] forCellReuseIdentifier:@"HOMECATEORYCELL"];
    [myTableView registerNib:[UINib nibWithNibName:@"HomeADCell" bundle:nil] forCellReuseIdentifier:@"HOMEADCELL"];
    [myTableView registerNib:[UINib nibWithNibName:@"HomeGoodsCell" bundle:nil] forCellReuseIdentifier:@"HOMEGOODSCELL"];
    [myTableView registerNib:[UINib nibWithNibName:@"HomecollectionCell" bundle:nil] forCellReuseIdentifier:@"HOMECOLLECTIONCELL"];
}

#pragma mark - 切换地址
- (void)toAddressViewAction {
    [MobClick event:Clik_SwitchAddr];
    
    if ([self isNotNetwork]) {
        return;
    }
    if ([[MapLocation sharedObject] isOpenLocal]) {
        NSDictionary *pointsDic = [[CommClass sharedCommon] localObjectForKey:AUTOLOCATIONADDRESS][1];
        AddressMapViewController * addressMapViewController = [[AddressMapViewController alloc]init];
        addressMapViewController.isSwitchCity = YES;
        addressMapViewController.pointsDic = pointsDic;
        addressMapViewController.delegate = self;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressMapViewController animated:YES];
        return;
    }
    else{
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"定位失败"
                                                      message:@"请手动开启定位服务"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        return;
    }
}

#pragma mark - 下单选择地址 若地址换城市执行
-(void)changeAddress:(id)not
{
    NSString * address = (NSString *)[not object];
    [self getAddress:address];
}
#pragma mark - 首页选择地址后回调
-(void)getAddress:(NSString *)address {
    NSDictionary *locationAddress = [[CommClass sharedCommon] objectForKey:LocationAddress];
    NSDictionary *parms = nil;
    id location = [locationAddress objectForKey:@"location"];
    if ([[location class] isSubclassOfClass:[AMapGeoPoint class]]) {
        AMapGeoPoint * location = [locationAddress objectForKey:@"location"];
        parms = @{@"lat":[NSString stringWithFormat:@"%f",location.latitude], @"lng":[NSString stringWithFormat:@"%f",location.longitude]};
    }else{
        CLLocation * location = [locationAddress objectForKey:@"location"];
        parms = @{@"lat":[NSString stringWithFormat:@"%f",location.coordinate.latitude], @"lng":[NSString stringWithFormat:@"%f",location.coordinate.longitude]};
    }
    
    NSString *cityCode = [locationAddress objectForKey:@"cityCode"];
    NSArray *addList = @[cityCode, parms, [locationAddress objectForKey:@"address"]];
    [[CommClass sharedCommon] localObject:addList forKey:AUTOLOCATIONADDRESS];
    if (addList.count > 2 && [DataCheck isValidString:addList.lastObject]) {
        [headerHurdleView setMYAddressLabText:addList.lastObject];
    }
    else
    {
        [headerHurdleView setMYAddressLabText:address];
    }
    
//    [apiModel noShopAtNearbyAction:parms];
    if ([UserLoginModel isLogged]) {
        [self getCartTotalData];
    }
}

#pragma mark - 头部搜索
- (void)searchBtnAction {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark - 二维码扫描
- (void)sweepBtnAction {
    [MobClick event:Clik_Scan];
    TempViewController *temp = [[TempViewController alloc] init];
    [self.navigationController pushViewController:temp animated:true];
}

#pragma mark - 推送红点显示
-(void)redDian:(NSNotification *)not
{
    NSString * msgType = [not object];
    headerHurdleView.redPoint.hidden = NO;
    if ([msgType integerValue] == 510)
    {
        [[CommClass sharedCommon] setObject:@"YES" forKey:COUPONRED];
        return;
    }
    
    if ([msgType integerValue] == 600)
    {
        [[CommClass sharedCommon] setObject:@"YES" forKey:EBEANRED];
        return;
    }
}

#pragma mark - 查看后红点显示情况刷新
-(void)refrashRed
{
    if ([UserLoginModel isAverageUser])
    {
        NSString * couponRed =[[CommClass sharedCommon] objectForKey:COUPONRED];
        NSString * eBeanRed =[[CommClass sharedCommon] objectForKey:EBEANRED];
        if ([couponRed isEqualToString:@"YES"] || [eBeanRed isEqualToString:@"YES"])
        {
            headerHurdleView.redPoint.hidden = NO;
        }
        else
        {
            headerHurdleView.redPoint.hidden = YES;
        }
    }
}

#pragma mark - 创建广告轮播图
- (void)adCreate {
    NSMutableArray *advPics = [NSMutableArray array];
    for (SlidersModel *sliderModel in homeModel.sliders)
    {
        [advPics addObject:sliderModel.advPic];
    }
    
    int length = (int)advPics.count;
    //添加最后一张图 用于循环
    NSMutableArray *itemArray = [NSMutableArray array];
    if (length > 1)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:nil image:advPics[length-1] tag:-1];
        [itemArray addObject:item];
    }
    
    for (int i = 0; i < length; i++)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:nil image:advPics[i] tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:nil image:advPics[0] tag:length];
        [itemArray addObject:item];
    }
    
    sgFocus = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/2.666) delegate:self imageItems:itemArray isAuto:YES];
    bannerView = sgFocus;
    
    [sgFocus addObserver:self forKeyPath:@"pageControl.currentPage" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"pageControl.currentPage"]) {
        NSInteger index = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        SlidersModel *sliderModel = homeModel.sliders[index];
        [UIView animateWithDuration:0.5 animations:^{
            if (![DataCheck isValidString: sliderModel.color]) {
                headerHurdleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBarBackground"]];
            }
            else
            {
                headerHurdleView.backgroundColor = [UIColor_HEX colorWithHexString:sliderModel.color]; 
            }
             headerHurdleView.searchView.backgroundColor = headerHurdleView.backgroundColor;
            headerView.backgroundColor = headerHurdleView.backgroundColor;
            middleTableView.backgroundColor = headerHurdleView.backgroundColor;
            upTableView.backgroundColor = headerHurdleView.backgroundColor;
            if (isHiddenCity == YES && headerView.frame.size.height == 0) {
                [myTableView beginUpdates];
                [myTableView setTableHeaderView:headerView];
                [myTableView endUpdates];
            }
        }];
    }
}

#pragma mark - 点击广告轮播图回调
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    if ([self isNotNetwork])
    {
        [SRMessage infoMessage:@"网络异常，请检测您的网络" delegate:self];
        return;
    }
    
    SlidersModel *sliderModel = homeModel.sliders[item.tag];
    NSString *urlLink = sliderModel.urlLink;
    if ([DataCheck isValidString:urlLink])
    {
        GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
        advShowWebView.advUrlLink = urlLink;
        [self.navigationController pushViewController:advShowWebView animated:YES];
        // 友盟统计，点击轮播图之后跳转
        [self mobClickLoopADTag:item.tag];
    }
}

#pragma mark - 跳转我的页面
- (void)goToMyViewControllerAction:(id)sender {
    // 友盟统计
    [MobClick event:Clik_User];
    
    MyViewController * myViewController = [[MyViewController alloc] init];
    [self.navigationController pushViewController:myViewController animated:YES];
}

#pragma mark - 点击按钮弹出蒙层广告
- (void)ADAnimationAction:(id)sender {
    
    [CYMask show];
    
    CYActivityView *activity = [CYActivityView shoeInPoint:self.view.center];
    if ([DataCheck isValidString:homeModel.configModel.showRegImg] && !sender && ![UserLoginModel isLogged])
    {
        showRegHidden = YES;
        activity.ADImageUrl = homeModel.configModel.showRegImg;
    }
    else
    {
        if ([UserLoginModel isAverageUser]) {
            activity.ADImageUrl = homeModel.maskAdModel.advPic;
        }
    }
    
    activity.delegate = self;
    [activity closeBlock:^{
        if ([DataCheck isValidString:homeModel.configModel.showRegImg] && showRegHidden == YES)
        {
            showRegHidden = NO;
            [activity hideInPoint:CGPointMake(self.view.width/2, self.view.height/2) completion:^{
                [CYMask hidden];
            }];
        }
        else
        {
            [activity hideInPoint:CGPointMake(self.view.width/2, self.view.height/2) completion:^{
                [CYMask hidden];
            }];
        }
    }];
}

#pragma mark - 点击浮层广告页面之后跳转
- (void)pushToDestionViewController
{
    if ([self isNotNetwork])
    {
        [CYMask hidden];
        [SRMessage infoMessage:@"网络异常，请检测您的网络" delegate:self];
        return;
    }
    
    NSString *urlLink = homeModel.maskAdModel.urlLink;
    if ([DataCheck isValidString:urlLink] && showRegHidden == NO)
    {
        GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
        advShowWebView.advUrlLink = urlLink;
        [CYMask hidden];
        [self.navigationController pushViewController:advShowWebView animated:YES];
    }
    else if (showRegHidden == YES)
    {
        showRegHidden = NO;
        RegisterViewController *registerView = [[RegisterViewController alloc] init];
        registerView.viewTag = -1;
        [self.navigationController pushViewController:registerView animated:YES];
    }
    else
    {
        [CYMask hidden];
    }
}

#pragma mark - 点击collection跳转
- (void)collectionClickBtnAction:(NSInteger)tagNum {
    // 友盟统计点击广告
    [self mobClickADTag:tagNum];
    
    pinsModel = homeModel.pin[tagNum];
    if ([DataCheck isValidString:pinsModel.urlLink])
    {
        GeneralShowWebView *general = [[GeneralShowWebView alloc] init];
        general.advUrlLink = pinsModel.urlLink;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:general animated:YES];
    }
}

#pragma mark - 分类跳转处理事件
- (void)clickAction:(UIButton *)sender {
    // 友盟统计
    [self mobClick:sender.tag];
    
    hotCategModel = homeModel.hotCategories[sender.tag];
    CategoryController *category = [[CategoryController alloc] init];
    if ([hotCategModel.ID isEqualToString:@"-1"]) {
        category.transportID = @"";
    }
    else
    {
        category.transportID = hotCategModel.ID;
    }
    category.homePagePushed = YES;
    [self.navigationController pushViewController:category animated:YES];
}

- (void)counterAddAndSubAction:(NSInteger)type andBtn:(UIButton *)sender {
    // 友盟统计，首页加号按钮，添加购物车
    if (type == 0)
    {
        [MobClick endEvent:Minus_inMainPage];
    }
    else
    {
        [MobClick event:Add_inMainPage];
    }
    
    if ([self isNotNetwork])
    {
        [SRMessage infoMessage:@"网络异常，请检测您的网络" delegate:self];
        return;
    }
    
    if (type == 0)
    {
        labelModel = labelModel = homeModel.topices[sender.superview.tag - 2];
        goodsModel = labelModel.topicGoodsVos[sender.tag - 1];
        if (!(goodsModel.num == 1))
        {
            shopBtnView.goodsNumLab.hidden = YES;
        }
        goodsModel.num -= 1;
        CounterClass *countView = (CounterClass *)sender.superview;
        NSString *num = [NSString stringWithFormat:@"%ld", [countView.numLabel.text integerValue] - 1];
        [self editWithGoodsId:goodsModel.goodsId andNumber:num];
    }
    else
    {
        CounterClass *countView = (CounterClass *)sender.superview;
        if ([countView.numLabel.text integerValue] > 99)
        {
            [SRMessage infoMessage:@"购物车中商品超过最大值" delegate:self];
        }
        [self addShoppingCartAction:sender];
    }
}

#pragma mark - 加入购物车处理事件
- (void)addShoppingCartAction:(UIButton *)sender {
    // 友盟统计首页加号点击
    [MobClick event:Add_inMainPage];
    if ([self isNotNetwork])
    {
        [SRMessage infoMessage:@"网络异常，请检测您的网络" delegate:self];
        return;
    }
    labelModel = homeModel.topices[sender.superview.tag - 2];
    labelModels = @[labelModel];
    if (![UserLoginModel isAverageUser] || ![UserLoginModel isLogged])
    {
        [self setAddCartData:sender.tag - 1];
        return;
    }
    
    goodsModel = labelModel.topicGoodsVos[sender.tag - 1];
    goodsModel.num += 1;
    for (id obj in sender.superview.subviews)
    {
        if ([obj isKindOfClass:[CounterClass class]])
        {
            UIView *view = (UIView *)obj;
            view.hidden = NO;
        }
    }
    
    UIButton *btn = (UIButton *)sender;
    CGPoint point = [btn convertPoint:btn.frame.origin toView:self.view];
    //创建动画view
    UIImageView *animationView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth, point.y, 30, 30)];
    if (goodsModel.num == 1)
    {
        animationView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth, point.y - 30, 30, 30)];
    }
    animationView.image = [UIImage imageNamed:@"icon"];
    animationView.layer.masksToBounds = YES;
    animationView.layer.cornerRadius = 15;
    animationView.tag = sender.tag - 1;
    [self.view addSubview:animationView];
    [self showView:animationView];
}

#pragma mark - 加入购物车动画
- (void)showView:(UIImageView *)myView {
    [self setAddCartData:myView.tag];
    
    [myTableView setScrollEnabled:NO];
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(thePath, NULL, myView.center.x - 25, myView.center.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, 150, 30, shopBtnView.center.x, shopBtnView.center.y);
    
    bounceAnimation.path = thePath;
    bounceAnimation.duration = 0.5;
    [myView.layer addAnimation:bounceAnimation forKey:@"move"];
    
    [self performSelector:@selector(hidenView:) withObject:myView afterDelay:0.5f];
}

- (void)hidenView:(UIView *)myView {
    
    [myTableView setScrollEnabled:YES];
    [myView removeFromSuperview];
}

#pragma mark - 加入购物车接口
- (void)editWithGoodsId:(NSString *)goodsId andNumber:(NSString *)number {
    [[CommClass sharedCommon]setObject:@"" forKey:CART_GOODSID];
    
    CloudClient *client =[CloudClient getInstance];
    
    NSDictionary *paramsDic = nil;
    if ([number integerValue] > 0) {
        paramsDic=@{@"type":@"1", @"goodsId":goodsId,@"number":number};
    }
    else
    {
        paramsDic=@{@"type":@"2", @"goodsId":goodsId,@"number":number};
    }
    
    [client requestMethodWithMod:@"cart/editCart"
                           params:nil
                       postParams:paramsDic
                         delegate:self
                         selector:@selector(editShoppingSuccess:)
                    errorSelector:@selector(editShoppingFail:)
                 progressSelector:nil];
}

-(void)editShoppingSuccess:(NSDictionary *)response{
    if ([DataCheck isValidDictionary:[response objectForKey:@"cartInfo"]]) {
        
        NSDictionary *cartInfo=[response objectForKey:@"cartInfo"];
        [cartModel updateShoppingCartInfo:cartInfo];
        
        NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_UPDATESHOPPINGCARTINFO
                                                                     object:nil
                                                                   userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self shopingCartAction];
        
        cartModel.shopInfos = response[@"goodsList"];
    }
}

-(void)editShoppingFail:(NSDictionary *)response{
    animationFinish = YES;
    [[CommClass sharedCommon]setObject:@"" forKey:CART_GOODSID];
    [myTableView reloadData];
}

//加入购物车后回调
- (void)shopingCartAction {
    if ([self isKindOfClass:[HomePageController class]] && isOut == NO)
    {
        if ([cartModel.goodsNum integerValue] > 0)
        {
            shopBtnView.goodsNumLab.hidden = NO;
            if ([cartModel.goodsNum integerValue] > 99) {
                shopBtnView.goodsNumLab.text = [NSString stringWithFormat:@"···"];
            }
            else
            {
                shopBtnView.goodsNumLab.text = [NSString stringWithFormat:@"%@", cartModel.goodsNum];
            }
            
            if ([DataCheck isValidString:[[CommClass sharedCommon] objectForKey:@"LOGINBACK"]])
            {
                [myTableView reloadData];
                [[CommClass sharedCommon] setObject:@"" forKey:@"LOGINBACK"];
            }
        }
        else
        {
            shopBtnView.goodsNumLab.hidden = YES;
        }
        [myTableView reloadData];
    }
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + homeModel.topices.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (homeModel.pin.count == 0)
            {
                return 2;
            }
            else
            {
                return 3;
            }
            break;
        case 1:
            return homeModel.banners.count;
            break;
        default:
            labelModel = homeModel.topices[section - 2];
            if (labelModel.topicGoodsVos.count > 0)
            {
                return labelModel.topicGoodsVos.count + 1;
            }
            else
            {
                return 0;
            }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0)
            {
                HomeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOMEHEADERCELL"];
                if (homeModel.sliders.count > 0)
                {
                    cell.bannersView = bannerView;
                }
                return cell;
            }
            else if (indexPath.row == 1)
            {
                HomeCateoryCell *cell = [tableView dequeueReusableCellWithIdentifier: @"HOMECATEORYCELL"];
                cell.images = homeModel.hotCategories;
                for (UIButton *btn in cell.BtnList)
                {
                    btn.hidden = NO;
                    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                return cell;
            }
            else
            {
                HomecollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOMECOLLECTIONCELL"];
                cell.collectionView = myCollection;
                return cell;
            }
            break;
        case 1:
        {
            HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOMEPAGECELL"];
            bannerModel = homeModel.banners[indexPath.row];
            if (homeModel.banners.count > 0)
            {
                cell.number = homeModel.banners.count - 1;
            }
            cell.tag = indexPath.row;
            cell.imageUrl = bannerModel.advPic;
            return cell;
        }
            break;
        default:
        {
            if (indexPath.row == 0)
            {
                HomeADCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOMEADCELL"];
                labelModel = homeModel.topices[indexPath.section - 2];
                cell.adImageUrl = labelModel.labelImageNewUrl;
                return cell;
            }
            else
            {
                HomeGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOMEGOODSCELL"];
                labelModel = homeModel.topices[indexPath.section - 2];
                goodsModel = labelModel.topicGoodsVos[indexPath.row - 1];
                cell.goodModel = goodsModel;
                
                cell.addBtn.tag = indexPath.row;
                cell.addBtn.superview.tag = indexPath.section;
                [cell.addBtn addTarget:self action:@selector(addShoppingCartAction:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.counterView.delegate = self;
                cell.counterView.tag = indexPath.section;
                cell.counterView.subBtn.tag = indexPath.row;
                cell.counterView.addBtn.tag = indexPath.row;
                
                return cell;
            }
        }
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0)
            {
                if (homeModel.sliders.count > 0)
                {
                    return bannerView.frame.size.height;
                }
            }
            else if(indexPath.row == 1)
            {
                return 91;
            }
            else
            {
                if (homeModel.pin.count == 0)
                {
                    return 0;
                }
                else
                {
                    return cellHeight + 12;
                }
            }
            break;
            
        case 1:
            if (homeModel.banners.count > 0)
            {
                if (homeModel.banners.count - 1 == indexPath.row)
                {
                    return viewWidth/3.516;
                }
                else
                {
                    return viewWidth/3.516 + 12;
                }
            }
            break;
            
        default:
            if (indexPath.row == 0)
            {
                return viewWidth/8;
            }
            else
            {
                return 105;
            }
            break;
    }
    return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1)
    {
        if (homeModel.banners.count == 0)
        {
            return 0;
        }
        else
        {
            return 12;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0)
    {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
        footView.backgroundColor = [UIColor clearColor];
        return footView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return;
    }
    
    switch (indexPath.section) {
        case 1:
        {
            if ([self isNotNetwork])
            {
                [SRMessage infoMessage:@"网络异常，请检测您的网络" delegate:self];
                return;
            }
            
            bannerModel = homeModel.banners[indexPath.row];
            if ([DataCheck isValidString:bannerModel.urlLink])
            {
                [self mobClickPuzzleAdTag:indexPath.row];
                GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
                advShowWebView.advUrlLink = bannerModel.urlLink;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:advShowWebView animated:YES];
            }
        }
            break;
            
        default:
        {
            if (indexPath.row != 0) {
                labelModel = homeModel.topices[indexPath.section - 2];
                goodsModel = labelModel.topicGoodsVos[indexPath.row - 1];
                
                if (indexPath.section != 0 && [goodsModel.sellType integerValue] == 0)
                {
                    [self mobClickCatComTag:indexPath.section-2 comTag:indexPath.row-1];
                    CommodityDetailsViewController * commodityDetail = [[CommodityDetailsViewController alloc]init];
                    commodityDetail.goodsId = goodsModel.goodsId;
                    [self.navigationController pushViewController:commodityDetail animated:YES];
                }
                else
                {
                    if ([DataCheck isValidString:goodsModel.link])
                    {
                        GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
                        advShowWebView.advUrlLink = goodsModel.link;
                        [self.navigationController pushViewController:advShowWebView animated:YES];
                    }
                }
            }
        }
            break;
    }
}

#pragma mark - 无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork])
    {
        if (homeModel) {
            if (headerView.hidden == YES) {
                [UIView animateWithDuration:0.5 animations:^{
                    headerView.frame = CGRectMake(0, 0, viewWidth, 36);
                    [myTableView beginUpdates];
                    [myTableView setTableHeaderView:headerView];
                    [myTableView endUpdates];
                    if (helperViewHeight != 0) {
                        [self showAndHiddenHelperView:nil];
                    }
                } completion:^(BOOL finished) {
                    headerView.hidden = NO;
                    middleTableView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame) - 1, viewWidth, 3);
                    middleTableView.hidden = NO;
                }];
            }
            
            headerHurdleView.hViewLabel.frame = CGRectMake(0, 8, viewWidth, 20);
            headerHurdleView.hViewLabel.textAlignment = NSTextAlignmentCenter;
            headerHurdleView.hViewLabel.text = @"网络异常，请检查您的网络连接";
            headerHurdleView.tableHrImg.hidden = YES;
            headerHurdleView.tableHbutton.hidden = YES;
            [self.myTableView.mj_header endRefreshing];
            
            return YES;
        }
        
        myTableView.hidden = YES;
        [self hidenHUD];
        noNetWork.hidden = NO;
        noNetWork = [NoNetworkView sharedInstance].view;
        [NoNetworkView sharedInstance].reloadDelegate = self;
        noNetWork.frame = CGRectMake(0, DEFAULTHEIGHT, self.view.frame.size.width, self.view.frame.size.height - DEFAULTHEIGHT);
        [self.view addSubview:noNetWork];
        return YES;
    }
    else
    {
        noNetWork.hidden = YES;
        if ([DataCheck isValidString:[[CommClass sharedCommon] objectForKey:@"hometabelHeaderMsg"]]) {
            [headerHurdleView setTableViewHeaderViewMsg:[[CommClass sharedCommon] objectForKey:@"hometabelHeaderMsg"]];
            headerHurdleView.tableHrImg.hidden = NO;
            headerHurdleView.tableHbutton.hidden = NO;
        }
        else
        {
            headerHurdleView.hViewLabel.text = @"";
            middleTableView.frame = CGRectZero;
            middleTableView.hidden = YES;
            [UIView animateWithDuration:0.5 animations:^{
                headerView.frame = CGRectMake(0, 0, viewWidth, 0);
                [myTableView beginUpdates];
                [myTableView setTableHeaderView:headerView];
                [myTableView endUpdates];
            } completion:^(BOOL finished) {
                headerView.hidden = YES;
            }];
        }
        
        return NO;
    }
}

- (void)reloadAgainAction {
    [self getHomeInfoRequest];
}

#pragma mark - 首页api请求回调方法
- (void)homeResponseData:(BOOL)isSuccessed Response:(NSDictionary *)response model:(NSObject *)model type:(NSInteger)type {
    
    switch (type) {
        case 1:
            [self homeDataResponse:isSuccessed model:model];
            break;
        case 2:
            [self cartTotalFinish];
            break;
        case 3:
            [self loopDataFinish:response];
            break;
        case 4:
        {
            headerHurdleView.tableHrImg.hidden = NO;
            headerHurdleView.tableHbutton.hidden = NO;
            if ([DataCheck isValidString:[response objectForKey:@"msg"]]) {
                isHiddenCity = YES;
                [[CommClass sharedCommon] setObject:[response objectForKey:@"msg"] forKey:@"hometabelHeaderMsg"];
                [headerHurdleView setTableViewHeaderViewMsg:[response objectForKey:@"msg"]];
                [UIView animateWithDuration:0.5 animations:^{
                    headerView.frame = CGRectMake(0, 0, viewWidth, 36);
                    headerView.backgroundColor = headerHurdleView.backgroundColor;
                    myTableView.frame = CGRectMake(0, DEFAULTHEIGHT + helperViewHeight, viewWidth, kViewHeight - headerHeight);
                } completion:^(BOOL finished) {
                    [myTableView beginUpdates];
                    [myTableView setTableHeaderView:headerView];
                    [myTableView endUpdates];
                    headerView.hidden = NO;
                    middleTableView.hidden = NO;
                }];
            }
            else
            {
                isHiddenCity = NO;
                headerHurdleView.tableHrImg.hidden = YES;
                headerHurdleView.hViewLabel.text = @"";
                [[CommClass sharedCommon] setObject:@"" forKey:@"hometabelHeaderMsg"];
                headerView.hidden = YES;
                middleTableView.hidden = YES;
                if (headerView.frame.size.height != 0) {
                    [UIView animateWithDuration:0.5 animations:^{
                        headerView.frame = CGRectMake(0, 0, viewWidth, 0);
                        myTableView.frame = CGRectMake(0, DEFAULTHEIGHT + helperViewHeight, viewWidth, kViewHeight - headerHeight);
                        [myTableView beginUpdates];
                        [myTableView setTableHeaderView:headerView];
                        [myTableView endUpdates];
                    }];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 获取首页信息的请求
- (void)getHomeInfoRequest
{
    if ([self noNetwork])
    {
        return;
    }
    [apiModel getHomeInfoRequest];
}

#pragma mark - 首页数据处理
- (void)homeDataResponse:(BOOL)isSuccessed model:(NSObject *)model {
    if (isSuccessed == YES) {
        
        homeModel = (HomeModel *)model;
        //判断右上角广告是否更改
        if ([DataCheck isValidString:homeModel.configModel.showRegImg] && ![UserLoginModel isLogged])
        {
            NSString *showRegImg = [[CommClass sharedCommon] objectForKey:@"SHOWREGIMG"];
            if (![DataCheck isValidString:showRegImg])
            {
                [[CommClass sharedCommon] setObject:homeModel.configModel.showRegImg forKey:@"SHOWREGIMG"];
                [self ADAnimationAction:nil];
            }
        }
        else
        {
            NSString *maskAdUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"MASKAD"];
            if (![homeModel.maskAdModel.advPic isEqualToString:maskAdUrl] && (homeModel.maskAdModel.advPic != nil) && [UserLoginModel isAverageUser])
            {
                [[NSUserDefaults standardUserDefaults] setObject:homeModel.maskAdModel.advPic forKey:@"MASKAD"];
                [self ADAnimationAction:nil];
            }
        }
        
        if (sgFocus) {
            [sgFocus removeObserver:self forKeyPath:@"pageControl.currentPage"];
            [sgFocus removeFromSuperview];
        }
        [self adCreate];
        
        [headerHurdleView.leftImageView setImageWithURL:[NSURL URLWithString:homeModel.userInfoListModel.imgUrl] placeholderImage:UIIMAGE(@"icon_homeLeft")];
        if ([DataCheck isValidString:homeModel.userInfoListModel.imgUrl])
        {
//            headerHurdleView.leftImageView.layer.borderColor = [[UIColor_HEX colorWithHexString:@"#6a3906"] CGColor];
            headerHurdleView.leftImageView.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.400].CGColor;
            headerHurdleView.leftImageView.layer.borderWidth = 1.0;
        }
        else
        {
            headerHurdleView.leftImageView.layer.borderColor = nil;
            headerHurdleView.leftImageView.layer.borderWidth = 0.0;
        }
        
        if (homeModel.pin.count == 2)
        {
            cellHeight = viewWidth/4;
        }
        else if (homeModel.pin.count == 3 || homeModel.pin.count == 4)
        {
            cellHeight = viewWidth/2;
        }
        else if (homeModel.pin.count == 5)
        {
            cellHeight = viewWidth/1.5;
        }
        else
        {
            cellHeight = 0;
        }
        
        if (myCollection)
        {
            [myCollection removeFromSuperview];
        }
        myCollection = [[DLCollectionView alloc] initWithFrame:CGRectMake(0, 12, viewWidth, cellHeight)];
        myCollection.pins = homeModel.pin;
        [myCollection createWithCollectionView:nil height:myCollection.frame.size.height width:viewWidth];
        myCollection.delegate = self;
        
        myTableView.hidden = NO;
        [myTableView reloadData];
    }
    if ([DataCheck isValidString:[[CommClass sharedCommon] objectForKey:CART_GOODSID]])
    {
        [self setAddCartData:0];
    }
    
    [self hidenHUD];
    [self.myTableView.mj_header endRefreshing];
    if (isRefHeader == YES) {
        self.myTableView.contentOffset = CGPointMake(0, 0);
        isRefHeader = NO;
    }
    else
    {
        [self.myTableView.mj_header endRefreshing];
        [self hidenHUD];
    }
}

#pragma mark - 获取购物车合计数据
- (void)getCartTotalData {
    if ([self isNotNetwork])
    {
        return;
    }
    
    [apiModel getCartTotalData];
}

- (void)cartTotalFinish {
    NSString *goodsId=[[CommClass sharedCommon]objectForKey:CART_GOODSID];
    if ([DataCheck isValidString:goodsId])
    {
        [self setAddCartData:0];
    }
    
    [myTableView reloadData];
}

#pragma mark - 加入购物车请求接口处理方法
- (void)setAddCartData:(NSInteger)indexTag {
    if (labelModels.count > indexTag) {
        labelModel = labelModels[indexTag];
    }
    
    if (labelModel.topicGoodsVos.count > indexTag) {
        goodsModel = labelModel.topicGoodsVos[indexTag];
    }
    
    NSString *goodsId = goodsModel.goodsId;
    
    if (![UserLoginModel isLogged])
    {
        [[CommClass sharedCommon] setObject:@"loginBack" forKey:@"LOGINBACK"];
        [[CommClass sharedCommon]setObject:[NSString stringWithFormat:@"%@",goodsId] forKey:CART_GOODSID];
        [[AppModel sharedModel] presentLoginController:self];
        return;
    }
    if ([UserLoginModel isShopOwner])
    {
        [SRMessage infoMessage:kMessage_001 delegate:self];
        return;
    }
    if ([UserLoginModel isMarki])
    {
        [SRMessage infoMessage:kMessage_002 delegate:self];
        return;
    }
    
    cartModel.homeEditShop = YES;
    if ([DataCheck isValidString:[[CommClass sharedCommon]objectForKey:CART_GOODSID]])
    {
        goodsId=[[CommClass sharedCommon]objectForKey:CART_GOODSID];
        [self editWithGoodsId:goodsId andNumber:@"1"];
    }
    else
    {
        goodsId = goodsModel.goodsId;
        [self editWithGoodsId:goodsId andNumber:[NSString stringWithFormat:@"%ld", goodsModel.num]];
    }
}

#pragma mark - 检查是否存取当前时间
- (void)getUpdateTimeAction {
    NSDictionary *dic = [self getPlistSaveTime];
    if (![dic objectForKey:@"oldTime"])
    {
        [apiModel getUpData];
    }
    else
    {
        NSString *time = [self intervalSinceNow:[dic objectForKey:@"oldTime"]];
        if ([time integerValue] >= [[dic objectForKey:@"nextDate"] integerValue] || [[dic objectForKey:@"nextDate"] integerValue] == 0) {
            [apiModel getUpData];
        }
    }
}

#pragma mark - 下拉刷新处理事件
- (void)headerRereshing {
    isRefHeader = YES;
    [self getHomeInfoRequest];
}

- (NSDictionary *)getPlistSaveTime {
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    NSString *filename=[plistPath stringByAppendingPathComponent:@"myOldTime.plist"];
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    return data;
}

- (NSString *)intervalSinceNow:(NSString *)theDate
{
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"YYYYMMdd"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=fabs(now - late);
    if (cha/3600<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"剩余%@分", timeString];
    }
    if (cha/3600>1&&cha/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"剩余%@小时", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@", timeString];
        
    }
    return timeString;
}

#pragma mark - 自动定位成功通知
- (void)autoLocationAction:(NSNotification *)notification {
    NSArray *addList = [[CommClass sharedCommon] localObjectForKey:AUTOLOCATIONADDRESS];
    if (addList.count > 1) {
        [headerHurdleView setMYAddressLabText:addList.lastObject];
    }
    [self getHomeInfoRequest];
    
    if ([UserLoginModel isLogged]) {
         [self getCartTotalData];
    }
//    [apiModel noShopAtNearbyAction:notification.userInfo];
}

#pragma mark - 有新订单通知
- (void)newOrderNotigation:(NSNotification *)notification {
    isClosedMsg = YES;
    [headerHurdleView setHelperLabAction:@"正在努力通知附近店家接单" time:@"0" andtype:1];
}

- (void)cancelOrderAction {
    isClosedMsg = YES;
}

#pragma mark - 开启订单提示轮循
- (void)orderLoopAction
{
    if ([self isNotNetwork] || ![UserLoginModel isLogged] || isOut == YES)
    {
        return;
    }
    
    [apiModel orderLoopAction];
}

- (void)loopDataFinish:(NSDictionary *)response {
    [UIView animateWithDuration:0.3 animations:^{
        [myTableView beginUpdates];
        myTableView.frame = CGRectMake(0, headerHeight, viewWidth, kViewHeight - headerHeight);
        [myTableView endUpdates];
    }];
    
    if ([DataCheck isValidDictionary:response])
    {
        NSString *msg = [response objectForKey:@"msg"];
        BOOL next = [[response objectForKey:@"next"] boolValue];
        NSInteger state = [[response objectForKey:@"state"] integerValue];
        //BOOL show = [[response objectForKey:@"show"] boolValue];
        NSString *newOrderNum = [response objectForKey:@"orderNo"];
        NSString *sceondTime = [response objectForKey:@"second"];
        
        if (next == YES) {
            [self performSelector:@selector(orderLoopAction) withObject:nil afterDelay:30.0];
        }
        
        NSString *oldOrderNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"newOrderDic"] objectForKey:@"orderNo"];
        if ([DataCheck isValidString:msg] && (state != myState || ![newOrderNum isEqualToString:oldOrderNum])) {
            headerHurdleView.helperBtn.hidden = NO;
            if (state == 1) {
                headerHurdleView.animiteView.hidden = NO;
                [headerHurdleView setHelperLabAction:msg time:sceondTime andtype:1];
            }
            else
            {
                headerHurdleView.animiteView.hidden = YES;
                [headerHurdleView setHelperLabAction:msg time:nil andtype:0];
            }
            
            if ((helperViewHeight == 0 && isClosedMsg == YES)) {
                [self showAndHiddenHelperView:nil];
            }
        }
        
        if (![DataCheck isValidString:msg]) {
            if (helperViewHeight != 0) {
                [self showAndHiddenHelperView:nil];
            }
            headerHurdleView.helperBtn.hidden = YES;
        }
        
        
        if ([DataCheck isValidString:newOrderNum]) {
            [[NSUserDefaults standardUserDefaults] setObject:@{@"orderNo":newOrderNum} forKey:@"newOrderDic"];
        }
        myState = state;
    }
}

#pragma mark - 选择顶部消息提示处理事件
- (void)clickHelperAction{
    [MobClick endEvent:Clik_OrderAssit];
    [self showAndHiddenHelperView:nil];
    
    NSDictionary *newOrderDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"newOrderDic"];
    
    self.hidesBottomBarWhenPushed = YES;
    if (myState == 1)
    {
        OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
        orderDetail.orderNum = [newOrderDic objectForKey:@"orderNo"];//订单号
        orderDetail.orderState = 1;
        orderDetail.homePush = YES;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
    else
    {
        MyOrderController *orderView = [[MyOrderController alloc] init];
        if (myState > 4)
        {
            orderView.statusNum = 2;
        }
        else
        {
            orderView.statusNum = 1;
        }
        [self.navigationController pushViewController:orderView animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == myTableView)
    {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
    if (scrollView.contentOffset.y > oldOffset && isHidden == NO && scrollView.contentOffset.y > 0 && isOut == NO) {
        //如果当前位移大于缓存位移，说明scrollView向上滑动
        if (headerHurdleView.msgHelperView.frame.size.height > 0) {
            isHidden = YES;
            [self showAndHiddenHelperView:nil];
        }
    }
    
    oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
}

#pragma mark - 订单状态控制处理事件
- (void)showAndHiddenHelperView:(UIButton *)sender {
    if (isClickBtn == 1) {
        isClickBtn = 0;
        isClosedMsg = YES;
        helperViewHeight = 0;
        [headerHurdleView.helperBtn setBackgroundImage:[UIImage imageNamed:@"icon_zhushou1"] forState:UIControlStateNormal];
        headerHeight = DEFAULTHEIGHT;
    }
    else
    {
        isClickBtn = 1;
        isHidden = NO;
        isClosedMsg = NO;
        helperViewHeight = 39;
        [headerHurdleView.helperBtn setBackgroundImage:[UIImage imageNamed:@"icon_zhushou2"] forState:UIControlStateNormal];
        headerHurdleView.msgHelperView.hidden = NO;
        headerHeight = NOTDEFAULTHEIGHT;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        headerHurdleView.frame = CGRectMake(0, 0, viewWidth, headerHeight);
        headerHurdleView.msgHelperView.frame = CGRectMake(0, CGRectGetMaxY(headerHurdleView.addressView.frame), viewWidth, helperViewHeight);
        headerHurdleView.searchView.frame = CGRectMake(0, CGRectGetMaxY(headerHurdleView.msgHelperView.frame), viewWidth, 36);
        upTableView.frame = CGRectMake(0, CGRectGetMaxY(headerHurdleView.frame) - 1, viewWidth, 2);
        upTableView.hidden = NO;
        myTableView.frame = CGRectMake(0, headerHeight, viewWidth, kViewHeight - headerHeight);
    } completion:^(BOOL finished) {
        if (helperViewHeight == 0) {
            headerHurdleView.msgHelperView.hidden = YES;
            upTableView.hidden = YES;
        }
    }];
}

#pragma mark - 分类跳转
- (void)categoryViewBtnsAction:(UIButton *)sender {
    [MobClick event:Clik_Category];
    CategoryController *cateory = [[CategoryController alloc] init];
    cateory.transportID = @"-1";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cateory animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 友盟统计
- (void)mobClick:(NSInteger)tag
{
    switch (tag) {
        case 0:
            [MobClick event:Category1_inMP];
            break;
            
        case 1:
            [MobClick event:Category2_inMP];
            
            break;
            
        case 2:
            [MobClick event:Category3_inMP];
            
            break;
            
        case 3:
            [MobClick event:Category4_inMP];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 友盟统计，点击拼图广告
- (void)mobClickPuzzleAdTag:(NSInteger)puzzleTag {
    switch (puzzleTag) {
        case 0:
            [MobClick event:Clik_MBanner1];
            break;
            
        case 1:
            [MobClick event:Clik_MBanner2];
            
            break;
            
        case 2:
            [MobClick event:Clik_MBanner3];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 友盟统计，点击广告位
- (void)mobClickADTag:(NSInteger)ADTag
{
    switch (ADTag) {
        case 0:
            [MobClick event:Clik_AD1];
            break;
            
        case 1:
            [MobClick event:Clik_AD2];
            
            break;
            
        case 2:
            [MobClick event:Clik_AD3];
            
            break;
            
        case 3:
            [MobClick event:Clik_AD4];
            
            break;
            
        case 4:
            [MobClick event:Clik_AD5];
            
            break;
        case 5:
            [MobClick event:Clik_AD6];
            
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 友盟统计，点击轮播广告跳转统计
- (void)mobClickLoopADTag:(NSInteger)ADTag
{
    switch (ADTag) {
        case 0:
            [MobClick event:Clik_Banner1];
            break;
            
        case 1:
            [MobClick event:Clik_Banner2];
            
            break;
            
        case 2:
            [MobClick event:Clik_Banner3];
            
            break;
            
        case 3:
            [MobClick event:Clik_Banner4];
            
            break;
            
        case 4:
            [MobClick event:Clik_Banner5];
            
            break;
        case 5:
            [MobClick event:Clik_Banner6];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 友盟统计，点击某个分类的某个商品跳转统计
- (void)mobClickCatComTag:(NSInteger)catTag comTag:(NSInteger)comTag
{
    switch (catTag) {
        case 0:
        {
            switch (comTag)
            {
                case 0:
                    [MobClick event:Clik_MPCat1_Com1];
                    break;
                case 1:
                    [MobClick event:Clik_MPCat1_Com2];
                    break;
                case 2:
                    [MobClick event:Clik_MPCat1_Com3];
                    break;
                case 3:
                    [MobClick event:Clik_MPCat1_Com4];
                    break;
                case 4:
                    [MobClick event:Clik_MPCat1_Com5];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (comTag) {
                case 0:
                    [MobClick event:Clik_MPCat2_Com1];
                    break;
                case 1:
                    [MobClick event:Clik_MPCat2_Com2];
                    break;
                case 2:
                    [MobClick event:Clik_MPCat2_Com3];
                    break;
                case 3:
                    [MobClick event:Clik_MPCat2_Com4];
                    break;
                case 4:
                    [MobClick event:Clik_MPCat2_Com5];
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (catTag) {
                case 0:
                    [MobClick event:Clik_MPCat3_Com1];
                    break;
                case 1:
                    [MobClick event:Clik_MPCat3_Com2];
                    break;
                case 2:
                    [MobClick event:Clik_MPCat3_Com3];
                    break;
                case 3:
                    [MobClick event:Clik_MPCat3_Com4];
                    break;
                case 4:
                    [MobClick event:Clik_MPCat3_Com5];
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (comTag) {
                case 0:
                    [MobClick event:Clik_MPCat4_Com1];
                    break;
                case 1:
                    [MobClick event:Clik_MPCat4_Com2];
                    break;
                case 2:
                    [MobClick event:Clik_MPCat4_Com3];
                    break;
                case 3:
                    [MobClick event:Clik_MPCat4_Com4];
                    break;
                case 4:
                    [MobClick event:Clik_MPCat4_Com5];
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            switch (comTag) {
                case 0:
                    [MobClick event:Clik_MPCat5_Com1];
                    break;
                case 1:
                    [MobClick event:Clik_MPCat5_Com2];
                    break;
                case 2:
                    [MobClick event:Clik_MPCat5_Com3];
                    break;
                case 3:
                    [MobClick event:Clik_MPCat5_Com4];
                    break;
                case 4:
                    [MobClick event:Clik_MPCat5_Com5];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

@end
