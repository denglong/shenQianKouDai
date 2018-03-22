//
//  AddAttendantViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/8/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "AddAttendantViewController.h"

@interface AddAttendantViewController ()<UITextFieldDelegate>
{
    NSTimer * timer;
    NSInteger timeNum;
    CloudClient * _cloudClient;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *vercodeLine;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;

- (IBAction)BtnAction:(UIButton *)sender;

@end

@implementation AddAttendantViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   [MobClick beginLogPageView:NSStringFromClass([self class])];
    self.title = @"增加配送员";
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.codeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
    self.codeBtn.layer.borderWidth = 1;
    self.codeBtn.layer.cornerRadius = 5;
    self.vercodeLine.frame = CGRectMake(self.vercodeLine.frame.origin.x, 40.5, self.vercodeLine.frame.size.width, 0.5);
    self.codeLoginBtn.layer.cornerRadius = 3;
    self.codeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cloudClient = [CloudClient getInstance];
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

- (IBAction)BtnAction:(UIButton *)sender {
    if (![super checkTel:self.phoneText.text]) {
        return;
    }
    if (sender == self.codeBtn) {
        //获取验证码
        if (self.codeBtn.enabled == YES) {
            self.codeBtn.enabled = NO;
             self.codeBtn.layer.borderColor = RGBACOLOR(102, 102, 102, 1.0).CGColor;
            timeNum = 60;
            [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(attendantDaojishi) userInfo:nil repeats:YES];
            [self getAuthCode];
        }
    }else{
    //验证并增加
        if (![DataCheck isValidString:self.codeText.text]) {
            [SRMessage infoMessage:@"请输入验证码" delegate:self];
            return;
        }
        self.nameText.text = [self.nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![DataCheck isValidString:self.nameText.text]) {
            [SRMessage infoMessage:@"请输入配送员的姓名" delegate:self];
            return;
        }
        [self addAttendant];
    }
    
}
//获取验证码倒计时
-(void)attendantDaojishi
{
    if (timeNum > 1) {
        timeNum--;
        self.codeBtn.enabled = NO;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码\n（%lds）",(long)timeNum] forState:UIControlStateDisabled];
    }else{
        [timer invalidate];
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
    }
}

#pragma mark - textfeild delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField addTarget:self action:@selector(attendantFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    return YES;
}


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
    if (textField == self.codeText) {
        if (toBeString.length > 4) {
            return NO;
        }else{
            return YES;
        }
    }
    if (textField == self.nameText) {
        if (toBeString.length > 10) {
            return NO;
        }else{
            return YES;
        }
    }

    return YES;
}
//对键盘选择文字的监听
-(void)attendantFiledEditChanged:(UITextField *)textview
{
    NSString *toBeString = textview.text;
    
    [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        //emoji length is 2  replace emoji with emptyString
        if (substring.length == 2) {
            //过滤表情符号
            textview.text = [textview.text stringByReplacingOccurrencesOfString:substring withString:@""];
        }
    }];
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;//键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]){ //简体中文输入,包括简体拼音,五笔,手写
        UITextRange *selecteRange = [textview markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textview positionFromPosition:selecteRange.start offset:0];
        //没有高亮选择的字,则对已输入的文字精心字数统计合限制
        
        if (textview == self.nameText) {
            if (!position){
                if(toBeString.length > 10){
                    self.nameText.text = [toBeString substringToIndex:10];
                }
            }else{  //有高亮选择的字符串,则暂不对文字进行统计和限制
                
            }
        }
        
    }else{  //中文输入法以外的直接对其统计限制即可,不考虑其他语种情况
        
        if (textview == self.nameText) {
            if (toBeString.length > 10) {
                self.nameText.text = [toBeString substringToIndex:10];
            }
        }
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneText resignFirstResponder];
    [self.codeText resignFirstResponder];
    [self.nameText resignFirstResponder];
    return YES;
}
#pragma mark - intifier
-(void)getAuthCode
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    NSDictionary * postparams =@{@"sources":@"4",
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
    [timer invalidate];
    self.codeBtn.enabled = YES;
     self.codeBtn.layer.borderColor = RGBACOLOR(245, 125, 110, 1.0).CGColor;
    //获取验证码失败
    
}
/*
 添加配送员
 */
-(void)addAttendant
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [super showHUD];
    NSDictionary * postparams =@{@"mobile":self.phoneText.text,
                                 @"authCode":self.codeText.text,
                                 @"name":self.nameText.text};
    
    [_cloudClient requestMethodWithMod:@"member/addDelivery"
                                params:nil
                            postParams:postparams
                              delegate:self
                              selector:@selector(addAttendantSecussed:)
                         errorSelector:@selector(addAttendantError:)
                      progressSelector:nil];
}
-(void)addAttendantSecussed:(NSDictionary *)response
{
    //添加成功
    [super hidenHUD];
    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addAttendantError:(NSDictionary *)response
{
    //添加失败
    [super hidenHUD];
    
}
@end
