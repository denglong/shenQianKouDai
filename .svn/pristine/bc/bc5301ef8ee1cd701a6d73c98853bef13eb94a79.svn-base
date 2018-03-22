 //
//  NewAddressViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/8/3.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "NewAddressViewController.h"
#import "AddressMapViewController.h"
#import "AddressReqModel.h"
@interface NewAddressViewController ()<UITextFieldDelegate,AddressMapViewControllerDelegate>
{
    CloudClient * _cloudClient;
}
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *addressScrollView;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *nametext;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneAndNameView;

@property (weak, nonatomic) IBOutlet UIView *phoneView;
- (IBAction)btnClick:(UIButton *)sender;
@end

@implementation NewAddressViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    if ([self.type integerValue] == 1) {
        self.title = @"新建收货地址";
    }else{
        self.title = @"编辑收货地址";
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

-(void)backAction:(id)sender
{
    [self.nametext resignFirstResponder];
    [self.addressText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    if ([DataCheck isValidString:self.stateLabel.text] || [DataCheck isValidString:self.nametext.text] || [DataCheck isValidString:self.addressText.text] || [DataCheck isValidString:self.phoneText.text]) {
        [SRMessage infoMessage:@"确定放弃本次编辑？" block:^{
             [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.addressScrollView.contentSize = CGSizeMake(0, self.saveBtn.frame.origin.y+100);
    self.saveBtn.layer.cornerRadius = 2;
    self.stateLabel.frame = CGRectMake(self.stateLabel.frame.origin.x, self.stateLabel.frame.origin.y, viewWidth - self.stateLabel.frame.origin.x - self.addressBtn.frame.size.width - 12 , self.stateLabel.frame.size.height);
    self.addressBtn.center = CGPointMake(viewWidth - 11 - self.addressBtn.frame.size.width/2, self.addressBtn.center.y);

    self.stateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * stateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAddressMap)];
    stateTap.cancelsTouchesInView = YES;
    [self.stateLabel addGestureRecognizer:stateTap];
    [[AddressReqModel sharedInstance] setIfDefault:@"0"];
    if ([self.type integerValue] == 2) {
        //编辑收货地址
        self.stateLabel.textColor = [UIColor blackColor];
        self.stateLabel.text = self.addressInfo.address;
//        [self.stateLabel sizeToFit];
//        
//        self.stateView.frame = CGRectMake(0, 0, viewWidth, self.stateLabel.frame.origin.y+self.stateLabel.frame.size.height +13+41);
//        self.phoneAndNameView.center = CGPointMake(self.phoneAndNameView.center.x, self.stateView.frame.size.height+10+self.phoneAndNameView.frame.size.height/2);
        self.addressText.text = self.addressInfo.addressDetail;
        self.nametext.text = self.addressInfo.addressUser;
        self.phoneText.text = self.addressInfo.addressTel;
        [[AddressReqModel sharedInstance] setId:self.addressInfo.ID];
        [[AddressReqModel sharedInstance] setAddress:self.addressInfo.address];
        [[AddressReqModel sharedInstance] setStreet:self.addressInfo.street];
        [[AddressReqModel sharedInstance] setLat:self.addressInfo.lat];
        [[AddressReqModel sharedInstance] setLng:self.addressInfo.lng];
        [[AddressReqModel sharedInstance] setIfDefault:self.addressInfo.ifDefault];
    }else{
       
    }
    [[AddressReqModel sharedInstance] setType:self.type];
    
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

- (IBAction)btnClick:(UIButton *)sender {
    if (sender == self.saveBtn) {
        //保存
        if (![DataCheck isValidString:self.stateLabel.text]) {
            [SRMessage infoMessage:@"请选择地址" delegate:self];
            return;
        }
        self.addressText.text = [self.addressText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![DataCheck isValidString:self.addressText.text]) {
            [SRMessage infoMessage:@"请输入具体地址" delegate:self];
            return;
        }
        self.nametext.text = [self.nametext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![DataCheck isValidString:self.nametext.text]) {
            [SRMessage infoMessage:@"请输入真实姓名" delegate:self];
            return;
        }
        self.phoneText.text = [self.phoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![DataCheck isValidString:self.phoneText.text]) {
            [SRMessage infoMessage:@"请输入收货电话" delegate:self];
            return;
        }
        if (![super checkTel:self.phoneText.text]) {
            return;
        }
        [[AddressReqModel sharedInstance] setAddressDetail:self.addressText.text];
        [[AddressReqModel sharedInstance] setAddressUser:self.nametext.text];
        [[AddressReqModel sharedInstance] setAddressTel:self.phoneText.text];
        _cloudClient = [CloudClient getInstance];
        [self editAndNewAddress];
    }else{
        
        [self goAddressMap];
    }
}

/**
   跳入地图页
 */
-(void)goAddressMap
{
    if ([[MapLocation sharedObject] isOpenLocal]) {
        //填写收货地址页
        AddressMapViewController * addressMapViewController = [[AddressMapViewController alloc]init];
        addressMapViewController.delegate = self;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressMapViewController animated:YES];
        return;
    }
    else{
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"定位失败"
                                                      message:@"请手动开启定位服务"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        return;
    }
}

/*编辑地址*/
-(void)editAndNewAddress
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [super showHUD];
    NSDictionary * postParams = [RequestModel class:@"AddressReqModel"];
    NSString * addressId = [NSString stringWithFormat:@"%@",[postParams objectForKey:@"id"]];
    if ([addressId isEqualToString:@""]) {
        NSMutableDictionary * mutDic = [NSMutableDictionary dictionaryWithDictionary:postParams];
        [mutDic removeObjectForKey:@"id"];
        postParams = [NSDictionary dictionaryWithDictionary:mutDic];
    }
    
    [_cloudClient requestMethodWithMod:@"member/setAddress"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(editAndNewAddressSuccessed:)
                         errorSelector:@selector(editAndNewAddressError:)
                      progressSelector:nil];
    
}
-(void)editAndNewAddressSuccessed:(NSDictionary *)response
{
    [super hidenHUD];
    if (self.confirmPage == 1 || self.confirmPage == 3) {
        
        if ([DataCheck isValidDictionary:response]) {
            NSDictionary *addressDic = [response objectForKey:@"addressList"][0];
            NSArray *addressList = [[CommClass sharedCommon] localObjectForKey:AUTOLOCATIONADDRESS];
            NSString *cityCode = addressList.firstObject;
            if ([[addressDic objectForKey:@"cityCode"] isEqualToString:cityCode]) {
                [RequestModel clearModel:@"AddressReqModel"];
                NSString *addressId = [addressDic objectForKey:@"id"];
                NSString *address = [NSString stringWithFormat:@"%@%@", [addressDic objectForKey:@"address"], [addressDic objectForKey:@"addressDetail"]];
                NSString *addressUser = [addressDic objectForKey:@"addressUser"];
                NSString *addressTel = [addressDic objectForKey:@"addressTel"];
                NSDictionary *values = @{@"address":address,
                                         @"addressUser":addressUser,
                                         @"addressTel":addressTel};
                [[CommClass sharedCommon] localObject:[addressDic objectForKey:@"lat"] forKey:AddressLat];
                [[CommClass sharedCommon] localObject:[addressDic objectForKey:@"lng"] forKey:AddressLng];
                [self.addressDelegate newAddress:values andAddressId:addressId];
                if (self.confirmPageList == YES) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                NSString * msg = [NSString stringWithFormat:@"是否切换到【%@】？切换后当前订单信息将会消失",[addressDic objectForKey:@"address"]];
                [SRMessage infoMessage:msg title:@"已经超出配送范围"  cancelTitle:@"换个地址" sureTitle:@"确认切换" block:^{
                    CLLocation * location = [[CLLocation alloc]initWithLatitude:[[addressDic objectForKey:@"lat"] floatValue] longitude:[[addressDic objectForKey:@"lng"] floatValue]];
                     NSDictionary * selectedAddress = @{@"area":[addressDic objectForKey:@"street"],@"address":[addressDic objectForKey:@"address"],@"location":location,@"cityCode":[addressDic objectForKey:@"cityCode"]};
                    [[CommClass sharedCommon] setObject:selectedAddress forKey:LocationAddress];
                   
                    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGELOCATIONLATANDLNG object:[addressDic objectForKey:@"address"] userInfo:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }
        }
    }else{
        [RequestModel clearModel:@"AddressReqModel"];
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}
-(void)editAndNewAddressError:(NSDictionary *)response
{
    [super hidenHUD];
    
}
#pragma mark - textFiled delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   [textField addTarget:self action:@selector(usertextFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString =[textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField == self.phoneText) {
        if (toBeString.length > 11) {
            [textField resignFirstResponder];
            return NO;
        }else{
            return YES;
        }
    }
    if (textField == self.nametext) {
        if (toBeString.length > 12) {
            [textField resignFirstResponder];
            return NO;
        }else{
            return YES;
        }
    }
    
    if (textField == self.addressText) {
        if (toBeString.length > 200) {
            [textField resignFirstResponder];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

//对键盘选择文字的监听
-(void)usertextFiledEditChanged:(UITextField *)textview
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
        
        if (textview == self.nametext) {
            if (!position){
                if(toBeString.length > 12){
                    self.nametext.text = [toBeString substringToIndex:12];
                }
            }else{  //有高亮选择的字符串,则暂不对文字进行统计和限制
                
            }
        }
        
        if (textview == self.addressText) {
            if (!position){
                if(toBeString.length > 200){
                    self.addressText.text = [toBeString substringToIndex:200];
                }
            }else{  //有高亮选择的字符串,则暂不对文字进行统计和限制
                
            }
        }
        
    }else{  //中文输入法以外的直接对其统计限制即可,不考虑其他语种情况
        
        if (textview == self.nametext) {
            if (toBeString.length > 12) {
                self.nametext.text = [toBeString substringToIndex:12];
            }
        }
        if (textview == self.addressText) {
            if (toBeString.length > 200) {
                self.addressText.text = [toBeString substringToIndex:200];
            }
        }

        
    }
}


#pragma mark - AddressMapViewControllerDelegate 
-(void)getAddress:(NSString *)address
{
//    self.stateLabel.frame = CGRectMake(self.stateLabel.frame.origin.x, self.stateLabel.frame.origin.y, viewWidth - self.stateLabel.frame.origin.x - self.addressBtn.frame.size.width - 12 , self.stateLabel.frame.size.height);
    self.stateLabel.textColor = [UIColor blackColor];
    self.stateLabel.text = address;
//    [self.stateLabel sizeToFit];
//    self.stateLabel.frame = CGRectMake(self.stateLabel.frame.origin.x, self.stateLabel.frame.origin.y, viewWidth - self.stateLabel.frame.origin.x - self.addressBtn.frame.size.width - 12 , self.stateLabel.frame.size.height);
//    self.stateView.frame = CGRectMake(0, 0, viewWidth, self.stateLabel.frame.origin.y+self.stateLabel.frame.size.height +13+41);
//
//    self.stateView.center = CGPointMake(viewWidth/2, self.stateView.frame.size.height/2);
//    self.phoneAndNameView.center = CGPointMake(self.phoneAndNameView.center.x, self.stateView.frame.size.height+10+self.phoneAndNameView.frame.size.height/2);
}
@end
