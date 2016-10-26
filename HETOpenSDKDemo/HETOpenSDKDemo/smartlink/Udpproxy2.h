//
//  Udpproxy2.h
//  SmartlinkLib
//
//  Created by wangmeng on 15/4/15.
//  Copyright (c) 2015年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFSmartLinkDeviceInfo.h"

@interface Udpproxy2 : NSObject
+(instancetype)shareInstence;
-(void)CreateBindSocket;
-(void)send:(char*)shit;
-(void)sendMCast:(char*)shit withAddr:(char *)addr andSN:(int)sn;
-(void)sendSmartLinkFind;
-(HFSmartLinkDeviceInfo*)recv;
-(void)close;
@end
