//
//  HETWIFIUpgradeViewController.h
//  HETOpenSDKDemo
//
//  Created by Newman on 15/8/10.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HETBaseViewController.h"
@interface HETWIFIUpgradeViewController : HETBaseViewController

@property (nonatomic,copy  ) NSString  * deviceId;
@property (nonatomic,copy  ) NSString  * versionType;
@property (nonatomic       ) NSInteger deviceVersionId;
@property (nonatomic,assign) NSInteger deviceTypeId;

/**
 *  升级一个设备中多个模块时，表示是第几个模块正在升级
 */
@property (nonatomic)    NSInteger  whichPacke;
@end
