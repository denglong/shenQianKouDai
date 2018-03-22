//
//  MyAddressViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/8/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MyAddressViewController.h"
#import "MyAddressCell.h"
#import "editMyAddressCell.h"
#import "NewAddressViewController.h"
#import "newAddressCell.h"
#import "MyAddressModel.h"
#import "AddressReqModel.h"
#import "ListModel.h"
#import "SWTableViewCell.h"
@interface MyAddressViewController ()<UITableViewDataSource,UITableViewDelegate,reloadDelegate,SWTableViewCellDelegate,newAddressDelegate>
{
    NSMutableArray * list;
    CloudClient * _cloudClient;
    NSInteger _pageNum;
    UIView * noNetWork;
}
@property (weak, nonatomic) IBOutlet UITableView *myAddressTableView;
@property (weak, nonatomic) IBOutlet UIButton *addressNUllView;
@property (nonatomic , retain) ListModel * chooseAddressList;
@property(nonatomic , copy) addressNumBlock myBlock;
@end

@implementation MyAddressViewController
-(void)setAddressNumBlock:(addressNumBlock)block
{
    self.myBlock = block;
}
//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        [super hidenHUD];
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        return YES;
    }
    else
    {
        [noNetWork removeFromSuperview];
        return NO;
    }
}
-(void)reloadAgainAction{
    if (self.confirmPage == 1 || self.confirmPage == 3) {
        [self getChooseAddressList];
    }else{
       [self headerRereshing];
    }
}

#pragma mark - interface
/*获取我的地址列表*/
-(void)getMyAddressList
{
    if ([self noNetwork]) {
        return;
 
    }
    NSString * _pageStr = [NSString stringWithFormat:@"%ld",(long)_pageNum];
    NSDictionary * postParams = @{@"pageNum":_pageStr};
    [_cloudClient requestMethodWithMod:@"member/getAddress"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(getMyAddressListSuccessed:)
                         errorSelector:@selector(getMyAddressListError:)
                      progressSelector:nil];
    
}
-(void)getMyAddressListSuccessed:(NSDictionary *)response
{
    ListModel * addressList = [ListModel mj_objectWithKeyValues:response];
    if ([DataCheck isValidArray:addressList.addressList]) {
        if (_pageNum == 1) {
            [list removeAllObjects];
        }
        [list addObjectsFromArray:addressList.addressList];
    }else{
        if (_pageNum >1) {
            _pageNum--;
        }else{
            [list removeAllObjects];
        }
    }
    if ([DataCheck isValidArray:list]) {
        self.myAddressTableView.hidden = NO;
        self.addressNUllView.hidden = YES;
       [self.myAddressTableView reloadData];
    }else{
        self.myAddressTableView.hidden = YES;
         self.addressNUllView.hidden = NO;
    }

    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [super hidenHUD];
}
-(void)getMyAddressListError:(NSDictionary *)response
{
    if (_pageNum >1) {
        _pageNum--;
    }
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [super hidenHUD];
    
}
/*获取我的地址列表*/
-(void)getChooseAddressList
{
    if ([self noNetwork]) {
        return;
    }
    [_cloudClient requestMethodWithMod:@"member/getChooseAddress"
                                params:nil
                            postParams:nil
                              delegate:self
                              selector:@selector(getChooseAddressListSuccessed:)
                         errorSelector:@selector(getChooseAddressListError:)
                      progressSelector:nil];
    
}
-(void)getChooseAddressListSuccessed:(NSDictionary *)response
{
    _chooseAddressList = [ListModel mj_objectWithKeyValues:response];
    [list removeAllObjects];
    [list addObjectsFromArray:_chooseAddressList.availableList];
    [list addObjectsFromArray:_chooseAddressList.unavailableList];
    
    [self.myAddressTableView reloadData];
    [super hidenHUD];
}
-(void)getChooseAddressListError:(NSDictionary *)response
{
    [super hidenHUD];
}
/*删除地址*/
-(void)CancelAddress:(NSString *)addressId
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [super showHUD];
    NSDictionary * postParams = @{@"type":@"3",@"id":addressId};
    [_cloudClient requestMethodWithMod:@"member/setAddress"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(CancelAddressSuccessed:)
                         errorSelector:@selector(CancelAddressError:)
                      progressSelector:nil];
    
}
-(void)CancelAddressSuccessed:(NSDictionary *)response
{
    [super hidenHUD];
    [list removeAllObjects];
    ListModel * addressList = [ListModel mj_objectWithKeyValues:response];
    if ([DataCheck isValidArray:addressList.addressList]) {
        _pageNum = 1;
        [list addObjectsFromArray:addressList.addressList];
    }
    if ([DataCheck isValidArray:list]) {
        [self.myAddressTableView reloadData];
    }else{
        self.myAddressTableView.hidden = YES;
        self.addressNUllView.hidden = NO;
    }
    
}
-(void)CancelAddressError:(NSDictionary *)response
{
    [super hidenHUD];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.title = @"收货地址";
    if (self.confirmPage != 1 && self.confirmPage != 3) {
        self.title = @"我的地址";
    }

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     if (self.confirmPage == 1 || self.confirmPage == 3) {
         [self getChooseAddressList];
     }else{
//         if ([UserLoginModel isLogged]) {
//             [self setupHeaderRefresh:self.myAddressTableView];
//         }
     }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

/** 注册cell*/
-(void)addressRegisterCell
{
    [self.myAddressTableView registerNib:[UINib  nibWithNibName:@"newAddressCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([newAddressCell class])];
    [self.myAddressTableView registerNib:[UINib  nibWithNibName:@"MyAddressCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyAddressCell class])];
    [self.myAddressTableView registerNib:[UINib  nibWithNibName:@"editMyAddressCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([editMyAddressCell class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addressRegisterCell];
    [super setExtraCellLineHidden:self.myAddressTableView];
    if (self.confirmPage != 1 && self.confirmPage != 3) {
//        [self setUpFooterRefresh:self.myAddressTableView];
        [self setupHeaderRefresh:self.myAddressTableView];
    }
    self.navigationItem.rightBarButtonItem = [super createRightItem:self itemStr:@"新建" itemImage:nil itemImageHG:nil selector:@selector(newAddress:)];
    list = [NSMutableArray array];
    _cloudClient = [CloudClient getInstance];
    
//     if (self.confirmPage == 1) {
//        self.myAddressTableView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0);
//     }
    
//    [super showHUD];
}

//下拉刷新方法
-(void)headerRereshing
{
    _pageNum = 1;
    [self getMyAddressList];
}
//上拉加载方法
-(void)footerRereshing
{
    _pageNum++;
    [self getMyAddressList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return list.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    float w = viewWidth-12-21-36;
    MyAddressModel * addressModel = [list objectAtIndex:indexPath.section];

        if ((self.confirmPage == 1 || self.confirmPage == 3)) {
            if (indexPath.section < _chooseAddressList.availableList.count) {
                if ([addressModel.ID isEqualToString:self.selectedID]) {
                    w = viewWidth-12-21-36;
                }else{
                    w = viewWidth-12-12;
                }
            }else{
                w = viewWidth-12-21-36;
            }
        }else{
           w = viewWidth-12-12;
        }
    NSString * address = [NSString stringWithFormat:@"%@%@%@",addressModel.street,addressModel.address,addressModel.addressDetail];
    CGSize size = [CommClass getSuitSizeWithString:address font:12 bold:NO sizeOfX:w];
    return 43+size.height+13;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyAddressCell class])];
    cell.selectedID = self.selectedID;
    if ((self.confirmPage == 1 || self.confirmPage == 3)) {
        if (indexPath.section < _chooseAddressList.availableList.count) {
            [cell setAddressModel:[list objectAtIndex:indexPath.section] index:1];
        }else{
          [cell setAddressModel:[list objectAtIndex:indexPath.section] index:2];
        }
    }else{
        [cell setAddressModel:[list objectAtIndex:indexPath.section] index:0];
    }
    
    if (!IOS9) {
        [cell setRightUtilityButtons:[self rightButtons:indexPath.section] WithButtonWidth:80.0];
        cell.delegate = self;
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((self.confirmPage == 1 || self.confirmPage == 3)&& section == _chooseAddressList.availableList.count) {
        return 30;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.933 alpha:0.000];
    if ((self.confirmPage == 1 || self.confirmPage == 3)&& section == _chooseAddressList.availableList.count) {
        headerView.frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-30, 30)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        label.text = @"以下地址超出配送范围";
        [headerView addSubview:label];
    }
    return headerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MyAddressModel * addressModel = [list objectAtIndex:indexPath.section];
    if (self.confirmPage == 1 || self.confirmPage == 3) {
        if (indexPath.section < _chooseAddressList.availableList.count) {
            
            NSString *address  = [NSString stringWithFormat:@"%@%@",addressModel.address,addressModel.addressDetail];
            
            NSDictionary *values = @{@"address":address,
                                     @"addressUser":addressModel.addressUser,
                                     @"addressTel":addressModel.addressTel};
            [[CommClass sharedCommon] localObject:addressModel.lat forKey:AddressLat];
            [[CommClass sharedCommon] localObject:addressModel.lng forKey:AddressLng];
            
            [self.trendDelegate passTrendValues:values andAddressId:addressModel.ID];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString * msg = [NSString stringWithFormat:@"是否切换到【%@】？切换后当前订单信息将会消失",addressModel.address];
            [SRMessage infoMessage:msg title:@"已经超出配送范围"  cancelTitle:@"换个地址" sureTitle:@"确认切换" block:^{
                CLLocation * location = [[CLLocation alloc]initWithLatitude:[addressModel.lat floatValue] longitude:[addressModel.lng floatValue]];
                NSDictionary * selectedAddress = @{@"area":addressModel.street,@"address":addressModel.address,@"location":location,@"cityCode":addressModel.cityCode};
                [[CommClass sharedCommon] setObject:selectedAddress forKey:LocationAddress];
                [[NSNotificationCenter defaultCenter] postNotificationName:CHANGELOCATIONLATANDLNG object:addressModel.address userInfo:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.confirmPage == 1 || self.confirmPage == 3) {
         return NO;
    }
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self canclebtnClick:indexPath];
    }];
    deleteRowAction.backgroundColor = [UIColor colorWithRed:1.000 green:0.353 blue:0.118 alpha:1.000];
    // 删除一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self editbtnClick:indexPath];
    }];
    topRowAction.backgroundColor = [UIColor colorWithRed:0.561 green:0.765 blue:0.122 alpha:1.000];
    
    // 添加一个更多按钮
    MyAddressModel * addressModel = [list objectAtIndex:indexPath.section];
    NSString * title = @"默认";
    if ([addressModel.ifDefault integerValue] == 1) {
        title = @"取消默认";
    }
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self ifDefaultbtnClick:indexPath];
    }];
     moreRowAction.backgroundColor = [UIColor colorWithRed:0.078 green:0.725 blue:0.839 alpha:1.000];
    
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, topRowAction, moreRowAction];
}

#pragma mark - 自定义删除按钮
- (NSArray *)rightButtons:(NSInteger)section
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    MyAddressModel * addressModel = [list objectAtIndex:section];
    NSString * title = @"默认";
    if ([addressModel.ifDefault integerValue] == 1) {
        title = @"取消默认";
    }
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.078 green:0.725 blue:0.839 alpha:1.000]
                                                title:title];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.561 green:0.765 blue:0.122 alpha:1.000]
                                                title:@"编辑"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.000 green:0.353 blue:0.118 alpha:1.000]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}
#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [self.myAddressTableView indexPathForCell:cell];
           [self ifDefaultbtnClick:cellIndexPath];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.myAddressTableView indexPathForCell:cell];
             [self editbtnClick:cellIndexPath];
            break;
        }
        case 2:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.myAddressTableView indexPathForCell:cell];
            [self canclebtnClick:cellIndexPath];
            break;
        }

        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            if (self.confirmPage == 1 || self.confirmPage == 3)
            {
                return NO;
            }
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark - 新建地址
-(void)newAddress:(id)sender
{
    NewAddressViewController * newAddressViewController = [[NewAddressViewController alloc]init];
    newAddressViewController.type = @"1";
    if (self.confirmPage == 1 ||self.confirmPage == 3) {
        newAddressViewController.confirmPage = self.confirmPage;
        newAddressViewController.confirmPageList = YES;
        newAddressViewController.addressDelegate = self.delegate;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newAddressViewController animated:YES];
}

#pragma mark - 编辑地址

-(void)editbtnClick:(NSIndexPath *)sender
{
    NewAddressViewController * newAddressViewController = [[NewAddressViewController alloc]init];
    newAddressViewController.type = @"2";
    newAddressViewController.addressInfo = [list objectAtIndex:sender.section];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newAddressViewController animated:YES];
}

-(void)canclebtnClick:(NSIndexPath *)sender
{
    [SRMessage infoMessage:@"确认删除当前地址吗？" block:^{
        MyAddressModel * addressModel = [list objectAtIndex:sender.section];
        [self CancelAddress:addressModel.ID];
    }];
   
}

-(void)ifDefaultbtnClick:(NSIndexPath *)sender
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [super showHUD];
    MyAddressModel * addressModel = [list objectAtIndex:sender.section];
    [[AddressReqModel sharedInstance] setId:addressModel.ID];
    [[AddressReqModel sharedInstance] setAddress:addressModel.address];
    [[AddressReqModel sharedInstance] setLat:addressModel.lat];
    [[AddressReqModel sharedInstance] setLng:addressModel.lng];
    [[AddressReqModel sharedInstance] setType:@"2"];
    [[AddressReqModel sharedInstance] setAddressDetail:addressModel.addressDetail];
    [[AddressReqModel sharedInstance] setAddressTel:addressModel.addressTel];
    [[AddressReqModel sharedInstance] setAddressUser:addressModel.addressUser];
    [[AddressReqModel sharedInstance] setStreet:addressModel.street];
    [[AddressReqModel sharedInstance] setCityCode:addressModel.cityCode];
    if ([addressModel.ifDefault integerValue] == 1) {
        [[AddressReqModel sharedInstance] setIfDefault:@"0"];
    }else{
        [[AddressReqModel sharedInstance] setIfDefault:@"1"];
    }
    NSDictionary * postParams = [RequestModel class:@"AddressReqModel"];
    [_cloudClient requestMethodWithMod:@"member/setAddress"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(ifDefaultAddressSuccessed:)
                         errorSelector:@selector(ifDefaultAddressError:)
                      progressSelector:nil];

}

-(void)ifDefaultAddressSuccessed:(NSDictionary *)response
{
    [super hidenHUD];
    [RequestModel clearModel:@"AddressReqModel"];
    [list removeAllObjects];
    ListModel * addressList = [ListModel mj_objectWithKeyValues:response];
    if ([DataCheck isValidArray:addressList.addressList]) {
        _pageNum = 1;
        [list addObjectsFromArray:addressList.addressList];
    }
    [self.myAddressTableView reloadData];
}

-(void)ifDefaultAddressError:(NSDictionary *)response
{
    [super hidenHUD];
    
}

-(void)backAction:(id)sender {
    
    if (self.confirmPage == 1 || self.confirmPage == 3 )  {
        if (list.count == 0) {
            [self.trendDelegate passTrendValues:nil andAddressId:nil];
        }
    }else{
        if (self.myBlock !=nil && list.count != self.addressnum) {
            self.myBlock(list.count);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end
