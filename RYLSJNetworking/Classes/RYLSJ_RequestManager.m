//
//  RYLSJ_RequestManager.m
//  RYLSJNetworking_Example
//
//  Created by SM-JS-Wangrunya-PC on 0725.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import "RYLSJ_RequestManager.h"
#import "RYLSJ_CacheManager.h"
#import "RYLSJ_URLRequest.h"
#import "NSString+RYLSJ_UTF8Encoding.h"

@implementation RYLSJ_RequestManager
#pragma mark - 配置请求
+ (void)requestWithConfig:(requestConfig)config success:(requestSuccess)success failure:(requestFailure)failure{
    [self requestWithConfig:config progress:nil success:success failure:failure];
}

+ (void)requestWithConfig:(requestConfig)config progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure {
    RYLSJ_URLRequest *request=[[RYLSJ_URLRequest alloc]init];
    config ? config(request) : nil;
    [self sendRequest:request progress:progress success:success failure:failure];
}

+ (RYLSJ_BatchRequest *)sendBatchRequest:(batchRequestConfig)config success:(requestSuccess)success failure:(requestFailure)failure{
    return [self sendBatchRequest:config progress:nil success:success failure:failure];
}

+ (RYLSJ_BatchRequest *)sendBatchRequest:(batchRequestConfig)config progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    RYLSJ_BatchRequest *batchRequest=[[RYLSJ_BatchRequest alloc]init];
    config ? config(batchRequest) : nil;
    
    if (batchRequest.urlArray.count==0)return nil;
    [batchRequest.urlArray enumerateObjectsUsingBlock:^(RYLSJ_URLRequest *request , NSUInteger idx, BOOL *stop) {
        [self sendRequest:request progress:progress success:success failure:failure];
    }];
    return batchRequest;
}
#pragma mark - 发起请求
+ (void)sendRequest:(RYLSJ_URLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    
    if([request.URLString isEqualToString:@""]||request.URLString==nil)return;
    
    if (request.methodType==RYLSJ_MethodTypeUpload) {
        [self sendUploadRequest:request progress:progress success:success failure:failure];
    }else if (request.methodType==RYLSJ_MethodTypeDownLoad){
        [self sendDownLoadRequest:request progress:progress success:success failure:failure];
    }else{
        [self sendHTTPRequest:request progress:progress success:success failure:failure];
    }
}

+ (void)sendUploadRequest:(RYLSJ_URLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    [[RYLSJ_RequestEngine defaultEngine] uploadWithRequest:request rylsj_progress:progress success:^(NSURLSessionDataTask *task, id responseObject) {
        success ? success(responseObject,0,NO) : nil;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure ? failure(error) : nil;
    }];
}

+ (void)sendDownLoadRequest:(RYLSJ_URLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    [[RYLSJ_RequestEngine defaultEngine] downloadWithRequest:request progress:progress completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        failure ? failure(error) : nil;
        success ? success([filePath path],request.apiType,NO) : nil;
    }];
}

+ (void)sendHTTPRequest:(RYLSJ_URLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    NSString *key = [self keyWithParameters:request];
    if ([[RYLSJ_CacheManager sharedInstance]diskCacheExistsWithKey:key]&&request.apiType!=RYLSJ_RequestTypeRefresh&&request.apiType!=RYLSJ_RequestTypeRefreshMore){
        [[RYLSJ_CacheManager sharedInstance]getCacheDataForKey:key value:^(NSData *data,NSString *filePath) {
            id result=[self responsetSerializerConfig:request responseObject:data];
            success ? success(result ,request.apiType,YES) : nil;
        }];
    }else{
        [self dataTaskWithHTTPRequest:request progress:progress success:success failure:failure];
    }
}

+ (void)dataTaskWithHTTPRequest:(RYLSJ_URLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    
    [[RYLSJ_RequestEngine defaultEngine]dataTaskWithMethod:request rylsj_progress:^(NSProgress * _Nonnull rylsj_progress) {
        progress ? progress(rylsj_progress) : nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self storeObject:responseObject request:request];
        id result=[self responsetSerializerConfig:request responseObject:responseObject];
        success ? success(result,request.apiType,NO) : nil;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure ? failure(error) : nil;
    }];
}

#pragma mark - 其他配置
+ (NSString *)keyWithParameters:(RYLSJ_URLRequest *)request{
    if (request.parametersfiltrationCacheKey.count>0) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:request.parameters];
        [mutableParameters removeObjectsForKeys:request.parametersfiltrationCacheKey];
        request.parameters =  [mutableParameters copy];
    }
    NSString *URLStringCacheKey;
    if (request.customCacheKey) {
        URLStringCacheKey=request.customCacheKey;
    }else{
        URLStringCacheKey=request.URLString;
    }
    return [NSString rylsj_stringUTF8Encoding:[NSString rylsj_urlString:URLStringCacheKey appendingParameters:request.parameters]];
}

+ (void)storeObject:(NSObject *)object request:(RYLSJ_URLRequest *)request{
    NSString * key= [self keyWithParameters:request];
    [[RYLSJ_CacheManager sharedInstance] storeContent:object forKey:key isSuccess:^(BOOL isSuccess) {
        if (isSuccess) {
            RYLSJ_Log(@"store successful");
        }else{
            RYLSJ_Log(@"store failure");
        }
    }];
}

+ (id)responsetSerializerConfig:(RYLSJ_URLRequest *)request responseObject:(id)responseObject{
    if (request.responseSerializer==RYLSJ_HTTPResponseSerializer) {
        return responseObject;
    }else{
        NSError *serializationError = nil;
        NSData *data = (NSData *)responseObject;
        // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
        // See https://github.com/rails/rails/issues/1742
        BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
        if (data.length > 0 && !isSpace) {
            id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
            return result;
        } else {
            return nil;
        }
    }
}

+ (void)cancelRequest:(NSString *)URLString completion:(cancelCompletedBlock)completion{
    if([URLString isEqualToString:@""]||URLString==nil)return;
    [[RYLSJ_RequestEngine defaultEngine]cancelRequest:URLString completion:completion];
}

@end
