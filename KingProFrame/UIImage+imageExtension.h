//
//  UIImage+imageExtension.h
//  KingProFrame
//
//  Created by eqbang on 15/11/13.
//  Copyright © 2015年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (imageExtension)

+(instancetype) originalImageWithimageName:(NSString *)imageName;

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


@end
