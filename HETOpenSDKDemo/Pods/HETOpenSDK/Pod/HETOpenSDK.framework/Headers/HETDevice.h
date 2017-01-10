//
//  HETDevice.h
//  HETOpenSDK
//
//  Created by mr.cao on 16/12/29.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETDevice : NSObject

@property (nonatomic, strong) NSString *authUserId;
@property (nonatomic, strong) NSString *bindTime;
@property (nonatomic, strong) NSNumber *bindType;
@property (nonatomic, strong) NSNumber *controlType;
@property (nonatomic, strong) NSNumber *deviceBrandId;
@property (nonatomic, strong) NSString *deviceBrandName;
@property (nonatomic, strong) NSString *deviceIcon;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *deviceModel;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSNumber *deviceSubtypeId;
@property (nonatomic, strong) NSString *deviceSubtypeName;
@property (nonatomic, strong) NSNumber *deviceTypeId;
@property (nonatomic, strong) NSString *deviceTypeName;
@property (nonatomic, strong) NSString *macAddress;
@property (nonatomic, strong) NSNumber *onlineStatus;
@property (nonatomic, strong) NSNumber *roomId;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSNumber *share;
@property (nonatomic, strong) NSString *userKey;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *moduleType;
@property (nonatomic, strong) NSString *productIcon;

@end
