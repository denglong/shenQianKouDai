//
//  DLCollectionView.m
//  myTest
//
//  Created by denglong on 12/24/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import "DLCollectionView.h"
#import "Headers.h"

#define COLLOCATIONCOLOR [UIColor whiteColor]

@implementation DLCollectionView
@synthesize pinsModel, pins;

- (UIView *)createWithCollectionView:(NSArray *)viewList height:(NSInteger)height width:(NSInteger)width {
    if (pins.count == 4) {
        height = height/2;
    }
    for (NSInteger i = 0; i < pins.count; i ++) {
        if (pins.count == 2 || pins.count == 4) {
            int j,x = i%2;
            if (i == 2 || i == 3) {
                j = 1;
            }
            else
            {
                j = 0;
            }
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x*(width/2 + 1), 0.5 + (height + 1)*j, width/2, height - j*0.5)];
            view.backgroundColor = COLLOCATIONCOLOR;
            
            pinsModel = pins[i];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height, 0, view.frame.size.height, view.frame.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            NSString *str = [NSString stringWithFormat:@"%@", pinsModel.advPic];
            [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:UIIMAGE(@"home_pin")];
            [view addSubview:imageView];
            
            [self createLabelAction:pinsModel.advName strColor:pinsModel.color shopName:pinsModel.content view:view];
            
            UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            clickBtn.tag = i;
            [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:clickBtn];
            
            [self addSubview:view];
        }
        
        if (pins.count == 3) {
            
            switch (i) {
                case 0:
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, width/2, height - 0.5)];
                    view.backgroundColor = COLLOCATIONCOLOR;
                    
                    pinsModel = pins[0];
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height, height/2 - 20, view.frame.size.height/2, view.frame.size.height/2)];
                    imageView.center = CGPointMake(view.center.x, imageView.center.y);
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    NSString *str = [NSString stringWithFormat:@"%@", pinsModel.advPic];
                    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:UIIMAGE(@"home_pin")];
                    [view addSubview:imageView];
                    
                    [self createLabelFirstAction:pinsModel.advName strColor:pinsModel.color shopName:pinsModel.content view:view];
                    
                    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                    clickBtn.tag = i;
                    [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:clickBtn];
                    
                    [self addSubview:view];
                }
                    break;
                case 1:
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width/2 + 1, 0.5, width/2 + 0.5, height/2 - 0.5)];
                    view.backgroundColor = COLLOCATIONCOLOR;
                    
                    pinsModel = pins[1];
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height, 0, view.frame.size.height, view.frame.size.height)];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    NSString *str = [NSString stringWithFormat:@"%@", pinsModel.advPic];
                    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:UIIMAGE(@"home_pin")];
                    [view addSubview:imageView];
                    
                    [self createLabelAction:pinsModel.advName strColor:pinsModel.color shopName:pinsModel.content view:view];
                    
                    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                    clickBtn.tag = i;
                    [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:clickBtn];
                    
                    [self addSubview:view];
                }
                    break;
                case 2:
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width/2 + 1, height/2 + 1, width/2 + 0.5, height/2)];
                    view.backgroundColor = COLLOCATIONCOLOR;
                    
                    pinsModel = pins[2];
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height, 0, view.frame.size.height, view.frame.size.height)];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    NSString *str = [NSString stringWithFormat:@"%@", pinsModel.advPic];
                    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:UIIMAGE(@"home_pin")];
                    [view addSubview:imageView];
                    
                    [self createLabelAction:pinsModel.advName strColor:pinsModel.color shopName:pinsModel.content view:view];
                    
                    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                    clickBtn.tag = i;
                    [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:clickBtn];
                    
                    [self addSubview:view];
                }
                    break;
                default:
                    break;
            }
            
        }
        
        if (pins.count == 5) {
            switch (i) {
                case 0:
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, width/2, height/3 * 2 - 0.5)];
                    view.backgroundColor = COLLOCATIONCOLOR;
                    
                    pinsModel = pins[0];
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height, height/3 - 20, view.frame.size.height/2, view.frame.size.height/2)];
                    imageView.center = CGPointMake(view.center.x, imageView.center.y);
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    NSString *str = [NSString stringWithFormat:@"%@", pinsModel.advPic];
                    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:UIIMAGE(@"home_pin")];
                    [view addSubview:imageView];
                    
                    [self createLabelFirstAction:pinsModel.advName strColor:pinsModel.color shopName:pinsModel.content view:view];
                    
                    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                    clickBtn.tag = i;
                    [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:clickBtn];
                    
                    [self addSubview:view];
                }
                    break;
                    
                case 1:
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width/2 + 1, 0.5, width/2 + 0.5, height/3 - 1)];
                    view.backgroundColor = COLLOCATIONCOLOR;
                    
                    pinsModel = pins[1];
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height, 0, view.frame.size.height, view.frame.size.height)];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    NSString *str = [NSString stringWithFormat:@"%@", pinsModel.advPic];
                    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:UIIMAGE(@"home_pin")];
                    [view addSubview:imageView];
                    
                    [self createLabelAction:pinsModel.advName strColor:pinsModel.color shopName:pinsModel.content view:view];
                    
                    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                    clickBtn.tag = i;
                    [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:clickBtn];
                    
                    [self addSubview:view];
                }
                    break;
                case 2:
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width/2 + 1, height/3 + 0.5, width/2 + 0.5, height/3)];
                    view.backgroundColor = COLLOCATIONCOLOR;
                    
                    pinsModel = pins[2];
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height, 0, view.frame.size.height, view.frame.size.height)];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    NSString *str = [NSString stringWithFormat:@"%@", pinsModel.advPic];
                    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:UIIMAGE(@"home_pin")];
                    [view addSubview:imageView];
                    
                    [self createLabelAction:pinsModel.advName strColor:pinsModel.color shopName:pinsModel.content view:view];
                    
                    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                    clickBtn.tag = i;
                    [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:clickBtn];
                    
                    [self addSubview:view];
                }
                    break;
                case 3:
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height/3 * 2 + 1.5, width/2, height/3 + 1)];
                    view.backgroundColor = COLLOCATIONCOLOR;
                    
                    pinsModel = pins[3];
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height, 0, view.frame.size.height, view.frame.size.height)];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    NSString *str = [NSString stringWithFormat:@"%@", pinsModel.advPic];
                    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:UIIMAGE(@"home_pin")];
                    [view addSubview:imageView];
                    
                    [self createLabelAction:pinsModel.advName strColor:pinsModel.color shopName:pinsModel.content view:view];
                    
                    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                    clickBtn.tag = i;
                    [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:clickBtn];
                    
                    [self addSubview:view];
                }
                    break;
                case 4:
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width/2 + 1, height/3 * 2 + 1.5, width/2 + 0.5, height/3 + 1)];
                    view.backgroundColor = COLLOCATIONCOLOR;
                    
                    pinsModel = pins[4];
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height, 0, view.frame.size.height, view.frame.size.height)];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    NSString *str = [NSString stringWithFormat:@"%@", pinsModel.advPic];
                    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:UIIMAGE(@"home_pin")];
                    [view addSubview:imageView];
                    
                    [self createLabelAction:pinsModel.advName strColor:pinsModel.color shopName:pinsModel.content view:view];
                    
                    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                    clickBtn.tag = i;
                    [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:clickBtn];
                    
                    [self addSubview:view];
                }
                    break;
                default:
                    break;
            }
        }
    }
    self.backgroundColor = [UIColor_HEX colorWithHexString:@"#eeeeee"];
    return self;
}

- (void)createLabelAction:(NSString *)name strColor:(NSString *)color shopName:(NSString *)shopName view:(UIView *)myView{
    for (NSInteger i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(11, 10 + i * 20, myView.frame.size.width - 22, 13 - i * 1)];
        if (i == 0) {
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor_HEX colorWithHexString:color];
            label.text = name;
        }
        
        if (i == 1) {
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor_HEX colorWithHexString:@"#666666"];
            label.text = shopName;
        }
        
        [myView addSubview:label];
    }
}

- (void)createLabelFirstAction:(NSString *)name strColor:(NSString *)color shopName:(NSString *)shopName view:(UIView *)myView{
    for (NSInteger i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + i * 20, myView.frame.size.width - 20, 13 - i * 1)];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor_HEX colorWithHexString:color];
            label.text = name;
        }
        if (i == 1) {
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor_HEX colorWithHexString:@"#666666"];
            label.text = shopName;
        }
        
        [myView addSubview:label];
    }
}

- (void)clickBtnAction:(UIButton *)sender {
    [self.delegate collectionClickBtnAction:sender.tag];
}


@end
