//
//  ViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "ViewController.h"

#import <HETOpenSDK/HETOpenSDK.h>
#import "MainViewController.h"



@interface ViewController ()
@property (nonatomic, strong) HETAuthorize *auth;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftBarButtonItemHide:YES];
    
   
    
    // Do any additional setup after loading the view, typically from a nib.
   //检查SDK是否已经授权登录，否则不能使用
    HETAuthorize *auth = [[HETAuthorize alloc] init];
    self.auth = auth;
    
    if (![auth isAuthenticated]) {
        [auth authorizeWithCompleted:^(HETAccount *account, NSError *error) {
            NSLog(@"%@,token:%@",account,account.accessToken);
            MainViewController *vc=[[MainViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }];

            }
    else
    {
        MainViewController *vc=[[MainViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
