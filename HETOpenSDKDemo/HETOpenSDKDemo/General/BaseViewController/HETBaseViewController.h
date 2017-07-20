//
//  HETBaseViewController.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HETOpenSDK/HETOpenSDK.h>
#import "Masonry.h"

#define IOS_IS_AT_LEAST_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.25f

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

static NSString * const StartWIFIBINDFACTORY_ShuangChi = @"StartWIFIBINDFACTORY_ShuangChi";
static NSString * const StopWIFIBINDFACTORY_ShuangChi = @"StopWIFIBINDFACTORY_ShuangChi";

@interface HETBaseViewController : UIViewController
//设置导航条标题
-(void)setNavigationBarTitle:(NSString *)title;
-(void)setLeftBarButtonItemHide:(BOOL)hide;
-(UIColor *) colorFromHexRGB:(NSString *) inColorString;
@end
