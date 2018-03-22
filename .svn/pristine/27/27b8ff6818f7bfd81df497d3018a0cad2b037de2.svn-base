//
//  GetMutiMediaData.h
//  SixFeetLanePro
//
//  Created by lihualin on 14-12-10.
//  Copyright (c) 2014年 QCSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
@protocol GetMutiImageProtocol <NSObject>

@optional

- (void)getImages:(NSArray *)images;

@end

@interface GetMutiMediaData : UIViewController<QBImagePickerControllerDelegate>
@property(nonatomic, assign) id<GetMutiImageProtocol> getImageDelegate;
@property(nonatomic, assign) NSInteger count;
+ (GetMutiMediaData *)shareGetMediaData;
-(QBImagePickerController *)showQBImagePickerController;
-(QBImagePickerController *)showQBImagePickerController :(NSString *)text image:(UIImage *)image;
@end
