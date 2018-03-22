//
//  CoupViewController.m
//  KingProFrame
//
//  Created by denglong on 8/20/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "CoupViewController.h"
#import "CouponCell.h"
#import "RultsWebViewController.h"
@interface CoupViewController ()
{
    NSInteger sagMentTag;
}

@end

@implementation CoupViewController
@synthesize lists, nullImage, nullLab, cantLists, leftLine, rightLine, useableBtn, unUseableBtn;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择优惠券";
    self.view.backgroundColor = [UIColor_HEX colorWithHexString:@"#f5f5f1"];
    
    sagMentTag = 0;
    if (lists.count > 0) {
        nullLab.hidden = YES;
        nullImage.hidden = YES;
    }
    
    rightLine.hidden = YES;
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (sagMentTag == 0) {
        return lists.count;
    }
    else
    {
        return cantLists.count;
    }
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:nil];
        cell = [views objectAtIndex:0];
        cell.selectionStyle = UITableViewCellStyleDefault;
    }
    
    NSDictionary * data = nil;
    if (sagMentTag == 1) {
        data = [cantLists objectAtIndex:indexPath.section];
    }
    else {
        data = [lists objectAtIndex:indexPath.section];
    }
    
////    NSInteger isDefault = [[data objectForKey:@"isDefault"] integerValue];
//    NSInteger mycoupId = [[data objectForKey:@"id"] integerValue];
//    if (mycoupId == [self.coupId integerValue]) {
////        if (sagMentTag == 0) {
//            cell.rightImageView.hidden = NO;
////        }
//    }
//    else
//    {
//        cell.rightImageView.hidden = YES;
////        if (isDefault == 1 && ![self.coupId isEqualToString:@"-1"] && sagMentTag == 0) {
////           cell.rightImageView.hidden = NO;
////        }
//    }
    [cell setData:data];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sagMentTag == 0) {
        CouponCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSString *coupPrice = [lists[indexPath.section] objectForKey:@"price"];
        NSString *coupId = [NSString stringWithFormat:@"%@", [lists[indexPath.section] objectForKey:@"id"]];
        NSString *coupName = [lists[indexPath.section] objectForKey:@"couponName"];
        
        if (cell.rightImageView.hidden == NO) {
            coupId = @"-1";
            coupPrice = @"";
            coupName = @"";
        }
        
        [self.myCoupDelegate coupValue:coupPrice andCoupId:coupId andCoupName:coupName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)selectAction:(UIButton *)sender {
    NSString *coupPrice = [lists[sender.tag] objectForKey:@"price"];
    NSString *coupId = [NSString stringWithFormat:@"%@", [lists[sender.tag] objectForKey:@"id"]];
    NSString *coupName = [lists[sender.tag] objectForKey:@"couponName"];

    if (sender.selected == YES) {
        coupId = @"-1";
        coupPrice = @"";
        coupName = @"";
    }
    
    [self.myCoupDelegate coupValue:coupPrice andCoupId:coupId andCoupName:coupName];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择优惠券
- (IBAction)choseCoupAction:(UIButton *)sender {
    sagMentTag = sender.tag;
    if (sagMentTag == 1) {
        useableBtn.selected = NO;
        unUseableBtn.selected = YES;
        rightLine.hidden = NO;
        leftLine.hidden = YES;
        
        if (cantLists.count == 0) {
            nullLab.hidden = NO;
            nullLab.text = @"暂无优惠券信息~";
            nullImage.hidden = NO;
            self.myTableView.hidden = YES;
        }
        else
        {
            nullLab.hidden = YES;
            nullImage.hidden = YES;
            self.myTableView.hidden = NO;
            [self.myTableView reloadData];
            [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
    else
    {
        useableBtn.selected = YES;
        unUseableBtn.selected = NO;
        rightLine.hidden = YES;
        leftLine.hidden = NO;
 
        if (lists.count == 0) {
            nullLab.hidden = NO;
            nullLab.text = @"暂无优惠券信息~";
            nullImage.hidden = NO;
            self.myTableView.hidden = YES;
        }
        else
        {
            nullLab.hidden = YES;
            nullImage.hidden = YES;
            self.myTableView.hidden = NO;
            [self.myTableView reloadData];
            [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
}

@end
