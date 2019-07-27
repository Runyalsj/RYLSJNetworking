//
//  RYLSJ_RequestEngine.h
//  RYLSJNetworking_Example
//
//  Created by tutu on 2019/7/27.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "RYLSJ_RequestConst.h"
#import "RYLSJ_URLRequest.h"
NS_ASSUME_NONNULL_BEGIN
/*
 硬性设置：
 1.服务器返回的数据 必须是二进制
 2.证书设置
 3.开启菊花
 */
@interface RYLSJ_RequestEngine : AFHTTPSessionManager
+ (instancetype)defaultEngine;

/**
 发起网络请求
 
 @param request RYLSJ_URLRequest
 @param rylsj_progress 进度
 @param success 成功回调
 @param failure 失败回调
 @return task
 */
- (NSURLSessionDataTask *)dataTaskWithMethod:(RYLSJ_URLRequest *)request
                                 rylsj_progress:(void (^)(NSProgress * _Nonnull))rylsj_progress
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 上传文件
 
 @param request RYLSJ_URLRequest
 @param rylsj_progress 进度
 @param success 成功回调
 @param failure 失败回调
 @return task
 */
- (NSURLSessionDataTask *)uploadWithRequest:(RYLSJ_URLRequest *)request
                                rylsj_progress:(void (^)(NSProgress * _Nonnull))rylsj_progress
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 下载文件
 
 @param request RYLSJ_URLRequest
 @param downloadProgressBlock 进度
 @param completionHandler 回调
 @return task
 */
- (NSURLSessionDownloadTask *)downloadWithRequest:(RYLSJ_URLRequest *)request
                                         progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/**
 取消请求任务
 
 @param urlString           协议接口
 */
- (void)cancelRequest:(NSString *)urlString  completion:(cancelCompletedBlock)completion;

@end

NS_ASSUME_NONNULL_END
