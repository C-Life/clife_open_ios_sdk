//
//  HFWIFICommonReform.h
//  HETOpenSDK
//
//  Created by mr.cao on 15/6/29.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

//是否需要回复
typedef NS_ENUM(UInt8, ReplayStat) {
    NeedReplay = 0x01,    //需要确认
    DontNeedReplay = 0x00,    //不需要确认
};
//数据方向
typedef NS_ENUM(UInt8, DataDirection) {
    AppToDevice = 0x40,    //APP发往设备
    DeviceToApp = 0x00,    //设备发往APP
};

@interface HETWIFICommonReform : NSObject
@property(nonatomic,assign)UInt8        startflag;//协议头
@property(nonatomic,assign)UInt8        protocol_version;//协议版本号
@property(nonatomic,assign)UInt8        protocol_type;//协议类型
@property(nonatomic,strong)NSString     *device_mac;//设备的 MAC 地址
@property(nonatomic,strong)NSString     *device_ip;//设备的 IP 地址
@property(nonatomic,assign)UInt8        device_type;//设备的主类型
@property(nonatomic,assign)UInt8        device_subtype;//设备的子类型
@property(nonatomic,assign)UInt16       device_cmdtype;//相关操作命令字
@property(nonatomic,assign)unsigned long  device_brand;//设备的品牌
@property(nonatomic,assign)UInt16       body_length;//数据长度
@property(nonatomic,strong)NSData*      body;//数据内容
@property(nonatomic,assign)UInt16       device_wifiStatus;//WIFI信号强度
@property(nonatomic,strong)NSString     *deviceID;//设备标示
@property(nonatomic,assign)unsigned long  packetNum;//报文号
@property(nonatomic,assign)ReplayStat   replay;//是否需要回复
@property(nonatomic,assign)DataDirection   direction;//数据方向

@end

