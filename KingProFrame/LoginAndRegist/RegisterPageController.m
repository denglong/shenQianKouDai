//
//  RegisterPageController.m
//  KingProFrame
//
//  Created by 邓龙 on 11/27/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "RegisterPageController.h"

@interface RegisterPageController ()<UITextFieldDelegate>

/** title标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleStr;
/** 输入框 */
@property (weak, nonatomic) IBOutlet UITextField *inputText;
/** 下一步点击按钮 */
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
/** 密码密文显示 */
@property (weak, nonatomic) IBOutlet UIButton *passwordHidden;
/** 重新发送验证码 */
@property (weak, nonatomic) IBOutlet UIButton *sendCheckNum;
/** 发送验证码倒计时Label */
@property (nonatomic, strong) UILabel *timeNum;
/** 验证码时间倒计时 */
@property (nonatomic, assign) NSInteger checkNumTime;
/** 输入框字符串 */
@property (nonatomic, copy) NSString *inputStr;
/** api请求对象 */
@property (nonatomic, strong) CloudClient *client;

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *checkNum;

@end

@implementation RegisterPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.client = [CloudClient getInstance];
    self.navigationController.navigationBarHidden = YES;
    self.titleStr.text = self.titleName;
    [self createTimeNumAction];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.checkNumTime = 0;
}

#pragma mark - 创建倒计时Label
- (void)createTimeNumAction {
    
    self.timeNum = [[UILabel alloc] init];
    self.timeNum.textAlignment = NSTextAlignmentCenter;
    self.timeNum.textColor = [UIColor_HEX colorWithHexString:@"999999"];
    self.timeNum.font = [UIFont systemFontOfSize:15];
    [self.sendCheckNum addSubview:self.timeNum];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.timeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.sendCheckNum).insets(edge);
    }];
}

#pragma mark - textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
//    textField.text = self.inputStr;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString =[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 11) {
        
        return NO;
    }
    
    self.inputStr = toBeString;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.inputStr = textField.text;
    [textField resignFirstResponder];
}

#pragma mark - 返回按钮点击事件
- (IBAction)backUpPageAction:(id)sender {
    
    if (self.sendCheckNum.isHidden == NO ||
        [self.clickButton.titleLabel.text isEqualToString:@"完成"]) {
        
        __weak typeof(self) weakSelf = self;
        [SRMessage infoDLMessage:nil
                           title:@"是否放弃注册?"
                     cancelTitle:@"放弃"
                       sureTitle:@"继续注册" block:^{
                           
                           return;
                       } cancleBlock:^{
                           
                           [weakSelf.navigationController popViewControllerAnimated:YES];
                       }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - 隐藏键盘
- (IBAction)hiddenKeyBoardAction:(id)sender {
    
    [self.inputText resignFirstResponder];
}

#pragma mark - 是否显示密码
- (IBAction)hiddenOrSHowPwAction:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    self.inputText.secureTextEntry = sender.isSelected;
}

#pragma mark - 重新发送验证码
- (IBAction)sendCheckNumAgain:(UIButton *)sender {
    
    self.checkNumTime = 60;
    [self checkNumTimeAction];
}

#pragma mark - 下一步点击事件
- (IBAction)nextButtonAction:(UIButton *)sender {
    
    [self.inputText resignFirstResponder];
    if (self.sendCheckNum.isHidden == NO) {
        
        self.checkNum = self.inputStr;
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        self.passwordHidden.hidden = NO;
        self.sendCheckNum.hidden = YES;
        self.inputText.placeholder = @"请输入密码";
        self.inputText.secureTextEntry = YES;
        self.inputText.text = @"";
        
    }
    else
    {
        if ([sender.titleLabel.text isEqualToString:@"完成"]) {
            if (![DataCheck isValidString:self.inputStr]) {
                [SRMessage infoMessage:@"请输入密码"];
                return;
            }
            [self registerAction];
            return;
        }
        
        __weak typeof(self) weakSelf = self;
        if (![DataCheck isValidString:self.inputStr]) {
            [SRMessage infoMessage:@"请输入手机号码"];
            return;
        }
        self.phoneNum = self.inputStr;
        NSString *phoneNum = [NSString stringWithFormat:@"我们将发送验证码短信至：%@", self.inputStr];
        [SRMessage infoDLMessage:nil
                           title:phoneNum
                     cancelTitle:@"取消"
                       sureTitle:@"确定" block:^{
                           
                           [weakSelf sendCheckNumAction];
//                           [weakSelf registerAction];
                       } cancleBlock:^{
                           
                           return;
                       }];
    }
}

#pragma mark - 验证码倒计时
- (void)checkNumTimeAction {

    self.checkNumTime --;
    if (self.checkNumTime > 0) {
        
        self.sendCheckNum.enabled = NO;
        self.timeNum.text = [NSString stringWithFormat:@"重新发送  (%zd)", self.checkNumTime];
        [self performSelector:@selector(checkNumTimeAction) withObject:nil afterDelay:1.0];
    }
    else
    {
        self.sendCheckNum.enabled = YES;
        self.timeNum.text = @"重新发送";
        return;
    }
}

- (void)dealloc {
    
}

#pragma mark - 发送短信验证码
- (void)sendCheckNumAction {
    
    [self showHUD];
    
    NSDictionary *params = @{@"userName":self.inputStr, @"type":@"1", @"sources":@"1"};
    if ([self.titleName isEqualToString:@"忘记密码"]) {
        params = @{@"userName":self.inputStr, @"type":@"1", @"sources":@"3"};
    }
    
    [self.client requestMethodWithMod:@"system/getAuthCode"
                               params:nil
                           postParams:params
                             delegate:self
                             selector:@selector(sendCheckNumSuccess:)
                        errorSelector:@selector(sendCheckNumError:)
                     progressSelector:nil];
}

- (void)sendCheckNumSuccess:(NSDictionary *)response {
    
    [self hidenHUD];
    [SRMessage infoMessage:@"验证码发送成功"];
    self.sendCheckNum.hidden = NO;
    self.checkNumTime = 60;
    self.inputText.placeholder = @"请输入验证码";
    self.inputText.text = @"";
    self.inputStr = @"";
    [self checkNumTimeAction];
}

- (void)sendCheckNumError:(NSDictionary *)response {
    
    [self hidenHUD];
    [SRMessage infoMessage:@"验证码发送失败"];
}

- (void)registerAction {
    
    NSDictionary *postparams = @{@"username":self.phoneNum, @"authCode":self.checkNum, @"password":self.inputStr};
    if([self.titleName isEqualToString:@"忘记密码"]){
        [self.client requestMethodWithMod:@"member/resetPsw"
                                   params:nil
                               postParams:postparams
                                 delegate:self
                                 selector:@selector(userRegisterSecussed:)
                            errorSelector:@selector(userRegisterError:)
                         progressSelector:nil];
        return;
    }
    [self.client requestMethodWithMod:@"member/reg"
                                params:nil
                            postParams:postparams
                              delegate:self
                              selector:@selector(userRegisterSecussed:)
                         errorSelector:@selector(userRegisterError:)
                      progressSelector:nil];
}

- (void)userRegisterSecussed:(NSDictionary *)response {
    if([self.titleName isEqualToString:@"忘记密码"]){
        [SRMessage infoMessage:@"密码修改成功！"];
    }
    else
    {
    [SRMessage infoMessage:@"注册成功！"];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)userRegisterError:(NSDictionary *)response {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
