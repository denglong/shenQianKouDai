//
//  RegisterViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/7/29.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "UserAgreementViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate>

{
    NSTimer * _timer;
    NSInteger timeNum;
    NSInteger regtimeNum;
    NSString * sources;
    CloudClient * _cloudClient;
    NSString * username;
    NSString * type;
    NSString * passWord;
    NSTimer  *pushTimer;
}
@property (weak, nonatomic) IBOutlet UIView *UpBGview;
@property (weak, nonatomic) IBOutlet UIScrollView *registScrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *phoneLine;
@property (weak, nonatomic) IBOutlet UIView *verCodeLine;
@property (weak, nonatomic) IBOutlet UITextField *verCodeText;//验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (weak, nonatomic) IBOutlet UITextField *peopleIdText;
@property (weak, nonatomic) IBOutlet UIButton *verCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *IdView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *newpassWordSuccessView;
@property (weak, nonatomic) IBOutlet UIButton *changeCodeBtn; //李栋add
@property (weak, nonatomic) IBOutlet UIView *changeView;      //李栋add
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *changePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)regBtnAction:(UIButton *)sender;


@end

@implementation RegisterViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    if (self.viewTag == 321) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        return;
    }
    if (self.viewTag ==101) {
        self.title = @"忘记密码";
    }else if (self.viewTag == 123){
        self.title = @"修改密码";
       // [self regBtnAction:nil];
    }else{
        self.title = @"注册";
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    [MobClick endLogPageView:NSStringFromClass([self class])];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.verCodeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
    self.verCodeBtn.layer.borderWidth = 0.5;
    self.verCodeBtn.layer.cornerRadius = 5;
    self.phoneLine.frame = CGRectMake(self.phoneLine.frame.origin.x, 41.5, viewWidth-30, 0.5);
    self.verCodeLine.frame = CGRectMake(self.verCodeLine.frame.origin.x, 41.5, viewWidth-30, 0.5);
    self.verCodeText.frame = CGRectMake(self.verCodeText.frame.origin.x, self.verCodeText.frame.origin.y, viewWidth - self.verCodeText.frame.origin.x-15, self.verCodeText.frame.size.height);
    self.registBtn.layer.cornerRadius = 5;

    self.registScrollView.contentSize = CGSizeMake(viewWidth, self.registBtn.frame.origin.y+self.registBtn.frame.size.height+150);
    
    //用户协议
    NSString * str1 =@"点击“注册”代表您同意";
     NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@《省钱口袋用户隐私条款》",str1]];
    NSRange contentRange = {str1.length,[content length]-str1.length};
    [content addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(243, 200, 73, 1.0) range:contentRange];
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    UITapGestureRecognizer * tapContent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yinsiBTnClcik:)];
    [self.contentLabel addGestureRecognizer:tapContent];
    self.contentLabel.attributedText = content;
    
    
    
    sources=@"1";
    type = @"2";
    NSInteger isRecomShow = [[[CommClass sharedCommon] objectForKey:@"isRecomShow"] integerValue];
    if (self.viewTag != 101 && self.viewTag != 123 && isRecomShow == 0) {
         self.IdView.hidden = YES;
        self.registBtn.center = CGPointMake(self.registBtn.center.x, self.registBtn.center.y - 52);
        self.contentLabel.center = CGPointMake(self.contentLabel.center.x, self.contentLabel.center.y - 52);
    }
    
    if (self.viewTag == 101) {
//        type = @"1";
        sources=@"3";
        self.IdView.hidden = YES;
        self.contentLabel.hidden = YES;
        [self.verCodeBtn setTitle:@"获取语音验证码" forState:UIControlStateNormal];
        self.registBtn.center = CGPointMake(self.registBtn.center.x, self.registBtn.center.y - 52);
        [self.registBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    _cloudClient = [CloudClient getInstance];
    
    if (self.viewTag == 123) {
        sources=@"3";
//        type = @"1";
        self.changeCodeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
        self.changeCodeBtn.layer.borderWidth = 0.5;
        self.changeCodeBtn.layer.cornerRadius = 5;
        self.changeCodeBtn.hidden = NO;
        self.UpBGview.frame = CGRectMake(0, 0, viewWidth, 126);
        self.changeView.hidden = NO;
        self.phoneView.hidden = YES;
        self.IdView.hidden = YES;
        self.contentLabel.hidden = YES;
        self.changeCodeBtn.frame = CGRectMake(viewWidth-15 - self.changeCodeBtn.frame.size.width, self.changeCodeBtn.frame.origin.y, self.changeCodeBtn.frame.size.width, self.changeCodeBtn.frame.size.height);
        self.verCodeText.frame = CGRectMake(self.verCodeText.frame.origin.x, self.verCodeText.frame.origin.y, self.changeCodeBtn.frame.origin.x -self.verCodeText.frame.origin.x, self.verCodeText.frame.size.height);
//        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceCodeClick)];
//        [self.contentLabel addGestureRecognizer:singleRecognizer];
        
        self.registBtn.center = CGPointMake(self.registBtn.center.x, self.registBtn.center.y - 52-15);
        [self.registBtn setTitle:@"确定" forState:UIControlStateNormal];
        username = [[CommClass sharedCommon] objectForKey:LOGGED_USERNAME];
        self.changePhoneLabel.text = [NSString stringWithFormat:@"验证码已发送手机%@",[super getPhoneStr:username fromIndex:3 Ranglength:4 subString:@"****"]];
        self.changePhoneLabel.hidden = YES;
    }
    
    
    
}

////语音验证码的事件
//-(void)voiceCodeClick
//{
//    type = @"2";
//    [self getAuthCode];
//}


- (IBAction)regBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 10:
        {
           //获取语音验证吗
            if (self.viewTag != 101) {
                [MobClick event:Get_VoiceCode];
            }
            if (![super checkTel:self.phoneText.text]) {
                return;
            }
            if (self.verCodeBtn.enabled == YES) {
                self.verCodeBtn.enabled = NO;
                self.verCodeBtn.layer.borderColor = RGBACOLOR(102, 102, 102, 1.0).CGColor;
                timeNum = 60;
                if (self.viewTag == 101) {
                    [self.verCodeBtn setTitle:[NSString stringWithFormat:@"获取语音验证码\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
                }else{
                    [self.verCodeBtn setTitle:[NSString stringWithFormat:@"获取语音验证码\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
                }
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
                [self getAuthCode];
            }
        }
            break;
        case 11:
        {
           //注册
            
            [self.phoneText resignFirstResponder];
            [self.verCodeText resignFirstResponder];
            [self.passWordText resignFirstResponder];
            [self.peopleIdText resignFirstResponder];
            if (self.viewTag != 101 && self.viewTag != 123) {
                [MobClick event:Cfm_Reg];
            }
            if (self.viewTag != 123) {
                username = self.phoneText.text;
            }
            if (![super checkTel:username]) {
                return;
            }
            
            if (![DataCheck isValidString:self.verCodeText.text]) {
                [SRMessage infoMessage:@"请输入验证码" delegate:self];
                return;
            }
            if (![DataCheck isValidString:self.passWordText.text]) {
                
                [SRMessage infoMessage:@"请输入密码" delegate:self];
                return;
            }
            if (self.passWordText.text.length < 6) {
                [SRMessage infoMessage:@"密码不能少于6位" delegate:self];
                return;
            }
            [super showHUD];
            if (self.viewTag == 101 || self.viewTag == 123) {
                [self resetPsw];
            }else{
                [self userRegister];
            }
        }
            break;
        case 12:
        {
            //修改密码获取验证码
            if (![super checkTel:username]) {
                return;
            }
            if (self.changeCodeBtn.enabled == YES) {
                self.changePhoneLabel.hidden = NO;
                self.changeCodeBtn.enabled = NO;
                self.changeCodeBtn.layer.borderColor = RGBACOLOR(102, 102, 102, 1.0).CGColor;
                timeNum = 60;
                [self.changeCodeBtn setTitle:[NSString stringWithFormat:@"重新获取\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
                [self getAuthCode];
            }
        }
            break;

        default:
        {
           //密码明文
            if (self.passWordText.secureTextEntry == YES) {
                [self.passWordText setSecureTextEntry:NO];
                 sender.selected = YES;
            }else{
                [self.passWordText setSecureTextEntry:YES];
                 sender.selected = NO;
            }
        }
            break;
    }
    
}

- (void)yinsiBTnClcik:(UIGestureRecognizer *)sender {
    UserAgreementViewController *userViewController = [[UserAgreementViewController alloc]init];
    userViewController.viewTag = self.viewTag;
    userViewController.titleString = @"省钱口袋用户协议";
    NSString *url = [NSString stringWithFormat:@"%@user.jhtml", CLOUD_API_URL];
    userViewController.urlString = url;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userViewController animated:YES];

}


//获取验证码倒计时
-(void)daojishi
{
     timeNum--;
   
    if (timeNum > 0) {
        if (self.viewTag == 123) {
            self.changeCodeBtn.enabled = NO;
            [self.changeCodeBtn setTitle:[NSString stringWithFormat:@"重新获取\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
            return;
        }
        
        self.verCodeBtn.enabled = NO;
        if (self.viewTag == 101) {
            [self.verCodeBtn setTitle:[NSString stringWithFormat:@"获取语音验证码\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
        }else{
            [self.verCodeBtn setTitle:[NSString stringWithFormat:@"获取语音验证码\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
        }
    }else{
        [_timer invalidate];
        if (self.viewTag == 123) {
            self.changeCodeBtn.enabled = YES;
            [self.changeCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            self.changeCodeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
            return;
        }
        self.verCodeBtn.enabled = YES;
       [self.verCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.verCodeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
    }
}

#pragma mark - textfeild delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * toBeString =[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.phoneText) {
        if (toBeString.length > 11) {
            return NO;
        }else{
            return YES;
        }
    }
    if (textField == self.verCodeText) {
        if (toBeString.length > 4) {
            return NO;
        }else{
            return YES;
        }
    }
    if (textField == self.passWordText) {
        //数字
        NSString * tempStr =@"0123456789";
        NSRange rangeshuzi = [tempStr rangeOfString:string];//判断字符串是否包含连续的数字
        
        //小写  正序
        NSString * lowerStr = @"abcdefghijklmnopqrstuvwxyz";
        NSRange rangeLower = [lowerStr rangeOfString:string];//判断字符串是否包含连续的小写字母
        //大写  正序
        NSString * capitalStr =[lowerStr uppercaseString];
        NSRange rangeCap = [capitalStr rangeOfString:string];//判断字符串是否包含连续的大写字母
        passWord = toBeString;
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if(rangeshuzi.length == 0 && rangeLower.length == 0 && rangeCap.length == 0)
        {
            return NO;
        }
        
        if ([string isEqualToString:@" "]) {
            return NO;
        }

        if (toBeString.length > 18) {
            return NO;
        }else{
            return YES;
        }
    }
    
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.passWordText) {
        [textField addTarget:self action:@selector(passWordFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return YES;
}

-(void)passWordFiledEditChanged:(UITextField *)textField
{
    self.passWordText.text = passWord;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneText resignFirstResponder];
    [self.verCodeText resignFirstResponder];
    [self.passWordText resignFirstResponder];
    [self.peopleIdText resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    passWord = @"";
    return YES;
}
#pragma mark - intifier
-(void)getAuthCode
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    if (self.viewTag != 123 ) {
        username= self.phoneText.text;
    }
    NSDictionary * postparams =@{@"sources":@"1",
                                 @"type":@"1",
                                  @"userName":username};
    
   [_cloudClient requestMethodWithMod:@"system/getAuthCode"//@"setting/getAuthCode"
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
//        [SRMessage infoMessage:@"验证码将以语音的形式通知到您，来电号码以010/021开头，请注意接听~" delegate:self];
        [SRMessage infoMessageWithTitle:nil message:[response objectForKey:@"msg"] delegate:self];

}
-(void)getAuthCodeError:(NSDictionary *)response
{
    //获取验证码失败
    [_timer invalidate];
    if (self.viewTag != 123 ) {
        self.verCodeBtn.enabled = YES;
         self.verCodeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
    }else{
        self.changeCodeBtn.enabled = YES;
        self.changeCodeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
    }
    [super hidenHUD];
}

/*
   注册事件
 */
-(void)userRegister
{
    if ([self isNotNetwork]) {
    [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
    return;
    }
    
    [[CommClass sharedCommon] setObject:[GeTuiSdk clientId] forKey:@"CID"];
    
    NSDictionary * postparams =nil;
    if ([DataCheck isValidString:self.peopleIdText.text]) {
        postparams=@{@"username":self.phoneText.text,
                     @"authCode":self.verCodeText.text,
                     @"password":[super md5:[super md5:self.passWordText.text]],
                     @"recordCode":self.peopleIdText.text,
                     @"cid":[GeTuiSdk clientId]};
    }else{
        postparams=@{@"username":self.phoneText.text,
                     @"authCode":self.verCodeText.text,
                     @"password":[super md5:[super md5:self.passWordText.text]],
                     @"cid":[GeTuiSdk clientId]};
    }

    [_cloudClient requestMethodWithMod:@"member/reg"
                                params:nil
                            postParams:postparams
                              delegate:self
                              selector:@selector(userRegisterSecussed:)
                         errorSelector:@selector(userRegisterError:)
                      progressSelector:nil];
}
-(void)userRegisterSecussed:(NSDictionary *)response
{
    [super hidenHUD];
    [_timer invalidate];
    //注册成功
    [MobClick event:Reg_Succes];
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
   
   
    if (self.viewTag == -1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
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

-(void)userRegisterError:(NSDictionary *)response
{
    [super hidenHUD];
    //注册失败    
}

/*
 修改密码事件
 */
-(void)resetPsw
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    NSDictionary * postparams=@{@"username":username,
                     @"authCode":self.verCodeText.text,
                     @"password":[super md5:[super md5:self.passWordText.text]]};
    [_cloudClient requestMethodWithMod:@"member/resetPsw"
                                params:nil
                            postParams:postparams
                              delegate:self
                              selector:@selector(resetPswSecussed:)
                         errorSelector:@selector(resetPswError:)
                      progressSelector:nil];
}
-(void)resetPswSecussed:(NSDictionary *)response
{
    [super hidenHUD];
    [_timer invalidate];
    //修改成功
    UIWindow * window =[UIApplication sharedApplication].keyWindow;
    self.newpassWordSuccessView.layer.cornerRadius = 10;
    self.bgView.frame = CGRectMake(0, 0, viewWidth, window.frame.size.height);
    [window addSubview: self.bgView];
    regtimeNum = 3;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goLogin) userInfo:nil repeats:YES];
}
-(void)resetPswError:(NSDictionary *)response
{
    //修改失败
    [super hidenHUD];
    
}

-(void)goLogin
{
    regtimeNum--;
    if (regtimeNum > 0) {
         self.timeLabel.text = [NSString stringWithFormat:@"%ld秒后自动跳转至登录",regtimeNum];
    }else{
        [self.bgView removeFromSuperview];
        [_timer invalidate];
        if (self.viewTag == 123) {
            self.viewTag = 321;
            [[AppModel sharedModel] presentLoginController:self];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
