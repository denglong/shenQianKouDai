  //
//  CategoryController.m
//  KingProFrame
//
//  Created by JinLiang on 15/7/27.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CategoryController.h"
#import "CommodityDetailsViewController.h"
#import "TabBarController.h"
#import "CYCategoryCellModel.h"
#import "GeneralShowWebView.h"
#import "TempViewController.h" 
#import "ShopBtnView.h"
#import "CYShopCartingViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "HomeViewModel.h"

@interface CategoryController ()<reloadDelegate,CYCategoryDetailCellDelegate,UITextFieldDelegate,CYShopCartingViewControllerDelegate>
{
    UIView * noNetWork ;
    BOOL isToTop;
}

/** label */
@property (nonatomic , strong) UILabel *label;
/** window */
@property (nonatomic , strong) UIWindow *window;
/** categoryCellModel */
@property (nonatomic , strong) NSMutableArray *categoryCellModelArray;
/** 选中行商品的goodsId */
@property (nonatomic,retain) NSString *goodsId;
/** 某一个分类中共有多少页 */
@property (nonatomic,retain) NSNumber *totalPageNumber;
/** 记录未登录时点击的按钮 */
@property (nonatomic , strong) UIButton *selectedButton;
/** 是否无网 */
@property (nonatomic,assign) BOOL isNoWork;
/** uibutton */
@property (nonatomic , strong) UIButton *searchButton;
/** menuName数组 */
@property (nonatomic , strong) NSMutableArray *menuNameArray;
/** shopButtonView */
@property (nonatomic , strong) ShopBtnView *shoppingCartView;
/** 下单时用的购物车信息 */
@property (nonatomic , strong) NSDictionary *orderInfoDictionary;
/** 顶部搜索按钮 */
@property (nonatomic , strong) UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UIButton *goodsNumberButton;

@end

@implementation CategoryController

#pragma  mark - 初始化tableItem
// 初始化tabitem
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

#pragma  mark - 无网判断
//无网判断添加页面
- (BOOL)noNetwork {
    [super hidenHUD];
    if ([self isNotNetwork]) {
        noNetWork.hidden = NO;
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        
        return YES;
    }
    else
    {
        [self initCartData];
        noNetWork.hidden = YES;
        return NO;
    }
}

#pragma mark - view生命周期相关方法
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.searchButton.hidden = NO;
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initCartData)
                                                 name:NOTIFICATION_UPDATESHOPPINGCARTINFO
                                               object:nil];

    [self initCartData];
    
    if ([UserLoginModel isLogged]&&[UserLoginModel isAverageUser])
    {
        // 先判断登录与否，如果登陆之后，再去请求，如果没登陆，就直接不显示 此处应该请求的是购物车数据，
        // 包含多少钱减运费的东西哦 使用 cart/getCartInfo这个借口，既能拿到购物车数据，也能有差多少免运费
        [self getCartTotalData];
        
    }else
    {
        [self setUpDataArrayZero];
        [self.goodsTableView reloadData];
    }

    
    // 判断是否有网
    if ([self isNotNetwork])
    {
        self.isNoWork = YES;
        [self noNetwork];
    }else
    {
        if (self.isNoWork == YES && self.isHomePagePushed == NO)
        {
            [self requestCategoryList];
        }
        self.isNoWork = NO;
        if (self.isHomePagePushed == YES)
        {
            isToTop = YES;
            if ([DataCheck isValidArray:self.goodsDataArray])
            {
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.goodsDataArray];
                [array removeAllObjects];
                self.goodsDataArray = array;
                [self.goodsTableView reloadData];
            }
            [self requestCategoryList];
        }
        
    }
    
    self.searchView.hidden = YES;
    self.searchTextField.text = @"";
//    [self tableView:self.menuTableView
//          didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    

}

- (void)getCartTotalData
{
    [_cloudClient requestMethodWithMod:@"cart/getCartInfo"
                                params:nil
                            postParams:nil
                              delegate:self
                              selector:@selector(getCartTotalFinish:)
                         errorSelector:nil
                      progressSelector:nil];
}

- (void)getCartTotalFinish:(NSDictionary *)response {

    [response writeToFile:@"/Users/eqbang/Desktop/进入分类时的数据.plist" atomically:YES];
    if ([DataCheck isValidDictionary:response]) {
        //更新购物车数据
        NSDictionary *cartInfo = [response objectForKey:@"cartInfo"];
        ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
        cartModel.shopInfos = response[@"goodsList"];
        [cartModel updateShoppingCartInfo:cartInfo];
        
        // 购物车中的所有商品
        NSMutableArray *tempArray = [response[@"goodsList"] mutableCopy];
        // 遍历购物车中的数据，找出在self.goodsDataArray中的数据，修改；
        // 购物车中没有数据
        if (tempArray.count == 0)
        {
            self.goodsNumberButton.hidden = YES;
            [self setUpDataArrayZero];
            [self.goodsTableView reloadData];
            
            cartModel.shopInfos = [NSArray array];

        }
        else
        {
            self.goodsNumberButton.hidden = NO;
            if ([cartModel.goodsNum integerValue] >99)
            {
                [self.goodsNumberButton setTitle:@"..." forState:UIControlStateNormal];
            }else
            {
                [self.goodsNumberButton setTitle:[NSString stringWithFormat:@"%zd",[cartModel.goodsNum integerValue]] forState:UIControlStateNormal];
            }
            
            [self setUpDataArrayZero];
            
            
            // 拿出购物车中的商品，遍历
            for (NSDictionary *dict in tempArray)
            {
                // 拿出购物车商品的goodsId
                NSString *goodsId = dict[@"goodsId"];
                // 与self.goodsDataArray中的商品进行比较，
                for (int i = 0; i < self.goodsDataArray.count; i++)
                {
                    NSDictionary *categoryGoods = self.goodsDataArray[i];
                    // 购物车中没有删除删除商品
                    if ([categoryGoods[@"goodsId"] intValue] == [goodsId intValue])
                    {
                        // 修改现在self.goodsDataArray中的对应商品的数据；
                        
                        // arr代表self.goodsDataArray;
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.goodsDataArray];
                        // categoryGoods正在遍历的分类中的商品；
                        NSMutableDictionary *selectedDictionary = [NSMutableDictionary dictionaryWithDictionary:categoryGoods];
                        // 分类商品的购买数量
                        NSNumber *buy =[selectedDictionary valueForKey:@"goodsNumber"];
                        // 购物车中的购买数量
                        int buyMore = [dict[@"goodsNumber"]  intValue];
                        
                        buy = [NSNumber numberWithInt:buyMore];
                        // 修改分类对应的商品数据
                        [selectedDictionary setValue:buy forKey:@"goodsNumber"];
                        // 替换self.goodsDataArray中的商品数据
                        [arr replaceObjectAtIndex:i withObject:selectedDictionary];
                        
                        self.goodsDataArray = arr;
                        self.categoryCellModelArray = [CYCategoryCellModel mj_objectArrayWithKeyValuesArray:self.goodsDataArray];

                        // 跳出循环
                        continue;
                        
                    }
                    
                }
            }
            
            NSString *goodsId=[[CommClass sharedCommon]objectForKey:CART_GOODSID];
            if ([DataCheck isValidString:goodsId]) {
                
                [self btnTouchAction:self.selectedButton];
            }

            
            [self.goodsTableView reloadData];
        }

//        if ([cartModel.goodsNum integerValue] > 0) {
//            [[TabBarController sharedInstance] showShopTitleMsg:cartModel.goodsShipping];
//
//        }
//        else
//        {
//            self.goodsNumberButton.hidden = YES;
//        }
    }
}

// 将slef.goodsDataArray置空
- (void)setUpDataArrayZero
{
    // 遍历self.goodsDataArray中的所有商品，直接设置为0；
    for (int i = 0; i < self.goodsDataArray.count; i++)
    {
        NSDictionary *dict = self.goodsDataArray[i];
        // arr代表self.goodsDataArray;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.goodsDataArray];
        // categoryGoods正在遍历的分类中的商品；
        NSMutableDictionary *selectedDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
        // 分类商品的购买数量
        NSNumber *buy =[selectedDictionary valueForKey:@"goodsNumber"];
        // 购物车中的购买数量
        int buyMore = 0;
        
        buy = [NSNumber numberWithInt:buyMore];
        // 修改分类对应的商品数据
        [selectedDictionary setValue:buy forKey:@"goodsNumber"];
        // 替换self.goodsDataArray中的商品数据
        [arr replaceObjectAtIndex:i withObject:selectedDictionary];
        
        self.goodsDataArray = arr;
        //
//        [self.goodsTableView reloadData];
        self.categoryCellModelArray = [CYCategoryCellModel mj_objectArrayWithKeyValuesArray:self.goodsDataArray];

    }

}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];

    self.searchView.hidden=YES;
    self.searchButton.hidden = YES;
    [self.searchTextField resignFirstResponder];
    
    self.homePagePushed = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBackgroundColor];
//    [self setUpSearchNavigationBar];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 创建刷新控件
    _pageNum = 1;
    [self setupHeaderRefresh:self.goodsTableView];
    [self setUpFooterRefresh:self.goodsTableView];

    [self setUpTableviews];
    //初始化为第一行

    [self initImageViewSingleTapGest];
    
    if (self.isHomePagePushed == YES)
    {
        self.typeId = self.transportID;
    }
    
//    if (self.isHomePagePushed == NO)
//    {
//        [self requestCategoryList];
//    }
    
    self.searchTextField.text=@"";
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor_HEX colorWithHexString:@"#cfa972"];
    // 字体大小
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入商品名称"
                                                                                 attributes:attributes];
    self.searchView.hidden = YES;
    
    [self setUpRightNavigationItem];
    
    if (self.homePagePushed == NO) {
        [self requestCategoryList];
    }

    [self setShoppingCartButtonView]; 
}

#pragma mark - searchBackground
//#pragma mark - 设置背景颜色
- (void)setUpBackgroundColor
{
    self.menuTableView.backgroundColor=[UIColor_HEX colorWithHexString:@"ECECEC"];
    self.menuTableView.layer.borderColor = [UIColor_HEX colorWithHexString:@"A8A8A8"].CGColor;
    self.menuTableView.layer.borderWidth = 0.5;
    self.goodsTableView.backgroundColor = [UIColor_HEX colorWithHexString:@"ECECEC"];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //创建搜索按钮
    self.searchBtn = [HomeViewModel createSearchViewAction:self.view];
    [self.searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpRightNavigationItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem
                                              creatItemWithTitle:@""
                                              normalColorString:nil
                                              hightLightColorString:nil
                                              addTarget:self
                                              action:nil];;
}

- (void)setUpSearchNavigationBar
{
    //头部搜索
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(39, self.navigationController.navigationBar.frame.size.height - 37, viewWidth - 51, 30)];
    searchBtn.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.760];
    searchBtn.layer.cornerRadius = 6;
    
    UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 6, 18, 18)];
    searchImg.image = [UIImage imageNamed:@"icon_homeSearch"];
    
    UILabel *searchLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImg.frame) + 4, 9, searchBtn.frame.size.width - 80, 12)];
    searchLab.font = [UIFont systemFontOfSize:12];
    searchLab.textColor = [UIColor_HEX colorWithHexString:@"cfa972"];
    searchLab.text = @"请输入商品名称";
    UIButton *sweepBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchBtn.frame.size.width - 42, 0, 42, 30)];
    [sweepBtn setImage:[UIImage imageNamed:@"icon_homeSweep"] forState:UIControlStateNormal];
    [sweepBtn addTarget:self action:@selector(sweepBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [searchBtn addSubview:searchImg];
    [searchBtn addSubview:searchLab];
    [searchBtn addSubview:sweepBtn];

    [self.navigationController.navigationBar addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.searchButton = searchBtn;
}


- (void)setShoppingCartButtonView
{
    self.goodsNumberButton.layer.masksToBounds = YES;
    self.goodsNumberButton.layer.cornerRadius = 10;
    self.goodsNumberButton.hidden = YES;
}


- (void)goToShopCartAction {
    
    
}

#pragma mark - navigationconBar初始化
- (void)searchBtnAction {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:searchView animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    });
}

- (void)sweepBtnAction {
    TempViewController *temp = [[TempViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:temp animated:true];
        self.hidesBottomBarWhenPushed = NO;
    });
}


#pragma mark - 懒加载
- (NSMutableArray *)goodsDataArray
{
    if (_goodsDataArray == nil)
    {
        _goodsDataArray = [NSMutableArray array];
    }
    
    return _goodsDataArray;
}

- (NSMutableArray *)menuDataArray
{
    if (_menuDataArray == nil)
    {
        _menuDataArray = [NSMutableArray array];
    }
    
    return _menuDataArray;
}

- (NSMutableArray *)shoppingArray
{
    if (_shoppingArray == nil)
    {
        _shoppingArray = [NSMutableArray array];
    }
    
    return _shoppingArray;
}

- (CloudClient *)cloudClient
{
    if (_cloudClient == nil)
    {
        _cloudClient = [CloudClient getInstance];
    }
    
    return _cloudClient;
}

- (NSMutableArray *)categoryCellModelArray
{
    if (_categoryCellModelArray == nil)
    {
        _categoryCellModelArray = [NSMutableArray array];
    }
    
    return _categoryCellModelArray;
}

- (NSMutableArray *)menuNameArray
{
    if (_menuNameArray == nil)
    {
        _menuNameArray = [NSMutableArray array];
    }
    
    return _menuNameArray;
}



#pragma mark - 注册tableviewCell
/**
 *  设置tableview
 */
- (void)setUpTableviews
{
    [self.menuTableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil]
             forCellReuseIdentifier:CYMenuCellIdentifier];
    [self.goodsTableView registerNib:[UINib nibWithNibName:@"CategoryDetailCell" bundle:nil]
              forCellReuseIdentifier:CYGoodsCellIdentifier];
    [self.goodsTableView registerNib:[UINib nibWithNibName:@"CategoryADCell" bundle:nil]
              forCellReuseIdentifier:CYAdCellIdentifier];
}

#pragma mark - 搜索按钮相关方法
//右边搜索图标点击事件
-(void)searchBtnTouch{
    
    [MobClick event:Search];
    if (![DataCheck isValidString:self.searchTextField.text])
    {
        [SRMessage infoMessage:@"请输入搜索内容！" delegate:self];

        
        [self.searchTextField resignFirstResponder];
    }else
    {
        [self gotoSearchView];
    }
}

//取消搜索执行
-(void)cancelSearch{

    self.searchTextField.text = @"";

    [self.searchTextField resignFirstResponder];
    
    
}

//点击搜索跳转至搜索页面
-(void)gotoSearchView{
    
    NSString *textFieldStr=[self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([textFieldStr isEqualToString:@""]) {
        [SRMessage infoMessage:@"请输入商品名称"];
        self.searchTextField.text=@"";
        return;
    }
    self.searchView.hidden=YES;
    SearchViewController *searchControl=[[SearchViewController alloc]initWithNibName:@"SearchViewController"
                                                                              bundle:nil];
    
    [self.searchTextField resignFirstResponder];
    searchControl.searchKey=self.searchTextField.text;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchControl animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

#pragma mark - 购物车相关

// 更新购物车信息
- (void)updateCartMessageTitle
{
    TabBarController *tabbar = [TabBarController sharedInstance];
    
    ShoppingCartModel *cartModel = [ShoppingCartModel shareModel];
//    NSInteger shoppingNum = [[cartModel goodsNum] integerValue];
//    NSLog(@"%@",[cartModel goodsNum]);
    NSString *message = [cartModel goodsShipping];
    DLog(@"%@",message);
}




//购物车点击手势
-(void)initImageViewSingleTapGest{
    
    self.shopBgImgView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(whenClickImage)];
    [self.shopBgImgView addGestureRecognizer:singleTap];
    
    self.cartImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 =
    [[UITapGestureRecognizer alloc]initWithTarget:self
                                           action:@selector(whenClickImage)];
    [self.cartImgView addGestureRecognizer:singleTap1];
}


//初始化购物车数据
-(void)initCartData{
    [self hidenHUD];
    ShoppingCartModel *cartModel = [ShoppingCartModel shareModel];
    
    NSInteger shoppingNum = [[cartModel goodsNum] integerValue];
    float totalPrice = [[cartModel goodsPrice] floatValue];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    self.numLabel.text = [NSString stringWithFormat:@"%ld件",(long)shoppingNum];
    self.diffPriceLabel.text = [cartModel goodsShipping];
    
    //判断购物车里面的商品个数是否为0
    if (shoppingNum<=0) {
        self.cartImgView.hidden=NO;
        self.shoppingView.hidden=YES;
        self.window.hidden = YES;
    }
    else{
        self.cartImgView.hidden=YES;
        
        self.window.hidden = NO;
        self.label.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    }
}
//跳转购物车页面
-(void)whenClickImage{
    
    if (![UserLoginModel isLogged]) {
        
        [[AppModel sharedModel] presentLoginController:self];
        return;
    }
    if ([UserLoginModel isShopOwner]) {
        [SRMessage infoMessageWithTitle:nil message:kMessage_001 delegate:self];
    }
    else if ([UserLoginModel isMarki])
    {
        [SRMessage infoMessageWithTitle:nil message:kMessage_002 delegate:self];
    }
    else
    {
        ShopCartController *shopCart=[[ShopCartController alloc]initWithNibName:@"ShopCartController"
                                                                         bundle:nil];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopCart animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - tableviewDataScource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.menuTableView)
        return [self.menuDataArray count];
    else
        return [self.goodsDataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.goodsTableView)
        return CYCtegoryRowHeight;
    else if (tableView == self.menuTableView)
        return CYMenuRowHeight;
    else
        return CYOtherRowHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.goodsTableView)
        return CYMenuHeaderViewHeight;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.goodsTableView)
    {
        return CYHeaderHeight;
    }else
    {
        return 0;
    }
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.menuTableView) {
        
        MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CYMenuCellIdentifier];
        
        NSString *imageUrl;
        if ( indexPath.row == self.whichCellFlag) {  
            // 点击了之后的imageUrl
            imageUrl=[[self.menuDataArray objectAtIndex:indexPath.row] objectForKey:@"imageUrl2"];
            [cell.typeLabel setTextColor:[UIColor_HEX colorWithHexString:@"FF5757"]];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectedIndicator.hidden = NO;
            cell.rightLine.hidden = YES;
        }
        else{
            // 未点击时的imageUrl0
            imageUrl=[[self.menuDataArray objectAtIndex:indexPath.row] objectForKey:@"imageUrl"];
            [cell.typeLabel setTextColor:[UIColor_HEX colorWithHexString:@"323232"]];
            cell.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
            cell.selectedIndicator.hidden = YES;
            cell.rightLine.hidden = NO;
            }
        
        [cell.desImgView setImageWithURL:[NSURL URLWithString:imageUrl]
                        placeholderImage:UIIMAGE(@"category_icon_default.png")];
        
        cell.typeLabel.text=[[self.menuDataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
    }
    
    
    else if (tableView == self.goodsTableView){
        
        NSString *advPic = [self.goodsDataArray[indexPath.row] objectForKey:@"advPic"];
        
        if ([DataCheck isValidString:advPic]) {
            
            CategoryADCell *cell = [tableView dequeueReusableCellWithIdentifier:CYAdCellIdentifier];

            [cell.ADImageview setImageWithURL:[NSURL URLWithString:advPic]
                             placeholderImage:UIIMAGE(@"advDefaultImg.png")];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        // 没有广告
        else{
            CategoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CYGoodsCellIdentifier];
            
            CYCategoryCellModel *model = self.categoryCellModelArray[indexPath.row];
            
            model.indexPathRow = indexPath.row;
            
            cell.model = model;
            
            cell.delegate = self;
            
            return cell;
        }
        
    }
    else{
        return nil;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (tableView == self.goodsTableView)
//    {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, CYMenuHeaderViewHeight)];
//        view.backgroundColor = [UIColor whiteColor];
//        
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, view.bounds.size.width - 30, view.bounds.size.height)];
//        lable.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
//        lable.font = [UIFont systemFontOfSize:12];
//        
//        NSInteger IDNumber = 0;
//        NSString *title = nil;
//        
//        if (self.menuDataArray.count != 0)
//        {
//            for (int i = 0; i<self.menuDataArray.count; i++)
//            {
//                if (self.typeId == [self.menuDataArray[i] objectForKey:@"id"])
//                {
//                    IDNumber = i;
//                    break;
//                }
//            }
//            
//            title = [self.menuNameArray objectAtIndex:IDNumber];
//            
//        }else
//        {
//            title = @"";
//        }
//        
//        
//        lable.text = [NSString stringWithFormat:@"%@", title];
//        
//        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 3, 12)];
//        imageview.image = [UIImage imageNamed:@"tableviewSectionImage"];
//        [view addSubview:imageview];
//        [view addSubview:lable];
//        
//        return view;
//        
//    }
//    
//    return nil;
//}

#pragma mark - tableview代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchTextField resignFirstResponder];
    // 点击的是goods
    if (tableView == self.goodsTableView)
    {
        //广告图片
        NSString *advPic=[[self.goodsDataArray objectAtIndex:indexPath.row] objectForKey:@"advPic"];
        
        if ([DataCheck isValidString:advPic]) {
            //标题
            //NSString *advName=[[self.goodsDataArray objectAtIndex:section] objectForKey:@"advName"];
            //链接
            NSString *urlLink=[self.goodsDataArray[indexPath.row] objectForKey:@"urlLink"];
            
            
            if ([DataCheck isValidString:urlLink]) {
                
                // 分类广告点击
//                [MobClick event:Clik_AD];
                GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView"
                                                                                       bundle:nil];
                advShowWebView.advUrlLink=urlLink;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:advShowWebView animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
        }
        
        else{
            CommodityDetailsViewController * commodityDetail = [[CommodityDetailsViewController alloc]init];
//            commodityDetail.cid = self.typeId;
            commodityDetail.goodsId = [self.goodsDataArray[indexPath.row] objectForKey:@"goodsId"];
            
#warning 立即购买商品的跳转
            // 选择的是那种商品
            CYCategoryCellModel *model = self.categoryCellModelArray[indexPath.row];
            
            DLog(@"%zd",[self.typeId integerValue]);
            // 普通商品
            if (model.sellType == 0)
            {
                // 友盟埋点,统计前三个商品点击量
                [self MobClickCategory:[self.typeId integerValue] NumberOfRow:indexPath.row];
                // 友盟埋点，统计某一个分类下商品的总点击数
                [self MobClickCategoryGoods:[self.typeId integerValue]];
                
                self.hidesBottomBarWhenPushed = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController pushViewController:commodityDetail animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                });
            }
            // 跳H5的商品
            else
            {
                [self pushToBuyNowWebiew:model.link];
            }
        }
    }
    // 如果点击的是menu
    else{
        //typeId分类ID
        self.typeId=[self.menuDataArray[indexPath.row] objectForKey:@"id"];
        DLog(@"%@",self.typeId);
        [self MobClick:[self.typeId integerValue]];
        if ([self isNotNetwork]) {
            [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
            return;
        }
        _pageNum=1;
        isToTop=YES;
        self.whichCellFlag=indexPath.row;
        self.typeId=[self.menuDataArray[indexPath.row] objectForKey:@"id"];
        [self.menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self.refreshHeaderView beginRefreshing];
        [self.menuTableView reloadData];
        [self requestCategoryGoods];
        [self.goodsTableView reloadData];
    }
}

#pragma mark - 友盟统计相关
//友盟统计分类
/**
 0  今日推荐 28 素食饼干 29 清纯水饮 30 酣畅酒饮 31 粮油调味
 32 洗护日用 33 牛奶咖啡 34 缤纷酷饮 35 闲暇小食 36 代买香烟
 */
-(void)MobClick:(NSInteger)categoryId
{
    switch (categoryId) {
            //今日推荐
//        case 0:
//            [MobClick event:Today_Recmd];
//            break;
        case 28:
            [MobClick event:Cat_Cookie];
            break;
        case 29:
            [MobClick event:Cat_Water];
            break;
        case 30:
            [MobClick event:Cat_Wine];
            break;
        case 31:
            [MobClick event:Cat_GrainOil];
            break;
        case 32:
            [MobClick event:Cat_WashProt];
            break;
        case 33:
            [MobClick event:Cat_MilkCoff];
            break;
        case 34:
            [MobClick event:Cat_Drinks];
            break;
        case 35:
            [MobClick event:Cat_Snacks];
            break;
        case 36:
            [MobClick event:Cat_Cigaret];
            break;
        default:
            break;
    }
}

/**
 0  今日推荐 28 素食饼干 29 清纯水饮 30 酣畅酒饮 31 粮油调味
 32 洗护日用 33 牛奶咖啡 34 缤纷酷饮 35 闲暇小食 36 代买香烟
 */
- (void)MobClickCategory:(NSInteger)categoryId NumberOfRow:(NSInteger)row
{
    switch (categoryId) {
            //今日推荐
            //        case 0:
            //            [MobClick event:Today_Recmd];
            //            break;
        case 28:
            switch (row)
           {
                case 0:
                   [MobClick event:Cat_Cookie_Pos1];
                    break;
                case 1:
                   [MobClick event:Cat_Cookie_Pos2];
                   break;
                case 2:
                   [MobClick event:Cat_Cookie_Pos3];
                   break;
                default:
                    break;
            }
            break;
            
        case 29:
            switch (row)
        {
            case 0:
                [MobClick event:Cat_Water_Pos1];
                break;
            case 1:
                [MobClick event:Cat_Water_Pos2];
                break;
            case 2:
                [MobClick event:Cat_Water_Pos3];
                break;
            default:
                break;
        }
            break;
            

        case 30:
            switch (row)
        {
            case 0:
                [MobClick event:Cat_Wine_Pos1];
                break;
            case 1:
                [MobClick event:Cat_Wine_Pos2];
                break;
            case 2:
                [MobClick event:Cat_Wine_Pos3];
                break;
                
            default:
                break;
            }
            
            break;
        case 31:
            switch (row)
        {
            case 0:
                [MobClick event:Cat_GrainOil_Pos1];
                break;
            case 1:
                [MobClick event:Cat_GrainOil_Pos2];
                break;
            case 2:
                [MobClick event:Cat_GrainOil_Pos3];
                break;
                
            default:
                break;
        }
            
            break;
        case 32:
            
            switch (row)
        {
            case 0:
                [MobClick event:Cat_WashProt_Pos1];
                break;
            case 1:
                [MobClick event:Cat_WashProt_Pos2];
                break;
            case 2:
                [MobClick event:Cat_WashProt_Pos3];
                break;
                
            default:
                break;
        }
            
            break;
            
        case 33:
            switch (row)
        {
            case 0:
                [MobClick event:Cat_MilkCoff_Pos1];
                break;
            case 1:
                [MobClick event:Cat_MilkCoff_Pos2];
                break;
            case 2:
                [MobClick event:Cat_MilkCoff_Pos3];
                break;
                
            default:
                break;
        }
            
            break;
        case 34:
            
            switch (row)
        {
            case 0:
                [MobClick event:Cat_Drinks_Pos1];
                break;
            case 1:
                [MobClick event:Cat_Drinks_Pos2];
                break;
            case 2:
                [MobClick event:Cat_Drinks_Pos3];
                break;
                
            default:
                break;
        }
            
            break;
        case 35:
            
            switch (row)
        {
            case 0:
                [MobClick event:Cat_Snacks_Pos1];
                break;
            case 1:
                [MobClick event:Cat_Snacks_Pos2];
                break;
            case 2:
                [MobClick event:Cat_Snacks_Pos3];
                break;
                
            default:
                break;
        }
            
            break;
        case 36:
            [MobClick event:Cat_Cigaret];
            
            switch (row)
        {
            case 0:
                [MobClick event:Cat_Cigaret_Pos1];
                break;
            case 1:
                [MobClick event:Cat_Cigaret_Pos2];
                break;
            case 2:
                [MobClick event:Cat_Cigaret_Pos3];
                break;
                
            default:
                break;
        }
            
            break;
        default:
            break;
    }
}

- (void)MobClickCategoryGoods:(NSInteger)categoryId
{
    switch (categoryId) {
            //今日推荐
            //        case 0:
            //            [MobClick event:Today_Recmd];
            //            break;
        case 28:
            [MobClick event:Cat_Cookie_SKUClik];
            break;
        case 29:
            [MobClick event:Cat_Water_SKUClik];
            break;
        case 30:
            [MobClick event:Cat_Wine_SKUClik];
            break;
        case 31:
            [MobClick event:Cat_GrainOil_SKUClik];
            break;
        case 32:
            [MobClick event:Cat_WashProt_SKUClik];
            break;
        case 33:
            [MobClick event:Cat_MilkCoff_SKUClik];
            break;
        case 34:
            [MobClick event:Cat_Drinks_SKUClik];
            break;
        case 35:
            [MobClick event:Cat_Snacks_SKUClik];
            break;
        case 36:
            [MobClick event:Cat_Cigaret_SKUClik];
            break;
        default:
            break;
    }
}

-(void)MobClickAddButton:(NSInteger)categoryId
{
    switch (categoryId) {
            //今日推荐
            //        case 0:
            //            [MobClick event:Today_Recmd];
            //            break;
        case 28:
            [MobClick event:Cat_Cookie_AddClik];
            break;
        case 29:
            [MobClick event:Cat_Water_AddClik];
            break;
        case 30:
            [MobClick event:Cat_Wine_AddClik];
            break;
        case 31:
            [MobClick event:Cat_GrainOil_AddClik];
            break;
        case 32:
            [MobClick event:Cat_WashProt_AddClik];
            break;
        case 33:
            [MobClick event:Cat_MilkCoff_AddClik];
            break;
        case 34:
            [MobClick event:Cat_Drinks_AddClik];
            break;
        case 35:
            [MobClick event:Cat_Snacks_AddClik];
            break;
        case 36:
            [MobClick event:Cat_Cigaret_AddClik];
            break;
        default:
            break;
    }
}


#pragma mark - 添加购物车
-(void)btnTouchAction:(id)sender{
    
    DLog(@"%zd",self.typeId);
    NSInteger tag=[(UIButton *)sender tag];
    
    NSNumber *buy = [[self.goodsDataArray objectAtIndex:tag] objectForKey:@"goodsNumber"];
    int buyNumber = [buy intValue];
    if (buyNumber >= 99)
    {
        [SRMessage infoMessage:@"购物车中该商品超过最大值" delegate:self];
        return;
    }

    NSString *goodsId=[[self.goodsDataArray objectAtIndex:tag] objectForKey:@"goodsId"];
    
    if (![UserLoginModel isLogged]) {
        [[CommClass sharedCommon]setObject:[NSString stringWithFormat:@"%@",goodsId] forKey:CART_GOODSID];
        [[CommClass sharedCommon]setObject:[NSString stringWithFormat:@"%zd",tag] forKey:CART_GOODSID_TAG];
        [[AppModel sharedModel] presentLoginController:self];
        self.selectedButton = (UIButton *)sender;
        return;
    }
//    if ([UserLoginModel isShopOwner]) {
//        [SRMessage infoMessage:kMessage_001 delegate:self];
//        return;
//    }
//    if ([UserLoginModel isMarki]) {
//        [SRMessage infoMessage:kMessage_002 delegate:self];
//        return;
//    }
    
    NSString *addId=[[CommClass sharedCommon]objectForKey:CART_GOODSID];
    if ([DataCheck isValidString:addId]) {
        goodsId=[[CommClass sharedCommon]objectForKey:CART_GOODSID];
    }
    else{
        goodsId=[[self.goodsDataArray objectAtIndex:tag] objectForKey:@"goodsId"];
    }
    
    // 友盟统计，某一分类所有按钮点击数量
    [self MobClickAddButton:[self.typeId integerValue]];
    
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    UIButton *btn = (UIButton *)sender;
    CGPoint point = [btn convertPoint:btn.center toView:self.view];
    //创建动画view
    UIImageView *animationView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth, point.y - 30, 30, 30)];
//    animationView.image = [UIImage imageNamed:@"icon"];
    animationView.backgroundColor = [UIColor clearColor];
    animationView.layer.masksToBounds = YES;
    animationView.layer.cornerRadius = 15;
    animationView.tag = tag;
    [self.view addSubview:animationView];
    [self showView:animationView];
}



#pragma mark - 加入购物车动画
- (void)showView:(UIImageView *)myView {
    [self.goodsTableView setScrollEnabled:NO];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(thePath, NULL, myView.center.x - 30, myView.center.y - 15);
    CGPathAddQuadCurveToPoint(thePath, NULL, 150, 30, [UIScreen mainScreen].bounds.size.width *0.5, [UIScreen mainScreen].bounds.size.height - 100);

//    CGPathMoveToPoint(thePath, NULL, myView.center.x - 25, myView.center.y);
//    CGPathAddQuadCurveToPoint(thePath, NULL, 150, 30, viewWidth/2, kViewHeight);
    
    bounceAnimation.path = thePath;
    bounceAnimation.duration = 0.5;
    [myView.layer addAnimation:bounceAnimation forKey:@"move"];
    
//    [self performSelector:@selector(hidenView:) withObject:myView afterDelay:0.5f];
    [self showHUD];
    [self hidenView:myView];

}


- (void)hidenView:(UIView *)myView {
    [self.goodsTableView setScrollEnabled:YES];
    
    NSString *goodsId=[[CommClass sharedCommon]objectForKey:CART_GOODSID];
    if ([DataCheck isValidString:goodsId]) {
        goodsId = [[CommClass sharedCommon]objectForKey:CART_GOODSID];
    }
    else{
        goodsId = [[self.goodsDataArray objectAtIndex:myView.tag] objectForKey:@"goodsId"];
    }
    self.goodsId = goodsId;
    //请求购物车数据
//    ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
//    [cartModel addWithGoodsId:goodsId];
    
    if ([DataCheck isValidString:[[CommClass sharedCommon]objectForKey:CART_GOODSID]])
    {
        myView.tag = [[[CommClass sharedCommon]objectForKey:CART_GOODSID_TAG] intValue];
    }
    
    NSNumber *buy = [[self.goodsDataArray objectAtIndex:myView.tag] objectForKey:@"goodsNumber"];
    int buyNumber = [buy intValue];
    buyNumber += 1;
    
    NSString *buyNumberString = [NSString stringWithFormat:@"%d",buyNumber];
    
    [self editCartType:@"1" goodsId:goodsId number:buyNumberString];
    
    
    [self initCartData];
    
    
    
    // 将选中行的goodsId保存起来
//    self.goodsId = goodsId;
//    
//    int i = 0;
//    
//    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.goodsDataArray];
//    
//    NSDictionary *dict =  [self.goodsDataArray objectAtIndex:myView.tag] ;
//    
//    NSMutableDictionary *selectedDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
//    
//    NSNumber *buy =[selectedDictionary valueForKey:@"buy"];
//
//    int buyMore = [buy intValue];
//
//    buyMore +=1;
//    
//    buy = [NSNumber numberWithInt:buyMore];
//    
//    [selectedDictionary setValue:buy forKey:@"buy"];
//    
//    [arr replaceObjectAtIndex:myView.tag withObject:selectedDictionary];
//    
//    self.goodsDataArray = arr;
//    
    
    
//    // 按照goodsId找出商品
//    for (CYCategoryCellModel *model in self.categoryCellModelArray)
//    {
//        if ([goodsId integerValue] == model.goodsId)
//        {
//            model.buy +=1;
//            
//            // 更新模型
//            [self.categoryCellModelArray replaceObjectAtIndex:myView.tag withObject:model];
//
//            // 刷新某一行数据
//            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:myView.tag inSection:0];
//            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//            [self.goodsTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//
//            break;
//        }
//}
    // 编辑购物车，更改分类对应goods的数据，只是告诉服务器，我秀改了这个商品，更新服务器的数据；
//    [self editCartType:@1 goodsId:goodsId number:@1];


    
    self.numLabel.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    self.numLabel.transform = CGAffineTransformMakeScale(3.0f, 3.0f);//将要显示的view按照正常比例显示出来
    
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  //InOut 表示进入和出去时都启动动画
    
    [UIView setAnimationDuration:0.5f];//动画时间
    
    self.numLabel.transform=CGAffineTransformMakeScale(1.0f, 1.0f);//先让要显示的view最小直至消失
    
    [UIView commitAnimations];
    [myView removeFromSuperview];
    
    
}


/**
 * 减号按钮点击之后，应该做的动作：1.商品数量减少，goodsCount变小，更新指定得cell
                              2.更新购物车图标上的文字，满多少减运费
                              3.更新购物车数据 cartModel;
 */
- (void)minusGoodsCount:(id)sender
{
    NSInteger tag=[(UIButton *)sender tag];
    NSString *goodsId=[[self.goodsDataArray objectAtIndex:tag] objectForKey:@"goodsId"];
    
    if (![UserLoginModel isLogged]) {
        [[CommClass sharedCommon]setObject:[NSString stringWithFormat:@"%@",goodsId] forKey:CART_GOODSID];
        [[AppModel sharedModel] presentLoginController:self];
        return;
    }
    if ([UserLoginModel isShopOwner]) {
        [SRMessage infoMessage:kMessage_001 delegate:self];
        return;
    }
    if ([UserLoginModel isMarki]) {
        [SRMessage infoMessage:kMessage_002 delegate:self];
        return;
    }
    // 为了防止在未登录的时候点击了添加或者删除商品按钮，在登录之后继续进行动画，故而记下goodsId；
    NSString *minusId=[[CommClass sharedCommon]objectForKey:CART_GOODSID];
    // 未登录
    if ([DataCheck isValidString:minusId]) {
        goodsId=[[CommClass sharedCommon]objectForKey:CART_GOODSID];
    }
    // 已经登录
    else{
        goodsId=[[self.goodsDataArray objectAtIndex:tag] objectForKey:@"goodsId"];
    }

    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    
    self.goodsId = goodsId;

    
    NSNumber *buy = [[self.goodsDataArray objectAtIndex:tag] objectForKey:@"goodsNumber"];
    int buyNumber = [buy intValue];
    buyNumber -= 1;
    
    NSString *buyNumberString = [NSString stringWithFormat:@"%d",buyNumber];
    
    if (buyNumber >=1 )
    {
        [self editCartType:@"1" goodsId:goodsId number:buyNumberString];
    }else
    {
        [self editCartType:@"2" goodsId:goodsId number:buyNumberString];
    }
    
    DLog(@"----------------");
}

-(void)editCartType:(NSString *)editType goodsId:(NSString *)goodsId number:(NSString *)number{
    
    NSDictionary *paramsDic=@{@"type":editType,
                              @"goodsId":goodsId,
                              @"number":number,
                              @"settlement":@1};
    paramsDic = @{@"goodsId":goodsId, @"number":@"1"};
    
    [_cloudClient requestMethodWithMod:@"cart/addCart"
                                params:nil
                            postParams:paramsDic
                              delegate:self
                              selector:@selector(editSuccess:)
                         errorSelector:@selector(editFail:)
                      progressSelector:nil];
}





// 编辑成功后，还需刷新购物车提示,调用【self getCartTotalData】;
-(void)editSuccess:(NSDictionary*)response{
    
    [self hidenHUD];
    if ([DataCheck isValidDictionary:response]) {
        
        NSString *number = response[@"cartInfo"][@"cartNumber"];
        [[TabBarController sharedInstance] setShopCartNumberAction:number];
    }
    
    if ([DataCheck isValidString:[[CommClass sharedCommon] objectForKey:CART_GOODSID]])
    {
        self.goodsId = [[CommClass sharedCommon] objectForKey:CART_GOODSID];
    }
    // 一次用完之后清空存储的goodsId;
    [[CommClass sharedCommon] setObject:@"" forKey:CART_GOODSID];
    

    // 此处response是购物车中的所有的商品
    NSMutableArray *array = [response[@"goodsList"] mutableCopy];
    
    NSMutableDictionary *goodsDictionary = [NSMutableDictionary dictionary];
    // 找出array中与goodsId相符合的那一个
    for (NSDictionary *dict in array)
    {
        if ([self.goodsId integerValue] == [[dict objectForKey:@"goodsId"] integerValue])
        {
            goodsDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
            break;
        }
    }
    
    
        int i = 0;
        for (NSDictionary *dict in self.goodsDataArray)
        {
            if ([self.goodsId integerValue] == [[dict objectForKey:@"goodsId"] integerValue])
            {
                
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.goodsDataArray];
                
                NSDictionary *goodsDict =  [self.goodsDataArray objectAtIndex:i] ;
                
                NSMutableDictionary *selectedDictionary = [NSMutableDictionary dictionaryWithDictionary:goodsDict];
                
                NSNumber *buy =[goodsDictionary valueForKey:@"goodsNumber"];
                
                [selectedDictionary setValue:buy forKey:@"goodsNumber"];
                    
                [arr replaceObjectAtIndex:i withObject:selectedDictionary];
                        
                self.goodsDataArray = arr;
                
                // 刷新某一行数据
//                NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:i inSection:0];
//                
//                NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//                
//                [self.goodsTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                
                break;
            }
            
            i++;
        }
    
    // 避坑
    CategoryModel *cateModel = [CategoryModel shareModel];
    cateModel.goodsDataArray = self.goodsDataArray;
    
    self.categoryCellModelArray = [CYCategoryCellModel mj_objectArrayWithKeyValuesArray:self.goodsDataArray];

    
    [self.goodsTableView reloadData];
    
//
//    // 更新模型 购物车中的goodsNumber和首页以及分类的buy是一致的；返回来的数据就是购物车中的商品，返回的数据，应该就是现在应该显示的数量，拿出edit返回的goodsId，将这个Id对应的goodsNumber赋值给goodsId对应的商品的buy；之后，刷新制定的这一行；首先要拿到正在修改的商品的goodsId，保存，然后这个地方就可以用了
//    if ([DataCheck isValidArray:[response objectForKey:@"goodsList"]]) {
////        self.cartInfoArray=[[response objectForKey:@"goodsList"] mutableCopy];
//        
//        self.goodsArray = [CYCartGoodsModel mj_objectArrayWithKeyValuesArray:response[@"goodsList"]];
//        // 购物车信息模型数组
//        self.infoArray = [CYCartInfoModel mj_objectArrayWithKeyValuesArray:@[response[@"cartInfo"]]];
//        
//        [self traverseGoodsInfo:self.cartInfoArray];
//        
//        //        NSArray *cartList = [response objectForKey:@"cartHomeTotalList"];
//        //        NSArray *cartList = [response objectForKey:@"cartInfo"];
//        //        NSDictionary* cartInfo=[self formatSpecialArray:cartList];
//        
//        NSDictionary *cartInfo = response[@"cartInfo"];
//        
//        //更新购物车数据
//        ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
//        [cartModel updateShoppingCartInfo:cartInfo];
//        //self.editArray=[self.cartInfoArray mutableCopy];
//        [self.goodsTableView reloadData];
//    }
//    else {
//        self.cartInfoArray=[NSMutableArray array];
//        [self traverseGoodsInfo:self.cartInfoArray];
//        self.editArray=[self.cartInfoArray mutableCopy];
//        [self.goodsTableView reloadData];
//        self.emptyView.hidden=NO;
//        
//        self.navigationItem.rightBarButtonItem = nil;
//        deleteView.hidden = YES;
//    }
//
    
    // 更新购物车信息，显示还差多少钱免配送费；
    [self getCartTotalData];
    
//    [self getCartTotaInfo];
}

-(void)editFail:(NSDictionary*)response{
    [self hidenHUD];
    
}


#pragma mark - getdata 获取标签和商品列表

-(void)requestCategoryList{
    
    if ([self noNetwork]) {
        [self hidenHUD];
        return;
    }
    [self showHUD];
    
    NSDictionary *paramsDic=@{@"pageNum":@"0"};
    [self.cloudClient requestMethodWithMod:@"category/getCategoryList"
                                    params:nil
                                postParams:paramsDic
                                  delegate:self
                                  selector:@selector(requestCategoryListSuccess:)
                             errorSelector:@selector(requestCategoryListFail:)
                          progressSelector:nil];
}


// 获取所有的分类
-(void)requestCategoryListSuccess:(NSDictionary*)response{
    
    [response writeToFile:@"/Users/eqbang/Desktop/22222.plist" atomically:YES];
    
    [self hidenHUD];
    if ([DataCheck isValidArray:[response objectForKey:@"categoryList"]]) {
        
        self.menuDataArray=[response objectForKey:@"categoryList"];
        
        for (int i = 0; i<self.menuDataArray.count; i++)
        {
            NSString *name = [self.menuDataArray[i] objectForKey:@"name"];
            
            [self.menuNameArray addObject:name];
        }

        
        NSString *selectedID = nil;
        int circleNumber = 0;
        
        if (self.isHomePagePushed == YES)
        {
            _pageNum = 1;
            // 遍历每一个id
            for (int i = 0; i< self.menuDataArray.count; i++)
            {
                selectedID = [[self.menuDataArray objectAtIndex:i] objectForKey:@"id"];
                
                DLog(@"%@,%@",selectedID,self.transportID);
                
                if ([self.transportID integerValue] == [selectedID integerValue])
                {
                    circleNumber = i;
                    self.homePagePushed = NO;
                    break;
                }
            }
            
        }
        
        self.whichCellFlag = circleNumber;
        
        DLog(@"%zd",self.menuDataArray.count);
        [self.menuTableView reloadData];
        
        [self.menuTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:circleNumber inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        
        self.typeId=[[self.menuDataArray objectAtIndex:circleNumber] objectForKey:@"id"];
        
        DLog(@"%@",self.typeId);
        
        CategoryModel *cateModel=[CategoryModel shareModel];
        [cateModel updateCategoryGoods:[self.menuDataArray objectAtIndex:circleNumber] page:_pageNum];
        self.goodsDataArray= cateModel.goodsDataArray;

        
        [self requestCategoryGoods];
        
//        [self.goodsTableView reloadData];
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
}

-(void)requestCategoryListFail:(NSDictionary*)response{
    [super hidenHUD];
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
}

#pragma mark - 获取特定分类的商品列表
/**
 * Method name: requestCategoryGoods
 * Description: 根据分类ID 获取goods列表数据
 */
-(void)requestCategoryGoods{
    
    if ([self noNetwork]) {
        [super hidenHUD];
        return;
    }
    if ([DataCheck isValidString:self.typeId]||[DataCheck isValidNumber:self.typeId]) {
        
        NSDictionary *paramsDic=@{@"pageNum":[NSString stringWithFormat:@"%d",_pageNum],
                                  @"cid":self.typeId};
        
        [self.cloudClient requestMethodWithMod:@"category/getCategoryGoodsList"//@"goods/getCategoryGoods"
                                        params:nil
                                    postParams:paramsDic
                                      delegate:self
                                      selector:@selector(requestCategorySuccess:)
                                 errorSelector:@selector(requestCategoryFail:)
                              progressSelector:nil];
    }
}

// 请求成功之后，显示新的menu的商品；
-(void)requestCategorySuccess:(NSDictionary *)response{
    
    [response writeToFile:@"/Users/eqbang/Desktop/888888.plist" atomically:YES];
    self.totalPageNumber = response[@"totalPage"];
    DLog(@"%zd",[self.totalPageNumber intValue]);
    CategoryModel *cateModel=[CategoryModel shareModel];
    [cateModel updateCategoryGoods:response page:_pageNum];
    self.goodsDataArray=cateModel.goodsDataArray;
    
#warning 更新categoryCellModel数组
    self.categoryCellModelArray = [CYCategoryCellModel mj_objectArrayWithKeyValuesArray:self.goodsDataArray];
    
    [self.goodsTableView reloadData];
    // 上拉下拉刷新都停掉，防止数据错误
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    
    // 如果是第一页而且需要在顶部，滚动到顶部；
//    if (_pageNum==1 && isToTop==YES) {
//        [self.goodsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
//                                   atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
    
//    [self.goodsTableView reloadData];
    ShoppingCartModel *model = [ShoppingCartModel shareModel];
    
    if ([UserLoginModel isLogged])
    {
        if (model.shopInfos.count == 0)
        {
            self.goodsNumberButton.hidden = YES;
        }else
        {
            self.goodsNumberButton.hidden = NO;
            if (model.shopInfos.count >99)
            {
                [self.goodsNumberButton setTitle:@"..." forState:UIControlStateNormal];
            }else
            {
                [self.goodsNumberButton setTitle:[NSString stringWithFormat:@"%zd",[model.goodsNum integerValue]] forState:UIControlStateNormal];
            }
        }
        
    }else
    {
        self.goodsNumberButton.hidden = YES;
    }
    
    
    [self hidenHUD];

}

-(void)requestCategoryFail:(NSDictionary *)response{
    [super hidenHUD];
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    
    if (_pageNum==1 && isToTop==YES) {
        [self.goodsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                   atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - 上下拉刷新
//下拉刷新方法
-(void)headerRereshing
{
    isToTop=NO;
    _pageNum = 1;
    [self requestCategoryGoods];
}
//上拉加载方法
-(void)footerRereshing
{
    long nextType = self.whichCellFlag;
    nextType += 1;
    if ((_pageNum == [self.totalPageNumber intValue]) && (nextType < self.menuDataArray.count))
    {
        [self tableView:self.menuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:nextType
                                                                                      inSection:0]];
        
    }else
    {
        _pageNum+=1;
        [self requestCategoryGoods];
    }
}


// 添加下拉取消搜索操作
#pragma  mark - 新添加方法 下拉任意tableview的时候，取消搜索；
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cancelSearch];
}

#pragma mark - 没网view的delegate方法
// 没网之后，显示出来的重新加载的按钮，点击重新加载的按钮之后的动作；
-(void)reloadAgainAction
{
    [super showHUD];
    [self headerRereshing];
    [self requestCategoryList];
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.searchTextField becomeFirstResponder];
    
    DLog(@"%s",__FUNCTION__);
}

#pragma mark - 获取购物车信息
- (void)getCartTotaInfo
{
    if ([self isNotNetwork]) {
        return;
    }
    
    [_cloudClient requestMethodWithMod:@"cart/getCart"
                                params:nil
                            postParams:nil
                              delegate:self
                              selector:@selector(getCartTotalInfoFinish:)
                         errorSelector:nil
                      progressSelector:nil];
}

- (void)getCartTotalInfoFinish:(NSDictionary *)response {
    
    if ([DataCheck isValidDictionary:response]) {
        //更新购物车数据
        NSDictionary *cartInfo = [response objectForKey:@"cartInfo"];
    
        ShoppingCartModel *cartModel = [ShoppingCartModel shareModel];
        [cartModel updateShoppingCartInfo:cartInfo];
        
        if ([[cartInfo objectForKey:@"cartNumber"] integerValue] > 0) {
            
            self.goodsNumberButton.hidden = NO;
            [self.goodsNumberButton setTitle:[NSString stringWithFormat:@"%zd",[[cartInfo objectForKey:@"cartNumber"] integerValue]] forState:UIControlStateNormal];
        }
        else
        {
            self.goodsNumberButton.hidden = YES;
        }
    }
}


#pragma mark - 立即购买商品跳转H5
- (void)pushToBuyNowWebiew:(NSString *)urlLink
{
    if ([DataCheck isValidString:urlLink]) {
        GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView"
                                                                               bundle:nil];
        advShowWebView.advUrlLink = urlLink;
        self.hidesBottomBarWhenPushed = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:advShowWebView animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        });
    }
}


#pragma  mark - searchTextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}

#pragma mark - 扫描二维码
- (IBAction)scanButtonClick:(UIButton *)sender
{
    TempViewController *temp = [[TempViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:temp animated:true];
        self.hidesBottomBarWhenPushed = NO;
    });
}
- (IBAction)shoppingCartButtonClick:(UIButton *)sender
{
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
    
    ShoppingCartModel *cartModel = [ShoppingCartModel shareModel];
    
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
    
    __weak __typeof (self) weakSelf = self;
    
    [self presentSemiViewController:shoppingCartController
                        withOptions:@{
                                      KNSemiModalOptionKeys.pushParentBack : @(NO),
                                      KNSemiModalOptionKeys.parentAlpha : @(0.5)
                                      }
                         completion:nil
                       dismissBlock:^{
                           [weakSelf getCartTotalData];
//                           [self.navigationController setNavigationBarHidden:NO];

                           if ([cartModel.goodsNum integerValue] > 0)
                           {
                               self.searchButton.hidden = NO;
                               
                               if ([cartModel.goodsNum integerValue] >99)
                               {
                                   [weakSelf.goodsNumberButton setTitle:@"..." forState:UIControlStateNormal];
                               }else
                               {
                                   [weakSelf.goodsNumberButton setTitle:[NSString stringWithFormat:@"%zd",[cartModel.goodsNum integerValue]] forState:UIControlStateNormal];
                               }
                           }else
                           {
                               [weakSelf.goodsNumberButton setTitle:@"" forState:UIControlStateNormal];
                               weakSelf.goodsNumberButton.hidden = YES;
                               
                           }
                           
                       }];

}

#pragma mark - CYShopCartingViewControllerDelegate
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
    
    
//    [self.navigationController setNavigationBarHidden:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:confirmControll animated:YES];
    });
//    [self.navigationController setNavigationBarHidden:NO];


}


@end
