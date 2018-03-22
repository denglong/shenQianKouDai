//
//  MyInfoViewController.m
//  KingProFrame
//
//  Created by lihualin on 15/7/31.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoHeaderCell.h"
#import "MyInfoCell.h"
//#import "MyInfoModel.h"
#import "MyInfoList.h"
#import "MyInfo.h"
#import "MyAddressViewController.h"
#import "ChangeNameViewController.h"
#import "CloudClientRequest.h"
#define section0 5
#define section1 1
@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate,reloadDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,GetImageProtocol>

{
    CloudClient * _cloudClient;
    MyInfo * myInfo;
    NSMutableDictionary * nutPostParams;
//    UITextView * textview;
    
    UIImageView * headerImage;
    UILabel * infoLabel;
//    UIImageView * sexImage;
//    NSDictionary * signDic;
    UIView * noNetWork;
    CloudClientRequest *requestClient;
}

@property (strong, nonatomic) IBOutlet UIView *ChangePwdView;
/**弹框*/
@property (weak, nonatomic) IBOutlet UIView *myAlertView;
/**修改密码弹框*/
@property (weak, nonatomic) IBOutlet UITableView *myInfoTableView;
/**密码输入框*/
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
- (IBAction)cancelOrOkAction:(UIButton *)sender;

@end

@implementation MyInfoViewController
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
    [self getMyInfoData];
    
}
/**获取个人资料详情*/
-(void)getMyInfoData
{
    if ([self noNetwork]) {
        return;
    }
    [_cloudClient requestMethodWithMod:@"member/getUserInfo"
                                params:nil
                            postParams:nil
                              delegate:self
                              selector:@selector(getMyInfoSuccessed:)
                         errorSelector:@selector(getMyInfoError:)
                      progressSelector:nil];
    
}
-(void)getMyInfoSuccessed:(NSDictionary *)response
{
    [super hidenHUD];
    [ResponseModel class:@"MyInfoList" dic:response];
    [MyInfoList create:@"MyInfo"];
    NSMutableArray * titleName = [NSMutableArray array];
    NSMutableArray * titleNum = [NSMutableArray array];
    if ([DataCheck isValidArray:[MyInfoList sharedInstance].userLabelList]) {
        NSArray * userLabelList = [MyInfoList sharedInstance].userLabelList;
        for (NSDictionary * dic in userLabelList) {
            [titleName addObject:dic[@"name"]];
            [titleNum addObject:dic[@"number"]];
        }
        
//        signDic = @{@"titleName":titleName,@"titleNum":titleNum};
    }
    [self.myInfoTableView reloadData];
}
-(void)getMyInfoError:(NSDictionary *)response
{
    
    [super hidenHUD];
}

#pragma mark -修改密码成功后，未登录点击返回通知事件
-(void)notLoginback:(id)not
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notLoginback:) name:NOTIFICATION_LOGINCANCEL object:nil];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
   
    self.title = @"账户管理";

    [self noNetwork];
    [self getMyInfoData];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCell];
    [super setExtraCellLineHidden:self.myInfoTableView];
    nutPostParams = [NSMutableDictionary dictionary];
    _cloudClient = [CloudClient getInstance];
    requestClient = [[CloudClientRequest alloc] init];
    [super showHUD];
   
}
/**
 *  注册cell
 */
-(void)registerCell
{
    [self.myInfoTableView registerNib:[UINib nibWithNibName:@"MyInfoHeaderCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyInfoHeaderCell class])];
}


/*保存*/
-(void)saveAction
{
    [MobClick event:Save_AccInfo];
    NSDictionary * postParams = [NSDictionary dictionaryWithDictionary:nutPostParams];
    if (![DataCheck isValidDictionary:nutPostParams]) {
        [self.myInfoTableView reloadData];
        return;
    }
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [super showHUD];
    [_cloudClient requestMethodWithMod:@"member/setProfile"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(saveMyInfoSuccessed:)
                         errorSelector:@selector(saveMyInfoError:)
                      progressSelector:nil];

    
}

-(void)saveMyInfoSuccessed:(NSDictionary *)response
{
    [super hidenHUD];
    [nutPostParams removeAllObjects];
    [SRMessage infoMessage:@"修改成功" delegate:self];
}
-(void)saveMyInfoError:(NSDictionary *)response
{
    [super hidenHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return section0;
    }
    return section1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return 41;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myInfo = [MyInfo sharedInstance];
    MyInfoHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyInfoHeaderCell class])];
    [cell setMyInfo:myInfo indexPath:indexPath];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myInfoHeaderImageViewTap:)];
    [cell.titleImage addGestureRecognizer:tap];
    if (indexPath.section == 0) {
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myInfoLabelTap:)];
        [cell.finishLabel addGestureRecognizer:tap1];

    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return LHLHeaderHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        MyAddressViewController * myAddressViewController = [[MyAddressViewController alloc]init];
//        myAddressViewController.addressnum = [myInfo.addrNum integerValue];
//        __weak __typeof (self) weakSelf = self;
//        [myAddressViewController setAddressNumBlock:^(NSUInteger addressNum) {
//            myInfo.addrNum = [NSString stringWithFormat:@"%ld",(unsigned long)addressNum];
//            MyInfoHeaderCell * cell =[weakSelf.myInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//            cell.finishLabel.text = [NSString stringWithFormat:@"%@个",myInfo.addrNum];
//        }];
//        [self.navigationController pushViewController:myAddressViewController animated:YES];
//        return;
//    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self showChangePwdView];
        return;
    }
}

#pragma mark - 上传图片
/**
 头像点击事件
 */
-(void)myInfoHeaderImageViewTap:(UIGestureRecognizer *)sender
{
    headerImage = (UIImageView *)sender.view;
    //修改图像
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    [actionSheet showInView:self.view];
    
}
#pragma mark - actionSheet delegate 修改图像
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //判断相机是否能够使用
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(status == AVAuthorizationStatusDenied) {
                [SRMessage infoMessage:@"照相机已被禁止，请在设置中开启后使用。" delegate:self];
            }
            else
            {
                [self presentViewController:[[GetMediaData shareGetMediaData] showImageController:YES] animated:YES completion:nil];
                [GetMediaData shareGetMediaData].getImageDelegate = self;
            }
        }
            break;
        case 1:
            [self presentViewController:[[GetMediaData shareGetMediaData] showImageController:NO] animated:YES completion:nil];
            [GetMediaData shareGetMediaData].getImageDelegate = self;
        default:
            break;
    }
}

#pragma mark - GetMediaData delegate
-(void)getImage:(UIImage *)imge imagePath:(NSString *)path
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSArray * array = [path componentsSeparatedByString:@"?"];
    NSString * name = [array objectAtIndex:0];
    if (array.count > 1) {
        name = [array objectAtIndex:1];
    }
    name = [name stringByReplacingOccurrencesOfString:@"id=" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];
    NSData *_data = UIImageJPEGRepresentation(imge, 0.001f);
    
    NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSDictionary * postParams = @{@"file":_encodedImageStr};
    [self changeHeaderImage:postParams];
}

-(void)changeHeaderImage :(NSDictionary *)postParams
{
    if ([self isNotNetwork]) {
        [SRMessage infoMessage:@"网络异常，请检查您的网络。" delegate:self];
        return;
    }
    [super showHUD];
    [_cloudClient requestMethodWithMod:@"member/upload"
                                params:nil
                            postParams:postParams
                              delegate:self
                              selector:@selector(changeHeaderImageSuccessed:)
                         errorSelector:@selector(changeHeaderImageError:)
                      progressSelector:nil];
    
}
-(void)changeHeaderImageSuccessed:(NSDictionary *)response
{
    [myInfo setImgUrl:[response objectForKey:@"imgUrl"]];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
    NSURL * url = [NSURL URLWithString:myInfo.imgUrl];
    [[MyInfoModel sharedInstance] setImgUrl:myInfo.imgUrl];
    [headerImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"header"]];
    [super hidenHUD];
}
-(void)changeHeaderImageError:(NSDictionary *)response
{
    [super hidenHUD];
}

#pragma mark - 修改昵称，性别，生日
-(void)myInfoLabelTap:(UIGestureRecognizer *)sender
{
    infoLabel = (UILabel *)sender.view;
    self.hidesBottomBarWhenPushed = YES;
    if (infoLabel.tag == 1 || infoLabel.tag == 4) {
              //1 修改昵称 4 注册账号
        ChangeNameViewController * changeNameVC = [[ChangeNameViewController alloc]init];
        changeNameVC.viewtag = infoLabel.tag-1;
        changeNameVC.accountNumber = [[CommClass sharedCommon] objectForKey:LOGGED_USERNAME];
        [self.navigationController pushViewController:changeNameVC animated:YES];
        if (infoLabel.tag == 1) {
            changeNameVC.accountNumber = myInfo.nickName;
              __weak __typeof (self) weakSelf = self;
            [changeNameVC setBackBlock:^(NSString *showText) {
                infoLabel.text = showText;
                [myInfo setNickName:showText];
                [[MyInfoModel sharedInstance] setNickName:myInfo.nickName];
                [nutPostParams setObject:showText forKey:@"nickName"];
                [weakSelf saveAction];
            }];
        }
        return;
    }
    if (infoLabel.tag == 2) {
        //修改性别
        RIButtonItem * girlItem = [RIButtonItem item];
        [girlItem setLabel:@"女"];
        girlItem.action = ^{
            if ([myInfo.sex isEqualToString:@"M"]) {
                [myInfo setSex:@"F"];
                infoLabel.text = @"女士";
                [nutPostParams setObject:myInfo.sex forKey:@"sex"];
            }
            [self saveAction];
        };
        RIButtonItem * boyItem = [RIButtonItem item];
        [boyItem setLabel:@"男"];
        boyItem.action = ^{
            if ([myInfo.sex isEqualToString:@"F"]) {
                infoLabel.text = @"男士";
                [myInfo setSex:@"M"];
                [nutPostParams setObject:myInfo.sex forKey:@"sex"];
            }
            [self saveAction];
        };
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"选择性别" message:nil cancelButtonItem:girlItem otherButtonItems:boyItem, nil];
        [alert show];

        return;
    }
    if (infoLabel.tag == 3) {
        //修改生日
        UIDatePicker * dataPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(15, 30, viewWidth-30, 225)];
        dataPicker.datePickerMode = UIDatePickerModeDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate * oldDate = [formatter dateFromString:infoLabel.text];
        [dataPicker setDate:oldDate];
        
        if (IOS8) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择日期" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                NSString * dateStr = [formatter stringFromDate:dataPicker.date];
                if ([myInfo.birthday isKindOfClass:[NSString class]]) {
                    if (![myInfo.birthday isEqualToString:dateStr]) {
                        [myInfo setBirthday:dateStr];
                        infoLabel.text = dateStr;
                        [nutPostParams setObject:myInfo.birthday forKey:@"birthday"];
                    }
                }else{
                    NSString * timeStr = [super subStringlostZero:myInfo.birthday];
                    timeStr = [self formatTimeStamp:timeStr timeFormat:@"yyyy-MM-dd"];
                    if (![timeStr isEqualToString:dateStr]) {
                        [myInfo setBirthday:dateStr];
                        infoLabel.text = dateStr;
                        [nutPostParams setObject:myInfo.birthday forKey:@"birthday"];
                    }
                }
                 [self saveAction];
            }];
            [alertController.view addSubview:dataPicker];
            [alertController addAction:cancelAction];
            [alertController addAction:sureAction];
            NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:dataPicker attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:alertController.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            
            constraint = [NSLayoutConstraint constraintWithItem:dataPicker attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:alertController.view.frame.size.width];
            [alertController.view addConstraint:constraint];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            RIButtonItem * cancelItem = [RIButtonItem item];
            [cancelItem setLabel:@"返回"];
            cancelItem.action = ^{};
            RIButtonItem * sureItem = [RIButtonItem item];
            [sureItem setLabel:@"确定"];
            sureItem.action = ^{
                NSString * dateStr = [formatter stringFromDate:dataPicker.date];
                if ([myInfo.birthday isKindOfClass:[NSString class]]) {
                    if (![myInfo.birthday isEqualToString:dateStr]) {
                        [myInfo setBirthday:dateStr];
                        infoLabel.text = dateStr;
                        [nutPostParams setObject:myInfo.birthday forKey:@"birthday"];
                    }
                }else{
                    NSString * timeStr = [super subStringlostZero:myInfo.birthday];
                    timeStr = [self formatTimeStamp:timeStr timeFormat:@"yyyy-MM-dd"];
                    if (![timeStr isEqualToString:dateStr]) {
                        [myInfo setBirthday:dateStr];
                        infoLabel.text = dateStr;
                        [nutPostParams setObject:myInfo.birthday forKey:@"birthday"];
                    }
                }
                 [self saveAction];
            };
            
            UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择日期\n\n\n\n\n\n\n\n\n\n\n\n\n" cancelButtonItem:cancelItem destructiveButtonItem:sureItem otherButtonItems:nil, nil];
            [actionSheet addSubview:dataPicker];
            [actionSheet showInView:self.view];
        }
        return;
    }
}



#pragma mark - 修改密码
/**
 *  显示弹框
 */
-(void)showChangePwdView
{
    self.myAlertView.layer.cornerRadius = 10;
    self.myAlertView.layer.shadowRadius = 7.5;
    self.myAlertView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myAlertView.layer.shadowOpacity = 0.5;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.ChangePwdView.frame = window.bounds;
    [window insertSubview:self.ChangePwdView atIndex:500];
}
/**
 *  取消，确定
 *
 *  @param sender
 */
- (IBAction)cancelOrOkAction:(UIButton *)sender {
    if (sender.tag == 1) {
        //确定
        if (![DataCheck isValidString:self.pwdTextFiled.text]) {
            [self alertMsg:@"请输入密码"];
            return;
        }
        if (self.pwdTextFiled.text.length < 6) {
            [self alertMsg:@"密码不能少于6位"];
            return;
        }
        [self checkOldPsw];
    }else{
       [self.ChangePwdView removeFromSuperview];
        self.pwdTextFiled.text = nil;
        [self.pwdTextFiled setPlaceholder:@"密码"];
    }
}

#pragma mark - textfiled delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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

    if (textField == self.pwdTextFiled) {
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

-(void)alertMsg:(NSString *)msg
{
    [self.ChangePwdView removeFromSuperview];
    [SRMessage infoMessage:msg delegate:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showChangePwdView];
    });
}
#pragma mark - 验证密码接口
/*
 修改密码事件
 */
-(void)checkOldPsw
{
    if ([self isNotNetwork]) {
        [self alertMsg:@"网络异常，稍后再试试。"];
        return;
    }
    NSDictionary * postparams=@{@"username":[[CommClass sharedCommon] objectForKey:LOGGED_USERNAME],
                                @"password":self.pwdTextFiled.text};//[super md5:[super md5:self.pwdTextFiled.text]]
    _cloudClient = [CloudClient getInstance];
    [_cloudClient requestMethodWithMod:@"member/checkPassword"
                                params:nil
                            postParams:postparams
                              delegate:self
                              selector:@selector(checkOldPswSecussed:)
                         errorSelector:@selector(checkOldPswError:)
                      progressSelector:nil];
}
/**验证成功*/
-(void)checkOldPswSecussed:(NSDictionary *)response
{
    [super hidenHUD];
    self.pwdTextFiled.text = nil;
    [self.ChangePwdView removeFromSuperview];
    ChangeNameViewController * changeNameVC = [[ChangeNameViewController alloc]init];
    changeNameVC.viewtag = 1;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeNameVC animated:YES];
}
/**验证失败*/
-(void)checkOldPswError:(NSDictionary *)response
{
    [super hidenHUD];
    if ([[response objectForKey:@"code"] integerValue] == CODE_LOGINFAIL) {
        [SRMessage loginInfoMessage:[response objectForKey:@"msg"] block:^{
            self.pwdTextFiled.text = nil;
            [self.ChangePwdView removeFromSuperview];
            [[AppModel sharedModel] presentLoginController:self];
        }];

    }else{
        self.pwdTextFiled.text = @"";
        self.pwdTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"密码错误,请重新输入" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    }
}


@end
