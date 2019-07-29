//
//  RYLSJ_RequestConst.h
//  RYLSJNetworking
//
//  Created by SM-JS-Wangrunya-PC on 0725.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#ifndef RYLSJ_RequestConst_h
#define RYLSJ_RequestConst_h

@class RYLSJ_URLRequest,RYLSJ_BatchRequest;

#define RYLSJBUG_LOG 1

#if(RYLSJBUG_LOG == 1)
# define RYLSJ_Log(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
# define RYLSJ_Log(...);
#endif


/**
 用于标识不同类型的请求
 */
typedef NS_ENUM(NSInteger,apiType) {
    /** 重新请求:   不读取缓存，重新请求*/
    RYLSJ_RequestTypeRefresh,
    /** 读取缓存:   有缓存,读取缓存--无缓存，重新请求*/
    RYLSJ_RequestTypeCache,
    /** 加载更多:   不读取缓存，重新请求*/
    RYLSJ_RequestTypeRefreshMore,
    /** 加载更多:   有缓存,读取缓存--无缓存，重新请求*/
    RYLSJ_RequestTypeCacheMore,
    /** 详情页面:   有缓存,读取缓存--无缓存，重新请求*/
    RYLSJ_RequestTypeDetailCache,
    /** 自定义项:   有缓存,读取缓存--无缓存，重新请求*/
    RYLSJ_RequestTypeCustomCache
};
/**
 HTTP 请求类型.
 */
typedef NS_ENUM(NSInteger,MethodType) {
    /**GET请求*/
    RYLSJ_MethodTypeGET,
    /**POST请求*/
    RYLSJ_MethodTypePOST,
    /**Upload请求*/
    RYLSJ_MethodTypeUpload,
    /**DownLoad请求*/
    RYLSJ_MethodTypeDownLoad,
    /**PUT请求*/
    RYLSJ_MethodTypePUT,
    /**PATCH请求*/
    RYLSJ_MethodTypePATCH,
    /**DELETE请求*/
    RYLSJ_MethodTypeDELETE
};
/**
 请求参数的格式.默认是HTTP
 */
typedef NS_ENUM(NSUInteger, requestSerializerType) {
    /** 设置请求参数为二进制格式*/
    RYLSJ_HTTPRequestSerializer,
    /** 设置请求参数为JSON格式*/
    RYLSJ_JSONRequestSerializer
};
/**
 返回响应数据的格式.默认是JSON
 */
typedef NS_ENUM(NSUInteger, responseSerializerType) {
    /** 设置响应数据为JSON格式*/
    RYLSJ_JSONResponseSerializer,
    /** 设置响应数据为二进制格式*/
    RYLSJ_HTTPResponseSerializer
};

/** 批量请求配置的Block */
typedef void (^batchRequestConfig)(RYLSJ_BatchRequest * batchRequest);
/** 请求配置的Block */
typedef void (^requestConfig)(RYLSJ_URLRequest * request);
/** 请求成功的Block */
typedef void (^requestSuccess)(id responseObject,apiType type,BOOL isCache);
/** 请求失败的Block */
typedef void (^requestFailure)(NSError * error);
/** 请求进度的Block */
typedef void (^progressBlock)(NSProgress * progress);
/** 请求取消的Block */
typedef void (^cancelCompletedBlock)(BOOL results,NSString * urlString);



#endif /* RYLSJ_RequestConst_h */
