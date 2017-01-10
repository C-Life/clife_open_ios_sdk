//
//  UdpProxy.h
//  SmartlinkLib
//
//  Created by wangmeng on 15/3/16.
//  Copyright (c) 2015年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFSmartLinkDeviceInfo.h"

@interface UdpProxy : NSObject
+(instancetype)shaInstence;
-(void)send:(char*)shit;
-(HFSmartLinkDeviceInfo*)recv;
-(void)close;
@end
