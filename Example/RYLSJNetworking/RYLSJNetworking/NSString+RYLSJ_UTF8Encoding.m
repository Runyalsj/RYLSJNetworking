//
//  NSString+RYLSJ_UTF8Encoding.m
//  RYLSJNetworking_Example
//
//  Created by tutu on 2019/7/27.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import "NSString+RYLSJ_UTF8Encoding.h"

@implementation NSString (RYLSJ_UTF8Encoding)

+ (NSString *)rylsj_stringUTF8Encoding:(NSString *)urlString{
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0){
        return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else{
        return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

+ (NSString *)rylsj_urlString:(NSString *)urlString appendingParameters:(id)parameters{
    if (parameters==nil) {
        return urlString;
    }else{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *key in parameters) {
            id obj = [parameters objectForKey:key];
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
            [array addObject:str];
        }
        
        NSString *parametersString = [array componentsJoinedByString:@"&"];
        return  [urlString stringByAppendingString:[NSString stringWithFormat:@"?%@",parametersString]];
    }
}
@end
