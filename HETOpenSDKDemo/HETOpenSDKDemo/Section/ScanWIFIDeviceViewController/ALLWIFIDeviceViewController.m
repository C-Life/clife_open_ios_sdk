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

#import "ELIANBroadcast_SSID_Password.h"

@interface ALLWIFIDeviceViewController ()
{
   
    HFSmartLink * hfsmtlk;
    
    ELIANBroadcast_SSID_Password *mtksmtlk;
    

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
    
    if(self.productId.integerValue==1374)//汉风模块的设备
    {
    //HF WiFi模块接入路由
    hfsmtlk =[[HFSmartLink alloc]init];
    hfsmtlk.isConfigOneDevice = false;
    
    hfsmtlk.waitTimers = 30;
    [hfsmtlk startWithKey:self.wifiPassword processblock:^(NSInteger process) {
        
    } successBlock:^(HFSmartLinkDeviceInfo *dev) {
        //[self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
    } failBlock:^(NSString *failmsg) {
        //[self  showAlertWithMsg:failmsg title:@"error"];
    } endBlock:^(NSDictionary *deviceDic) {
        
        
    }];
  }
 else if(self.productId.integerValue==2159)//MTK芯片的设备
 {
     mtksmtlk=[[ELIANBroadcast_SSID_Password alloc]init];
     [mtksmtlk startBroadcast_SSID:self.ssid Password:self.wifiPassword];
  }


    [HETCommonHelp showCustomHudtitle:@"开始绑定设备(100s超时)"];
    
    [[HETWIFIBindBusiness sharedInstance] startBindDeviceWithProductId:self.productId withTimeOut:100 completionHandler:^(HETDevice *deviceObj, NSError *error) {
        NSLog(@"设备mac地址:%@,%@",deviceObj.macAddress,error);
        if(hfsmtlk)
        {
          [hfsmtlk closeWithBlock:^(NSString *closeMsg, BOOL isOK) {
            
           }];
           [hfsmtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            
           }];
        }
        hfsmtlk=nil;
        if(mtksmtlk)
        {
            [mtksmtlk stopBroadcast];
        }
        mtksmtlk=nil;
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
    [[HETWIFIBindBusiness sharedInstance] stop];
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
