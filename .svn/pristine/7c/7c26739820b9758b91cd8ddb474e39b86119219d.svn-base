//
//  CloudClientRequest.h
//  KingProFrame
//
//  Created by JinLiang on 15/7/22.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAppDotNetAPIClient.h"
#import "Headers.h"
#import "HTTPRequestPost.h"

@protocol CloudClientRequestDelegate;

@interface CloudClientRequest : NSObject{
    
    id<CloudClientRequestDelegate> _delegate;
    SEL finishSelector;
    SEL finishErrorSelector;
    SEL progressSelector;
    
}
@property (nonatomic,strong)id <CloudClientRequestDelegate> delegate;
@property (nonatomic) SEL finishSelector;
@property (nonatomic) SEL finishErrorSelector;
@property (nonatomic) SEL progressSelector;
@property (nonatomic,retain)AFAppDotNetAPIClient *AFAppDotNetClient;

-(NSString*)getRequestUrl:(NSString*)mod parameter:(NSDictionary *)jsonDic;

-(void)callMethodWithMod:(NSString *)mod
              parameters:(NSDictionary *)parameters
                delegate:(id)delegate
                 succeed:(SEL)succeedSel
                 failure:(SEL)errorSel
        progressSelector:(SEL)progressSel
           statusMessage:(NSString *)loadingMessage;

-(void)callGETMethodWithMod:(NSString *)mod
                 parameters:(NSDictionary *)parameters
                   delegate:(id)delegate
                    succeed:(SEL)succeedSel
                    failure:(SEL)errorSel
           progressSelector:(SEL)progressSel
              statusMessage:(NSString *)loadingMessage;


@end


#pragma -mark  CloudClientRequestDelegate

@protocol CloudClientRequestDelegate <NSObject>

- (void) finish:(NSArray *)delegateInfo errorInfo:(NSDictionary *)result;
- (void) finishError:(NSArray *)delegateInfo errorInfo:(NSDictionary *)errorInfo;
- (void) setProgress:(NSArray *)delegateInfo newProgress:(NSDictionary *)newProgress;

@end
