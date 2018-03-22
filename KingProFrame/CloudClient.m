//
//  CloudClient.m
//  KingProFrame
//
//  Created by JinLiang on 15/7/22.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "CloudClient.h"
#import "BaseViewController.h"

@implementation CloudClient

+(CloudClient *)getInstance{
    CloudClient *client=[[CloudClient alloc]init];
    return client;
}

-(id)init{
    self=[super init];
    if (self) {
        self.requestClient=[[CloudClientRequest alloc]init];
        _requestClient.delegate=self;
        _requestClient.finishSelector=@selector(finish:errorInfo:);
        _requestClient.finishErrorSelector=@selector(finishError:errorInfo:);
        _requestClient.progressSelector=@selector(setProgress:newProgress:);
    }
    return self;
}

#pragma -mark cloudClientRequestDelegate

-(void)finish:(NSDictionary *)delegateInfo errorInfo:(NSDictionary *)result{
    id object =[delegateInfo objectForKey:@"delegate"];
    NSString *selectorName=[delegateInfo objectForKey:@"selector"];
    
    NSArray *parts=[selectorName componentsSeparatedByString:@":"];
    NSInteger count=[parts count];
    
    if (count==2) {
        
        [object performSelector:NSSelectorFromString(selectorName) withObject:result];
    }
    else if (count==3){
        [object performSelector:NSSelectorFromString(selectorName) withObject:result withObject:self];
    }
    else{
        return;
    }
    
}

-(void)finishError:(NSDictionary *)delegateInfo errorInfo:(NSDictionary *)errorInfo{

    id object =[delegateInfo objectForKey:@"delegate"];
    
    NSString *selectorName=[delegateInfo objectForKey:@"errorSelector"];
    
    NSArray *parts=[selectorName componentsSeparatedByString:@":"];
    NSInteger count=[parts count];
    
    if (count==2) {
        [object performSelector:NSSelectorFromString(selectorName) withObject:errorInfo];
    }
    else if (count==3) {
        [object performSelector:NSSelectorFromString(selectorName) withObject:errorInfo withObject:self];
    }
    else{
        return;
    }
    
}

-(void)setProgress:(NSDictionary *)delegateInfo newProgress:(NSDictionary *)newProgress{
    
    id object=[delegateInfo objectForKey:@"delegate"];
    
    NSString *selectorName=[delegateInfo objectForKey:@""];
    
    NSArray *parts=[selectorName componentsSeparatedByString:@":"];
    NSInteger count=[parts count];
    
    if (count==2) {
        [object performSelector:NSSelectorFromString(selectorName) withObject:newProgress];
    }
    else if(count==3){
        [object performSelector:NSSelectorFromString(selectorName) withObject:newProgress withObject:self];
    }
    else{
        return;
    }
}


//通用请求方法POST
-(void)requestMethodWithMod:(NSString *)mod
                     params:(NSDictionary *)params
                 postParams:(NSDictionary *)postParams
                   delegate:(id)delegate
                   selector:(SEL)selector
              errorSelector:(SEL)errorSelector
           progressSelector:(SEL)progressSelector{
    
    [_requestClient callMethodWithMod:mod
                           parameters:postParams
                             delegate:delegate
                              succeed:selector
                              failure:errorSelector
                     progressSelector:progressSelector
                        statusMessage:nil];
    
    
}

//通用请求方法GET
-(void)requestGETMethodWithMod:(NSString *)mod
                     params:(NSDictionary *)params
                 postParams:(NSDictionary *)postParams
                   delegate:(id)delegate
                   selector:(SEL)selector
              errorSelector:(SEL)errorSelector
           progressSelector:(SEL)progressSelector{
    
    [_requestClient callGETMethodWithMod:mod
                           parameters:postParams
                             delegate:delegate
                              succeed:selector
                              failure:errorSelector
                     progressSelector:progressSelector
                        statusMessage:nil];
    
    
}

@end
