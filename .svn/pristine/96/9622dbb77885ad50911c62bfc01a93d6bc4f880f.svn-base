//
//  WLZ_ShoppingCarController.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//




//   MVVM (降低耦合) KVO(一处计算总价钱) 键盘处理(精确到每个cell) 代码适配(手动代码适配，无第三方) ，还有全选,侧滑操作等操作，仅供大家参考交流

#import "WLZ_ShoppingCarController.h"
#import "ConfirmOrderController.h"
#import "WLZ_HeardView.h"

@interface WLZ_ShoppingCarController () <UITableViewDataSource,UITableViewDelegate,WLZ_ShoppingCarCellDelegate,WLZ_ShoppingCartEndViewDelegate>


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *carDataArrList;
@property(nonatomic,strong)UIToolbar *toolbar;
@property (nonatomic , strong) UIBarButtonItem *previousBarButton;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,strong)WLZ_ShoppingCartEndView *endView;
@property(nonatomic,strong) WLZ_ShopViewModel *vm;

@end

@implementation WLZ_ShoppingCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    [self createShopViewAction];
    
    //获取数据
    _vm = [[WLZ_ShopViewModel alloc]init];
    
    __weak typeof (WLZ_ShoppingCarController) *waks = self;
    __weak typeof (NSMutableArray)* carDataArrList = self.carDataArrList;
    __weak typeof (UITableView ) *tableView = self.tableView;
    [_vm getShopData:^(NSArray *commonArry, NSArray *kuajingArry) {
        [carDataArrList addObject:commonArry];
        [carDataArrList addObject:kuajingArry];
        [tableView reloadData];
        [waks numPrice];
    } priceBlock:^{

        [waks numPrice];
    }];
    
     [self finshBarView];
    [self loadNotificationCell];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edits:)];
}

- (void)createShopViewAction {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.userInteractionEnabled=YES;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop=YES;
    //        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:@"EEEEEE"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGFloat endViewHeight = [WLZ_ShoppingCartEndView getViewHeight];
    self.endView = [[WLZ_ShoppingCartEndView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, endViewHeight)];
    self.endView.delegate=self;
    self.endView.isEdit = _isEdit;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.endView];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, endViewHeight, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view).insets(edge);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.endView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(endViewHeight));
        make.left.equalTo(self.view).with.offset(0);
        if (weakSelf.goodDetailIn) {
            
            make.bottom.equalTo(self.view).with.offset(0);
        }
        else
        {
            make.bottom.equalTo(self.view).with.offset(-endViewHeight);
        }
        make.right.equalTo(self.view).with.offset(0);
    }];
}

-(void)finshBarView
{
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, APPScreenHeight, APPScreenWidth, 44)];
//     _toolbar.frame = CGRectMake(0, 0, APPScreenWidth, 44);
    [_toolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonIsClicked:)];
    NSArray *barButtonItems = @[flexBarButton,self.previousBarButton];
    _toolbar.items = barButtonItems;
    [self.view addSubview:_toolbar];
}

- (void) previousButtonIsClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(void)loadNotificationCell
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

}

//本来想着kvo写在 Controller里面 但是想尝试不同的方式 试试在viewModel 里面 ，感觉还是在Controller 里面更 好点
- (void)numPrice
{
    NSArray *lists =   [_endView.Lab.text componentsSeparatedByString:@"￥"];
    float num = 0.00;
    NSInteger numCount = 0;
    for (int i=0; i<self.carDataArrList.count; i++) {
        NSArray *list = [self.carDataArrList objectAtIndex:i];
        for (int j = 0; j<list.count-1; j++) {
            WLZ_ShoppIngCarModel *model = [list objectAtIndex:j];
            NSInteger count = [model.count integerValue];
            float sale = [model.item_info.sale_price floatValue];
            if (model.isSelect && ![model.item_info.sale_state isEqualToString:@"3"] ) {
                num = count*sale+ num;
            }
            numCount = count + numCount;
        }
    }
    _endView.Lab.text = [NSString stringWithFormat:@"%@￥%.2f",lists[0],num];
    [_endView.pushBt setTitle:[NSString stringWithFormat:@"去下单 (共%zd件)", numCount] forState:UIControlStateNormal];
}

- (void)clickALLEnd:(UIButton *)bt
{
    //全选 也可以在 VM里面 写  这次在Controller里面写了
    bt.selected = !bt.selected;
    
    BOOL btselected = bt.selected;
    
    NSString *checked = @"";
    if (btselected) {
        checked = @"YES";
    }
    else
    {
        checked = @"NO";
    }
    
    if (self.isEdit) {
        //取消
        for (int i =0; i<_carDataArrList.count; i++) {
            NSArray *dataList = [_carDataArrList objectAtIndex:i];
            NSMutableDictionary *dic = [dataList lastObject];
            
            [dic setObject:checked forKey:@"checked"];
            for (int j=0; j<dataList.count-1; j++) {
                WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[dataList objectAtIndex:j];
                if (![model.item_info.sale_state isEqualToString:@"3"]) {
                    model.isSelect=btselected;
                }
                
            }
        }
    }
    else
    {
        //编辑
        for (int i =0; i<_carDataArrList.count; i++) {
            NSArray *dataList = [_carDataArrList objectAtIndex:i];
            NSMutableDictionary *dic = [dataList lastObject];
            [dic setObject:checked forKey:@"checked"];
            for (int j=0; j<dataList.count-1; j++) {
                WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[dataList objectAtIndex:j];
                model.isSelect=btselected;
            }
        }
    }
    
    [_tableView reloadData];
}

- (void)clickRightBT:(UIButton *)bt
{
    if(bt.tag==19)
    {
        //删除
        for (int i = 0; i<_carDataArrList.count; i++) {
            NSMutableArray *arry = [_carDataArrList objectAtIndex:i];
            for (int j=0 ; j<arry.count-1; j++) {
                WLZ_ShoppIngCarModel *model = [ arry objectAtIndex:j];
                if (model.isSelect==YES) {
                    [arry removeObjectAtIndex:j];
                    continue;
                }
            }
            if (arry.count<=1) {
                [_carDataArrList removeObjectAtIndex:i];
            }
        }
        [_tableView reloadData];
    }
    else if (bt.tag==18)
    {
        //结算
        ConfirmOrderController *confirmOrder = [[ConfirmOrderController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:confirmOrder animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)edits:(UIBarButtonItem *)item
{
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        item.title = @"取消";
        for (int i=0; i<_carDataArrList.count; i++) {
            NSArray *list = [_carDataArrList objectAtIndex:i];
            for (int j = 0; j<list.count-1; j++) {
                WLZ_ShoppIngCarModel *model = [list objectAtIndex:j];
                if ([model.item_info.sale_state isEqualToString:@"3"]) {
                    model.isSelect=NO;
                }
                else
                {
                    model.isSelect=YES;
                }
            }
        }
    }
    else{
        item.title = @"编辑";
        for (int i=0; i<_carDataArrList.count; i++) {
            NSArray *list = [_carDataArrList objectAtIndex:i];
            for (int j = 0; j<list.count-1; j++) {
                WLZ_ShoppIngCarModel *model = [list objectAtIndex:j];
                model.isSelect = YES;
            }
        }
    }
    
    _endView.isEdit = self.isEdit;
    [_vm pitchOn:_carDataArrList];
    [_tableView reloadData];
}

- (NSMutableArray *)carDataArrList
{
    if (!_carDataArrList) {
        _carDataArrList = [NSMutableArray array];
    }
    return _carDataArrList;
}

- (void)endViewHidden
{
    if (_carDataArrList.count==0) {
        self.endView.hidden=YES;
    }
    else
    {
        self.endView.hidden=NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self endViewHidden];
    
    return 1;//self.carDataArrList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.carDataArrList.count > 0) {
        NSArray *list = [self.carDataArrList objectAtIndex:section];
        return list.count - 1;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WLZ_ShoppingCarCell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *shoppingCaridentis = @"WLZ_ShoppingCarCells";
    WLZ_ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCaridentis];
    if (!cell) {
        cell = [[WLZ_ShoppingCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoppingCaridentis tableView:tableView];
        cell.delegate=self;
    }
    if (self.carDataArrList.count>0) {
        cell.isEdit = self.isEdit;
        NSArray *list = [self.carDataArrList objectAtIndex:indexPath.section];
        cell.row = indexPath.row+1;
        [cell setModel:[list objectAtIndex:indexPath.row]];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        if (list.count-2 !=indexPath.row) {
            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(45, [WLZ_ShoppingCarCell getHeight]-0.5, APPScreenWidth-45, 0.5)];
            line.backgroundColor=[UIColor colorFromHexRGB:@"e2e2e2"];
            [cell addSubview:line];
        }
    }
    return cell;
}

- (void)singleClick:(WLZ_ShoppIngCarModel *)models row:(NSInteger)row
{
    [_vm pitchOn:_carDataArrList];
    if (models.type==1) {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    else if(models.type==2)
    {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        NSMutableArray *list = [_carDataArrList objectAtIndex:indexPath.section];
        
        
        
        WLZ_ShoppIngCarModel *model = [ list objectAtIndex:indexPath.row];
        model.isSelect=NO;
        [list removeObjectAtIndex:indexPath.row];
        
        if (list.count==1) {
            
            
            [_carDataArrList removeObjectAtIndex:indexPath.section];
            
        }
        
        [_tableView reloadData];
        [self numPrice];
    }
}

-(void)dealloc
{
    _tableView = nil;
    _tableView.dataSource=nil;
    _tableView.delegate=nil;
    self.endView = nil;
    self.carDataArrList = nil;
    NSLog(@"Controller释放了。。。。。");
}

- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        CGFloat maxY = CGRectGetMaxY(sub.frame);
        if ([sub isKindOfClass:[UITableView class]]) {

                sub.frame = CGRectMake(0, 0, sub.frame.size.width, APPScreenHeight-_toolbar.frame.size.height-rect.size.height);
                sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.frame.size.height/2);

        }else{
            if (maxY > y - 2) {
                sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.center.y - maxY + y );
            }
        }
    }
    [UIView commitAnimations];
}

- (void)keyboardShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        if (sub.center.y < CGRectGetHeight(self.view.frame)/2.0) {
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
        }
    }
      _toolbar.frame=CGRectMake(0, APPScreenHeight, APPScreenWidth, _toolbar.frame.size.height);
    _endView.frame = CGRectMake(0, self.view.frame.size.height-_endView.frame.size.height, APPScreenWidth, _endView.frame.size.height);

    self.tableView.frame=CGRectMake(0, 0, self.tableView.frame.size.width, APPScreenHeight-[WLZ_ShoppingCartEndView getViewHeight]);
    [UIView commitAnimations];
}

- (void)keyboardHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

@end
