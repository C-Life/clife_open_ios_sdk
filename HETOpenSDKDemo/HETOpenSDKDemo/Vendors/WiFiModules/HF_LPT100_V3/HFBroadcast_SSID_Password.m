//
//  HFBroadcast_SSID_Password.m
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 2016/12/11.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HFBroadcast_SSID_Password.h"
// 汉枫WiFi模组
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
@interface HFBroadcast_SSID_Password ()
{
    // 汉枫smartlink
    HFSmartLink         *smtlk;
}
@end
@implementation HFBroadcast_SSID_Password

- (void)startBroadcast_SSID:(NSString *)ssid Password:(NSString *)password
{
    //HF WiFi模块接入路由
    smtlk =[[HFSmartLink alloc]init];// [HFSmartLink shareInstence];
    smtlk.isConfigOneDevice = false;
    
    smtlk.waitTimers = 30;//15;
    [smtlk startWithKey:password processblock:^(NSInteger process) {
        
    } successBlock:^(HFSmartLinkDeviceInfo *dev) {
        //[self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
    } failBlock:^(NSString *failmsg) {
        //[self  showAlertWithMsg:failmsg title:@"error"];
    } endBlock:^(NSDictionary *deviceDic) {
        
        
    }];
}
- (void)stopBroadcast
{
    [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
        
    }];
    [smtlk closeWithBlock:^(NSString *closeMsg, BOOL isOK) {
        
    }];
}
@end
