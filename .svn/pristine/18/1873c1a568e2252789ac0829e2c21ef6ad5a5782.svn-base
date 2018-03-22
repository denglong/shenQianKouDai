//
//  MsgSortViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/11/19.
//  Copyright © 2015年 king. All rights reserved.
//

#import "MsgSortViewController.h"
#import "MsgSortCell.h"
#import "MessageViewController.h"
#import "ListModel.h"
#import "MsgSort.h"
@interface MsgSortViewController ()<UITableViewDataSource,UITableViewDelegate,reloadDelegate>
{
    NSArray * list;
    UIView * noNetWork;
}
@property(nonatomic , retain) CloudClient * cloudClient;
@property (weak, nonatomic) IBOutlet UITableView *msgSortTableView;

@end

@implementation MsgSortViewController
/**无网判断添加页面*/
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        [super hidenHUD];
        return NO;
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
    [self getMsgSort];
}
#pragma mark - getMsgSort data
-(void)getMsgSort
{
    if ([self noNetwork]) {
        return;
    }
    [_cloudClient requestMethodWithMod:@"member/getMsgCata"
                              params:nil
                          postParams:nil
                            delegate:self
                            selector:@selector(successMsgSort:)
                       errorSelector:@selector(errorMsgSort:)
                    progressSelector:nil];
}

-(void)successMsgSort:(NSDictionary *)response
{
    [super hidenHUD];
    ListModel * msgList = [ListModel mj_objectWithKeyValues:response];
    if ([DataCheck isValidArray:msgList.msgCata]) {
        list = [NSArray arrayWithArray:msgList.msgCata];
    }
    [self.msgSortTableView reloadData];
}

-(void)errorMsgSort:(NSDictionary *)response
{
    [super hidenHUD];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title =@"消息中心";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [super setExtraCellLineHidden:self.msgSortTableView];
    _cloudClient = [CloudClient getInstance];
    [super showHUD];
    [self getMsgSort];
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
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return LHLHeaderHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = [MsgSortCell class];
    NSString * indentifier = NSStringFromClass(class);
    MsgSortCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MsgSortCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setMsgSort:[list objectAtIndex:indexPath.section]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgSort * msgSort = [list objectAtIndex:indexPath.section];
    switch ([msgSort.ID integerValue]) {
        case 1:
            [MobClick event:Order_Msg];
            break;
        case 2:
            [MobClick event:System_Msg];
            break;
        case 3:
            [MobClick event:eBean_Msg];
            break;
        case 4:
            [MobClick event:Coupon_Msg];
            break;
        default:
            break;
    }
    MessageViewController * messageViewController = [[MessageViewController alloc]init];
    
    messageViewController.msgType = msgSort.ID;
    messageViewController.title = msgSort.title;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageViewController animated:YES];
}

@end
