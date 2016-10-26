//
//  UIImage+bundle.m
//  NewBindDeviceProject
//
//  Created by mr.cao on 15/8/17.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "UIImage+hetbundle.h"

@implementation UIImage (hetbundle)

+ (UIImage *)hetimageWithFileName:(NSString *)filename bundle:(NSBundle *)bundle
{
    if(nil == bundle)
        bundle = [NSBundle mainBundle];
    NSString *path = nil;
    
    //3x
    if([[UIScreen mainScreen] respondsToSelector:@selector(nativeScale)])
    {
        CGFloat scale = [UIScreen mainScreen].nativeScale;
        if(nil == path)
            path = [bundle pathForResource:[filename stringByAppendingFormat:@"@%ix", (int)scale] ofType:@"png"];
    }
    
    //2x
    if(nil == path)
        path = [bundle pathForResource:[filename stringByAppendingString:@"@2x"] ofType:@"png"];
    
    //最后，找 1x 的图片
    if(nil == path)
        path = [bundle pathForResource:filename ofType:@"png"];
    
    
    
    if(nil == path)//从本地读取图片
        path = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
    
    if(nil == path)//从本地读取图片
        path = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
    if(nil==path)
    {
        return [UIImage imageNamed:filename];
    }
        
    
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)hetimageWithFileName:(NSString *)filename
{
    return [self hetimageWithFileName:filename bundle:[self hetresourceBundle]];
}
// 读取文件 deviceBind.bundle
+ (NSBundle *)hetresourceBundle
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"deviceBind" ofType:@"bundle"];
    NSBundle *ret = [NSBundle bundleWithPath:bundlePath];
    if(nil == ret)
    {
        NSLog(@"warning: inavlid bundle:%@ path:%@", ret, bundlePath);
    }
    return ret;
}

@end
