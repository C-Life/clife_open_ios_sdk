//
//  Udpproxy2.m
//  SmartlinkLib
//
//  Created by wangmeng on 15/4/15.
//  Copyright (c) 2015年 HF. All rights reserved.
//


#import "Udpproxy2.h"
#import "HFSmartLinkDeviceInfo.h"

#include <stdio.h> /* These are the usual header files */
#include <string.h>
#include <unistd.h> /* for close() */
#include <sys/types.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <ifaddrs.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>


#define PORT 49999 /* Port that will be opened */
#define MPORT 45999 /* Port that will be opened */
#define MAXDATASIZE 100 /* Max number of bytes of data */

@implementation Udpproxy2{
    int sockfd; /* socket descriptors */
    int sockMCast;
    struct sockaddr_in localAdd; /* server's address information */
    struct sockaddr_in clientAdd; /* client's address information */
    struct sockaddr_in remoteAdd;
    struct sockaddr_in findAdd;
    socklen_t remote_addr_len,find_addr_len;
    int num;
    char recvmsg[MAXDATASIZE]; /* buffer for message */
    char sendmsg[MAXDATASIZE];
}

+(instancetype)shareInstence{
    static Udpproxy2 *me = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[Udpproxy2 alloc]init];
    });
    return me;
}

-(void)CreateBindSocket{
    if ((sockMCast = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1) {
        /* handle exception */
        NSLog(@"Creating socket failed.");
        return;
    }
    
    char loop=0, ttl=255, reuse=1;
    struct ip_mreq mcast;
    int ret=setsockopt(sockMCast, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));
    ret=setsockopt(sockMCast, IPPROTO_IP, IP_MULTICAST_LOOP, &loop, sizeof(loop));
    ret=setsockopt(sockMCast, IPPROTO_IP, IP_MULTICAST_TTL, &ttl, sizeof(ttl));
    mcast.imr_interface.s_addr=htonl (INADDR_ANY);
    mcast.imr_multiaddr.s_addr=inet_addr("224.0.0.251");
    if (setsockopt(sockMCast, IPPROTO_IP, IP_ADD_MEMBERSHIP, (char *)&mcast, sizeof(mcast))<0){
        NSLog(@"add membership error");
        return;
    }
    
    bzero(&localAdd,sizeof(localAdd));
    localAdd.sin_family=AF_INET;
    localAdd.sin_port=htons(MPORT);
    localAdd.sin_addr.s_addr = htonl (INADDR_ANY);
    if (bind(sockMCast, (struct sockaddr *)&localAdd, sizeof(struct sockaddr)) < 0) {
        /* handle exception */
        NSLog(@"Bind error");
        return;
    }
    
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
        /* handle exception */
        NSLog(@"Creating socket failed.");
        return;
    }
    int i=1;
    socklen_t len = sizeof(i);
    setsockopt(sockfd,SOL_SOCKET,SO_BROADCAST,&i,len);
    struct timeval timeout={1,0};
    setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
    int set=1;
    setsockopt(sockfd, SOL_SOCKET, SO_NOSIGPIPE, (char *)&set, sizeof(set));

    bzero(&localAdd,sizeof(localAdd));
    localAdd.sin_family=AF_INET;
    localAdd.sin_port=htons(PORT);
    localAdd.sin_addr.s_addr = htonl (INADDR_ANY);
    if (bind(sockfd, (struct sockaddr *)&localAdd, sizeof(struct sockaddr)) < 0) {
        /* handle exception */
        NSLog(@"Bind error");
        return;
    }

    memset(&findAdd,0,sizeof(findAdd));
    findAdd.sin_family = AF_INET;
    findAdd.sin_addr.s_addr = inet_addr([self localBroadCastIP].UTF8String);
    findAdd.sin_port = htons(48899);
    find_addr_len=sizeof(findAdd);
    
    memset(&remoteAdd,0,sizeof(remoteAdd));
    remoteAdd.sin_family = AF_INET;
    remoteAdd.sin_addr.s_addr = inet_addr([self localBroadCastIP].UTF8String);
    remoteAdd.sin_port = htons(49999);
    remote_addr_len=sizeof(remoteAdd);
}
-(int)initSendSock{
    if((sockfd = socket(PF_INET,SOCK_DGRAM,0)) < 0)
    {
        NSLog(@"create send socket error");
        return -1;
    }
    
    int i=1;
    socklen_t len = sizeof(i);
    setsockopt(sockfd,SOL_SOCKET,SO_BROADCAST,&i,len);
    int set=1;
    setsockopt(sockfd, SOL_SOCKET, SO_NOSIGPIPE, (char *)&set, sizeof(set));
    
   memset(&remoteAdd,0,sizeof(remoteAdd));
    remoteAdd.sin_family = AF_INET;
    remoteAdd.sin_addr.s_addr = inet_addr([self localBroadCastIP].UTF8String);
    remoteAdd.sin_port = htons(49999);
    remote_addr_len=sizeof(remoteAdd);
    return  1;
}
-(void)send:(char*)shit{
    //printf("send %lu\n",strlen(shit));
    NSInteger len = sendto(sockfd, shit, strlen(shit), 0, (struct sockaddr*)&remoteAdd, remote_addr_len);
    if(len<0){
//        NSLog(@"send errr----->%d",sockfd);
        //close(sockfd);
        //[self initSendSock];
        return ;

    }
    return ;
}

-(void)sendMCast:(char*)shit withAddr:(char *)addr andSN:(int)sn
{
    struct sockaddr_in ra;
    int ra_l;
    memset(&ra,0,sizeof(ra));
    ra.sin_family = AF_INET;
    ra.sin_addr.s_addr = inet_addr(addr);
    ra.sin_port = htons(49999);
    ra_l=sizeof(ra);

    NSInteger len=sendto(sockMCast, shit, strlen(shit), 0, (struct sockaddr*)&ra, ra_l);
    if(len<0){
        NSLog(@"send errr");
    }
    return ;
}

-(void)sendSmartLinkFind{
    
    char data[] = "smartlinkfind";
    sendto(sockfd, data, strlen(data), 0, (const struct sockaddr *)&findAdd, find_addr_len);
}

-(HFSmartLinkDeviceInfo*)recv{
    char recvbuf[512]={0};
    //memset(recvbuf, 0, 512);
    socklen_t recv_addr_len = sizeof(clientAdd);
    NSInteger len  = recvfrom(sockfd,recvbuf,512,0,(struct sockaddr*)&clientAdd,&recv_addr_len);
    
    if(len < 0){
        return nil;
    }
    
//    NSLog(@"recv : %s",recvbuf);
    if(strncmp(recvbuf, "smart_config", strlen("smart_config"))==0){
        NSLog(@"recv : %s",recvbuf);
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
                dev.ip = [NSString stringWithFormat:@"%s",inet_ntoa(clientAdd.sin_addr)];
                return dev;
            }
        }
    }
    return nil;
}


-(void)close{
    if(sockfd!=-1)
    {
       close(sockfd);
        sockfd=-1;
    }
    if(sockMCast!=-1)
    {
      close(sockMCast);
        sockMCast=-1;
    }
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
