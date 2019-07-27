//
//  RYLSJ_RootModel.m
//  RYLSJNetworking_Example
//
//  Created by tutu on 2019/7/27.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import "RYLSJ_RootModel.h"

@implementation RYLSJ_RootModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //  NSLog(@"undefinedKey:%@",key);
    if ([key isEqualToString:@"id"]) {
        self.wid=value;
    }
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
