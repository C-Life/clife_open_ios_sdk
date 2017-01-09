//
//  HETAuthorize.h
//  openSDK
//
//  Created by peng on 6/25/15.
//  Copyright (c) 2015 peng All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HETAccount.h"


typedef void(^authenticationCompletedBlock)(HETAccount *account, NSError *error);
typedef void(^successBlock)(id responseObject);
typedef void(^failureBlock)( NSError *error);


@interface HETAuthorize : NSObject



/**
 *  是否授权认证
 *
 *  @return   YES为已经授权登录
 */
- (BOOL)isAuthenticated;


/**
 *  授权认证
 *
 *  @param completedBlock 授权认证回调
 */
- (void)authorizeWithCompleted:(authenticationCompletedBlock)completedBlock;


/**
 *  取消授权认证
 */
- (void)unauthorize;





/**
 *  获取用户信息
 *
 *  @param success
 *  @param failure
 */
-(void)getUserInformationSuccess:(successBlock)success
                         failure:(failureBlock)failure;

@end
