//
//  GetMediaData.m
//  textPhoto
//
//  Created by macos on 14-4-21.
//  Copyright (c) 2014年 李华林. All rights reserved.
//

#import "GetMediaData.h"
#import "EditImage.h"
#import "Headers.h"
static GetMediaData *instance = nil;  //单例对象
static NSString * textString = nil;  //水印文字
static UIImage * textImage = nil;    //水印图片
@implementation GetMediaData

@synthesize getImageDelegate;

/************************************************************************************************
 函数名称 : + (SendHttpOperation *)shareSendHttpOperation
 函数描述 : 创建单例，在其他文件中可以直接类名加方法调用该类中方法
 输入参数 : 无
 返回    : 无
 备注    : 无
 ************************************************************************************************/
+ (GetMediaData *)shareGetMediaData
{
    if(!instance)
    {
        instance = [[GetMediaData alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [super dealloc];
    [instance release];
}
//调系统相册
//参数：camera:YES即调摄像头 NO调相册库
//返回：相机或相册库
- (UIImagePickerController *)showImageController:(BOOL)camera
{
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    
    if([UIImagePickerController isSourceTypeAvailable:camera?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        self.count = nil;
        //        UIModalTransitionStyleCoverVertical
        picker.delegate = self;
        picker.sourceType = camera?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.allowsEditing = YES;
    }
    return picker;
}
//调系统相册
//参数：camera:YES即调摄像头 NO调相册库 , text: nil无 反之即水印文字 ，image: nil无，反之即水印图片
//返回：相机或相册库
- (UIImagePickerController *)showImageController:(BOOL)camera text:(NSString *)text image:(UIImage *)image
{
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    if([UIImagePickerController isSourceTypeAvailable:camera?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.delegate = self;
        picker.sourceType = camera?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.allowsEditing =YES;
        textString=text;
        textImage=image;
    }
    return picker;
}

//回掉函数，并且返回获取的数据(系统)
/*
 * UIImagePickerControllerCropRect = "NSRect: {{0, 248}, {640, 640}}";
 * UIImagePickerControllerEditedImage = "<UIImage: 0x17dae000>";
 * UIImagePickerControllerMediaType = "public.image";
 * UIImagePickerControllerOriginalImage = "<UIImage: 0x19b28150>";
 * UIImagePickerControllerReferenceURL = "assets-library://asset/asset.PNG?id=DFDB07F7-C127-4221-A9FC-AEAA665B0832&ext=PNG";
 */
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSInteger total = [[self.count objectForKey:@"total"] integerValue];
    NSArray * imags = [self.count objectForKey:@"count"];
    if (imags !=nil && imags.count == total) {
        //[SRMessage infoMessage:[NSString stringWithFormat:@"最多可上传%ld张图片",total]];
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    NSString * path = [NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerReferenceURL]];
    UIImage *image= [info objectForKey:UIImagePickerControllerEditedImage];//UIImagePickerControllerOriginalImage
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //图片存入相册
        
        path = [NSString stringWithFormat:@"%@.png",[self formatTime]];
    }
    if (total != 10) {
        image = [EditImage imageWithImageSimple:image scaledToSize :CGSizeMake(584.0, 584.0/image.size.width*image.size.height)];
    }
    
    image = [EditImage editImage:image textStr:textString textImage:textImage];
    [getImageDelegate getImage:image imagePath:path];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)passImage:(UIImage *)image
{
    image = [EditImage imageWithImageSimple:image scaledToSize :CGSizeMake(584.0, 584.0/image.size.width*image.size.height)];
    UIImage * img = [EditImage editImage:image textStr:textString textImage:textImage];
    [getImageDelegate getImage:img imagePath:nil];
}

//时间转换成时间戳
-(NSString*)formatTime{
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    //时间转时间戳的方法:
    NSString *timeStamp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];
    //DLog(@"timeSp:%@",timeStamp); //时间戳的值
    
    return timeStamp;
}

@end
