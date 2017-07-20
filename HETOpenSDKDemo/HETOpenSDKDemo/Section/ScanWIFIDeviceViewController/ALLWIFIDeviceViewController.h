//
//  ALLWIFIDeviceViewController.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 15/6/25.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//  扫描到的所有WiFi设备列表

#import <UIKit/UIKit.h>
#import "HETBaseViewController.h"
@interface ALLWIFIDeviceViewController : HETBaseViewController

@property(nonatomic,strong)NSString  *wifiPassword;
@property(nonatomic,strong)NSString  *wifiSsid;

@property(nonatomic,strong)NSString *bindTypeStr;
@property(nonatomic,strong)NSString *deviceTypeStr;
@property(nonatomic,strong)NSString *deviceSubTypeStr;
@property(nonatomic,strong)NSString *moduleIdStr;
@property(nonatomic,strong)NSString *productId;
@end
