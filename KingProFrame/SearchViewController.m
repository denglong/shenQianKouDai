//
//  SearchViewController.m
//  KingProFrame
//
//  Created by JinLiang on 15/8/27.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "SearchViewController.h"
#import "CYSearchResultGoodsModel.h"
#import "UIBarButtonItem+CYExtensioin.h"
#import "NavigationController.h"
#import "GeneralShowWebView.h"
#import "EvaluteNoPhysicObjectViewController.h"

@interface SearchViewController ()<reloadDelegate,CYSearchResultGoodsModelDelegate>
{
    UIView * noNetWork;
    int _pageNum;
    NSString *goodsId;
}

/** 搜索出的商品数组 */
@property (nonatomic , strong) NSMutableArray *searchResultGoods;
/** 是否是第一次进入搜索页面 */
@property (nonatomic,assign,getter=isfirstEnterSearch) BOOL firstEnterSearch;

/** searchView */
@property (nonatomic , strong) UIView *searchView;
/** 搜索的textField */
@property (nonatomic , strong) UITextField *navigationSearchTextField;
/** 空白页面 */
@property (nonatomic , strong) UIView *emptyView;

@end


@implementation SearchViewController
#pragma mark - synthesis
@synthesize searchInfoArray;
@synthesize searchTableView;
@synthesize navSearchView;
@synthesize searchTextField;
@synthesize searchKey;
@synthesize noSearchView;
@synthesize chooseOkBtn;

#pragma mark - 控制器view生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNum=1;
    self.firstEnterSearch = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResignFirstResponse)];
    
    [self.noSearchView addGestureRecognizer:tap];
    
    //创建刷新控件
    //    [self setupRefresh:self.searchTableView];
    [self setUpFooterRefresh:self.searchTableView];
    
    self.searchInfoArray=[NSMutableArray array];
    
    _cloudClient=[CloudClient getInstance];
    
    
    [self setUpChooseOkButton];
    
    
    self.navSearchView.hidden=YES;
    

    
    [self setUpRightNavigationItem];
    
    self.priceLabel.backgroundColor=[UIColor clearColor];
    self.goodsNumLabel.backgroundColor=[UIColor clearColor];
    self.shippingLabel.backgroundColor=[UIColor clearColor];
    
    for (UIViewController *controller in [self.navigationController viewControllers]) {
        if ([controller isKindOfClass:[SearchViewController class]]) {
            
            [controller.navigationController.view addSubview:self.navSearchView];
        }
        else{
            [self.navSearchView removeFromSuperview];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initSearchCartData)
                                                 name:NOTIFICATION_UPDATESHOPPINGCARTINFO
                                               object:nil];
    
    //    [self searchingInShopGoods];
    [self initSearchCartData];
    [self setUpSearchResultTableview];
    
    [self setUpEmptyView];

    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
   
    [self setUpSearchNavigationBar];
    [self setUpSearchTextfield];

    if (self.isfirstEnterSearch == YES)
    {
        self.noSearchView.hidden = NO;
        [self.navigationSearchTextField becomeFirstResponder];
    }else
    {
        self.noSearchView.hidden = YES;
    }
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    if ([DataCheck isValidString:[[CommClass sharedCommon]objectForKey:CART_GOODSID]]) {
        [self addSearchGoodsAction:nil];
    }
    
    [self initSearchCartData];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navSearchView.hidden=YES;
    [self noNetwork];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.searchView.hidden = NO;
    
    
    //    [self setupHeaderRefresh:self.searchTableView];
    [self setUpNoAutoRefreshHeader:self.searchTableView];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navSearchView.hidden=YES;
    [self.navigationSearchTextField resignFirstResponder];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.searchView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化设置

- (void)setUpEmptyView
{
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    emptyView.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResignFirstResponse)];
    
    [emptyView addGestureRecognizer:tap];
    
    self.emptyView = emptyView;
    
    [self.view insertSubview:emptyView aboveSubview:self.noSearchView];
    
}


- (void)setUpSearchNavigationBar
{

    if (self.searchView == nil)
    {
        // 头部搜索
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(20, self.navigationController.navigationBar.frame.size.height - 35, viewWidth - 75, 28)];
        searchView.backgroundColor = [UIColor whiteColor];
        self.searchView = searchView;
        
        [[searchView layer] setShadowOffset:CGSizeMake(1, 1)]; // 阴影的范围
        [[searchView layer] setShadowRadius:1]; // 阴影扩散的范围控制
        [[searchView layer] setShadowOpacity:0.5]; // 阴影透明度
        [[searchView layer] setShadowColor:[UIColor blackColor].CGColor]; // 阴影的颜色
        
        // 圆角
        searchView.layer.cornerRadius=14;
        searchView.layer.borderColor=[[UIColor whiteColor] CGColor];
        searchView.layer.borderWidth=0.0f;
        
        // 放大镜
        UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(14, 6, 17, 16)];
        searchImg.image = [UIImage imageNamed:@"icon_search"];
        
        // textfield
        UITextField *navigationTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImg.frame) + 12, 7, searchView.frame.size.width - 45, 15)];
        navigationTextField.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.760];

        navigationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //    navigationTextField.placeholder = @"请输入商品名称";
        navigationTextField.delegate = self;
        navigationTextField.font = [UIFont systemFontOfSize:12];
        self.navigationSearchTextField = navigationTextField;
        
        [searchView addSubview:searchImg];
        [searchView addSubview:navigationTextField];
        
        [self.navigationController.navigationBar addSubview:searchView];

    }
}

- (void)setUpChooseOkButton
{
    self.chooseOkBtn.layer.cornerRadius=34/2;
    self.chooseOkBtn.layer.borderColor=[[UIColor clearColor] CGColor];
    self.chooseOkBtn.layer.borderWidth=0.0f;
}

- (void)setUpSearchTextfield
{
    self.navigationSearchTextField.backgroundColor=[UIColor clearColor];
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor_HEX colorWithHexString:@"323232"];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    // 设置UITextField的占位文字
    self.navigationSearchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入商品名称" attributes:attributes];
    
//    self.searchTextField.text=self.searchKey;
    
    [self.navigationSearchTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventAllEditingEvents];
    
}

- (void)setUpRightNavigationItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem
                                              creatItemWithTitle:@"取消"
                                              normalColorString:@"#6a3906"
                                              hightLightColorString:@"#6a3906"
                                              addTarget:self
                                              action:@selector(cancelSearch)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                             creatItemWithTitle:@""
                                             normalColorString:nil
                                             hightLightColorString:nil
                                             addTarget:self
                                             action:nil];
    self.navigationItem.backBarButtonItem = nil;
    
}

#pragma mark - 设置搜索结果tableview
- (void)setUpSearchResultTableview
{
    [self.searchTableView registerNib:[UINib nibWithNibName:@"CYSearchTableViewCell" bundle:nil] forCellReuseIdentifier:CYSearchResultGoodsCellIdentifier];
}

#pragma mark - 懒加载
- (NSMutableArray *)searchResultGoods
{
    if (_searchResultGoods == nil)
    {
        _searchResultGoods = [NSMutableArray array];
    }
    
    return  _searchResultGoods;
}





#pragma mark - 手动设置约束
//手动设置约束
-(void)setConstraints{
    
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.navSearchView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.navigationController.view
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0f
                                                                       constant:10.0f];
    //logoImageView右侧与父视图右侧对齐
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.navigationController.view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.navSearchView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0f
                                                                        constant:62.0f];
    
    //logoImageView顶部与父视图顶部对齐
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.navSearchView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.navigationController.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:27.0f];
    
    //logoImageView高度为父视图高度
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:self.navSearchView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0f
                                                                         constant:30.0f];
    
    [self.navigationController.view addConstraints:@[leftConstraint,rightConstraint,topConstraint,heightConstraint]];
    
    //iOS 8.0以后设置active属性值
    if (IOS8) {
        leftConstraint.active = YES;
        rightConstraint.active = YES;
        topConstraint.active = YES;
        heightConstraint.active = YES;
    }
}


#pragma mark - 立即购买商品跳转H5
- (void)pushToBuyItRightNowWebiew:(NSString *)urlLink
{
    if ([DataCheck isValidString:urlLink]) {
        GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
        advShowWebView.advUrlLink = urlLink;
        self.hidesBottomBarWhenPushed = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:advShowWebView animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        });
    }
}

#pragma mark - 点击收起键盘
- (void)tapResignFirstResponse
{
    if ([self.navigationSearchTextField isFirstResponder])
    {
        [self.navigationSearchTextField resignFirstResponder];
    }
}

#pragma mark - 滚动tableview时候,收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.navigationSearchTextField resignFirstResponder];
}



#pragma mark - 上拉下拉刷新

//下拉刷新方法
-(void)headerRereshing
{
    if (self.isfirstEnterSearch == YES)
    {
        [self.refreshHeaderView endRefreshing];
        [SRMessage infoMessage:@"请输入商品名称" delegate:self];
        self.firstEnterSearch = NO;
        self.noSearchView.hidden=NO;
        return;
    }else
    {
        _pageNum = 1;
        [self searchingInShopGoods];
    }
}
//上拉加载方法
-(void)footerRereshing
{
    _pageNum+=1;
    [self searchingInShopGoods];
}


#pragma mark - textField delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//        NSString * toBeString =[textField.text stringByReplacingCharactersInRange:range withString:string];
//    
////        if (textField == self.searchTextField) {
//            if (self.searchTextField.text.length > 0) {
//
    //            UIBarButtonItem *rightBarButtonItem = [self  createRightItem:self
    //                                                                 itemStr:@"搜索"
    //                                                               itemImage:nil
    //                                                             itemImageHG:nil
    //                                                                selector:@selector(doSearchAction)];
    //
    //            rightBarButtonItem.tintColor = [UIColor_HEX colorWithHexString:@"ffffff"];
    //
    //            self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    //            self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatItemWithTitle:@"搜索"
    //                                                                       normalColorString:@"#6a3906"
    //                                                                   hightLightColorString:@"#6a3906"
    //                                                                               addTarget:self
    //                                                                                  action:@selector(doSearchAction)];
    
    
    
    //        }else{
    ////            self.navigationItem.rightBarButtonItem = [self  createRightItem:self
    ////                                                                    itemStr:@"取消"
    ////                                                                  itemImage:nil
    ////                                                                itemImageHG:nil
    ////                                                                   selector:@selector(cancelSearch)];
    //
    //            self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatItemWithTitle:@"取消"
    //                                                                       normalColorString:@"#6a3906"
    //                                                                   hightLightColorString:@"#6a3906"
    //                                                                               addTarget:self
    //                                                                                  action:@selector(cancelSearch)];
    //        }
    //    }
    
//    if ([DataCheck isValidString:self.searchTextField.text])
//    {
//        [self doSearchAction];
//    }else
//    {
//        self.noSearchView.hidden = NO;
//        self.searchTableView.hidden = YES;
//    }
    
//            }

//        }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //    if (textField.text.length<=0) {
    //        self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatItemWithTitle:@"搜索"
    //                                                                   normalColorString:@"#6a3906"
    //                                                               hightLightColorString:@"#6a3906"
    //                                                                           addTarget:self
    //                                                                              action:@selector(doSearchAction)];
    //    }
    //    else{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatItemWithTitle:@"取消"
                                                               normalColorString:@"#6a3906"
                                                           hightLightColorString:@"#6a3906"
                                                                       addTarget:self
                                                                          action:@selector(cancelSearch)];
    //    }
    
}

- (void)textFieldTextChange:(UITextField *)textField
{

    
    if ([DataCheck isValidString:self.navigationSearchTextField.text])
    {
        if (self.emptyView)
        {
            [self.emptyView removeFromSuperview];
        }
        [self doSearchAction];
    }else
    {
        self.noSearchView.hidden = NO;
        self.searchTableView.hidden = YES;
    }
}




#pragma mark - 搜索相关

//右边搜索图标点击时间
-(void)searchBtnTouch{
    
    self.navSearchView.hidden=NO;
    //    self.navigationItem.rightBarButtonItem = [self  createRightItem:self
    //                                                            itemStr:@"取消"
    //                                                          itemImage:nil
    //                                                        itemImageHG:nil
    //                                                           selector:@selector(cancelSearch)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem
                                              creatItemWithTitle:@"取消"
                                              normalColorString:@"#6a3906"
                                              hightLightColorString:@"#6a3906"
                                              addTarget:self
                                              action:@selector(cancelSearch)];
    
    
}


//取消搜索执行
-(void)cancelSearch{
    
    [self.navigationSearchTextField resignFirstResponder];
    [self backAction:nil];
}

-(void)doSearchAction{
    _pageNum=1;
    [self searchingInShopGoods];
}

//点击搜索按钮执行界面切换
-(void)searchingInShopGoods{
    
    //    [self.searchTextField resignFirstResponder];
    
    //    [self.refreshHeaderView endRefreshing];
    
    self.firstEnterSearch = NO;
    
    if ([self noNetwork]) {
        return;
    }
    
//    self.searchTextField.text = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![DataCheck isValidString:self.navigationSearchTextField.text]) {
        [SRMessage infoMessage:@"请输入商品名称" delegate:self];
        self.navigationSearchTextField.text=@"";
        [self.refreshHeaderView endRefreshing];
        return;
    }
    NSDictionary *paramsDic=@{@"keywords":self.navigationSearchTextField.text,
                              @"pageNum":[NSString stringWithFormat:@"%d",_pageNum]};
    
    [_cloudClient requestMethodWithMod:@"goods/search"
                                params:nil
                            postParams:paramsDic
                              delegate:self
                              selector:@selector(searchSuccess:)
                         errorSelector:@selector(searchFail:)
                      progressSelector:nil];
    
}

-(void)searchSuccess:(NSDictionary *)response{
    
    
    [self hidenHUD];
    if ([DataCheck isValidDictionary:response]) {
        if ([DataCheck isValidArray:[response objectForKey:@"goodsList"]]) {
            
            if (_pageNum>1) {
                NSMutableArray *tmpArray=[[response objectForKey:@"goodsList"] mutableCopy];
                [self.searchInfoArray addObjectsFromArray:tmpArray];
                
                NSMutableArray *temporayArray = [CYSearchResultGoodsModel mj_objectArrayWithKeyValuesArray:response[@"goodsList"]];
                [self.searchResultGoods addObjectsFromArray:temporayArray];
                
            }
            else{
                self.searchInfoArray=[[response objectForKey:@"goodsList"] mutableCopy];
                self.searchResultGoods = [CYSearchResultGoodsModel mj_objectArrayWithKeyValuesArray:response[@"goodsList"]];
            }
            
            
            if (self.navigationSearchTextField.text.length == 0)
            {
                [self.searchResultGoods removeAllObjects];
                self.searchTableView.hidden = YES;
                self.noSearchView.hidden = NO;
            }else
            {
                self.searchTableView.hidden=NO;
                self.noSearchView.hidden=YES;
            }

            [self.searchTableView reloadData];
        }
        else{
            if (_pageNum==1) {
                self.searchTableView.hidden=YES;
                self.noSearchView.hidden=NO;
            }
        }
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
}

-(void)searchFail:(NSDictionary *)response{
    [self hidenHUD];
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
}


#pragma mark - tableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.searchInfoArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    footView.backgroundColor = [UIColor clearColor];
    
    return footView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    Class cellClass=[CYSearchTableViewCell class];
    //    NSString *indentifier=NSStringFromClass(cellClass);
    CYSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CYSearchResultGoodsCellIdentifier];
    
    //    if (!cell) {
    //
    //        cell=[[[NSBundle mainBundle] loadNibNamed:@"CYSearchTableViewCell" owner:self options:nil] objectAtIndex:0];
    //    }
    if (self.searchResultGoods.count > 0)
    {
        CYSearchResultGoodsModel *model = self.searchResultGoods[indexPath.row];
        //    cell.addBtn.tag = indexPath.row;
        cell.buttonTag = indexPath.row;
        NSLog(@"%zd",indexPath.row);
        [cell.addBtn addTarget:self action:@selector(addSearchGoodsAction:) forControlEvents:UIControlEventTouchUpInside];
        //    cell.delegate = self;
        cell.model = model;
        cell.delegate = self;
    }
    
    //    NSInteger section=[indexPath row];
    //
    //    cell.addBtn.tag=section;
    //    [cell.addBtn addTarget:self
    //                    action:@selector(addSearchGoodsAction:)
    //          forControlEvents:UIControlEventTouchUpInside];
    
    //    cell.addExtBtn.tag=section;
    //    [cell.addExtBtn addTarget:self
    //                       action:@selector(addSearchGoodsAction:)
    //             forControlEvents:UIControlEventTouchUpInside];
    
    
    //    NSLayoutConstraint *widthConstraint=[NSLayoutConstraint constraintWithItem:cell.desImageView
    //                                                                     attribute:NSLayoutAttributeWidth
    //                                                                     relatedBy:NSLayoutRelationEqual
    //                                                                        toItem:nil
    //                                                                     attribute:NSLayoutAttributeWidth
    //                                                                    multiplier:1.0f
    //                                                                      constant:89.0f];
    //
    //    [cell addConstraint:widthConstraint];
    
    //图片地址
    //    NSString *imageUrl=[[self.searchInfoArray objectAtIndex:section] objectForKey:@"goodsPic"];
    //    [cell.desImageView setImageWithURL:[NSURL URLWithString:imageUrl]
    //                      placeholderImage:UIIMAGE(@"goods_icon_default.png")];
    //
    //    //价格
    //    float goodsPrice=[[[self.searchInfoArray objectAtIndex:section] objectForKey:@"goodsPrice"] floatValue];
    //    //是否热销 0:否 1:是
    //    int isHot=[[[self.searchInfoArray objectAtIndex:section] objectForKey:@"isHot"] intValue];
    //
    //    if (isHot==0)
    //        cell.hotImageView.hidden=YES;
    //    else if (isHot==1)
    //        cell.hotImageView.hidden=NO;
    //    cell.goodsNameLabel.text=[[self.searchInfoArray objectAtIndex:section] objectForKey:@"goodsName"];
    //    cell.priceLabel.text=[NSString stringWithFormat:@"￥%.2f",goodsPrice];
    //    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommodityDetailsViewController * commodityDetail = [[CommodityDetailsViewController alloc]init];

    CYSearchResultGoodsModel *model = self.searchResultGoods[indexPath.row];
    commodityDetail.goodsId = [NSString stringWithFormat:@"%zd",model.goodsId];
    
        if (model.sellType ==0)
        {
            self.hidesBottomBarWhenPushed = YES;
            self.searchView.hidden = YES;
            [self.navigationController pushViewController:commodityDetail animated:YES];
        }
        else
        {
            if ([DataCheck isValidString:model.link])
            {
                GeneralShowWebView *advShowWebView=[[GeneralShowWebView alloc]initWithNibName:@"GeneralShowWebView" bundle:nil];
                advShowWebView.advUrlLink= model.link;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:advShowWebView animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
        }
}



#pragma mark - 添加购物车
-(void)addSearchGoodsAction:(id)sender{
    
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检测您的网络" delegate:self];
        return;
    }
    
    NSInteger tag=[(UIButton *)sender tag];
    
    goodsId=[[self.searchInfoArray objectAtIndex:tag] objectForKey:@"goodsId"];
    
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
    
    
    if ([DataCheck isValidString:[[CommClass sharedCommon]objectForKey:CART_GOODSID]]) {
        
        goodsId=[[CommClass sharedCommon]objectForKey:CART_GOODSID];
    }
    else{
        goodsId=[[self.searchInfoArray objectAtIndex:tag] objectForKey:@"goodsId"];
    }
    
    //    ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
    //
    //    [cartModel addWithGoodsId:goodsId];
    
    //待定？？？
    //[self initSearchCartData];
    
    UIButton *btn = (UIButton *)sender;
    CGPoint point = [btn convertPoint:btn.center toView:self.view];
    //创建动画view
    UIImageView *animationView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth, point.y - 50, 30, 30)];
    animationView.image = [UIImage imageNamed:@"icon"];
    animationView.layer.masksToBounds = YES;
    animationView.layer.cornerRadius = 15;
    animationView.tag = tag;
    [self.view addSubview:animationView];
    [self showView:animationView];
}



#pragma mark - 加入购物车动画
- (void)showView:(UIImageView *)myView {
    [searchTableView setScrollEnabled:NO];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(thePath, NULL, myView.center.x - 30, myView.center.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, 150, 30, 15, kViewHeight - 70);
    
    bounceAnimation.path = thePath;
    bounceAnimation.duration = 0.5;
    [myView.layer addAnimation:bounceAnimation forKey:@"move"];
    
    [self performSelector:@selector(hidenView:) withObject:myView afterDelay:0.5f];
}

- (void)hidenView:(UIView *)myView {
    [searchTableView setScrollEnabled:YES];
    
    myView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    self.goodsNumLabel.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    self.goodsNumLabel.transform = CGAffineTransformMakeScale(3.0f, 3.0f);//将要显示的view按照正常比例显示出来
    
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  //InOut 表示进入和出去时都启动动画
    
    [UIView setAnimationDuration:0.5f];//动画时间
    
    self.goodsNumLabel.transform=CGAffineTransformMakeScale(1.0f, 1.0f);//先让要显示的view最小直至消失
    
    [UIView commitAnimations];
    [myView removeFromSuperview];
    
    //    [self showHUD];
    //请求购物车数据
    ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
    [cartModel addWithGoodsId:goodsId];
}

#pragma mark - 点击选好了按钮
- (IBAction)chooseOkTouch:(id)sender {
    
    if (![UserLoginModel isLogged]) {
        
        [[AppModel sharedModel] presentLoginController:self];
        return;
    }
    
    if ([UserLoginModel isShopOwner]) {
        [SRMessage infoMessageWithTitle:nil message:kMessage_001 delegate:self];
        return;
    }
    if ([UserLoginModel isMarki]) {
        [SRMessage infoMessageWithTitle:nil message:kMessage_002 delegate:self];
        return;
    }
    
    ShopCartController * shopCartController = [[ShopCartController alloc]init];
    NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:shopCartController];
    [self presentViewController:navigation animated:YES completion:nil];
    
}

#pragma mark - 购物车相关
//给购物车里面赋值
-(void)initSearchCartData{
    
    [self hidenHUD];
    ShoppingCartModel *cartModel=[ShoppingCartModel shareModel];
    
    int shoppingNum=[[cartModel goodsNum] floatValue];
    float goodsPrice=[[cartModel goodsPrice] floatValue];
    
    self.priceLabel.text   =[NSString stringWithFormat:@"￥%.2f",goodsPrice];
    self.goodsNumLabel.text=[NSString stringWithFormat:@"%d件", shoppingNum];
    self.shippingLabel.text=[cartModel goodsShipping];;
    
    //判断购物车里面的商品个数是否为0
    if (shoppingNum<=0) {
        self.priceLabel.hidden=YES;
        self.goodsNumLabel.hidden=YES;
        self.shippingLabel.hidden=YES;
    }
    else{
        self.priceLabel.hidden=NO;
        self.goodsNumLabel.hidden=NO;
        self.shippingLabel.hidden=NO;
    }
}

#pragma mark - 无网相关
//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        [self hidenHUD];
        self.searchTableView.hidden = YES;
        [self.navigationSearchTextField resignFirstResponder];
        self.btnView.hidden = YES;
        self.noSearchView.hidden = YES;
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        
        return YES;
    }
    else
    {
        //self.searchTableView.hidden = NO;
//        self.btnView.hidden = NO;
        [noNetWork removeFromSuperview];
        return NO;
    }
}

// 点击重新加载按钮
-(void)reloadAgainAction{
    
    [super showHUD];
    [self searchingInShopGoods];
}


@end
