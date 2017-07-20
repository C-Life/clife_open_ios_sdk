//
//  testMarvell.m
//  Pods
//
//  Created by mr.cao on 16/11/25.
//
//

#import "MarvellV2Factory.h"

#import "zlib.h"//marvell
#import <SystemConfiguration/CaptiveNetwork.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <netinet/in.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#include <arpa/inet.h>

@interface MarvellV2Factory()<NSNetServiceBrowserDelegate>

{
    //marvell
    NSTimer *timer;
    NSTimer *timerMdns;
    int TimerCount;
    char ssid[33];
    int Mode;
    unsigned char bssid[6];
    unsigned char preamble[6];
    char passphrase[64];
    int passLen;
    int passLength;
    unsigned int ssidLength;
    int invalidKey;
    int invalidPassphrase;
    unsigned long passCRC;
    unsigned long ssidCRC;
    NSInteger _state;
    NSInteger _substate;
    
    Byte customData[16];
    int customDataLen;
    unsigned long customDataCRC;
    int encryptedCustomDataLen;
    Byte encryptedCustomData[16];
    int timerCount;
    int flag;
    //marvell
    
    
}

@property(nonatomic,strong)NSString *currentssid;//ssid
@property(strong,nonatomic)NSString  *wifiPassword;//wifi密码

@end
@implementation MarvellV2Factory

-(void)startSendSSID:(NSString *)currentssid withPassWord:(NSString *)psw
{
    flag=1;
    self.wifiPassword=psw;
    self.currentssid=currentssid;
    [self xmitterTaskv2];
}

-(void)stopSend
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(xmitterTaskv2) object:nil];
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    if ([timerMdns isValid]) {
        [timerMdns invalidate];
        timerMdns = nil;
    }
    
}
-(void) mdnsFound
{
    timerCount--;
    if (!timerCount) {
        [timerMdns invalidate];
        timerMdns = nil;
        [self performSelector:@selector(xmitterTaskv2) withObject:nil afterDelay:2];
        
    }
}
-(void)xmitterTaskv2
{
    [self currentWifiSSID];
    const char *temp = [self.wifiPassword UTF8String];
    strcpy(passphrase, temp);
    passLength = (int)self.wifiPassword.length;
    passLen = passLength;
    unsigned char *str = (unsigned char *)temp;
    unsigned char *str1 = (unsigned char *)ssid;
    int i;
    
    passCRC = crc32(0, str, passLen);
    ssidCRC = crc32(0, str1, ssidLength);
    
    passCRC = passCRC & 0xffffffff;
    ssidCRC = ssidCRC & 0xffffffff;
    
    NSString *customDataString =nil;
    for (i = 0; i < sizeof(customData); i++)
        customData[i] = 0x00;
    if ([customDataString length] % 2) {
        customDataLen = 0;
        customDataCRC = 0;
    } else {
        customDataLen = (int)[customDataString length] / 2;
        for (int i = 0; i < [customDataString length]; i += 2) {
            NSString *word = [customDataString substringWithRange:NSMakeRange(i, 2)];
            unsigned int c;
            [[NSScanner scannerWithString:word] scanHexInt:&c];
            customData[i/2] = c;
        }
        if (customDataLen % 16 == 0) {
            encryptedCustomDataLen = customDataLen;
        } else {
            encryptedCustomDataLen = ((customDataLen / 16) + 1) * 16;
        }
        
        customDataCRC = crc32(0, customData, encryptedCustomDataLen);
        customDataCRC = customDataCRC & 0xffffffff;
    }
    timer=  [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(statemachinev2) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}
-(void)statemachinev2
{
    NSString *temp;
    if (_state == 0 && _substate == 0) {
        TimerCount++;
    }
    if (TimerCount >= 300) {
        [self queryMdnsService];
        NSLog(@"Browsing services");
        timerCount = 15;
        timerMdns =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(mdnsFound) userInfo:nil repeats:YES];
        
        if ([timer isValid] && [timer isKindOfClass:[NSTimer class]]) {
            [timer invalidate];
            timer = nil;
        }
        _state = 0;
        _substate = 0;
        TimerCount = 0;
        flag = 1;
    }
    
    switch(_state) {
        case 0:
            if (_substate == 3) {
                _state = 1;
                _substate = 0;
            } else {
                [self xmitState0v2:_substate];
                _substate++;
            }
            break;
        case 1:
            
            [self xmitState1v2:_substate LengthSSID:2];
            _substate++;
            if (ssidLength % 2 == 1) {
                if (_substate * 2 == ssidLength + 5) {
                    [self xmitState1v2:_substate LengthSSID: 1];
                    _state = 2;
                    _substate = 0;
                }
            } else {
                if ((_substate - 1) * 2 == (ssidLength + 4)) {
                    _state = 2;
                    _substate = 0;
                }
            }
            break;
        case 2:
            [self xmitState2v2:_substate LengthPassphrase:2];
            
            _substate++;
            if (passLen % 2 == 1) {
                if (_substate * 2 == passLen + 5) {
                    [self xmitState2v2:_substate LengthPassphrase: 1];
                    _state = 3;
                    _substate = 0;
                }
            } else {
                if ((_substate - 1) * 2 == (passLen + 4)) {
                    _state = 3;
                    _substate = 0;
                }
            }
            break;
        case 3:
            [self xmitState3v2:_substate LengthCustomData:2];
            
            _substate++;
            if (encryptedCustomDataLen % 2 == 1) {
                if (_substate * 2 == encryptedCustomDataLen + 5) {
                    [self xmitState3v2:_substate LengthCustomData: 1];
                    _state = 0;
                    _substate = 0;
                }
            } else {
                if ((_substate - 1) * 2 == (encryptedCustomDataLen + 4)) {
                    _state = 0;
                    _substate = 0;
                }
            }
            break;
            
        default:
            NSLog(@"MRVL: I should not be here!");
    }
}

-(void)xmitState0v2:(int)substate
{
    int i, j, k;
    
    k = preamble[2  * substate];
    j = preamble[2 * substate + 1];
    i = substate | 0x78;
    [self xmitRawv2:i data: j substate: k];
}

-(void)xmitState1v2:(int)substate LengthSSID:(int)len
{
    if (substate == 0) {
        int u = 0x40;
        [self xmitRawv2:u data:ssidLength substate: ssidLength];
    } else if (substate == 1 || substate == 2) {
        int k = (int) (ssidCRC >> ((2 * (substate - 1) + 0) * 8)) & 0xff;
        int j = (int) (ssidCRC >> ((2 * (substate - 1) + 1) * 8)) & 0xff;
        int i = substate | 0x40;
        [self xmitRawv2:i data: j substate: k];
    } else {
        int u = 0x40 | substate;
        int l = (0xff & ssid[(2 * (substate - 3))]);
        int m;
        if (len == 2)
            m = (0xff & ssid[(2 * (substate - 3) + 1)]);
        else
            m = 0;
        [self xmitRawv2:u data:m substate:l];
    }
}

-(void)xmitState2v2: (int)substate LengthPassphrase:(int)len
{
    if (substate == 0) {
        int u = 0x00;
        [self xmitRawv2:u data:passLen substate: passLen];
    } else if (substate == 1 || substate == 2) {
        int k = (int) (passCRC >> ((2 * (substate - 1) + 0) * 8)) & 0xff;
        int j = (int) (passCRC >> ((2 * (substate - 1) + 1) * 8)) & 0xff;
        int i = substate;
        [self xmitRawv2:i data: j substate: k];
    } else {
        int u = substate;
        int l = (0xff & passphrase[(2 * (substate - 3))]);
        int m;
        if (len == 2)
            m = (0xff & passphrase[(2 * (substate - 3)) + 1]);
        else
            m = 0;
        [self xmitRawv2:u data:m substate:l];
    }
}


-(void)xmitState3v2:(int)substate LengthCustomData: (int)len
{
    if (substate == 0) {
        int i = 0x60;
        [self xmitRawv2:i data:customDataLen substate: customDataLen];
    } else if (substate == 1 || substate == 2) {
        int k = (int) (customDataCRC >> ((2 * (substate - 1) + 0) * 8)) & 0xff;
        int j = (int) (customDataCRC >> ((2 * (substate - 1) + 1) * 8)) & 0xff;
        int i = substate | 0x60;
        [self xmitRawv2:i data: j substate: k];
    } else {
        int u = substate | 0x60;
        int l = (0xff & encryptedCustomData[(2 * (substate - 3))]);
        int m;
        if (len == 2)
            m = (0xff & encryptedCustomData[(2 * (substate - 3)) + 1]);
        else
            m = 0;
        [self xmitRawv2:u data:m substate:l];
    }
}
-(void) xmitRawv2:(int) u data:(int) m substate:(int) l
{
    int sock;
    struct sockaddr_in addr;
    char buf = 'a';
    
    NSMutableString* getnamebyaddr = [NSMutableString stringWithFormat:@"239.%d.%d.%d", u, m, l];
    const char * d_addr = [getnamebyaddr UTF8String];
    
    if ((sock = socket(PF_INET, SOCK_DGRAM, 0)) < 0) {
        NSLog(@"ERROR: broadcastMessage - socket() failed");
        return;
    }
    
    bzero((char *)&addr, sizeof(struct sockaddr_in));
    
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr(d_addr);
    addr.sin_port        = htons(10000);
    
    if ((sendto(sock, &buf, sizeof(buf), 0, (struct sockaddr *) &addr, sizeof(addr))) != 1) {
        NSLog(@"Errno %d", errno);
        NSLog(@"ERROR: broadcastMessage - sendto() sent incorrect number of bytes");
        close(sock);
        return;
    }
    
    close(sock);
}
-(void)queryMdnsService
{
    NSNetServiceBrowser *serviceBrowser;
    
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [serviceBrowser setDelegate:self];
    [serviceBrowser searchForServicesOfType:@"_ezconnect-prov._tcp" inDomain:@"local"];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing
{
    
    NSLog(@"More coming");
    
}

-(NSString *)currentWifiSSID
{
    // Does not work on the simulator.
    NSString *ssid_str = nil;
    
    NSString *bssid_str = nil;
    NSArray *testArray = [[NSArray alloc] init];
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    NSString *temp;
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        NSLog(@"String %@", info);
        if (info[@"SSID"]) {
            ssid_str = info[@"SSID"];
            NSLog(@"ssid %@", ssid_str);
            for(int i = 0 ;i < [ssid_str length]; i++) {
                ssid[i] = [ssid_str characterAtIndex:i];
            }
            ssidLength = ssid_str.length;
            bssid_str = info[@"BSSID"];
            NSLog(@"bssid %@", bssid_str);
            testArray = [bssid_str componentsSeparatedByString:@":"];
            NSScanner *aScanner;
            unsigned int te;
            for (int i = 0; i < 6; i++) {
                temp = [testArray objectAtIndex:i];
                aScanner = [NSScanner scannerWithString:temp];
                [aScanner scanHexInt: &te];
                bssid[i] = te;
            }
            
            preamble[0] = 0x45;
            preamble[1] = 0x5a;
            preamble[2] = 0x50;
            preamble[3] = 0x52;
            preamble[4] = 0x32;
            preamble[5] = 0x32;
        }
    }
    return ssid_str;
}




@end

