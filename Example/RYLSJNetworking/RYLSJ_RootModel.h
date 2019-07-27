//
//  RYLSJ_RootModel.h
//  RYLSJNetworking_Example
//
//  Created by tutu on 2019/7/27.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RYLSJ_RootModel : NSObject
@property (nonatomic,copy)NSString *wid; //id
@property (nonatomic,copy)NSString *name;//名字
@property (nonatomic,copy)NSString *detail;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
