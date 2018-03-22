//
//  HTTPRequestPost.m
//  HTTPRequest
//
//  Created by kn on 15/04/19.
//  Copyright (c) 2015年 kn. All rights reserved.
//

#import "HTTPRequestPost.h"
#import "MacroDefinitions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HTTPRequestPost

-(id)init
{
    self=[super init];
    if(self)
    {
        self.AFAppDotNetClient=[[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:CLOUD_API_URL]];
        DLog(@"%@",CLOUD_API_URL);
    }
    return self;
}

/**
 *  普通的网络请求
 *
 *  @param url        请求链接
 *  @param postParam  请求参数
 *  @param block      成功回掉
 *  @param blockError 失败回掉
 */
+(void)hTTPRequest_PostpostBody:(id)parameters andUrl:(NSString *)url andSucceed:(Succeed)succeed andFailure:(Failure)failure andStatusMessage:(NSString *)loadingMessage;
{
    
    DLog(@"%@",parameters);
    
    HTTPRequestPost *httpRequestPost=[[HTTPRequestPost alloc] init];
    
    [httpRequestPost setconManagefiguration];
    
    if(loadingMessage)
    {
        //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        //[SVProgressHUD setStatus:loadingMessage];
    }
    
    [httpRequestPost.AFAppDotNetClient POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
        //[SVProgressHUD dismiss];
        //[CustomeAlertView showStatus:@"网络异常"];
    }];
    
}
/**
 *  上传图片
 *
 *  @param url        请求链接
 *  @param postParam  请求参数
 *  @param block      成功回掉
 *  @param blockError 失败回掉
 */
+(void)hTTPRequest_ImageWithUrl:(NSString *)url postParam:(NSDictionary *)postParam image:(NSString *)imageName success:(Succeed)block error:(Failure)blockError;
{
    HTTPRequestPost *httpRequestPost=[[HTTPRequestPost alloc] init];
    
    [httpRequestPost setconManagefiguration];
    
    [httpRequestPost requestWithUrl:url withImage:imageName fileName:nil postParam:postParam Block:block Error:blockError];
}

/**
 *  上传文件
 *
 *  @param url        请求链接
 *  @param postParam  请求参数
 *  @param block      成功回掉
 *  @param blockError 失败回掉
 */
+(void) requestUpdataFileWithUrl:(NSString *)url postParam:(NSDictionary *)postParam file:(NSString *)fileName success:(Succeed)block error:(Failure)blockError;
{
    HTTPRequestPost *httpRequestPost=[[HTTPRequestPost alloc] init];
    
    
    [httpRequestPost requestWithUrl:url withImage:nil fileName:fileName postParam:postParam Block:block Error:blockError];
}

-(void)requestWithUrl:(NSString *)url withImage:(NSString *)imageName  fileName:(NSString *)fileName  postParam:(NSDictionary *) postParam Block:(Succeed)block Error:(Failure)blockError
{
    if(IOS7_OR_LATER)
    {
        /**
         *  上传图片
         */
        dispatch_queue_t urls_queue = dispatch_queue_create("blog.devtang.com", NULL);
        dispatch_async(urls_queue, ^{
            
            if (imageName) {
                UIImage *imageNew = [UIImage imageWithContentsOfFile:imageName];
//                UIImage *imageNew = [UIImage imageNamed:imageName];
                //设置image的尺寸
                NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.2);
                
                [self.AFAppDotNetClient POST:url parameters:postParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    //upload
                    [formData appendPartWithFileData :imageData name:@"upload" fileName:imageName mimeType:@"image/jpeg"];
                } success:^(NSURLSessionDataTask *task, id responseObject) {
                    block(task,responseObject);
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    blockError(task,error);
                    
                }];
    
                return;
            }
        });
        
        /**
         *  上传文件
         */
        if (fileName) {
            NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
            
            NSURLSessionUploadTask *uploadTask = [self.AFAppDotNetClient uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                
            }];
            
            [AFAppDotNetAPIClient sharedClient];
            
            
            [uploadTask resume];
            return;
        }
    }
}

#pragma mark------------------------------------配置------------------------------------------------------
/**
 *  AFHTTPSessionManager 配置
 */
-(void)setconManagefiguration
{

    
    self.AFAppDotNetClient.requestSerializer = [AFJSONRequestSerializer serializer];
    
    self.AFAppDotNetClient.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.AFAppDotNetClient.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    
    [self.AFAppDotNetClient.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    
    [self.AFAppDotNetClient.requestSerializer setTimeoutInterval:10];
    
}
#pragma MD5加密
+ (NSString *)md5:(NSString *)str

{
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result);
    
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ]; 
    
}
@end
