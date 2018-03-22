//
//  CardView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "CardView.h"

@implementation CardView
@synthesize nameLabel, moneyLabel, goodImage;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
         [self initElementFrame];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // Corner Radius
    self.layer.cornerRadius = 10.0;
}

-(void)initElementFrame{
    
    goodImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    goodImage.layer.cornerRadius = 10.0;
    goodImage.clipsToBounds = YES;
    [self addSubview:goodImage];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 25, self.frame.size.width - 100, 15)];
    nameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:nameLabel];
    
    moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, nameLabel.frame.origin.y, 90, 15)];
    moneyLabel.font = [UIFont systemFontOfSize:13];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.textColor = [UIColor redColor];
    [self addSubview:moneyLabel];
}




@end
