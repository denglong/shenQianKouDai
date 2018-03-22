//
//  ChangeNameViewController.m
//  KingProFrame
//
//  Created by lihualin on 16/2/24.
//  Copyright © 2016年 king. All rights reserved.
//

#import "ChangeNameViewController.h"

@interface ChangeNameViewController ()<UITextFieldDelegate>
{
  CloudClient * _cloudClient;
    NSTimer * _timer;
    NSInteger regtimeNum;
}
/**修改密码按钮*/
@property (weak, nonatomic) IBOutlet UIButton *changePwdBtn;
/**textFiledView*/
@property (weak, nonatomic) IBOutlet UIView *textFiledView;
/**输入框*/
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property(nonatomic , copy) backBlock myBlock;
/**修改密码成功背景*/
@property (strong, nonatomic) IBOutlet UIView *bgView;
/**修改成功UI*/
@property (weak, nonatomic) IBOutlet UIView *newpassWordSuccessView;
/**修改密码按钮事件*/
- (IBAction)changePwdAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *DaojishiGoLoginLabel;

@end

@implementation ChangeNameViewController

-(void)setBackBlock:(backBlock)block
{
    self.myBlock = block;
}
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
    // Do any additional setup after loading the view from its nib.
    [self refresh];
}

-(void)backAction:(id)sender
{
    [self.nameTextFiled resignFirstResponder];
    if(self.viewtag == 0){
        if (![self.accountNumber isEqualToString:self.nameTextFiled.text]) {
            [SRMessage infoMessage:@"确认返回吗？你修改的信息还没有保存" block:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
           [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    if (self.viewtag == 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  初始化页面
 */
-(void)refresh
{
    if (self.viewtag == 0) {
        self.title = @"名字";
        self.nameTextFiled.text = self.accountNumber;
        self.nameTextFiled.placeholder = @"请输入您的名字";
        self.navigationItem.rightBarButtonItem = [self createRightItem:self itemStr:@"保存" itemImage:nil itemImageHG:nil selector:@selector(saveNameAction:)];
        if ([DataCheck isValidString:self.nameTextFiled.text]) {
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        }else{
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
       
        [self.nameTextFiled addTarget:self action:@selector(usertextFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
//        [self.nameTextFiled becomeFirstResponder];
        return;
    }
    if(self.viewtag == 1){
        self.title = @"账户与安全";
        self.changePwdBtn.imageEdgeInsets = UIEdgeInsetsMake(0, viewWidth-25, 0, 0);
        self.textFiledView.hidden = YES;
        return;
    }
    if(self.viewtag == 2){
        self.title = @"修改密码";
        self.textFiledView.hidden = NO;
        self.nameTextFiled.placeholder = @"请输入新密码";
        self.navigationItem.rightBarButtonItem = [self createRightItem:self itemStr:@"保存" itemImage:nil itemImageHG:nil selector:@selector(saveNameAction:)];
        [self.nameTextFiled addTarget:self action:@selector(usertextFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
        return;
    }
    if (self.viewtag == 3){
        self.title = @"注册账号";
        [self.nameTextFiled setEnabled:NO];
        self.nameTextFiled.text = self.accountNumber;
        return;
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
#pragma mark - 修改昵称
-(void)saveNameAction:(id)sender
{
    [self.nameTextFiled resignFirstResponder];
    self.nameTextFiled.text = [self.nameTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.viewtag == 0) {
        //修改姓名
        if ([self isNotNetwork]) {
            [SRMessage infoMessage:@"网络异常，稍后再试试。" delegate:self];
            return;
        }
        if (![DataCheck isValidString:self.nameTextFiled.text]) {
            [SRMessage infoMessage: @"名字不能为空" delegate:self];
            return;
        }
        
        if (self.myBlock !=nil && self.nameTextFiled.text.length > 0) {
            self.myBlock(self.nameTextFiled.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.viewtag == 2) {
        //修改密码
        [self updateOldPsw];
        return;
    }
}
#pragma mark - textfiled delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.nameTextFiled.text = textField.text;
    if (textField.text.length > 20) {
        self.nameTextFiled.text = [textField.text substringFromIndex:textField.text.length-20];
    }
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * toBeString =[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.viewtag == 2) {
        //数字
        NSString * tempStr =@"0123456789";
        NSRange rangeshuzi = [tempStr rangeOfString:string];//判断字符串是否包含连续的数字
        //小写  正序
        NSString * lowerStr = @"abcdefghijklmnopqrstuvwxyz";
        NSRange rangeLower = [lowerStr rangeOfString:string];//判断字符串是否包含连续的小写字母
        //大写  正序
        NSString * capitalStr =[lowerStr uppercaseString];
        NSRange rangeCap = [capitalStr rangeOfString:string];//判断字符串是否包含连续的大写字母
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

#pragma mark - 修改密码

- (IBAction)changePwdAction:(UIButton *)sender {
    ChangeNameViewController * changeNameVC = [[ChangeNameViewController alloc]init];
    changeNameVC.viewtag = 2;
    [self.navigationController pushViewController:changeNameVC animated:YES];
}

/*
 修改密码事件
 */
-(void)updateOldPsw
{
    if (![DataCheck isValidString:self.nameTextFiled.text]) {
        [SRMessage infoMessage:@"请输入密码" delegate:self];
        return;
    }
    if (self.nameTextFiled.text.length < 6) {
        [SRMessage infoMessage:@"密码不能少于6位" delegate:self];
        return;
    }

    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，稍后再试试。" delegate:self];
        return;
    }
    NSDictionary * postparams=@{@"username":[[CommClass sharedCommon] objectForKey:LOGGED_USERNAME],
                                @"password":[super md5:[super md5:self.nameTextFiled.text]]};
    _cloudClient = [CloudClient getInstance];
    [_cloudClient requestMethodWithMod:@"member/updatePassword"
                                params:nil
                            postParams:postparams
                              delegate:self
                              selector:@selector(updateOldPswSecussed:)
                         errorSelector:@selector(updateOldPswError:)
                      progressSelector:nil];
}
-(void)updateOldPswSecussed:(NSDictionary *)response
{
    [super hidenHUD];
    //修改成功
    UIWindow * window =[UIApplication sharedApplication].keyWindow;
    self.newpassWordSuccessView.layer.cornerRadius = 10;
    self.bgView.frame = window.bounds;
    [window addSubview: self.bgView];
    regtimeNum = 3;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goLogin) userInfo:nil repeats:YES];
}
-(void)updateOldPswError:(NSDictionary *)response
{
    //修改失败
    
    [super hidenHUD];
    
}

-(void)goLogin
{
    
    regtimeNum--;
    if (regtimeNum > 0) {
       self.DaojishiGoLoginLabel.text = [NSString stringWithFormat:@"%ld秒后自动跳转至登录",regtimeNum];
    }else{
        [self.bgView removeFromSuperview];
        [_timer invalidate];
         [[AppModel sharedModel] presentLoginController:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController setViewControllers:@[self.navigationController.viewControllers.firstObject,[self.navigationController.viewControllers objectAtIndex:1],[self.navigationController.viewControllers objectAtIndex:2]] animated:NO];
        });
        
    }
}

//对键盘选择文字的监听
-(void)usertextFiledEditChanged:(UITextField *)textField
{
    NSString *toBeString = textField.text;
    
    [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        //emoji length is 2  replace emoji with emptyString
        if (substring.length == 2) {
            //过滤表情符号
            textField.text = [textField.text stringByReplacingOccurrencesOfString:substring withString:@""];
        }
    }];
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;//键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]){ //简体中文输入,包括简体拼音,五笔,手写
        UITextRange *selecteRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selecteRange.start offset:0];
        //没有高亮选择的字,则对已输入的文字精心字数统计合限制
        if (!position){
            if (self.viewtag == 0) {
                if (textField.text.length ==0) {
                   self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }else{
                   self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                }

            }
            
        }else{  //有高亮选择的字符串,则暂不对文字进行统计和限制
            
        }
    }else{  //中文输入法以外的直接对其统计限制即可,不考虑其他语种情况
         if (self.viewtag == 0) {
             if (textField.text.length ==0) {
                self.navigationItem.rightBarButtonItem.customView.hidden = YES;
             }else{
                self.navigationItem.rightBarButtonItem.customView.hidden = NO;
             }
         }
    }
}


@end
