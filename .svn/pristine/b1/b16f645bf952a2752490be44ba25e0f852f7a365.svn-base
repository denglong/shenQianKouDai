//
//  HomeViewController.m
//  KingProFrame
//
//  Created by meyki on 11/24/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "AddressMapViewController.h"
#import "CategoryController.h"

#import "HomeViewModel.h"
#import "HeaderClassifyView.h"
#import "HomeCollectionViewCell.h"
#import "HomeCollectionHeaderCell.h"
#import "MapLocation.h"
#import "DLCollectionView.h"

#import "PinsModel.h"
#import "HomeApiModel.h"
#import "HotCategoriesModel.h"

/** banner和分类cell高度 */
static NSInteger const HeaderBannerAndCategoryHeight = 310;
/** 腰部广告cell高度 */
static NSInteger const MiddleAdCellHeight = 100;
/** UICollectionViewCell 纵向和横向的间距 */
static NSInteger const MinimumInteritemSpacing = 5;
/** 商品列表头部Cell高度 */
static NSInteger const GoodListHeaderCellHeight = 60;
/** UICollectionViewCell高度 */
static NSInteger const CollectionViewCellHeight = 215;
/** title cell个数 */
static NSInteger const TitleNameNum = 1;

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, AddressMapViewControllerDelegate, HomeApiDelegate, DLCollectionDelegate, JGInfiniteScrollViewDelegate>

@property (nonatomic, strong) HomeApiModel *apiModel;
@property (nonatomic, strong) HomeModel *homeModel;
@property (nonatomic, strong) UICollectionView *myCollectionView;
/** 首页广告View */
@property (nonatomic, strong) JGInfiniteScrollView *bannerView;
/** 首页头部View */
@property (nonatomic, strong) UIView *HeaderView;
/** 顶部搜索按钮 */
@property (nonatomic, strong) UIButton *searchBtn;
/** 地址选择按钮View */
@property (nonatomic, strong) HeaderClassifyView *classifyView;
/** 创建腰部View */
@property (nonatomic, strong) DLCollectionView *myCollection;
/** 腰部广告View */
@property (nonatomic, strong) UIView *middleAdView;
@property (nonatomic, strong) UIImageView *middleAdImg;
/** tableView头部view */
@property (nonatomic, strong) UIView *TBheaderView;
/** 腰部cell的高度 */
@property (nonatomic, assign) NSInteger cellHeight;

@property (nonatomic, strong) NSString *addressMsg;

@property (nonatomic, strong) SlidersModel *sliderModel;
@property (nonatomic, strong) BannersModel *bannerModel;
@property (nonatomic, strong) HotCategoriesModel *hotCategModel;
@property (nonatomic, strong) labelListModel *labelModel;
@property (nonatomic, strong) goodsListModel *goodsModel;
@property (nonatomic, strong) PinsModel *pinsModel;

@end

@implementation HomeViewController
@synthesize myCollectionView, myCollection, cellHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showHUD];
    
    [self createHomeCollectionView];
//    [self createBannerView];
    [self createMiddleAdViewAction];
    [self createDLCollectionAction];
    [self setupHeaderRefresh:myCollectionView];
    
    self.apiModel = [HomeApiModel sharedInstance];
    self.apiModel.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoLocationAction:)
                                                 name:LOCATIONLATANDLNG
                                               object:nil];
    
    if ([UserLoginModel isLogged]) {
        [self.apiModel getCartTotalData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self headerRereshing];
    if ([UserLoginModel isLogged]) {
        [self.apiModel getMyInfoData];
    }
}

#pragma mark - 创建banner及分类按钮
- (void)createBannerView
{
    if (self.HeaderView) {
        [self.HeaderView removeFromSuperview];
    }
    self.bannerView = [HomeViewModel createHomePageAdAction];
    self.bannerView.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    self.classifyView = [HeaderClassifyView
                         createHeaderClassifyView:self.homeModel.hotCategories address:self.addressMsg block:^(NSInteger type) {
                                            
                                            [weakSelf clickCategoryAction:type];
                                        }];
    
    [self.classifyView.addressBtn addTarget:self action:@selector(chooseAddressAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.HeaderView = [[UIView alloc] init];
    self.HeaderView.backgroundColor = [UIColor whiteColor];
    self.HeaderView.frame = CGRectMake(0, 0, viewWidth, viewWidth*0.66+130);
    [self.HeaderView addSubview:self.bannerView];
    [self.HeaderView addSubview:self.classifyView];
    
    if (self.searchBtn) {
        [self.searchBtn removeFromSuperview];
    }
    self.searchBtn = [HomeViewModel createSearchViewAction:self.view];
    [self.searchBtn addTarget:self action:@selector(searchGoodsAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 创建腰部商品广告
- (void)createDLCollectionAction
{
    if (myCollection)
    {
        [myCollection removeFromSuperview];
    }
    myCollection = [[DLCollectionView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, cellHeight)];
    myCollection.pins = self.homeModel.pin;
    [myCollection createWithCollectionView:nil height:myCollection.frame.size.height width:viewWidth];
    myCollection.delegate = self;
}

#pragma mark - 创建腰部广告View
- (void)createMiddleAdViewAction
{
    self.middleAdView = [[UIView alloc] init];
    self.middleAdView.frame = CGRectMake(0, 0, viewWidth, viewWidth*0.33);
    self.middleAdView.backgroundColor = self.view.backgroundColor;
    
    self.middleAdImg = [[UIImageView alloc] init];
    [self.middleAdImg setImageWithURL:nil placeholderImage:UIIMAGE(@"pintu")];
    self.middleAdImg.backgroundColor = [UIColor whiteColor];
    [self.middleAdView addSubview:self.middleAdImg];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.middleAdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.middleAdView).insets(edge);
    }];
}

#pragma mark - 创建首页CollectionView
- (void)createHomeCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    myCollectionView.backgroundColor = [UIColor_HEX colorWithHexString:@"ECECEC"];
    myCollectionView.dataSource=self;
    myCollectionView.delegate=self;
    [self.view addSubview:myCollectionView];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(-20, 0, 0, 0);
    [myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(edge);
    }];
    
    //注册Cell
    [myCollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [myCollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionHeaderCell"];
}

#pragma mark -- UICollectionViewDataSource
//定义每个section的cell个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (_homeModel.banners.count > 0 && _homeModel.pin.count > 0)
        {
            return 3;
        }
        if (_homeModel.banners.count > 0 || _homeModel.pin.count > 0)
        {
            return 2;
        }
        return TitleNameNum;
    }
    
    _labelModel = _homeModel.topices[section - TitleNameNum];
    return TitleNameNum+_labelModel.topicGoodsVos.count;
}

#pragma mark - 定义section数量
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return TitleNameNum + _homeModel.topices.count;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return MinimumInteritemSpacing;
}

#pragma mark - 定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return CGSizeMake(viewWidth, viewWidth*0.66+130);
        }
        else if (indexPath.row == 1 && self.homeModel.pin.count > 0)
        {
            return CGSizeMake(viewWidth, cellHeight);
        }
        else
        {
            if (_homeModel.banners.count == 0)
            {
                return CGSizeMake(0, 0);
            }
            else
            {
                return CGSizeMake(viewWidth, viewWidth*0.33);
            }
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            return CGSizeMake(viewWidth, GoodListHeaderCellHeight);
        }
        else
        {
            return CGSizeMake((viewWidth-5)/2, CollectionViewCellHeight);
        }
    }
}

#pragma mark - 定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, MinimumInteritemSpacing, 0 );
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor =  self.view.backgroundColor;
        if (indexPath.row == 0)
        {
            [cell addSubview:self.HeaderView];
        }
        else if (indexPath.row == 1 && _homeModel.pin.count > 0)
        {
            cell.backgroundColor =  self.view.backgroundColor;
            [cell addSubview:self.myCollection];
        }
        else
        {
            [cell addSubview:self.middleAdView];
        }
        
        return cell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            HomeCollectionHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionHeaderCell" forIndexPath:indexPath];
            
            _labelModel = _homeModel.topices[indexPath.section - TitleNameNum];
            [cell setTitleNameAction:_labelModel.name];
            
            return cell;
        }
        else
        {
            HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
            
            _labelModel = _homeModel.topices[indexPath.section - TitleNameNum];
            _goodsModel = _labelModel.topicGoodsVos[indexPath.row - TitleNameNum];
            [cell setCellDataAction:_goodsModel];
        
            cell.addCartBtn.tag = indexPath.section;
            cell.addCartBtn.superview.tag = indexPath.row;
            [cell.addCartBtn addTarget:self action:@selector(addShopCartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > 20 || scrollView.contentOffset.y < -45)
    {
        self.searchBtn.hidden = YES;
    }
    else
    {
        self.searchBtn.hidden = NO;
    }
}

#pragma mark - UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.section) {
        case 0:
        {
            if ([self isNotNetwork])
            {
                [SRMessage infoMessage:@"网络异常，请检测您的网络" delegate:self];
                return;
            }
            
            _bannerModel = _homeModel.banners.firstObject;
            if (_bannerModel.jumpType == 3)
            {
                if ([DataCheck isValidString:_bannerModel.urlLink]) {
                    CommodityDetailsViewController * commodityDetail = [[CommodityDetailsViewController alloc]init];
                    commodityDetail.goodsId = _bannerModel.urlLink;
                    [self.navigationController pushViewController:commodityDetail animated:YES];
                }
            }
            else
            {
                if ([DataCheck isValidString:_bannerModel.urlLink]) {
                    GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
                    advShowWebView.advUrlLink = _bannerModel.urlLink;
                    [self.navigationController pushViewController:advShowWebView animated:YES];
                }
            }
        }
            break;
            
        default:
        {
            if (indexPath.row != 0)
            {
                _labelModel = _homeModel.topices[indexPath.section - TitleNameNum];
                _goodsModel = _labelModel.topicGoodsVos[indexPath.row - TitleNameNum];
                
                if (indexPath.section != 0 && [_goodsModel.sellType integerValue] == 0)
                {
                    CommodityDetailsViewController * commodityDetail = [[CommodityDetailsViewController alloc]init];
                    commodityDetail.goodsId = _goodsModel.goodsId;
                    [self.navigationController pushViewController:commodityDetail animated:YES];
                }
                else
                {
                    if ([DataCheck isValidString:_goodsModel.link])
                    {
                        GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
                        advShowWebView.advUrlLink = _goodsModel.link;
                        [self.navigationController pushViewController:advShowWebView animated:YES];
                    }
                }
            }
        }
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 添加购物车点击事件
- (void)addShopCartBtnAction:(UIButton *)sender
{
    if (_homeModel.topices.count > sender.tag-TitleNameNum)
    {
        _labelModel = _homeModel.topices[sender.tag-TitleNameNum];
    }
    
    if (_labelModel.topicGoodsVos.count > sender.superview.tag-TitleNameNum)
    {
        _goodsModel = _labelModel.topicGoodsVos[sender.superview.tag-TitleNameNum];
    }
    
    NSString *goodsId = _goodsModel.goodsId;
    
    [self.apiModel addCartGoodAction:goodsId];
}

#pragma mark - 点击搜索商品
- (void)searchGoodsAction:(UIButton *)sender
{
    SearchViewController *search = [[SearchViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 头部广告点击事件
- (void)ScrollViewDidClickAtAnyImageView:(UIImageView *)imageView {
    _sliderModel = _homeModel.sliders[imageView.tag];
    self.hidesBottomBarWhenPushed = YES;
    if (_sliderModel.jumpType == 3)
    {
        if ([DataCheck isValidString:_sliderModel.urlLink]) {
            CommodityDetailsViewController * commodityDetail = [[CommodityDetailsViewController alloc]init];
            commodityDetail.goodsId = _sliderModel.urlLink;
            [self.navigationController pushViewController:commodityDetail animated:YES];
        }
    }
    else
    {
        if ([DataCheck isValidString:_sliderModel.urlLink]) {
            GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
            advShowWebView.advUrlLink = _sliderModel.urlLink;
            [self.navigationController pushViewController:advShowWebView animated:YES];
        }
    }
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 点击分类处理事件
- (void)clickCategoryAction:(NSInteger)selectType
{
    CategoryController *category = [[CategoryController alloc] init];
    if (_homeModel.hotCategories.count <= selectType) {
        
    }
    else
    {
        _hotCategModel = _homeModel.hotCategories[selectType];
        if ([_hotCategModel.ID isEqualToString:@"-1"]) {
            category.transportID = @"";
        }
        else
        {
            category.transportID = _hotCategModel.ID;
        }
    }
    
    category.homePagePushed = YES;
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:category animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//    self.tabBarController.selectedIndex = 1;
}

#pragma mark - 点击腰部商品事件
- (void)collectionClickBtnAction:(NSInteger)tagNum
{
    _pinsModel = _homeModel.pin[tagNum];
    if ([DataCheck isValidString:_pinsModel.urlLink])
    {
        GeneralShowWebView *general = [[GeneralShowWebView alloc] init];
        general.advUrlLink = _pinsModel.urlLink;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:general animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - 选中地址点击事件
- (void)chooseAddressAction
{
    if ([self isNotNetwork])
    {
        return;
    }
    if ([[MapLocation sharedObject] isOpenLocal])
    {
        NSDictionary *pointsDic = [[CommClass sharedCommon] localObjectForKey:AUTOLOCATIONADDRESS][1];
        AddressMapViewController * addressMapViewController = [[AddressMapViewController alloc]init];
        addressMapViewController.isSwitchCity = YES;
        addressMapViewController.pointsDic = pointsDic;
        addressMapViewController.delegate = self;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressMapViewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"定位失败"
                                                      message:@"请手动开启定位服务"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        return;
    }
}

#pragma mark - 首页选择地址后回调
-(void)getAddress:(NSString *)address
{
    NSDictionary *locationAddress = [[CommClass sharedCommon] objectForKey:LocationAddress];
    NSDictionary *parms = nil;
    id location = [locationAddress objectForKey:@"location"];
    if ([[location class] isSubclassOfClass:[AMapGeoPoint class]])
    {
        AMapGeoPoint * location = [locationAddress objectForKey:@"location"];
        parms = @{@"lat":[NSString stringWithFormat:@"%f",location.latitude], @"lng":[NSString stringWithFormat:@"%f",location.longitude]};
    }
    else
    {
        CLLocation * location = [locationAddress objectForKey:@"location"];
        parms = @{@"lat":[NSString stringWithFormat:@"%f",location.coordinate.latitude], @"lng":[NSString stringWithFormat:@"%f",location.coordinate.longitude]};
    }
    
    NSString *cityCode = [locationAddress objectForKey:@"cityCode"];
    NSArray *addList = @[cityCode, parms, [locationAddress objectForKey:@"address"]];
    [[CommClass sharedCommon] localObject:addList forKey:AUTOLOCATIONADDRESS];
    
    [self.classifyView setAddressString:address];
    self.addressMsg = address;
    
    [self.apiModel setUserLocation];
    [self getHomeInfoRequest];
}

#pragma mark - 自动定位成功通知
- (void)autoLocationAction:(NSNotification *)notification
{
    NSArray *addList = [[CommClass sharedCommon] localObjectForKey:AUTOLOCATIONADDRESS];
    [self.classifyView setAddressString:addList.lastObject];
    
    self.addressMsg = addList.lastObject;
    
    [self.apiModel setUserLocation];
}

#pragma mark - 下拉刷新处理事件
- (void)headerRereshing
{
    [self getHomeInfoRequest];
}

#pragma mark - 获取首页信息的请求
- (void)getHomeInfoRequest
{
    [self.apiModel getHomeInfoRequest];
}

#pragma mark - 首页api请求回调方法
- (void)homeResponseData:(BOOL)isSuccessed Response:(NSDictionary *)response model:(NSObject *)model type:(NSInteger)type
{
    [self hidenHUD];
    [self homeDataResponse:isSuccessed model:model];
}

#pragma mark - 首页数据处理
- (void)homeDataResponse:(BOOL)isSuccessed model:(NSObject *)model
{
    if (isSuccessed == YES) {
        
        self.homeModel = (HomeModel *)model;

        if (self.homeModel.pin.count == 2)
        {
            cellHeight = viewWidth/4;
        }
        else if (self.homeModel.pin.count == 3 || self.homeModel.pin.count == 4)
        {
            cellHeight = viewWidth/2;
        }
        else if (self.homeModel.pin.count == 5)
        {
            cellHeight = viewWidth/1.5;
        }
        else
        {
            cellHeight = 0;
        }
        
        [self createDLCollectionAction];
        [self createBannerView];
        
        _bannerModel = self.homeModel.banners.firstObject;
        NSURL *bannerUrl = [NSURL URLWithString:_bannerModel.advPic];
        [self.middleAdImg setImageWithURL:bannerUrl placeholderImage:UIIMAGE(@"pintu")];
        
        NSMutableArray *sliderImgs = [NSMutableArray array];
        for (_sliderModel in _homeModel.sliders) {
            [sliderImgs addObject:_sliderModel.advPic];
        }
        self.bannerView.images = sliderImgs;
        
        myCollectionView.hidden = NO;
        [myCollectionView reloadData];
    }
    
    [self hidenHUD];
    [myCollectionView.mj_header endRefreshing];
}

@end
