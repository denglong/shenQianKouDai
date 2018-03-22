//
//  RootViewController.m
//  QRCode_Demo
//
//  Created by 沈红榜 on 15/11/17.
//  Copyright © 2015年 沈红榜. All rights reserved.
//

#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RootViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) CIDetector *detector;

@end

@implementation RootViewController {
    AVCaptureSession *_session;
    
    UIImageView *_scanZomeBack;
    UIImageView *_lineView;
    
    UIImage     *_image;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    UIImage *hbImage = [UIImage imageNamed:@"scanscanBg"];
    _scanZomeBack = [[UIImageView alloc] initWithImage:hbImage];
    _scanZomeBack.backgroundColor = [UIColor clearColor];
    _scanZomeBack.layer.borderColor = [UIColor redColor].CGColor;
    _scanZomeBack.layer.borderWidth = 2;
    _scanZomeBack.frame = CGRectMake(width / 2 - 70, height / 2 - 70, 140, 140);
    [self.view addSubview:_scanZomeBack];
    
    // 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //闪光灯
    if ([device hasFlash] && [device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setFlashMode:AVCaptureFlashModeAuto];
        [device setTorchMode:AVCaptureTorchModeAuto];
        [device unlockForConfiguration];
    }
    
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 刷新线程
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    output.rectOfInterest = [self turnRect:_scanZomeBack.frame];
    
    // 初始化链接对象
    _session = [[AVCaptureSession alloc] init];
    
    //采集率
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    if (input) {
        [_session addInput:input];
    }
    
    if (output) {
        [_session addOutput:output];
        
        //设置扫码支持的编码格式
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [array addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [array addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [array addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [array addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes = array;
    }
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.bounds;
    [self.view.layer insertSublayer:layer above:0];
    
    [self.view bringSubviewToFront:_scanZomeBack];
    
    [self setOverView];
    
    [_session startRunning];
    [self loopDrawLine];
    
}

- (void)setOverView {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(_scanZomeBack.frame);
    CGFloat y = CGRectGetMinY(_scanZomeBack.frame);
    CGFloat w = CGRectGetWidth(_scanZomeBack.frame);
    CGFloat h = CGRectGetHeight(_scanZomeBack.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"相册" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 100, 100, 30);
    [btn addTarget:self action:@selector(turnTheLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor grayColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        NSLog(@"%@", metadataObject);
        [self scanResult:metadataObject.stringValue];
    }
}

- (void)loopDrawLine {
    CGFloat x = CGRectGetMinX(_scanZomeBack.frame);
    CGFloat y = CGRectGetMinY(_scanZomeBack.frame);
    CGFloat w = CGRectGetWidth(_scanZomeBack.frame);
    CGFloat h = CGRectGetHeight(_scanZomeBack.frame);
    
    CGRect start = CGRectMake(x, y, w, 2);
    CGRect end = CGRectMake(x, y + h - 2, w, 2);
    
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanLine"]];
        _lineView.frame = start;
        [self.view addSubview:_lineView];
    } else {
        _lineView.frame = start;
    }
    
    [UIView animateWithDuration:2 animations:^{
        _lineView.frame = end;
    } completion:^(BOOL finished) {
        [self loopDrawLine];
    }];
    
}

- (CGRect)turnRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}

- (void)scanResult:(NSString *)result {
    [_session stopRunning];
    NSString *title = [NSString stringWithFormat:@"扫描结果：%@", result];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_session startRunning];
    }]];
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)turnTheLight:(UIButton *)btn {
    

    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.mediaTypes = @[@"kUTTypeImage"];
    picker.allowsEditing = true;
    picker.delegate = self;
    [self presentViewController:picker animated:true completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    _image = info[UIImagePickerControllerEditedImage];
//    CIImage *tempImage = [CIImage imageWithCGImage:image.CGImage];

//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIDetector *te = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
//    NSArray *array = [te featuresInImage:tempImage];
    
    
    
    [picker dismissViewControllerAnimated:true completion:^{
        [self kkImage:_image];
    }];
}

- (void)kkImage:(UIImage *)image {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:nil];
    NSArray *array = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    CIQRCodeFeature *feature = [array firstObject];
    NSString *result = feature.messageString;
        
    NSLog(@"%@", result);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
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

@end
