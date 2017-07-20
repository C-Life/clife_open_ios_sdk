//
//  ESPBroadcast_SSID_Password.m
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 2016/12/11.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "ESPBroadcast_SSID_Password.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "ESPTouchResult.h"//乐鑫
#import "ESPTouchTask.h"//乐鑫

@interface ESPBroadcast_SSID_Password()
{
    NSString  *_ssid;//ssid
    NSString  *_password;//wifi密码
}
@property(nonatomic,strong)NSCondition *_condition;
// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;
@end
@implementation ESPBroadcast_SSID_Password
- (void)startBroadcast_SSID:(NSString *)ssid Password:(NSString *)password
{
    _ssid = ssid;
    _password = password;
    
    self._condition = [[NSCondition alloc]init];
    //            self._esptouchDelegate = [[EspTouchDelegateImpl alloc]init];
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"ESPViewController do the execute work...");
        // execute the task
        NSArray *esptouchResultArray = [self executeForResults];
        // show the result to the user in UI Main Thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //                    [self._spinner stopAnimating];
            //                    [self enableConfirmBtn];
            
            ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
            // check whether the task is cancelled and no results received
            if (!firstResult.isCancelled)
            {
                NSMutableString *mutableStr = [[NSMutableString alloc]init];
                NSUInteger count = 0;
                // max results to be displayed, if it is more than maxDisplayCount,
                // just show the count of redundant ones
                const int maxDisplayCount = 5;
                if ([firstResult isSuc])
                {
                    
                    for (int i = 0; i < [esptouchResultArray count]; ++i)
                    {
                        ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                        [mutableStr appendString:[resultInArray description]];
                        [mutableStr appendString:@"\n"];
                        count++;
                        if (count >= maxDisplayCount)
                        {
                            break;
                        }
                    }
                    
                    if (count < [esptouchResultArray count])
                    {
                        [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                    }
                }
                
            }
            
        });
    });
}
#pragma mark --WIFIBINDFACTORY_LX
// refer to http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

//the example of how to use executeForResults
- (NSArray *) executeForResults
{
    [self._condition lock];
    NSString *apSsid = _ssid;
    NSString *apPwd = _password;
    NSString *apBssid = [[self fetchNetInfo] objectForKey:@"BSSID"];//84:db:ac:b:f8:5c
    //    BOOL isSsidHidden = [self._isSsidHiddenSwitch isOn];
    //    int taskCount = [self._taskResultCountTextView.text intValue];
    self._esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:NO];
    // set delegate
    [self._esptouchTask setEsptouchDelegate:nil];
    [self._condition unlock];
    NSArray * esptouchResults = [self._esptouchTask executeForResults:1];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    return esptouchResults;
}
- (void)stopBroadcast
{
    [self._condition lock];
    if (self._esptouchTask != nil)
    {
        [self._esptouchTask interrupt];
    }
    [self._condition unlock];
}
@end
