//
//  BaseViewController.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <HETOpenSDK/HETOpenSDK.h>

#define isCCiPhone6 (([[UIScreen mainScreen] bounds].size.width>320)&&([[UIScreen mainScreen] bounds].size.width<=375))
#define isCCiPhone6Plus (([[UIScreen mainScreen] bounds].size.width>375)&&([[UIScreen mainScreen] bounds].size.width<=414))

#define isCCiPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define isCCiPhone4 ([[UIScreen mainScreen] bounds].size.height <568)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define CC_scale  (float)CCViewWidth/640.0
#define CC_lineHeight 0.5
#define IOS_IS_AT_LEAST_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.25f

#define  CCViewHeight \
(IOS_IS_AT_LEAST_7? (\
((self.edgesForExtendedLayout==UIRectEdgeNone ||(self.edgesForExtendedLayout==UIRectEdgeAll &&(!((UINavigationController*)[self valueForKey:@"navigationController"]).navigationBar.translucent))))\
?([UIScreen mainScreen].bounds.size.height-64)\
:([UIScreen mainScreen].bounds.size.height))\
:([UIScreen mainScreen].bounds.size.height-44))


#define  CCViewWidth [[UIScreen mainScreen] bounds].size.width

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;




@interface BaseViewController : UIViewController
//设置导航条标题
-(void)setNavigationBarTitle:(NSString *)title;
-(void)setLeftBarButtonItemHide:(BOOL)hide;
-(UIColor *) colorFromHexRGB:(NSString *) inColorString;
@end
