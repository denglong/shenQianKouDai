//
//  CodeLoginViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/7/29.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CodeLoginViewController.h"
#import "RegisterViewController.h"
#import "UserAgreementViewController.h"
@interface CodeLoginViewController ()<UITextFieldDelegate>
{
    NSTimer * timer;
    NSInteger timeNum;
    CloudClient * _cloudClient;
    NSTimer *pushTimer;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *vercodeLine;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UILabel *CodecontentLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
- (IBAction)BtnAction:(UIButton *)sender;

@end

@implementation CodeLoginViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title = @"登录";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    self.phoneText.text = nil;
    self.codeBtn.enabled = YES;
     self.codeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
    [timer invalidate];
}
- (void)yinsiBTnClcik:(UIGestureRecognizer *)sender {
    UserAgreementViewController *userViewController = [[UserAgreementViewController alloc]init];
    userViewController.titleString = @"省钱口袋用户协议";
    NSString *url = [NSString stringWithFormat:@"%@user.jhtml", CLOUD_API_URL];
    userViewController.urlString = url;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userViewController animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.codeBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.codeBtn.layer.borderWidth = 1;
    self.codeBtn.layer.cornerRadius = 5;
    self.vercodeLine.frame = CGRectMake(self.vercodeLine.frame.origin.x, 44.5, self.vercodeLine.frame.size.width, 0.5);
    self.codeLoginBtn.layer.cornerRadius = 5;
    self.codeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
     //用户协议
    NSString * str1 =@"登录代表您同意";
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@《省钱口袋用户隐私条款》",str1]];
    NSRange contentRange = {str1.length,[content length]-str1.length};
    [content addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(243, 200, 73, 1.0) range:contentRange];
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    UITapGestureRecognizer * tapContent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yinsiBTnClcik:)];
    [self.CodecontentLabel addGestureRecognizer:tapContent];
    self.CodecontentLabel.attributedText = content;

    
    
    //注册
    self.navigationItem.rightBarButtonItem = [super createRightItem:self itemStr:@"注册" itemImage:nil itemImageHG:nil selector:@selector(registerAction:)];
    _cloudClient = [CloudClient getInstance];
    if (timeNum > 0) {
        [timer invalidate];
        self.codeBtn.enabled = NO;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeDaojishi) userInfo:nil repeats:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/**
 注册事件
 */

-(void)registerAction:(id)sender
{
    [MobClick event:Clik_Reg];
    RegisterViewController * registerViewController = [[RegisterViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerViewController animated:YES];
}
- (IBAction)BtnAction:(UIButton *)sender {
    
    if (sender.tag == 15) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (sender == self.codeBtn) {
//        [MobClick event:Get_SMSCode];
        if (![super checkTel:self.phoneText.text]) {
            return;
        }
        //获取验证码
        if (self.codeBtn.enabled == YES) {
            self.codeBtn.enabled = NO;
            self.codeBtn.layer.borderColor = RGBACOLOR(102 , 102, 102, 1.0).CGColor;
            timeNum = 60;
            [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeDaojishi) userInfo:nil repeats:YES];
            [self getAuthCode];
        }
        
        
    }else if (sender == self.historyBtn){
        self.phoneText.text = self.historyBtn.titleLabel.text;
        self.historyBtn.hidden = YES;
    }else{
       //验证码登录
        [self.phoneText resignFirstResponder];
        [self.codeText resignFirstResponder];
//        [MobClick event:SMSCode_CmfLogin];
        if (![super checkTel:self.phoneText.text]) {
            return;
        }
        if ([DataCheck isValidString:self.codeText.text]) {
            [self login];
        }else{
            [SRMessage infoMessage:@"请输入验证码" delegate:self];
           return;
        }
    }
    
}
//获取验证码倒计时
-(void)codeDaojishi
{
    if (timeNum > 1) {
        timeNum--;
        self.codeBtn.enabled = NO;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
    }else{
        [timer invalidate];
        self.codeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }
}

#pragma mark - textfeild delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.phoneText) {
        NSString * phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNameCode"];
        if ([DataCheck isValidString:phone]) {
            self.historyBtn.hidden = NO;
            
            [self.historyBtn setTitle:phone forState:UIControlStateNormal];
        }
    }
    
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString =[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.phoneText) {
        if (textField.text.length > 0) {
            self.historyBtn.hidden = YES;
        }
        if (toBeString.length > 11) {
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneText resignFirstResponder];
    [self.codeText resignFirstResponder];
    return YES;
}
#pragma mark - intifier
-(void)getAuthCode
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    NSDictionary * postparams =@{@"sources":@"2",
                                 @"type":@"2",
                                 @"userName":self.phoneText.text};
    
    [_cloudClient requestMethodWithMod:@"setting/getAuthCode"
                                params:nil
                            postParams:postparams
                              delegate:self
                              selector:@selector(getAuthCodeSecussed:)
                         errorSelector:@selector(getAuthCodeError:)
                      progressSelector:nil];
}
-(void)getAuthCodeSecussed:(NSDictionary *)response
{
    //获取验证码成功
     [SRMessage infoMessageWithTitle:nil message:[response objectForKey:@"msg"] delegate:self];
}
-(void)getAuthCodeError:(NSDictionary *)response
{
    //获取验证码失败
    [timer invalidate];
    self.codeBtn.enabled = YES;
    self.codeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
    
}
#pragma mark - 登录
-(void)login
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [super showHUD];
    
    [[CommClass sharedCommon] setObject:[GeTuiSdk clientId] forKey:@"CID"];
    
    NSDictionary * postParams = @{@"type":@"2",
                                  @"username":self.phoneText.text,
                                  @"password":self.codeText.text,
                                  @"cid":[GeTuiSdk clientId]};
    
    [_cloudClient requestMethodWithMod:@"member/login"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(loginSuccessed:)
                         errorSelector:@selector(loginError:)
                      progressSelector:nil];
    
}

/*
 登陆成功
 */
-(void)loginSuccessed:(NSDictionary *)response
{
//    [MobClick event:SMSLogin_Succes];
    if ([DataCheck isValidArray:[response objectForKey:@"userInfoList"]]) {
        
        NSArray * userInfoList = [response objectForKey:@"userInfoList"];
        //用户信息 格式化收到的用户信息格式
        NSDictionary *userInfoDic  =[self formatSpecialArray:userInfoList];
        //用户token非空验证
        if ([DataCheck isValidString:[userInfoDic objectForKey:@"token"]]) {
            NSString *token=[userInfoDic objectForKey:@"token"];
            [UserLoginModel setLoginWithToken:token userName:self.phoneText.text userInfo:userInfoDic];
        }
    }
    [timer invalidate];
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneText.text forKey:@"phoneNameCode"];
    
    /**----------------------个推绑定账号-------------------------------------*/
    NSString *cid = [[CommClass sharedCommon] objectForKey:@"CID"];
    if (![DataCheck isValidString:cid]) {
        pushTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(pushRegisterAction) userInfo:nil repeats:YES];
    }
    else
    {
        [pushTimer invalidate];
    }
    [GeTuiSdk setPushModeForOff:NO];
    /**----------------------个推绑定账号-------------------------------------*/
    
 
    [super hidenHUD];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//个推注册
- (void)pushRegisterAction {
    NSString *phoneNum = [[CommClass sharedCommon] objectForKey:LOGGED_USERNAME];
    if ([DataCheck isValidString:phoneNum]) {
        [self registerRemoteNotification];
        [GeTuiSdk setPushModeForOff:NO];
        [GeTuiSdk bindAlias:phoneNum];
    }
    else
    {
        [pushTimer invalidate];
    }
}

-(void)loginError:(NSDictionary *)response
{
    [super hidenHUD];
    
    
}

@end
