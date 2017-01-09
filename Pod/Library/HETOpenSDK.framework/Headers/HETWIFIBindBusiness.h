//
//  HETWIFIBindBusiness.h
//  HETOpenSDK
//
//  Created by mr.cao on 15/6/24.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import "HETWIFICommonReform.h"



typedef NS_ENUM(NSInteger, HETDeviceBindError) {
    
    HETDeviceBindGetServerIPError = 0,    // 获取绑定服务器的IP地址和端口错误
    HETDeviceBindGetDeviceInfoError,      // 获取设备基本信息失败
    HETDeviceBindSendDeviceInfoError,   // 提交设备信息给服务器失败
    HETDeviceBindTimeOutError,            // 绑定超时
};







@interface HETWIFIBindBusiness : NSObject




+ (HETWIFIBindBusiness *)sharedInstance;

/**
 *  获取手机所连WIFI得SSID
 *
 *  @param interval 时间间隔，每隔interval 获取一次
 *  @param times    次数
 *  @param success  获取SSID的回调
 */
-(void)fetchSSIDInfoWithInterVal:(NSTimeInterval)interval
                       WithTimes:(NSTimeInterval)times
                    SuccessBlock:(void(^)(NSString* ssidStr))success;
/**
 *  停止获取手机所连WIFI得SSID
 */

-(void)stopFetchSSIDInfo;




/**
 *  获得所连Wi-Fi的Mac地址
 *
 *  @return 返回mac地址
 */
-(NSString *)fetchmacSSIDInfo;


-(void)startBindDeviceWithProductId:(NSString *)productId withTimeOut:(NSTimeInterval)interval completionHandler:(void (^)(HETWIFICommonReform *deviceObj, NSError *error))completionHandler;



/**
 *  停止服务，关闭socket
 */
-(void) stop;

@end
