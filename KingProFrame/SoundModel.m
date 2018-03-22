//
//  SoundModel.m
//  KingProFrame
//
//  Created by denglong on 1/7/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "SoundModel.h"

@implementation SoundModel
@synthesize client;

//初始化单例
+ (SoundModel *)shareSoundModel
{
    static SoundModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)setSoundApiData:(NSString *)orderNo from:(NSString *)from{
    client=[CloudClient getInstance];
    if (![DataCheck isValidString:orderNo]) {
        return;
    }
    
    [client requestMethodWithMod:@"monitor/voice"
                           params:nil
                      postParams:@{@"orderNo":orderNo, @"from":from}
                         delegate:self
                         selector:@selector(setSoundDataSuccess:)
                    errorSelector:@selector(setSoundDataFail:)
                 progressSelector:nil];
}

- (void)setSoundDataSuccess:(NSDictionary *)response {
    
}

- (void)setSoundDataFail:(NSDictionary *)response {
    
}

@end
