//
//  UdpProxy.m
//  SmartlinkLib
//
//  Created by wangmeng on 15/3/16.
//  Copyright (c) 2015年 HF. All rights reserved.
//

#import "UdpProxy.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <netinet/in.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#include <arpa/inet.h>

#define SMTV30UDPLOCALPORT 48899
#define SMTV30UDPRMPORT    49999 //49998


@implementation UdpProxy{
    int socketfd,recvsockfd;
    struct  sockaddr_in server_addr;
    struct  sockaddr_in local_sockaddr,remot_sockaddr;
    socklen_t addr_len,local_addr_len;
}

+(instancetype)shaInstence{
    static UdpProxy * me = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[UdpProxy alloc]init];
    });
    return me;
}
- (instancetype)init
{
    self = [super init];
    if (self) {

        if([self initSendSock]<0){
            NSLog(@"init send socket err");
        }
        
        if([self initRecvSock]<0){
            NSLog(@"intt recv socket err");
        }
    }
    return self;
}

-(int)initSendSock{
    if((socketfd = socket(PF_INET,SOCK_DGRAM,0)) < 0)
    {
        NSLog(@"create send socket error");
        return -1;
    }
    
    int i=1;
    socklen_t len = sizeof(i);
    setsockopt(socketfd,SOL_SOCKET,SO_BROADCAST,&i,len);
    int set=1;
    setsockopt(socketfd, SOL_SOCKET, SO_NOSIGPIPE, (char *)&set, sizeof(set));
    
    memset(&server_addr,0,sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr([self localBroadCastIP].UTF8String);
    server_addr.sin_port = htons(SMTV30UDPRMPORT);
    addr_len=sizeof(server_addr);
    return  1;
}
-(int)initRecvSock{
    if((recvsockfd = socket(PF_INET,SOCK_DGRAM,0)) < 0)
    {
        perror("socket");
        return -1;
    }
    
    struct timeval timeout={1,0};
    setsockopt(recvsockfd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
    int set=1;
    setsockopt(recvsockfd, SOL_SOCKET, SO_NOSIGPIPE, (char *)&set, sizeof(set));
    
    memset(&local_sockaddr,0,sizeof(local_sockaddr));
    local_sockaddr.sin_family = AF_INET;
    local_sockaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    local_sockaddr.sin_port = htons(SMTV30UDPRMPORT);
    local_addr_len=sizeof(local_sockaddr);
    
    if(bind(recvsockfd,(struct sockaddr*)&local_sockaddr,local_addr_len) < 0)
    {
        perror("bind");
        return -1;
    }
    return 1;
}

-(void)sendSmartLinkFind{
//    int findsockfd;
    struct  sockaddr_in find_addr;
    socklen_t find_addr_len;
//    
//    if((findsockfd = socket(PF_INET,SOCK_DGRAM,0)) < 0)
//    {
//        perror("socket");
//        return ;
//    }
    
    memset(&find_addr,0,sizeof(find_addr));
    find_addr.sin_family = AF_INET;
    find_addr.sin_addr.s_addr = inet_addr([self localBroadCastIP].UTF8String);
    find_addr.sin_port = htons(SMTV30UDPLOCALPORT);
    find_addr_len=sizeof(find_addr);
    char * data = "smartlinkfind";
    sendto(recvsockfd, data, strlen(data), 0, (const struct sockaddr *)&find_addr, find_addr_len);
    //close(findsockfd);
}

-(void)send:(char*)shit{
    //printf("send %lu\n",strlen(shit));
    
   int len = sendto(socketfd, shit, strlen(shit), 0, (struct sockaddr*)&server_addr, addr_len);
    if(len<0){
        NSLog(@"send error");
        close(socketfd);
        [self initSendSock];
        return ;
    }
    return ;
}
-(HFSmartLinkDeviceInfo*)recv{
    char recvbuf[512]={0};
    //memset(recvbuf, 0, 512);
    socklen_t remote_addr_len = sizeof(remot_sockaddr);
    int len  = recvfrom(recvsockfd,recvbuf,512,0,(struct sockaddr*)&remot_sockaddr,&remote_addr_len);
    
    if(len < 0){
        close(recvsockfd);
        [self initRecvSock];
        return nil;
    }
    
    NSLog(@"recv : %s",recvbuf);
    if(strncmp(recvbuf, "smart_config", strlen("smart_config"))==0){
        NSString * devStr = [NSString stringWithFormat:@"%s",recvbuf];
        HFSmartLinkDeviceInfo * dev = [[HFSmartLinkDeviceInfo alloc]init];
        
        NSArray *a = [devStr componentsSeparatedByString:@" "];
        
        
        if (a.count==2)
        {
            NSString * smartConfig =[a objectAtIndex:0];
            NSString * macID = [a objectAtIndex:1];
            
            if ([smartConfig isEqualToString:@"smart_config"] )
            {
                dev.mac = macID;
                dev.ip = [NSString stringWithFormat:@"%s",inet_ntoa(remot_sockaddr.sin_addr)];
                return dev;
            }
        }
    }
    return nil;
}
-(void)close{
    if(socketfd!=-1)
    {
        close(socketfd);
        socketfd=-1;
    }
    if(recvsockfd!=-1)
    {
        close(recvsockfd);
        recvsockfd=-1;
    }

    //close(socketfd);
    //close(recvsockfd);
}


-(NSString *)localBroadCastIP
{
    NSString *address = @"error";
    struct ifaddrs *interface = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    UInt32 uip,umask,ubroadip;
    
    success = getifaddrs(&interface);
    
    if(success == 0){
        temp_addr = interface;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name]isEqualToString:@"en0"]) {
                    uip = NTOHL(((struct sockaddr_in *)(temp_addr->ifa_addr))->sin_addr.s_addr);
                    umask = NTOHL((((struct sockaddr_in *)(temp_addr->ifa_netmask))->sin_addr).s_addr);
                    ubroadip = (uip&umask)+(0XFFFFFFFF&(~umask));
                    struct in_addr inadd;
                    inadd.s_addr = HTONL(ubroadip);
                    address = [NSString stringWithUTF8String:inet_ntoa(inadd)];
                    break;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interface);
    return address;
    
}


@end
