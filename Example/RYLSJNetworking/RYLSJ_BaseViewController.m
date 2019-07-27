//
//  RYLSJ_BaseViewController.m
//  RYLSJNetworking_Example
//
//  Created by tutu on 2019/7/27.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import "RYLSJ_BaseViewController.h"

@implementation RYLSJ_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
}

- (void)addItemWithTitle:(NSString *)title selector:(SEL)selector location:(BOOL)isLeft{
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain  target:self action:selector];
    
    if (isLeft == YES) {
        //左
        self.navigationItem.leftBarButtonItem = item;
    }else{
        //右边
        self.navigationItem.rightBarButtonItem = item;
    }
    
}
- (void)alertTitle:(NSString *)title andMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //
    [alertView show];
}

@end
