//
//  RYLSJ_BaseViewController.h
//  RYLSJNetworking_Example
//
//  Created by tutu on 2019/7/27.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define list_URL @"http://api.dotaly.com/lol/api/v1/authors?iap=0"

#define details_URL @"http://api.dotaly.com/lol/api/v1/shipin/latest?author=%@&iap=0jb=0&limit=50&offset=0"

//屏幕宽
#define RYLSJ_KSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define RYLSJ_KSCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

NS_ASSUME_NONNULL_BEGIN

@interface RYLSJ_BaseViewController : UIViewController

//title 设置btn的标题; selector点击btn实现的方法; isLeft 标记btn的位置
- (void)addItemWithTitle:(NSString *)title selector:(SEL)selector location:(BOOL)isLeft;
//title提示框的标题; andMessage提示框的描述
- (void)alertTitle:(NSString *)title andMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
