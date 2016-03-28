//
//  ViewController.m
//  XDCouponAlertViewDemo
//
//  Created by xiudou on 16/3/28.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import "ViewController.h"
#import "XDCouponAlertView.h"
@interface ViewController ()<XDCouponAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)show{
    XDCouponAlertView *alertView = [[XDCouponAlertView alloc] initWithTitle:@"你确定退出登" message:@"你确定退出登" phone:@"你确定退出登" delegate:self cancelButtonTitle:@"确定", nil];
    alertView.type = XDCouponAlertView_Custom;
    alertView.delegate = self;
    [alertView show];
    
}


- (void)alertView:(XDCouponAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
