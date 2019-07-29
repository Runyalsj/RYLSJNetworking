//
//  NSString+RYLSJ_UTF8Encoding.h
//  RYLSJNetworking_Example
//
//  Created by tutu on 2019/7/27.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (RYLSJ_UTF8Encoding)
/**
 UTF8
 
 @param urlString 编码前的url字符串
 @return 返回 编码后的url字符串
 */
+ (NSString *)rylsj_stringUTF8Encoding:(NSString *)urlString;

/**
 url字符串与parameters参数的的拼接
 
 @param urlString url字符串
 @param parameters parameters参数
 @return 返回拼接后的url字符串
 */
+ (NSString *)rylsj_urlString:(NSString *)urlString appendingParameters:(id)parameters;

@end

NS_ASSUME_NONNULL_END
