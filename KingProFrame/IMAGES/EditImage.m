//
//  EditImage.m
//  SixFeetLanePro
//
//  Created by lihualin on 14-12-10.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import "EditImage.h"

#import "GetFilePath.h"
@implementation EditImage

+(UIImage *)editImage:(UIImage *)image textStr:(NSString *)textString textImage:(UIImage *)textImage
{
    //添加水印
    if (textString != nil) {
        image=[self addText:image text:textString];
    }
    if (textImage != nil) {
        image = [self addImage:image addImage1:textImage];
    }
    return image;
}



//对图片进行压缩 否则图片可能过大
//参数: 图片  压缩后的大小
//返回: 处理后的图片

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - 保存图片至沙盒
//参数 ： 图片数组
+ (NSArray *) saveImage:(NSArray *)images :(UIImage *)image
{
    NSMutableDictionary * dic=nil;
    NSMutableArray * array=[[NSMutableArray alloc]init];
    for (int i =0; i<images.count; i++) {
        UIImage *currentImage=[images objectAtIndex:i];
        dic=[self getImagePath:currentImage index:i];
        [array addObject:dic];
    }
    return array;
}

+(NSMutableDictionary *) getImagePath : (UIImage *)currentImage index:(NSInteger)index
{
 NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSData *imageData;
    if (UIImagePNGRepresentation(currentImage)) {
        imageData=UIImagePNGRepresentation(currentImage); //获取图片数据
    }else{
        imageData=UIImageJPEGRepresentation(currentImage, 1.0); //获取图片数据
    }
    //获取存取路径，并写入
    NSString *filePath=[[GetFilePath getFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"image%ld%@",(long)index,@".png"]];
    NSArray *nameArray=[filePath componentsSeparatedByString:@"/"];
    NSString *fileName=[nameArray objectAtIndex:[nameArray count]-1];
    [imageData writeToFile:filePath atomically:NO];
    [dic setObject:filePath forKey:fileName];
    return dic;
}
//加水印文字
//需添加水印文字的图片 以及要添加的水印文字
//返回 ： 处理后的图片

+(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    //中文水印
    UIGraphicsBeginImageContext(img.size);
    [[UIColor redColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20],NSFontAttributeName,[UIColor redColor],NSForegroundColorAttributeName,paragraphStyle,NSParagraphStyleAttributeName,nil];
    [text1 drawInRect:CGRectMake(0, h-40, w, 40) withAttributes:attributeDic];
    UIImage * aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}
//加水印图片
//需添加水印文字的图片 以及要添加的水印图片
//返回 ： 处理后的图片
+(UIImage *)addImageLogo:(UIImage *)img text:(UIImage *)logo
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    int logoWidth = logo.size.width;
    int logoHeight = logo.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake(w-logoWidth, 0, logoWidth, logoHeight), [logo CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage * image = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return image;
    
    //  CGContextDrawImage(contextRef, CGRectMake(100, 50, 200, 80), [smallImg CGImage]);
}

//3.加半透明的水印
//需添加水印文字的图片 以及要添加的水印图片
//返回 ： 处理后的图片
+ (UIImage *)addImage:(UIImage *)useImage addImage1:(UIImage *)addImage1
{
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    [addImage1 drawInRect:CGRectMake(0, useImage.size.height-addImage1.size.height, addImage1.size.width, addImage1.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
