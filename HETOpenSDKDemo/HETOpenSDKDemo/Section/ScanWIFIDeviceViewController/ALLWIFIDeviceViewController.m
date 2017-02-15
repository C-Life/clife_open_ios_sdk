//
//  ALLWIFIDeviceViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 15/6/25.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "ALLWIFIDeviceViewController.h"
#import "MainViewController.h"
#import "HETCommonHelp.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ALLWIFIDeviceViewController ()
{
    HETWIFIBindBusiness *manager;
     HFSmartLink * smtlk;

}
@end

@implementation ALLWIFIDeviceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //HF WiFi模块接入路由
    smtlk =[[HFSmartLink alloc]init];
    smtlk.isConfigOneDevice = false;
    
    smtlk.waitTimers = 30;
    [smtlk startWithKey:self.wifiPassword processblock:^(NSInteger process) {
        
    } successBlock:^(HFSmartLinkDeviceInfo *dev) {
        //[self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
    } failBlock:^(NSString *failmsg) {
        //[self  showAlertWithMsg:failmsg title:@"error"];
    } endBlock:^(NSDictionary *deviceDic) {
        
        
    }];
    

    [HETCommonHelp showCustomHudtitle:@"开始绑定设备"];
    manager=[HETWIFIBindBusiness sharedInstance];
    [manager startBindDeviceWithProductId:self.productId withTimeOut:100 completionHandler:^(HETWIFICommonReform *deviceObj, NSError *error) {
        NSLog(@"设备mac地址:%@,%@",deviceObj.device_mac,error);
        [smtlk closeWithBlock:^(NSString *closeMsg, BOOL isOK) {
            
        }];
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            
        }];
        smtlk=nil;
       if(error)
       {
           [HETCommonHelp HidHud];
           [self.navigationController popViewControllerAnimated:YES];
       }
        else
        {
            [HETCommonHelp HidHud];
            MainViewController *vc=[[MainViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止扫描
    [manager stop];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)bindAction
{
    
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
