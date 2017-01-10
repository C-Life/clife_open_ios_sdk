//
//  WIFIBindManager.h
//  openSDK
//
//  Created by mr.cao on 15/6/24.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import "HETWIFICommonReform.h"

@protocol HETWIFIBindBusinessDelegate<NSObject>
/**
 *  绑定失败代理
 *
 *  @param obj  绑定失败的设备信息HETWIFICommonReform对象
 */
-(void)HETWIFIBindBusinessFail:(HETWIFICommonReform *)obj;

/**
 *  绑定成功代理
 *
 *  @param obj  绑定成功的设备信息HETWIFICommonReform对象
 */
-(void)HETWIFIBindBusinessSuccess:(HETWIFICommonReform *)obj;


/**
 *  扫描到设备代理
 *
 *  @param HETWIFIBindBusiness HETWIFIBindBusiness对象
 *  @param obj                 设备信息HETWIFICommonReform对象
 */
- (void)scanWIFIDevice:(id)HETWIFIBindBusiness bindDeviceInfo:(HETWIFICommonReform *)obj;

@end



@interface HETWIFIBindBusiness : NSObject


@property(nonatomic,weak)id<HETWIFIBindBusinessDelegate>delegate;




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

/**
 *  扫描设备
 *
 *  @param deviceType 设备类型，如果deviceType<1则扫描所有设备
 */
-(void)startScanDevicewithDeviceType:(NSInteger)deviceType;


/**
 *  绑定设备
 *
 *  @param deviceArrayObj 需要绑定的设备数组，数组里面必须是HETWIFICommonReform对象
 *  @param productId      设备型号标识
 *  @param deviceId       设备标识（更换MAC地址）
 *  @param interval       设置绑定超时时间
 */
-(void)bindDevices:(NSArray<HETWIFICommonReform *>*)deviceArrayObj withProductId:(NSString *)productId withDeviceId:(NSString *)deviceId withTimeOut:(NSTimeInterval)interval;


/**
 *  停止服务，关闭socket
 */
-(void) stop;

@end
