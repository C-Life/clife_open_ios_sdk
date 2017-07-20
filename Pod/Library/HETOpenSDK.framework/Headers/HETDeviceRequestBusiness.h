//
//  HETDeviceRequestBusiness.h
//  HETOpenSDK
//
//  Created by mr.cao on 15/8/13.
//  Copyright (c) 2015年 peng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HETNetWorkRequestHeader.h"
#import "HETFileInfo.h"
#import "HETDevice.h"

typedef void(^successBlock)(id responseObject);
typedef void(^failureBlock)( NSError *error);

typedef NS_ENUM(NSUInteger,HETDeviceBindType)
{
    HETWIFIDeviceBindType=1,//WiFi绑定类型
    HETBLEDeviceBindType=2,//蓝牙绑定类型
};


typedef NS_ENUM(NSUInteger,HETBLEDeviceDataUploadType)
{
    HETBLEDeviceHistoryDataUploadType=1,//蓝牙设备历史数据上传类型
    HETBLEDeviceRealTimeDataUploadType=2,//蓝牙设备实时数据上传类型
};



@interface HETDeviceRequestBusiness : NSObject

/**
 *  下发控制设备
 *
 *  @param json     设备控制json
 *  @param deviceId 设备deviceId
 *  @param success  设备控制成功的回调
 *  @param failure  设备控制失败的回调
 */
- (void)deviceControlWithJSON:(NSString *)json
                 withDeviceId:(NSString *)deviceId
                      success:(successBlock)success
                      failure:(failureBlock)failure;



/**
 *  查询设备配置数据信息
 *
 *  @param deviceId 设备deviceId
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
- (void)fetchDeviceConfigDataWithDeviceId:(NSString *)deviceId
                              success:(successBlock)success
                              failure:(failureBlock)failure;



/**
 *  查询设备运行数据信息
 *
 *  @param deviceId 设备deviceId
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
- (void)fetchDeviceRunDataWithDeviceId:(NSString *)deviceId
                              success:(successBlock)success
                              failure:(failureBlock)failure;


/**
 *  查询设备故障数据信息
 *
 *  @param deviceId 设备deviceId
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
- (void)fetchDeviceErrorDataWithDeviceId:(NSString *)deviceId
                               success:(successBlock)success
                               failure:(failureBlock)failure;


/**
 *  查询绑定的所有设备列表
 *
 *  @param success  设备列表返回HETDevice对象数组
 *  @param failure 失败的回调
 */
- (void)fetchAllBindDeviceSuccess:(void (^)(NSArray<HETDevice *>* deviceArray))success
                               failure:(failureBlock)failure;



/**
 *  查询设备大类
 *
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */


- (void)fetchDeviceTypeListSuccess:(successBlock)success
                           failure:(failureBlock)failure;




/**
 *  查询设备子分类
 *
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */


- (void)fetchDeviceSubtypeListWithDeviceTypeId:(NSString *)deviceTypeId
                                       success:(successBlock)success
                                       failure:(failureBlock)failure;


/**
 *  根据设备大类查询APP支持的设备型号
 *
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */

- (void)fetchDeviceProductListWithDeviceTypeId:(NSString *)deviceTypeId
                                       success:(successBlock)success
                                       failure:(failureBlock)failure;




/**
 *  解除设备绑定
 *
 *  @param deviceId 设备deviceId
 *  @param success  解除绑定成功的回调
 *  @param failure  解除绑定失败的回调
 */
- (void)unbindDeviceWithDeviceId:(NSString *)deviceId
                              success:(successBlock)success
                              failure:(failureBlock)failure;



/**
 *  设备绑定
 *
 *  @param macAddr         设备mac地址
 *  @param deviceProductId  设备型号标识
 *  @param deviceId         设备标识（更换MAC地址)
 *  @param success         绑定成功的回调
 *  @param failure         绑定失败的回调
 */


-(void)bindDeviceWithDeviceMAC:(NSString *)macAddr
                      deviceProductId:(NSInteger) deviceProductId
                      deviceId:(NSString *) deviceId
                       success:(successBlock)success
                      failure:(failureBlock)failure;


/**
 *  查询WIFI设备绑定状态
 *
 *  @param deviceId 设备标识deviceId
 *  @param success  查询设备绑定状态成功的回调
 *  @param failure  查询设备绑定状态失败的回调
 */
-(void)fetchWIFIDeviceBindStateWithDeviceId:(NSString *)deviceId
                                    success:(successBlock)success
                                    failure:(failureBlock)failure;





/**
 *  设备数据上传（蓝牙）
 *
 *  @param deviceId 设备deviceId
 *  @param dataType 数据类型（1-历史数据，2-实时数据）
 *  @param data     需要上传的数据
 *  @param success  上传成功的回调
 *  @param failure  上传失败的回调
 */
- (void)uploadDeviceDataWithDeviceId:(NSString *)deviceId
                            dataType:(HETBLEDeviceDataUploadType) dataType
                                data:(NSData *)data
                             success:(successBlock)success
                             failure:(failureBlock)failure;

/**
 *  设备数据上传（蓝牙）
 *
 *  @param deviceId 设备deviceId
 *  @param dataType 数据类型（1-历史数据，2-实时数据）
 *  @param jsonStr     需要上传的数据
 *  @param success  上传成功的回调
 *  @param failure  上传失败的回调
 */
- (void)uploadDeviceJsonDataWithDeviceId:(NSString *)deviceId
                                dataType:(HETBLEDeviceDataUploadType) dataType
                                    data:(NSString *)jsonStr
                                 success:(successBlock)success
                                 failure:(failureBlock)failure;


/**
 *  获取蓝牙历史数据
 *
 *  @param deviceId  设备标识
 *  @param order     排序方式（0-降序 1-升序 默认0-降序）
 *  @param pageRows  每页显示的行数(默认20)
 *  @param pageIndex 当前页（默认1）
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
-(void)getBluetoothListWithDeviceId:(NSString *)deviceId
                          withOrder:(NSUInteger)order
                       withPageRows:(NSUInteger)pageRows
                      withPageIndex:(NSUInteger)pageIndex
                            success:(successBlock)success
                            failure:(failureBlock)failure;

/**
 *  产品ID获取协议列表
 *
 *  @param productId 产品ID
 *  @param type      协议类型 0或者不传-完整协议	，包括以下协议内容1-设备基本信息2-控制数据3-运行数据4-故障数据
 *  @param protocolDate	协议时间
 *  @param success
 *  @param failure
 */
- (void)fetchDeviceProtocolListWithProductId:(NSString *)productId
                                        type:(NSInteger)type
                                protocolDate:(NSString *)protocolDate
                                     success:(successBlock)success
                                     failure:(failureBlock)failure;








/**
 *  修改设备基础信息
 *
 *  @param deviceId   设备标识
 *  @param deviceName 设备名称
 *  @param roomId     房间标识（绑定者才可以修改房间位置）
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */

- (void)updateDeviceInfoWithDeviceId:(NSString *)deviceId
                          deviceName:(NSString *)deviceName
                              roomId:(NSString *)roomId
                             success:(successBlock)success
                             failure:(failureBlock)failure;





/**
 *  获取设备运行数据列表（七天之内）
 *
 *  @param deviceId  设备标识
 *  @param startDate 开始时间
 *  @param endDate   结束时间（默认为当天）
 *  @param pageRows  每页显示的行数，默认为20
 *  @param pageIndex 当前页，默认为1
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
- (void)fetchDeviceRundataListWithDeviceId:(NSString *)deviceId
                                 startDate:(NSString *)startDate
                                   endDate:(NSString *)endDate
                                  pageRows:(NSString *)pageRows
                                 pageIndex:(NSString *)pageIndex
                                   success:(successBlock)success
                                   failure:(failureBlock)failure;



/**
 *  获取设备控制数据列表（七天之内）
 *
 *  @param deviceId  设备标识
 *  @param startDate 开始时间
 *  @param endDate   结束时间（默认为当天）
 *  @param pageRows  每页显示的行数，默认为20
 *  @param pageIndex 当前页，默认为1
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
- (void)fetchDeviceConfigDataListWithDeviceId:(NSString *)deviceId
                                    startDate:(NSString *)startDate
                                      endDate:(NSString *)endDate
                                     pageRows:(NSString *)pageRows
                                    pageIndex:(NSString *)pageIndex
                                      success:(successBlock)success
                                      failure:(failureBlock)failure;



/**
 *  获取设备故障数据列表（七天之内）
 *
 *  @param deviceId  设备标识
 *  @param startDate 开始时间
 *  @param endDate   结束时间（默认为当天）
 *  @param pageRows  每页显示的行数，默认为20
 *  @param pageIndex 当前页，默认为1
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
- (void)fetchDeviceErrorDataListWithDeviceId:(NSString *)deviceId
                                   startDate:(NSString *)startDate
                                     endDate:(NSString *)endDate
                                    pageRows:(NSString *)pageRows
                                   pageIndex:(NSString *)pageIndex
                                     success:(successBlock)success
                                     failure:(failureBlock)failure;





/**
 *  获取最新检测数据(针对远大环境仪)
 *
 *  @param deviceId  设备标识
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
-(void)fetchBroadairDeviceLatestDataWithDeviceId:(NSString *)deviceId
                                    success:(successBlock)success
                                    failure:(failureBlock)failure;



/**
 *  普通网络请求
 *
 *  @param method     HTTP网络请求方法
 *  @param requestUrl 网络请求的URL
 *  @param params     请求参数
 *  @param needSign   是否需要签名
 *  @param success    网络请求成功的回调
 *  @param failure    网络请求失败的回调
 */
-(void)startRequestWithHTTPMethod: (HETRequestMethod)method  withRequestUrl:(NSString *)requestUrl processParams:(NSDictionary *)params needSign:(BOOL)needSign
                 BlockWithSuccess:(successBlock)success
                          failure:(failureBlock)failure;





/**
 *  上传文件的接口
 *
 *  @param requestUrl 网络请求的URL
 *  @param params     请求参数
 *  @param success    网络请求成功的回调
 *  @param failure    网络请求失败的回调
 */

-(void)startMultipartFormDataRequestWithRequestUrl:(NSString *)requestUrl processParams:(NSDictionary *)params  uploadFileInfo:(NSArray<HETFileInfo *>*)fileInfoArray  BlockWithSuccess:(successBlock)success
                                           failure:(failureBlock)failure;
@end
