//
//  CashViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/8/14.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CashViewController.h"

@interface CashViewController ()<UITextFieldDelegate,reloadDelegate>

{
    CloudClient * _cloudClient;
    NSDictionary * cashDic;
    float cashBalance; //提现金额
    NSString * cardType;
    UIView * noNetWork;
}

@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;//卡类型
@property (weak, nonatomic) IBOutlet UILabel *bankLabel; //银行卡和后四位
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;//用户当前余额
@property (weak, nonatomic) IBOutlet UITextField *cashBalanceTextField;
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UIView *vercodeLine;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *finishBankLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishCashBalance;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIView *finishView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeFinishLabel;

-(IBAction)cashBtnClick:(UIButton *)sender;
@end

@implementation CashViewController
//无网判断添加页面
- (BOOL)noNetwork {
    if ([self isNotNetwork]) {
        noNetWork = [NoNetworkView sharedInstance].view;
        noNetWork.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [NoNetworkView sharedInstance].reloadDelegate =self;
        [self.view addSubview:noNetWork];
        [super hidenHUD];
        return YES;
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
    [self getCashBalance];
}

#pragma mark - interface
-(void)getCashBalance
{
    if ([self noNetwork]) {
        return;
    }
  [_cloudClient requestMethodWithMod:@"member/withdraw"
                              params:nil
                          postParams:nil
                            delegate:self
                            selector:@selector(getCashBalanceSuccess:)
                       errorSelector:@selector(getCashBalanceError:)
                    progressSelector:nil];
}

-(void)getCashBalanceSuccess:(NSDictionary *)response
{
    [super hidenHUD];
    cashDic = [NSDictionary dictionaryWithDictionary:response];
    if ([[cashDic objectForKey:@"cardType"] integerValue] == 1) {
        cardType = @"储蓄卡";
    }
    self.cardTypeLabel.text = cardType;
    self.bankLabel.text = [cashDic objectForKey:@"bank"];
    self.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[cashDic objectForKey:@"balance"] floatValue]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@，%@",[cashDic objectForKey:@"textA"],[cashDic objectForKey:@"textB"]];
    [self.timeLabel sizeToFit];
    if([[cashDic objectForKey:@"card"] integerValue] == 0){
        self.cashBtn.enabled = NO;
        self.cashBtn.backgroundColor = RGBACOLOR(204, 204, 204, 1.0);
    }else{
        self.cashBtn.enabled = YES;
    }
    
}

-(void)getCashBalanceError:(NSDictionary *)response
{
    [super hidenHUD];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title =@"提现";
    [self noNetwork];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [self.bgView removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cashBtn.layer.cornerRadius = 3;
   
    self.vercodeLine.frame = CGRectMake(self.vercodeLine.frame.origin.x, 40.5, self.vercodeLine.frame.size.width, 0.5);
    _cloudClient = [CloudClient getInstance];
    [super showHUD];
    [self getCashBalance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.cashBalanceTextField resignFirstResponder];
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.cashBalanceTextField) {
        //数字
        NSString * tempStr =@"0123456789";
        NSRange rangeshuzi = [tempStr rangeOfString:string];//判断字符串是否包含连续的数字
        
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        if(rangeshuzi.length == 0)
        {
            return NO;
        }
        
        if ([string isEqualToString:@" "]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 提现
-(IBAction)cashBtnClick:(UIButton *)sender
{
    [MobClick event:Cfm_GetCash];
    [self.cashBalanceTextField resignFirstResponder];
    if (sender == self.cashBtn) {
        if (![DataCheck isValidString:self.cashBalanceTextField.text]) {
            [SRMessage infoMessage:@"请输入提现金额" delegate:self];
            return;
        }
        cashBalance = [self.cashBalanceTextField.text floatValue];
        if (cashBalance == 0) {
            [SRMessage infoMessage:@"提现金额不能为0" delegate:self];
            return;
        }
       
        float maxBalance = [[cashDic objectForKey:@"maxBalance"] floatValue];
        float minBalance = [[cashDic objectForKey:@"minBalance"] floatValue];
        if (cashBalance > maxBalance) {
            [SRMessage infoMessage:@"超出您的可提现金额，请重新输入" delegate:self];
            return;
        }
        if (cashBalance < minBalance) {
            [SRMessage infoMessage:@"低于每笔最小提现额度，请重新输入" delegate:self];
            return;
        }
        if ([self isNotNetwork]) {
            [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
            return;
        }
        
        [super showHUD];
        
        NSDictionary * postParams = @{@"price":self.cashBalanceTextField.text};
        [_cloudClient requestMethodWithMod:@"member/subWithdraw"
                                    params:nil
                                postParams:postParams
                                  delegate:self
                                  selector:@selector(cashBalanceSuccess:)
                             errorSelector:@selector(cashBalanceError:)
                          progressSelector:nil];
 
    }else{
        //提现完成
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)cashBalanceSuccess:(NSDictionary *)response
{
    [super hidenHUD];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.bgView.frame = window.bounds;
    [window addSubview:self.bgView];
    [self refreshFinishCashView];
}
-(void)cashBalanceError:(NSDictionary *)response
{
    [super hidenHUD];
}


#pragma mark - 绘制提现成功弹出框
-(void)refreshFinishCashView{
    self.finishView.layer.cornerRadius = 10;
    self.finishBtn.layer.cornerRadius = 3;
    self.finishBankLabel.text = [cashDic objectForKey:@"bank"];
    self.finishCashBalance.text = [NSString stringWithFormat:@"￥%.2f",cashBalance];
    self.timeFinishLabel.text = [cashDic objectForKey:@"textB"];
    [self.finishBtn addTarget:self action:@selector(cashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
@end
