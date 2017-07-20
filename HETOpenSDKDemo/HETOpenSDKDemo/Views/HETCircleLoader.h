//
//  HETCircleLoader.h
//  HETCircleLoader
//
//  Created by hcc on 16/8/30.
//  Copyright © 2016年 HET. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

typedef void(^cancelBindBlock)();


@interface HETCircleLoader : UIView
@property(nonatomic,copy) NSString *progressStr;
@property(nonatomic,copy) cancelBindBlock cancelBind;


- (void)start;
- (void)stop;
+ (HETCircleLoader *)showInView:(UIView *)view;
+ (BOOL)hideInView:(UIView *)view;
- (void )showInView:(UIView *)view;
- (BOOL)hideInView:(UIView *)view;


@end