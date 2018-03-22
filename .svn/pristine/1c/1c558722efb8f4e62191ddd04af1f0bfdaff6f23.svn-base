//
//  GetMediaData.h
//  textPhoto
//
//  Created by macos on 14-4-21.
//  Copyright (c) 2014年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CaptureViewController.h"
@protocol GetImageProtocol <NSObject>

- (void)getImage:(UIImage *)image imagePath:(NSString *)path;

@end


@interface GetMediaData : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PassImageDelegate>

@property(nonatomic, assign) id<GetImageProtocol> getImageDelegate;
@property(nonatomic ,retain) NSDictionary * count;

+ (GetMediaData *)shareGetMediaData;

- (UIImagePickerController *)showImageController:(BOOL)camera;
- (UIImagePickerController *)showImageController:(BOOL)camera text:(NSString *)text image:(UIImage *)image;
@end
