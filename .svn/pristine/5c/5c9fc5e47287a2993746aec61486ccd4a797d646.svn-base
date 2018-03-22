//
//  GetMutiMediaData.m
//  SixFeetLanePro
//
//  Created by lihualin on 14-12-10.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import "GetMutiMediaData.h"
#import "EditImage.h"
static GetMutiMediaData *instance = nil;  //单例对象
static NSString * textString = nil;  //水印文字
static UIImage * textImage = nil;    //水印图片
@interface GetMutiMediaData ()

@end

@implementation GetMutiMediaData
@synthesize getImageDelegate;
/************************************************************************************************
 函数名称 : + (SendHttpOperation *)shareSendHttpOperation
 函数描述 : 创建单例，在其他文件中可以直接类名加方法调用该类中方法
 输入参数 : 无
 返回    : 无
 备注    : 无
 ************************************************************************************************/
+ (GetMutiMediaData *)shareGetMediaData
{
    if(!instance)
    {
        instance = [[GetMutiMediaData alloc] init];
    }
    return instance;
}

//调相册库（第三方）
//参数：无
//返回：相册库
-(QBImagePickerController *)showQBImagePickerController
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    return imagePickerController;
}

//调相册库（第三方）
//参数：text: nil无 反之即水印文字 ，image: nil无，反之即水印图片
//返回：相册库
-(QBImagePickerController *)showQBImagePickerController:(NSString *)text image:(UIImage *)image
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init] ;
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    textString=text;
    textImage=image;
    return imagePickerController;
}
//回掉函数，并且返回获取的数据(第三方)
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    NSMutableArray *imageAray=[[NSMutableArray alloc]init];
    if(imagePickerController.allowsMultipleSelection) {
        NSArray *mediaInfoArray = (NSArray *)info;
        
        for (int i=0; i<mediaInfoArray.count; i ++) {
            ALAsset *asset = [mediaInfoArray objectAtIndex:i];
            //获取到媒体的类型
            NSString *type = [asset valueForKey:UIImagePickerControllerMediaType];
            if ([type isEqualToString:ALAssetTypePhoto]) {
                UIImage *image= [asset valueForKey:UIImagePickerControllerOriginalImage];
                if (self.count != 10) {
                    if (image.size.width> image.size.height) {
                        image = [EditImage imageWithImageSimple:image scaledToSize :CGSizeMake(584.0, 584.0/image.size.width*image.size.height)];
                    }else if(image.size.width < image.size.height){
                        image = [EditImage imageWithImageSimple:image scaledToSize :CGSizeMake(584.0, 584.0/image.size.width*image.size.height)];
                    }else{
                        image = [EditImage imageWithImageSimple:image scaledToSize :CGSizeMake(584.0, 584.0)];
                    }
  
                }
                image = [EditImage editImage:image textStr:textString textImage:textImage];
                [imageAray addObject:image];
            }
        }
        [getImageDelegate getImages:imageAray];
        DLog(@"Selected %ld photos", (unsigned long)mediaInfoArray.count);
    } else {
        NSDictionary *mediaInfo = (NSDictionary *)info;
        //获取到媒体的类型
        NSString *type = [mediaInfo valueForKey:@"UIImagePickerControllerMediaType"];
        if ([type isEqualToString:ALAssetTypePhoto]) {
            UIImage *image= [mediaInfo valueForKey:UIImagePickerControllerOriginalImage];
            if (self.count != 10) {
                if (image.size.width> image.size.height) {
                    image = [EditImage imageWithImageSimple:image scaledToSize :CGSizeMake(584.0,584.0/image.size.width*image.size.height)];
                }else if(image.size.width <image.size.height){
                    image = [EditImage imageWithImageSimple:image scaledToSize :CGSizeMake(584.0, 584.0/image.size.width*image.size.height)];
                }else{
                    image = [EditImage imageWithImageSimple:image scaledToSize :CGSizeMake(584.0, 584.0)];
                }
 
            }
            image = [EditImage editImage:image textStr:textString textImage:textImage];
            
            [imageAray addObject:image];
        }
        [getImageDelegate getImages:imageAray];
        DLog(@"Selected: %@", mediaInfo);
    }
}
//回掉函数，并且退出相册(第三方)
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    DLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//回掉函数，并且解除全选(第三方)
- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"全选";
}
//回掉函数，并且全选(第三方)
- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"解除全选";
}
//回掉函数，并且返回相册图片总数(第三方)
- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"共%ld张图片", (unsigned long)numberOfPhotos];
}

@end
