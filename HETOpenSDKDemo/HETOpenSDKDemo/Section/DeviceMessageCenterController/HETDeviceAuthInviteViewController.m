//
//  HETDeviceAuthInviteViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/7/12.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETDeviceAuthInviteViewController.h"
#import  <HETOpenSDK/HETOpenSDK.h>
#import "HETCommonHelp.h"

@interface HETDeviceAuthInviteViewController ()


{
    HETDeviceShareBusiness *_request;
}

@end

@implementation HETDeviceAuthInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptButton.frame =  CGRectMake(0, 0, 150, 44);
    acceptButton.center=self.view.center;
    [acceptButton setTitle:@"设备授权同意" forState:UIControlStateNormal];
    [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [acceptButton addTarget:self action:@selector(acceptButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    acceptButton.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
    [self.view addSubview:acceptButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)acceptButtonClicked: (id)sender
{
    
     [HETCommonHelp showCustomHudtitle:@"请稍候..."];
   
    [HETDeviceShareBusiness deviceAuthAgreeWithDeviceId:self.deviceId success:^(id responseObject) {
        [HETCommonHelp HidHud];
        [HETCommonHelp showAutoDissmissAlertView:nil msg: @"设备分享成功"];
    } failure:^(NSError *error) {
        [HETCommonHelp HidHud];
        [HETCommonHelp showAutoDissmissAlertView:nil msg: error.userInfo[@"msg"]];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
