//
//  ELIANBroadcast_SSID_Password.m
//  HETOpenSDKDemo
//
//  Created by hcc on 2017/2/22.
//  Copyright © 2017年 HET. All rights reserved.
//

#import "ELIANBroadcast_SSID_Password.h"
#import "elian.h"
@interface ELIANBroadcast_SSID_Password()
{
    NSString *_m_ssid;
    NSString *_m_password;
    NSString *_m_authmode;
}
@end
@implementation ELIANBroadcast_SSID_Password

void *context = NULL;

- (void)OnSend:(unsigned int)flag
{
    const char *ssid = [_m_ssid cStringUsingEncoding:NSASCIIStringEncoding];
    const char *s_authmode = [_m_authmode cStringUsingEncoding:NSASCIIStringEncoding];
    int authmode = atoi(s_authmode);
    const char *password = [_m_password cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char target[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
    NSLog(@"OnSend: ssid = %s, authmode = %d, password = %s", ssid, authmode, password);
    if (context)
    {
        elianStop(context);
        elianDestroy(context);
        context = NULL;
    }
    context = elianNew(NULL, 0, target, flag);
    if (context == NULL)
    {
        NSLog(@"OnSend elianNew fail");
        return; }
    elianPut(context, TYPE_ID_AM, (char *)&authmode, 1); elianPut(context, TYPE_ID_SSID, (char *)ssid, strlen(ssid)); elianPut(context, TYPE_ID_PWD, (char *)password, strlen(password));
    elianStart(context);
}
/**
 *  开始广播即将连接的路由器SSID和密码给指定厂商的WIFI模组设备
 */
- (void)startBroadcast_SSID:(NSString *)ssid
                   Password:(NSString *)password
{
    _m_ssid     = ssid;
    _m_password = password;
    _m_authmode = @"7";
    [self OnSend:ELIAN_SEND_V4];
}
/**
 *  停止广播SSID和密码给指定厂商的WIFI模组设备
 */
- (void)stopBroadcast
{
    elianStop(context);
}
@end
