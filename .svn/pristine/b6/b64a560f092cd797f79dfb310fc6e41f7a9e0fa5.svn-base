
//
//  TempViewController.m
//  QRCode_Demo
//
//  Created by 沈红榜 on 15/11/17.
//  Copyright © 2015年 沈红榜. All rights reserved.
//

#import "TempViewController.h"
#import "SHBQRView.h"
#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GeneralShowWebView.h"
#define iPhone5ORiPhone5c ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface TempViewController ()<SHBQRViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    SHBQRView *qrView;
}
@end

@implementation TempViewController

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

-(void)dealloc
{
  [qrView stopScan];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
    self.navigationItem.rightBarButtonItem = [super createRightItem:self itemStr:@"相册" itemImage:nil itemImageHG:nil selector:@selector(rightBarItem)];
    
    qrView = [[SHBQRView alloc] initWithFrame:self.view.bounds];
    qrView.delegate = self;
    [qrView initView];
    [self.view addSubview:qrView];
    qrView.center = CGPointMake(self.view.center.x, qrView.center.y-50);
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, qrView.center.y+110+20, viewWidth, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"将二维码放入框内 , 即可自动扫描";
    [self.view insertSubview:label aboveSubview:qrView];
    label.center = CGPointMake(self.view.center.x, label.centerY);
}


- (void)qrView:(SHBQRView *)view ScanResult:(NSString *)result {
    [view stopScan];
      DLog(@"%@",[NSString stringWithFormat:@"扫描结果：%@", result]);
    if ([result isEqualToString:@"-400"]) {
         [SRMessage infoMessage:@"打开摄像头失败" delegate:self];
    }
    NSString * result1 = [result lowercaseString];
    if ([result1 hasPrefix:@"http://"] || [result1 hasPrefix:@"https://"]) {
        NSRange rang1 =[result1 rangeOfString:@".eqbangcdn.com"];
         NSRange rang2 =[result1 rangeOfString:@".eqbang.com"];
         NSRange rang3 =[result1 rangeOfString:@".eqbang.cn"];
        if (rang1.location != NSNotFound || rang2.location != NSNotFound || rang3.location != NSNotFound) {
            GeneralShowWebView * generalShowWebView = [[GeneralShowWebView alloc]init];
            generalShowWebView.advUrlLink = result;
            [self.navigationController pushViewController:generalShowWebView animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSMutableArray * viewControlers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [viewControlers removeObject:self];
                self.navigationController.viewControllers = [NSArray arrayWithArray:viewControlers];
            });
        }else{
          //非正确连接跳转系统默认的浏览器
            NSURL *url = [NSURL URLWithString:result];
            [[UIApplication sharedApplication] openURL:url];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }else{
//        [SRMessage infoMessage:@"请扫描二维码" delegate:self];
        [view startScan];
    }
}

-(void)rightBarItem
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = true;
    [self presentViewController:picker animated:true completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:true completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        if (!image) {
            image = info[UIImagePickerControllerOriginalImage];
        }
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        // kCIContextUseSoftwareRenderer : 软件渲染 -- 可以消除 "BSXPCMessage received error for message: Connection interrupted" 警告
        // kCIContextPriorityRequestLow : 低优先级在 GPU 渲染-- 设置为false可以加快图片处理速度
       
//
//        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        CIImage *ciImage = [CIImage imageWithData:imageData];
        [self stringFromCiImage:ciImage];
//        NSArray *ar = [detector featuresInImage:ciImage];
//        CIQRCodeFeature *feature = [ar firstObject];
//        NSLog(@"detector: %@", detector);
//        NSLog(@"context: %@", feature.messageString);
//        NSLog(@"%@",[NSString stringWithFormat:@"扫描结果：%@", feature.messageString ?: @"空"]);
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描结果：%@", feature.messageString ?: @"空"] preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:alert animated:true completion:nil];
        
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}
- (NSString *)stringFromCiImage:(CIImage *)ciimage {
    
    NSString *content = @"" ;
    
    
    
    if (!ciimage) {
        
        return content;
        
    }
    
    //     CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(true), kCIContextPriorityRequestLow : @(false)}];
    
    CIContext * context = [CIContext contextWithOptions:nil];
    if (iPhone5 || iPhone4) {
        [SRMessage infoMessage:@"iphone5/5c以上的设备才能识别二维码图片哦~" delegate:self];
        return content;
    }
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                            
                                              context:context
                            
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray *features = [detector featuresInImage:ciimage];
    
    if (features.count) {

        for (CIFeature *feature in features) {
            
            if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
                
                content = ((CIQRCodeFeature *)feature).messageString;
                DLog(@"%@",[NSString stringWithFormat:@"扫描结果：%@", content ?: @"空"]);
                NSRange rang1 =[content rangeOfString:@".eqbangcdn.com"];
                NSRange rang2 =[content rangeOfString:@".eqbang.com"];
                NSRange rang3 =[content rangeOfString:@".eqbang.cn"];
                if (rang1.location != NSNotFound || rang2.location != NSNotFound || rang3.location != NSNotFound) {
                    
                    GeneralShowWebView * generalShowWebView = [[GeneralShowWebView alloc]init];
                    generalShowWebView.advUrlLink = content;
                    [self.navigationController pushViewController:generalShowWebView animated:YES];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSMutableArray * viewControlers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                        [viewControlers removeObject:self];
                        self.navigationController.viewControllers = [NSArray arrayWithArray:viewControlers];
                    });
                }else{
                    //非正确连接跳转系统默认的浏览器
                    NSURL *url = [NSURL URLWithString:content];
                    [[UIApplication sharedApplication] openURL:url];
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }
                
                break;
                
            }
            
        }
        
    }
//    else {
//        [SRMessage infoMessage:@"iphone5/5c以上的设备才能识别二维码图片哦~" delegate:self];
//        
//    }
    
    return content;
    
}

@end
