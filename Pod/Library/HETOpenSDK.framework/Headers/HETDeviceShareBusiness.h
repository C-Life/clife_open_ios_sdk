//
//  HETDeviceShareBusiness.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/7/11.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^successBlock)(id responseObject);
typedef void(^failureBlock)( NSError *error);


@interface HETDeviceShareBusiness : NSObject


/**
 *  请求手机账号所有设备的授权
 *
 *  @param phone 待授权的手机号
 *  @param authOpenId  授权的openId
 *  @param openId  待授权的openId
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)fetchAllAuthDeviceWithPhone:(NSString *)phone
                        authOpenId:(NSString *)authOpenId
                            openId:(NSString *)openId
                           success:(successBlock)success
                           failure:(failureBlock)failure;

/**
 *  设备授权邀请
 *
 *  @param deviceId 设备标识
 *  @param account  帐号（手机、邮箱）
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */

+(void)deviceInviteWithDeviceId:(NSString *)deviceId
                       account:(NSString *)account
                       success:(successBlock)success
                       failure:(failureBlock)failure;




/**
 *  多用户设备授权
 *
 *  @param deviceId  设备标识
 *  @param friendIds 好友标识（多个标识用','（逗号）隔开）
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)deviceAuthWithDeviceId:(NSString *)deviceId
                       friendIds:(NSString *)friendIds
                       success:(successBlock)success
                       failure:(failureBlock)failure;




/**
 *  设备授权删除
 *
 *  @param deviceId  设备标识
 *  @param userId 用户标识，为空时表示删除所有授权信息或被授权人的授权信息 【2015-11-24修改为非必填参数】
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)deviceAuthDelWithDeviceId:(NSString *)deviceId
                       userId:(NSString *)userId
                       success:(successBlock)success
                       failure:(failureBlock)failure;





/**
 *  设备授权同意
 *
 *  @param deviceId  设备标识
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)deviceAuthAgreeWithDeviceId:(NSString *)deviceId
                       success:(successBlock)success
                       failure:(failureBlock)failure;




/**
 *  获取设备授权的用户
 *
 *  @param deviceId  设备标识
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */

+(void)deviceGetAuthUserWithDeviceId:(NSString *)deviceId
                       success:(successBlock)success
                       failure:(failureBlock)failure;








/**
 *  多设备授权邀请
 *
 *  @param deviceIds  设备标识（多个标识用','（逗号）隔开）
 *  @param account  帐号（手机、邮箱）
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)deviceMultiInviteWithDeviceIds:(NSString *)deviceIds
                       account:(NSString *)account
                       success:(successBlock)success
                       failure:(failureBlock)failure;




/**
 *  获取已分享出去的设备列表信息
 *
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)deviceGetAuthSuccess:(successBlock)success
                       failure:(failureBlock)failure;




@end
