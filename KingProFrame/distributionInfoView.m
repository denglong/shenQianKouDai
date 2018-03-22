//
//  distributionInfoView.m
//  KingProFrame
//
//  Created by 邓龙 on 12/7/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "distributionInfoView.h"
#import "Headers.h"

#import "DistributionWayCell.h"
#import "DistributionHeaderCell.h"
#import "YourSelfInfoCell.h"

@interface distributionInfoView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *distributionTable;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (nonatomic, strong) UIView *distributionBg;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipe;
@property (nonatomic, strong) CloudClient *client;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UIButton *deliverBtn;
@property (nonatomic, strong) UIButton *yourSelfBtn;
@property (nonatomic, strong) NSArray *shopAddList;
@property (nonatomic, assign) NSInteger selectTag;

@end

@implementation distributionInfoView

#pragma mark - 创建选择自提点View方法
- (void)addWindowAction {
    
    self.client = [CloudClient getInstance];
    
    self.backgroundColor = [UIColor_HEX colorWithHexString:@"ECECEC"];
    self.distributionTable.delegate = self;
    self.distributionTable.dataSource = self;
    self.distributionTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.distributionBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, kViewHeight)];
    self.distributionBg.backgroundColor = [UIColor_HEX colorWithHexString:@"000000" alpha:0.5];
    self.distributionBg.hidden = YES;
    
    self.frame = CGRectMake(viewWidth, 0, viewWidth-75, kViewHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.distributionBg];
    [window addSubview:self];
    
    self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenDistributtionSwipe:)];
    [self.distributionBg addGestureRecognizer:self.swipe];
    
    [self.distributionTable registerNib:[UINib nibWithNibName:@"DistributionHeaderCell" bundle:nil] forCellReuseIdentifier:@"DistributionHeaderCell"];
    [self.distributionTable registerNib:[UINib nibWithNibName:@"DistributionWayCell" bundle:nil] forCellReuseIdentifier:@"DistributionWayCell"];
    [self.distributionTable registerNib:[UINib nibWithNibName:@"YourSelfInfoCell" bundle:nil] forCellReuseIdentifier:@"YourSelfInfoCell"];
}

#pragma mark - 显示选择配送方式view
- (void)showDistributionInfoView:(NSArray *)shopAddressList black:(SelectYourSelfBlack)black {
    
    self.selectBlack = black;
    self.shopAddList = shopAddressList;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.distributionBg.hidden = NO;
        weakSelf.frame = CGRectMake(75, 0, viewWidth-75, kViewHeight);
    }];
}

#pragma mark - 隐藏选择配送方式view
- (void)hiddenDistributtonInfoView {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.frame = CGRectMake(viewWidth, 0, viewWidth-75, kViewHeight);
        
    } completion:^(BOOL finished) {
        
        weakSelf.distributionBg.hidden = YES;
    }];
}

- (void)hiddenDistributtionSwipe:(id)sender {
    
    [self hiddenDistributtonInfoView];
}

#pragma mark - TableViewDelegate,DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.isSelect) {
        return 1;
    }
    else
    {
       return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else
    {
        return self.shopAddList.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 45;
    }
    else
    {
        if (indexPath.section == 0) {
            return 102;
        }
    }

    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, viewWidth, 10);
    footerView.backgroundColor = [UIColor_HEX colorWithHexString:@"ECECEC"];
    if (section == 1) {
        footerView.backgroundColor = [UIColor_HEX colorWithHexString:@"FFFFFF"];
    }
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
        DistributionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributionHeaderCell"];
        
        if (indexPath.section == 0) {
            cell.nameLabel.text = @"方式选择";
        }
        else
        {
            cell.nameLabel.text = @"选择自提点";
        }
        
        return cell;
    }
    else
    {
        if (indexPath.section == 0) {
            DistributionWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributionWayCell"];
            
            if (indexPath.section == 0)
            {
                [cell showDeliver];
            }
            
            [cell.deliverButton addTarget:self action:@selector(clickDeliverAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.yourSelfButton addTarget:self action:@selector(clickDeliverAction:) forControlEvents:UIControlEventTouchUpInside];
            self.deliverBtn = cell.deliverButton;
            self.yourSelfBtn = cell.yourSelfButton;
            
            return cell;
        }
        else
        {
            YourSelfInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YourSelfInfoCell"];
            NSDictionary *dic = self.shopAddList[indexPath.row-1];
            [cell setYourSelfInfoAction:dic];
            
            if (indexPath.row == self.selectTag) {
                [cell colorSelectAction];
            }
            else
            {
                [cell defColorAction];
            }
            
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row != 0) {
        self.selectTag = indexPath.row;
        [tableView reloadData];
    }
}

#pragma mark - 点击配送方式
- (void)clickDeliverAction:(UIButton *)sender {
    NSLog(@"%ld", sender.tag);
    if (sender.tag == 1){
        self.isSelect = YES;
        sender.selected = YES;
        self.deliverBtn.selected = NO;
        self.yourSelfBtn.layer.borderColor = [UIColor_HEX colorWithHexString:@"FF5A1E"].CGColor;
        self.deliverBtn.layer.borderColor = [UIColor_HEX colorWithHexString:@"000000"].CGColor;
    }
    else
    {
        self.isSelect = NO;
        sender.selected = YES;
        self.yourSelfBtn.selected = NO;
        self.deliverBtn.layer.borderColor = [UIColor_HEX colorWithHexString:@"FF5A1E"].CGColor;
        self.yourSelfBtn.layer.borderColor = [UIColor_HEX colorWithHexString:@"000000"].CGColor;
    }
    [self.distributionTable reloadData];
}

- (IBAction)confirmOkAction:(id)sender {
    if (self.selectTag > 0) {
        NSDictionary *dic = self.shopAddList[self.selectTag?self.selectTag-1:self.selectTag];
        NSString *shopAddress = dic[@"id"];
        if (self.isSelect == YES) {
            self.selectBlack(shopAddress);
        }
        else
        {
            self.selectBlack(nil);
        }
    }
    
    [self hiddenDistributtonInfoView];
}

@end
