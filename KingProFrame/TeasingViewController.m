//
//  TeasingViewController.m
//  KingProFrame
//
//  Created by 李栋 on 15/7/31.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "TeasingViewController.h"

@interface TeasingViewController ()<UITextViewDelegate>
{
    UILabel *placeholder;
    CloudClient *cloudClient;
}
@end

@implementation TeasingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    
    cloudClient = [CloudClient getInstance];
    self.title = @"吐槽";
    placeholder = [[UILabel alloc]init];
    placeholder.frame = CGRectMake(2, 6, self.contentTextView.frame.size.width, 20);
    placeholder.text = @"请敞开心扉输入您的宝贵意见和建议~(200字以内)";
    placeholder.textAlignment = NSTextAlignmentCenter;
    placeholder.enabled = YES;
    placeholder.font = [UIFont systemFontOfSize:14];
    placeholder.textColor = RGBACOLOR(102, 102, 102, 1);
    [self.contentTextView addSubview:placeholder];
    
    self.navigationItem.rightBarButtonItem = [super createRightItem:self itemStr:@"提交" itemImage:nil itemImageHG:nil selector:@selector(submitItemBtnClick:)];

}


-(void)feedBackRequest {
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }

    NSDictionary *params = @{
                             @"opinion":self.contentTextView.text
                             };
    
    [cloudClient requestMethodWithMod:@"setting/opin"
                               params:nil
                           postParams:params
                             delegate:self
                             selector:@selector(feedBackFinish:)
                        errorSelector:@selector(feedBackError:)
                     progressSelector:nil];
}

- (void)feedBackFinish:(NSDictionary *)request {
    [self.contentTextView resignFirstResponder];
    DLog(@"finish request------>%@",request);
    [SRMessage infoMessage:@"我们已收到您的意见,非常感谢" delegate:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
//
}

- (void)feedBackError:(NSDictionary *)request {
    DLog(@"error request------->%@",request);
}


//自己写的TextView 的 placeholder
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if ([text isEqualToString:@"\n"]) {//检测到“完成”
//        //[textView resignFirstResponder];//释放键盘
//        //return NO;
//    }
    if (textView.text.length==0){//textview长度为0
        if ([textView.text isEqualToString:@""]) {//判断是否为删除键
            placeholder.hidden=NO;
        }else{
            placeholder.hidden=YES;
        }
    }else{//textview长度不为0
        if (textView.text.length==1){//textview长度为1时候
            if ([textView.text isEqualToString:@""]) {//判断是否为删除键
                placeholder.hidden=NO;
            }else{//不是删除
                placeholder.hidden=YES;
            }
        }else{//长度不为1时候
            placeholder.hidden=YES;
        }
    }
    
    return YES;
}
//对键盘选择文字的监听

-(void)textViewDidChange:(UITextView *)textView
{
    
    NSString *string = textView.text;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        //emoji length is 2  replace emoji with emptyString
        if (substring.length == 2) {
            //过滤表情符号
            textView.text = [textView.text stringByReplacingOccurrencesOfString:substring withString:@""];
        }
    }];

    
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;//键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]){ //简体中文输入,包括简体拼音,五笔,手写
        UITextRange *selecteRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selecteRange.start offset:0];
        //没有高亮选择的字,则对已输入的文字精心字数统计合限制
        if (!position){
            if(toBeString.length > 0){
                placeholder.hidden=YES;
            }else{
                placeholder.hidden = NO;
            }
            if (toBeString.length > 200) {
                self.contentTextView.text = [toBeString substringWithRange:NSMakeRange(0, 200)];
                [SRMessage infoMessage:@"您的意见不能超过200字" delegate:self];
            }
        }else{  //有高亮选择的字符串,则暂不对文字进行统计和限制
            
        }
        
    }else{  //中文输入法以外的直接对其统计限制即可,不考虑其他语种情况
        
        if (toBeString.length > 0) {
            placeholder.hidden=YES;
        }
    }

}



- (void)submitItemBtnClick:(id)sender {

    if ([DataCheck isValidString:self.contentTextView.text]) {
        [self feedBackRequest];
    }else{
        [SRMessage infoMessage:@"请输入您的宝贵意见" delegate:self];
    }
    
}
@end
