//
//  RYLSJ_RequestManager.h
//  RYLSJNetworking_Example
//
//  Created by SM-JS-Wangrunya-PC on 0725.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYLSJ_RequestEngine.h"
NS_ASSUME_NONNULL_BEGIN

@interface RYLSJ_RequestManager : NSObject

/**
 *  请求方法 GET/POST/PUT/PATCH/DELETE
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 */
+ (void)requestWithConfig:(requestConfig)config  success:(requestSuccess)success failure:(requestFailure)failure;

/**
 *  请求方法 GET/POST/PUT/PATCH/DELETE/Upload/DownLoad
 *
 *  @param config           请求配置  Block
 *  @param progress         请求进度  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 */
+ (void)requestWithConfig:(requestConfig)config  progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure;

/**
 *  批量请求方法 GET/POST/PUT/PATCH/DELETE
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 */
+ (RYLSJ_BatchRequest *)sendBatchRequest:(batchRequestConfig)config success:(requestSuccess)success failure:(requestFailure)failure;

/**
 *  批量请求方法 GET/POST/PUT/PATCH/DELETE/Upload/DownLoad
 *
 *  @param config           请求配置  Block
 *  @param progress         请求进度  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 */
+ (RYLSJ_BatchRequest *)sendBatchRequest:(batchRequestConfig)config progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure;

/**
 取消请求任务
 
 @param URLString           协议接口
 @param completion          后续操作
 */
+ (void)cancelRequest:(NSString *)URLString completion:(cancelCompletedBlock)completion;

@end

NS_ASSUME_NONNULL_END
