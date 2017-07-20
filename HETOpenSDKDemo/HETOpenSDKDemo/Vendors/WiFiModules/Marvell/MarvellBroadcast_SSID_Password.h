//
//  MarvellBroadcast_SSID_Password.h
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 2016/12/11.
//  Copyright © 2016年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarvellBroadcast_SSID_Password : NSObject
/**
 *  开始广播即将连接的路由器SSID和密码给指定厂商的WIFI模组设备
 */
- (void)startBroadcast_SSID:(NSString *)currentssid
                   Password:(NSString *)password;
/**
 *  停止广播SSID和密码给指定厂商的WIFI模组设备
 */
- (void)stopBroadcast;
@end
