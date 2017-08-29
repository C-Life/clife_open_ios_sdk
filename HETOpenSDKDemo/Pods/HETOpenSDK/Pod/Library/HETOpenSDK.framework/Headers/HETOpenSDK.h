//
//  HETOpenSDK.h
//  HETOpenSDK
//
//  Created by mr.cao on 16/4/26.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HETDevice.h"
#import "HETAccount.h"
#import "HETAuthorize.h"
#import "HETDeviceRequestBusiness.h"
#import "HETNetWorkRequestHeader.h"
#import "HETWIFIBindBusiness.h"
#import "HETDeviceControlBusiness.h"
#import "HETDeviceUpgradeBusiness.h"
#import "HETDeviceShareBusiness.h"




@interface HETOpenSDK : NSObject

/**
 *  注册第三方应用
 *
 *  @param appId    注册开发者账号时的appId
 *  @param appSecret 注册开发者账号时的appSecret
 *
 */
+ (void)registerAppId:(NSString *)appId
             appSecret:(NSString *)appSecret;



@end
