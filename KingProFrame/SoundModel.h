//
//  SoundModel.h
//  KingProFrame
//
//  Created by denglong on 1/7/16.
//  Copyright © 2016 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudClient.h"

@interface SoundModel : NSObject
@property (nonatomic, retain) CloudClient *client;

+(id)shareSoundModel;
- (void)setSoundApiData:(NSString *)orderNo from:(NSString *)from;

@end
