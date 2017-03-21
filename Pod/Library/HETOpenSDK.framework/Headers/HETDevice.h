//
//  HETDevice.h
//  HETOpenSDK
//
//  Created by mr.cao on 16/12/29.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETDevice : NSObject

@property (nonatomic, strong) NSString *authUserId;//授权设备用户标识
@property (nonatomic, strong) NSString *bindTime;//绑定时间
@property (nonatomic, strong) NSNumber *bindType;//设备绑定类型（1-WiFi，2-蓝牙，3-音频，4-GSM，5-红外）
@property (nonatomic, strong) NSNumber *controlType;//控制类型（1-原生，2-插件，3-H5插件）
@property (nonatomic, strong) NSNumber *deviceBrandId;//设备品牌标识
@property (nonatomic, strong) NSString *deviceBrandName;//设备品牌名称
@property (nonatomic, strong) NSString *deviceIcon;//设备图标
@property (nonatomic, strong) NSString *deviceId;//设备标识
@property (nonatomic, strong) NSString *deviceModel;
@property (nonatomic, strong) NSString *deviceName;//设备名称
@property (nonatomic, strong) NSNumber *deviceSubtypeId;//设备子分标识
@property (nonatomic, strong) NSString *deviceSubtypeName;//设备子分类名称
@property (nonatomic, strong) NSNumber *deviceTypeId;//设备大分类标识
@property (nonatomic, strong) NSString *deviceTypeName;//设备大分类名称
@property (nonatomic, strong) NSString *macAddress;//MAC地址
@property (nonatomic, strong) NSNumber *onlineStatus;//在线状态（1-正常，2-异常）
@property (nonatomic, strong) NSNumber *roomId;//房间标识
@property (nonatomic, strong) NSString *roomName;//房间名称
@property (nonatomic, strong) NSNumber *share;//设备分享（1-是，2-否，3-扫描分享）
@property (nonatomic, strong) NSString *userKey;//MAC与设备ID生成的KEY
@property (nonatomic, strong) NSNumber *productId;//设备型号标识
@property (nonatomic, strong) NSNumber *moduleType;//模块类型（1-WiFi，2-蓝牙，3-音频，4-GSM，5-红外）
@property (nonatomic, strong) NSString *productIcon;//设备型号图标
@property (nonatomic, strong) NSString *developerId;//客户代码

@end
