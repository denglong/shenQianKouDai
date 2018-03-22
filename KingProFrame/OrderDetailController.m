//
//  OrderDetailController.m
//  KingProFrame
//
//  Created by denglong on 8/3/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "OrderDetailController.h"
#import "OrderDetailCell.h"
#import "orderDetailLastCell.h"
#import "TabBarController.h"
#import "OrderDetailGoodsCell.h"
@interface OrderDetailController ()<UIAlertViewDelegate, reloadDelegate>
{
    CloudClient *client;
    NSDictionary *respDetail;
    NSString      *piecesNum;
    UIView        *noNetWork;  //无网页面
}

@end

@implementation OrderDetailController
@synthesize downBtn, orderNum, myTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    client = [CloudClient getInstance];
    [self getBusDetailOrderData:orderNum];
    
    if (self.xgTag == 1) {
        self.navigationItem.leftBarButtonItem = [super createLeftItem:self itemStr:nil itemImage:UIIMAGE(@"back.png") itemImageHG:nil selector:@selector(backAction:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self noNetwork];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

-(void)backAction:(id)sender {
    if (self.xgTag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        TabBarController *tabBarControl=[TabBarController sharedInstance];
        tabBarControl.selectedIndex=0;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 * Method name: tableView
 * MARK: - tableView相关实现方法
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
        {
            NSArray *goodsList = [respDetail objectForKey:@"goodsList"];
            return goodsList.count;
        }
            break;
        case 2:
            return 3;
            break;
        case 3:
            if ([[respDetail objectForKey:@"yushou"] integerValue] == 1) {
                return 2;
            }
            else
            {
                return 1;
            }
            break;
        case 4:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"OrderDetailCell" owner:self options:nil];
        cell = [views objectAtIndex:0];
        cell.selectionStyle = UITableViewCellStyleDefault;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            cell.addressIcon.hidden = NO;
            cell.address.hidden = NO;
            cell.leftLab.hidden = YES;
            
            cell.address.textColor = RGBACOLOR(245, 125, 110, 1);
            cell.address.numberOfLines = 0;
            cell.address.text = [NSString stringWithFormat:@"%@%@%@", [respDetail objectForKey:@"street"], [respDetail objectForKey:@"address"], [respDetail objectForKey:@"addressDetail"]];
            CGSize size =  [self sizeWithString:cell.address.text font:cell.address.font];
            cell.address.frame = CGRectMake(35, 15, size.width, size.height);
            
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.address.frame.size.height + cell.frame.size.height - 14);
            
            float distance = [[respDetail objectForKey:@"distance"] floatValue] / 1000.0;
            if (distance > 1.0) {
//                distance = ceilf(distance);
                cell.rightLab.text = [NSString stringWithFormat:@"%.1fkm", distance];
            }
            else
            {
                distance = [[respDetail objectForKey:@"distance"] floatValue];
                cell.rightLab.text = [NSString stringWithFormat:@"%.0fm", distance];
            }
            return cell;
            
        }
            break;
        case 1:
        {
            OrderDetailGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"OrderDetailGoodsCell" owner:self options:nil];
                cell = [views objectAtIndex:0];
                cell.selectionStyle = UITableViewCellStyleDefault;
            }
            
            NSArray *goodsList = [respDetail objectForKey:@"goodsList"];
            
            if (goodsList.count > 0) {
                NSDictionary *orderDic = goodsList[indexPath.row];
                NSURL * url = [NSURL URLWithString:[orderDic objectForKey:@"goodsPic"]];
                [cell.goodsImage setImageWithURL:url placeholderImage:UIIMAGE(@"orderShopHeader")];
                cell.goodsNameLabel.text = [NSString stringWithFormat:@"%@", [orderDic objectForKey:@"goodsName"]];
                cell.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [[orderDic objectForKey:@"goodsPrice"] floatValue]];
                cell.goodsCountLabel.text = [NSString stringWithFormat:@"x%@", [orderDic objectForKey:@"goodsNumber"]];
            }
            
            CGSize size =  [self sizeWithString:cell.goodsNameLabel.text font:cell.goodsNameLabel.font];
            cell.goodsNameLabel.frame = CGRectMake(cell.goodsNameLabel.frame.origin.x, 18, size.width, size.height);
            if (goodsList.count > 0) {
                NSDictionary *orderDic = goodsList[indexPath.row];
                if ([DataCheck isValidArray:[orderDic objectForKey:@"groupDetail"]]) {
                    cell.groupGoods = [orderDic objectForKey:@"groupDetail"];
                }
            }
            
            
            if(cell.goodsNameLabel.frame.size.height > cell.goodsImage.frame.size.height){
                cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.goodsNameLabel.frame.size.height+cell.goodsNameLabel.frame.origin.y+18);
            }
            
            return cell;
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    NSString *expressText = [respDetail objectForKey:@"expressText"];
                    if ([DataCheck isValidString:expressText]) {
                        expressText = [NSString stringWithFormat:@"(%@)", expressText];
                    }
                    else
                    {
                        expressText = @"";
                    }
                    cell.leftLab.text = [NSString stringWithFormat:@"配送费%@", expressText];
                    
                    float expressPrice = [[respDetail objectForKey:@"expressPrice"] floatValue];
                    cell.rightLab.text = [NSString stringWithFormat:@"￥%.2f", expressPrice];
                    cell.rightLab.textColor = [UIColor_HEX colorWithHexString:@"#666666"];
                }
                    break;
                case 1:
                {
                    cell.leftLab.text = @"小费";
                    float tipPrice = [[respDetail objectForKey:@"tipPrice"] floatValue];
                    cell.rightLab.text = [NSString stringWithFormat:@"￥%.2f", tipPrice];
                    cell.rightLab.textColor = [UIColor_HEX colorWithHexString:@"#666666"];
                }
                    break;
                case 2:
                {
                    cell.leftLab.text = @"平台奖励";
                    float platExprPrice = [[respDetail objectForKey:@"platExprPrice"] floatValue];
                    cell.rightLab.text = [NSString stringWithFormat:@"￥%.2f", platExprPrice];
                    cell.rightLab.textColor = [UIColor_HEX colorWithHexString:@"#666666"];
                }
                    break;
                default:
                    break;
            }
            
            return cell;
        }
            break;
        case 3:
        {
            if (indexPath.row == 0 && [[respDetail objectForKey:@"yushou"] integerValue] == 1)
            {
                cell.leftLab.text = @"佣金";
                float commission = [[respDetail objectForKey:@"commission"] floatValue];
                cell.rightLab.text = [NSString stringWithFormat:@"￥%.2f", commission];
                cell.rightLab.textColor = [UIColor_HEX colorWithHexString:@"#666666"];
            }
            else
            {
                cell.middleLab.hidden = NO;
                if ([[respDetail objectForKey:@"yushou"] integerValue] == 1)
                {
                    cell.leftLab.text = @"收入合计";
                    cell.leftLab.textColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
                    cell.rightLab.textColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
                    cell.middleLab.textColor = [UIColor_HEX colorWithHexString:@"#00b7ee"];
                }
                else
                {
                    cell.leftLab.text = @"合计";
                    cell.leftLab.textColor = RGBACOLOR(245, 125, 110, 1);
                    cell.rightLab.textColor = RGBACOLOR(245, 125, 110, 1);
                }
                
                float payPrice = [[respDetail objectForKey:@"payPrice"] floatValue];
                cell.rightLab.text = [NSString stringWithFormat:@"￥%.2f", payPrice];
                cell.middleLab.text = [NSString stringWithFormat:@"x%@", piecesNum];
            }
            
            return cell;
        }
            break;
        case 4:
        {
            if (indexPath.row == 0) {
                cell.leftLab.text = [NSString stringWithFormat:@"订单编号：%@", [respDetail objectForKey:@"orderNo"]];
                cell.leftLab.frame = CGRectMake(10, cell.leftLab.frame.origin.y, cell.frame.size.width, cell.leftLab.frame.size.height);
                cell.rightLab.hidden = YES;
                
                return cell;
            }
            else
            {
                orderDetailLastCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"orderDetailLastCell" owner:self options:nil];
                    cell = [views objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellStyleDefault;
                }
                
                if (respDetail.count > 0) {
                    NSString *downOrderTime = [NSString stringWithFormat:@"%@", [respDetail objectForKey:@"createTime"]];
                    NSString *chargeTime = [NSString stringWithFormat:@"%@", [respDetail objectForKey:@"userDeliveryTime"]];
                    NSString *mytime = [NSString stringWithFormat:@"%ld",  1800000 + [downOrderTime integerValue]];
                    if (downOrderTime) {
                        cell.downOrderTime.text = [self formatTimeStamp:[downOrderTime substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"];
                        
                        if ([chargeTime integerValue] == 0) {
                            if ([[respDetail objectForKey:@"yushou"] integerValue] == 1)
                            {
                                cell.chargeTime.text = [self formatTimeStamp:[mytime substringToIndex:10] timeFormat:@"YYYY-MM-dd"];
                            }
                            else
                            {
                                cell.chargeTime.text = [self formatTimeStamp:[mytime substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm"];
                            }
                        }
                        else
                        {
                            if ([[respDetail objectForKey:@"yushou"] integerValue] == 1)
                            {
                                cell.chargeTime.text = [self formatTimeStamp:[chargeTime substringToIndex:10]  timeFormat:@"YYYY-MM-dd"];
                            }
                            else
                            {
                                cell.chargeTime.text = [self formatTimeStamp:[chargeTime substringToIndex:10]  timeFormat:@"YYYY-MM-dd HH:mm"];
                            }
                        }
                    }
                    
                }
                
                cell.remarks.numberOfLines = 0;
                cell.remarks.text = [NSString stringWithFormat:@"%@", [respDetail objectForKey:@"orderRemark"]];
                CGSize size =  [self sizeWithString:cell.remarks.text font:cell.remarks.font];
                cell.remarks.frame = CGRectMake(cell.remarks.frame.origin.x, cell.remarks.frame.origin.y, cell.remarks.frame.size.width, size.height);
                cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height + cell.remarks.frame.size.height - 14);
                
                return cell;
            }
        }
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    footView.backgroundColor = [UIColor clearColor];
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

/**
 * Method name: sizeWithString
 * MARK: - 根据label内容计算label高度
 * Parameter: label内容
 * Parameter: label字体大小
 */
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect;
    if ([[UIScreen mainScreen] bounds].size.width > 320) {
        rect = [string boundingRectWithSize:CGSizeMake(230, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    else
    {
        rect = [string boundingRectWithSize:CGSizeMake(180, 8000)//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传入的字体字典
                                    context:nil];
    }
    
    
    return rect.size;
}

//MARK: - 抢单处理方法
- (IBAction)knockAction:(id)sender {
    [MobClick event:Cfm_GetOrder];
    [self getKnockOrderData:orderNum];
}

//MARK: - 无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        downBtn.hidden = YES;
        myTableView.hidden = YES;
        noNetWork = [[NoNetworkView sharedInstance] setConstraint:self.view.frame.size.height];
        [NoNetworkView sharedInstance].reloadDelegate = self;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, noNetWork.frame.size.height);
        [self.view addSubview:noNetWork];
        return YES;
    }
    else
    {
        downBtn.hidden = NO;
        if (noNetWork) {
            [noNetWork removeFromSuperview];
        }
        return NO;
    }
}

- (void)reloadAgainAction {
    
    [self getBusDetailOrderData:orderNum];
}

/**
 * Method name: getBusDetailOrderData
 * MARK: - 获取商家附近订单详情处理方法
 * Parameter: orderNum
 */
- (void)getBusDetailOrderData:(NSString *)orderNo {
    if ([self noNetwork]) {
        return;
    }
    
    [self showHUD];
    
    [client requestMethodWithMod:@"order/orderInfo"
                          params:nil
                      postParams:@{@"orderNo":orderNo, @"userType":@"1"}
                        delegate:self
                        selector:@selector(getBusDetailOrderDataSuccessed:)
                   errorSelector:@selector(getBusDetailOrderDatafiled:)
                progressSelector:nil];
}

- (void)getBusDetailOrderDataSuccessed:(NSDictionary *)response {
    [self noNetwork];
    
    if ([DataCheck isValidDictionary:response]) {
        respDetail = response;
        
        NSArray *goodsList = [response objectForKey:@"goodsList"];
        NSInteger sumNum = 0;
        for (NSDictionary *dic in goodsList) {
            sumNum += [[dic objectForKey:@"goodsNumber"] integerValue];
        }
        piecesNum = [NSString stringWithFormat:@"%ld", sumNum];
        
        NSString *isAccept = [response objectForKey:@"isAccept"];
        if ([isAccept integerValue] == 2) {
            downBtn.hidden = NO;
            downBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#FFE100"];
        }
        else
        {
            downBtn.enabled = NO;
            downBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#cccccc"];
        }
        
        myTableView.hidden = NO;
        [myTableView reloadData];
    }
    else
    {
        myTableView.hidden = YES;
        downBtn.hidden = YES;
    }
    [self hidenHUD];
}

- (void)getBusDetailOrderDatafiled:(NSDictionary *)response {
    myTableView.hidden = YES;
    if ([[[CommClass sharedCommon] objectForKey:@"GeTuiTag"] integerValue] == 100) {
        [[CommClass sharedCommon] setObject:@"10" forKey:@"GeTuiTag"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    [self hidenHUD];
}

/**
 * Method name: getKnockOrderData
 * MARK: - 抢单处理方法
 * Parameter: orderNum
 */
- (void)getKnockOrderData:(NSString *)orderNo {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [self showHUD];
    
    [client requestMethodWithMod:@"business/acceptOrder"
                          params:nil
                      postParams:@{@"orderNo":orderNo}
                        delegate:self
                        selector:@selector(getKnockOrderDataSuccessed:)
                   errorSelector:@selector(getKnockOrderDatafiled:)
                progressSelector:nil];
}

- (void)getKnockOrderDataSuccessed:(NSDictionary *)response {
    [self hidenHUD];
    
    if ([DataCheck isValidDictionary:response]) {
        NSString *code = [response objectForKey:@"code"];
        if ([code integerValue] == 1) {
            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示!"
                                                              message:@"您已抢单成功"
                                                             delegate:self
                                                    cancelButtonTitle:@"知道了"
                                                    otherButtonTitles:nil, nil];
            [myAlert show];
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hidenAlertView:) userInfo:myAlert repeats:NO];
        }
        else
        {
            [SRMessage infoMessage:[response objectForKey:@"accept"] delegate:self];
            [self getBusDetailOrderData:orderNum];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.downBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#cccccc"];
    self.downBtn.enabled = NO;
}

- (void)hidenAlertView:(NSTimer *)timer {
    UIAlertView *alert = [timer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
    
    self.downBtn.backgroundColor = [UIColor_HEX colorWithHexString:@"#cccccc"];
    self.downBtn.enabled = NO;
}

- (void)backListAction:(NSTimer *)sender {
    
    UIAlertController *alert=[sender userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getKnockOrderDatafiled:(NSDictionary *)response {
    
    [self hidenHUD];
}

@end
