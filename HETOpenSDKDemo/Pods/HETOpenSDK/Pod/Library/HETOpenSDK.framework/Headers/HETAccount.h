//
//  HETAccount.h
//  HETOpenSDK
//
//  Created by peng on 6/25/15.
//  Copyright (c) 2015 peng All rights reserved.
//

#import <Foundation/Foundation.h>



// 登录帐号信息
@interface HETAccount : NSObject<NSCoding>

@property (nonatomic, copy) NSString *openId; //授权用户Id
@property (nonatomic, copy) NSString *accessToken; //授权凭证
@property (nonatomic, copy) NSString *refreshToken; //授权凭证
@property (nonatomic, strong) NSDate *expirationDate; //过期时间
@property (nonatomic, strong) NSDate *refreshTokenDate;
@property (nonatomic, assign) BOOL selected; //是否选中（当前用户）

@end
