//
//  CloudClient.h
//  KingProFrame
//
//  Created by JinLiang on 15/7/22.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudClientRequest.h"

@protocol CloudClientRequestDelegate;
@class CloudClientRequest;

@interface CloudClient : NSObject<CloudClientRequestDelegate>{

    
}
@property(nonatomic,retain)CloudClientRequest *requestClient;
@property(nonatomic,retain)NSDictionary *userInfo;

+ (CloudClient *)getInstance;



//通用请求方法POST
-(void)requestMethodWithMod:(NSString *)mod
                     params:(NSDictionary *)params
                 postParams:(NSDictionary *)postParams
                   delegate:(id)delegate
                   selector:(SEL)selector
              errorSelector:(SEL)errorSelector
           progressSelector:(SEL)progressSelector;

//通用请求方法GET
-(void)requestGETMethodWithMod:(NSString *)mod
                        params:(NSDictionary *)params
                    postParams:(NSDictionary *)postParams
                      delegate:(id)delegate
                      selector:(SEL)selector
                 errorSelector:(SEL)errorSelector
              progressSelector:(SEL)progressSelector;

@end
