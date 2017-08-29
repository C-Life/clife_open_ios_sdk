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
 *  获取设备未分享的好友列表
 *
 *  @param deviceId  设备标识
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)deviceGetNotAuthUserWithDeviceId:(NSString *)deviceId
                             success:(successBlock)success
                             failure:(failureBlock)failure;





/**
 *  获取授权给好友的设备列表
 *
 *  @param deviceId  设备标识
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)deviceGetAuthFriendWithFriendId:(NSString *)friendId
                                success:(successBlock)success
                                failure:(failureBlock)failure;




/**
 *  获取未授权给好友的设备列表
 *
 *  @param deviceId  设备标识
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)deviceGetNotAuthFriendWithFriendId:(NSString *)friendId
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


/**
 *  消息列表
 *
 *  @param messageId  消息标识，只有上拉时传值，下拉时不能传值
 *  @param pageRows  每页数据大小
 *  @param pageIndex 加载第几页
 *  @param success   成功的回调
 *  @param failure   失败的回调
 
 字段名称	字段类型	字段说明
 messageId	number	消息标识
 title	string	标题
 description	string	描述
 businessParam	string	业务参数的值(系统推送消息对应消息详情URL(businessParam为空时不要跳转)；添加好友消息对应用户Id，控制设备消息对应设备ID，查看帖子评论对应帖子详情URL。）
 sender	number	发送者ID
 icon	string	图标URL
 messageType	number	消息类型：0-系统消息；1-添加好友；2-邀请控制设备；3-查看帖子评论；5-运营互动；其他后续补充
 createTime	number	时间戳
 status	number	消息状态(0-删除；1-未处理；2-已处理)
 level2	number	(系统消息的时候如果操作类标识)系统消息下的二级分类：1-无正文；2-文本H5；3-外链；4-设备
 content	String	(表示设备信息时候建议接口调用时传json格式值)系统消息内容
 readed	number	消息是否已读（0-已读 1-未读）
 readonly	number	消息是否只读（0-只读类 1-操作类）
 summary	String	简要描述
 pictureUrl	String	简图路径
 */
+(void)fetchMessageListByPageWithMessageId:(NSString*)messageId
                                  pageRows:(NSString *)pageRows
                                 pageIndex:(NSString *)pageIndex
                                   success:(successBlock)success
                                   failure:(failureBlock)failure;

@end
