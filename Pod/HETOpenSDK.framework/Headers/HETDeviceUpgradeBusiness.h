//
//  HETDeviceUpgradeBusiness.h
//  HETOpenSDK
//  WIFI设备升级类
//  Created by mr.cao on 16/7/6.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id responseObject);
typedef void(^failureBlock)( NSError *error);




@interface HETDeviceUpgradeBusiness : NSObject


/**
 *  查询设备固件版本
 *
 *  @param deviceId 设备标识
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */

-(void)deviceUpgradeCheckWithDeviceId:(NSString *)deviceId
                              success:(successBlock)success
                              failure:(failureBlock)failure;







/**
 *  确认设备升级
 *
 *  @param deviceId 设备标识
 *  @param deviceVersionType 设备版本类型（1-WIFI，2-PCB（目前蓝牙设备、wifi设备都只升级pcb）,3-蓝牙模块升级）
 *  @param deviceVersionId   设备版本标示
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */

-(void)deviceUpgradeConfirmWithDeviceId:(NSString *)deviceId
                      deviceVersionType:(NSString *)deviceVersionType
                        deviceVersionId:(NSString *)deviceVersionId
                              success:(successBlock)success
                              failure:(failureBlock)failure;






/**
 *  查询升级进度
 *
 *  @param deviceId          设备标识
 *  @param deviceVersionId   设备版本标示
 *  @param success           成功的回调
 *  @param failure           失败的回调
 */

-(void)fetchDeviceUpgradeProgress:(NSString *)deviceId
                        deviceVersionId:(NSString *)deviceVersionId
                                success:(successBlock)success
                                failure:(failureBlock)failure;




/**
 *  升级成功确认
 *
 *  @param deviceId        设备标识
 *  @param deviceVersionId 设备版本标示
 *  @param success           成功的回调
 *  @param failure           失败的回调
 */

-(void)deviceUpgradeConfirmSuccessWithDeviceId:(NSString *)deviceId
                               deviceVersionId:(NSString *)deviceVersionId
                                       success:(successBlock)success
                                       failure:(failureBlock)failure;

@end
