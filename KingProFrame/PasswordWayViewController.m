//
//  PasswordWayViewController.m
//  KingProFrame
//
//  Created by 李栋 on 15/7/31.
//  Copyright (c) 2015年 king. All rights reserved.
//


//此类暂时没用
#import "PasswordWayViewController.h"

@interface PasswordWayViewController ()
{
    CloudClient *cloudClient;
}
@end

@implementation PasswordWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    
    cloudClient = [CloudClient getInstance];
    
}
//点击背景隐藏键盘
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.oldPasswordTextField resignFirstResponder];
    [self.passwordNewTextField resignFirstResponder];
}
//点击return隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.oldPasswordTextField resignFirstResponder];
    [self.passwordNewTextField resignFirstResponder];
    return YES;
}
//判断字符长度 过滤特殊字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    if ([string isEqualToString:@"@"]
    //        ||[string isEqualToString:@"#"]
    //        ||[string isEqualToString:@"$"]
    //        ||[string isEqualToString:@"%"]
    //        ||[string isEqualToString:@"&"]
    //        ||[string isEqualToString:@"*"]
    //        ||[string isEqualToString:@"-"]
    //        ||[string isEqualToString:@"+"]
    //        ||[string isEqualToString:@"_"]
    //        ||[string isEqualToString:@" "])
    //    {
    //        [SRMessage infoMessage:AMEND_PASSWORD_05];
    //        return NO;
    //    }
    //数字
//    NSString * tempStr =@"0123456789";
//    NSRange rangeshuzi = [tempStr rangeOfString:string];//判断字符串是否包含连续的数字
//    
//    //小写  正序
//    NSString * lowerStr = @"abcdefghijklmnopqrstuvwxyz";
//    NSRange rangeLower = [lowerStr rangeOfString:string];//判断字符串是否包含连续的小写字母
//    //大写  正序
//    NSString * capitalStr =[lowerStr uppercaseString];
//    NSRange rangeCap = [capitalStr rangeOfString:string];//判断字符串是否包含连续的大写字母
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
//    if(rangeshuzi.length == 0 && rangeLower.length == 0 && rangeCap.length == 0)
//    {
//       // [SRMessage infoMessage:AMEND_PASSWORD_05];
//        return NO;
//    }
    
    if ([string isEqualToString:@" "]) {
       // [SRMessage infoMessage:AMEND_PASSWORD_05];
        return NO;
    }
    NSString *toBeString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length>16 )
    {
        //[SRMessage infoMessage:AMEND_PASSWORD_05];
        return NO;
    }else{
        return YES;
    }
    
    return YES;
}

-(void)resetPassWordRequest {
    
    NSDictionary *params = @{
                             @"":@"",
                             @"":@""
                             };
    
    [cloudClient requestMethodWithMod:@"member/resetPsw"
                               params:nil
                           postParams:params
                             delegate:self
                             selector:@selector(resetPswFinish:)
                        errorSelector:@selector(resetPswError:)
                     progressSelector:nil];
}

- (void)resetPswFinish:(NSDictionary *)request {
    DLog(@"finish request------>%@",request);
}

- (void)resetPswError:(NSDictionary *)request {
    DLog(@"error request------->%@",request);
}


- (IBAction)ConfirmButtonClick:(id)sender {
    
}
@end
