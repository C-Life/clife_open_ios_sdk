//
//  HFSmartLink.m
//  SmartlinkLib
//
//  Created by wangmeng on 15/3/16.
//  Copyright (c) 2015年 HF. All rights reserved.
//

#import "HFSmartLink.h"
//#import "UdpProxy.h"
#import "Udpproxy2.h"
//#import "PmkGenerator.h"
//#include "hf-pmk-generator.h"

#define SMTV30_BASELEN      76
#define SMTV30_STARTCODE      '\r'
#define SMTV30_STOPCODE       '\n'



@implementation HFSmartLink{
    SmartLinkProcessBlock processBlock;
    SmartLinkSuccessBlock successBlock;
    SmartLinkFailBlock failBlock;
    SmartLinkStopBlock stopBlock;
    SmartLinkEndblock endBlock;
    NSString * pswd;
    char cont[200];
    int cont_len;
    BOOL isconnnecting;
    BOOL userStoping;
    NSInteger sendTime;
    NSMutableDictionary *deviceDic;
    Udpproxy2 * udp;
    BOOL withV3x;
}

+(instancetype)shareInstence{
    static HFSmartLink * me = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
         me = [[HFSmartLink alloc]init];
    });
    return me;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /**
         *  初始化 套接字
         */
//        [UdpProxy shaInstence];
        udp = [Udpproxy2 shareInstence];
        deviceDic = [[NSMutableDictionary alloc]init];
        self.isConfigOneDevice = true;
        self.waitTimers = 30;//15;
        withV3x=true;
    }
    return self;
}


-(void)startWithKey:(NSString *)key processblock:(SmartLinkProcessBlock)pblock successBlock:(SmartLinkSuccessBlock)sblock failBlock:(SmartLinkFailBlock)fblock endBlock:(SmartLinkEndblock)eblock{
    
    if(udp){
        [udp CreateBindSocket];
    }else{
        udp = [Udpproxy2 shareInstence];
        [udp CreateBindSocket];
    }
    
    pswd = key;
    processBlock = pblock;
    successBlock = sblock;
    failBlock = fblock;
    endBlock = eblock;
    sendTime = 0;
    userStoping = false;
    [deviceDic removeAllObjects];
    if(isconnnecting){
        failBlock(@"is connecting ,please stop frist!");
        return ;
    }
    isconnnecting = true;
    //开始配置线程
    [[[NSOperationQueue alloc]init]addOperationWithBlock:^(){
        [self connect];
    }];
    
}

-(void)startWithContent:(char *)content lenght:(int)len key:(NSString *)key withV3x:(BOOL)v3x processblock:(SmartLinkProcessBlock)pblock successBlock:(SmartLinkSuccessBlock)sblock failBlock:(SmartLinkFailBlock)fblock endBlock:(SmartLinkEndblock)eblock;
{
    withV3x=v3x;
    if(udp){
        [udp CreateBindSocket];
    }else{
        udp = [Udpproxy2 shareInstence];
        [udp CreateBindSocket];
    }
    
    pswd=key;
    memcpy(cont, content, len);
    cont_len=len;
    // print content
    NSLog(@"***To Print Content***");
    char output[500];
    memset(output, 0, 500);
    for (int i=0;i<cont_len;i++){
        sprintf(output, "%s %X", output, (unsigned char)cont[i]);
    }
    NSLog(@"%s", output);
    processBlock = pblock;
    successBlock = sblock;
    failBlock = fblock;
    endBlock = eblock;
    sendTime = 0;
    userStoping = false;
    [deviceDic removeAllObjects];
    if(isconnnecting){
        failBlock(@"is connecting ,please stop frist!");
        return ;
    }
    isconnnecting = true;
    //开始配置线程
    [[[NSOperationQueue alloc]init]addOperationWithBlock:^(){
        [self connect];
    }];
    
    NSLog(@"start waitting module msg ");
    /*NSInteger waitCount = 0;
    while (waitCount < self.waitTimers&&isconnnecting) {
        [udp sendSmartLinkFind];
        sleep(1);
        waitCount++;
//        dispatch_async(dispatch_get_main_queue(), ^(){
//            processBlock(sendTime-1+waitCount);
//        });
        processBlock(waitCount*100/self.waitTimers);
    }
    isconnnecting = false;*/
    
//    dispatch_async(dispatch_get_main_queue(), ^(){
//        processBlock(18);
//    });
}


-(void)stopWithBlock:(SmartLinkStopBlock)block{
    stopBlock = block;
    isconnnecting = false;
    userStoping = true;
}
-(void)closeWithBlock:(SmartLinkCloseBlock)block{
    if(isconnnecting){
        dispatch_async(dispatch_get_main_queue(), ^(){
            block(@"please stop connect frist",false);
        });
    }
//    if([UdpProxy shaInstence]){
//        [[UdpProxy shaInstence] close];
//        dispatch_async(dispatch_get_main_queue(), ^(){
//            block(@"close Ok",true);
//        });
//    }else{
//        dispatch_async(dispatch_get_main_queue(), ^(){
//            block(@"udp sock is Closed,on need Close more",false);
//        });
//    }
    
    if(udp){
        [udp close];
        dispatch_async(dispatch_get_main_queue(), ^(){
            block(@"close Ok",true);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(){
            block(@"udp sock is Closed,on need Close more",false);
        });
    }
}

#pragma Send and Rcv

-(void)connect{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    while (isconnnecting&&sendTime <= 13) {
        
        for (int i = 0; i<200&&isconnnecting; i++) {
            [self sendOnePackageByLen:SMTV30_BASELEN];
            usleep(10000);
        }
        
        for (int i = 0; i<3&&isconnnecting; i++) {
            [self sendOnePackageByLen:SMTV30_BASELEN+SMTV30_STARTCODE];
            usleep(50000);
        }
        
        for (int i = 0; i<pswd.length&&isconnnecting; i++) {
             NSInteger code=SMTV30_BASELEN+ [pswd characterAtIndex:i];
            [self sendOnePackageByLen:code];
            usleep(50000);
        }
        
        for (int i = 0 ; i<3&&isconnnecting; i++) {
            [self sendOnePackageByLen:SMTV30_BASELEN+SMTV30_STOPCODE];
            usleep(50000);
        }
        
        for (int i = 0; i<3&&isconnnecting; i++) {
            [self sendOnePackageByLen:SMTV30_BASELEN+pswd.length+256];
            usleep(50000);
        }
        sendTime++;
        NSLog(@"send time %d",sendTime);
        dispatch_async(dispatch_get_main_queue(), ^(){
            processBlock(sendTime);
        });
    }
    
    //开始接收线程
    /*[[[NSOperationQueue alloc]init]addOperationWithBlock:^(){
        NSLog(@"start recv");
        [self recvNewModule];
    }];
    
    NSLog(@"start waitting module msg ");
    /*NSInteger waitCount = 0;
    while (waitCount < self.waitTimers&&isconnnecting) {
        [udp sendSmartLinkFind];
        sleep(1);
        waitCount++;
        dispatch_async(dispatch_get_main_queue(), ^(){
            processBlock(sendTime-1+waitCount);
        });
    }
    isconnnecting = false;
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        processBlock(18);
    });*/
        
    });
}

-(void)connectV70{
    //开始接收线程
    [[[NSOperationQueue alloc]init]addOperationWithBlock:^(){
        NSLog(@"start recv");
        [self recvNewModule];
    }];

    int flyTime=0;      // unit:10ms
    while (isconnnecting) {
        char cip[20];
        char c[100];
        memset(c, 0, 100);
        int sn=0;
        
        for (int i=0;i<sn+30;i++){
            c[i]='a';
        }
        
        for (int i=0;i<5;i++){
            [udp sendMCast:c withAddr:"239.48.0.0" andSN:0];
            usleep(10000);
            [self sendSmtlkV30:flyTime];
            flyTime++;
        }
        
        while (isconnnecting&&(sn*2<cont_len)) {
            memset(cip, 0, 20);
            sprintf(cip, "239.46.%d.%d",(unsigned char)cont[sn*2],(unsigned char)cont[sn*2+1]);
//            NSLog(@"%X %X", (unsigned char)cont[sn*2],(unsigned char)cont[sn*2+1]);
            [udp sendMCast:c withAddr:cip andSN:0];
            usleep(10000);
            [self sendSmtlkV30:flyTime];
            flyTime++;
            c[sn+30]='a';
            sn++;
        }

        if (isconnnecting){
            sendTime++;
            NSLog(@"send time %d",sendTime);
            dispatch_async(dispatch_get_main_queue(), ^(){
                processBlock(sendTime);
            });
        }
        
        for (int i=0;i<5;i++){
            usleep(10000);
            [self sendSmtlkV30:flyTime];
            flyTime++;
        }
    }
}

- (void) sendSmtlkV30:(int)ft
{
    if (withV3x==false)
        return;
    
    while (ft>= 200+(3+pswd.length+6)*5){
        ft-=200+(3+pswd.length+6)*5;
    }
    
    if (ft< 200){
        [self sendOnePackageByLen:SMTV30_BASELEN];
    }else if (ft % 5 == 0){
        int ft5=(ft-200)/5;
        if (ft5<3){
            [self sendOnePackageByLen:SMTV30_BASELEN+SMTV30_STARTCODE];
        }else if (ft5<3+pswd.length){
            int code=SMTV30_BASELEN+ [pswd characterAtIndex:(ft5-3)];
            [self sendOnePackageByLen:code];
            NSLog(@"code:%X", (unsigned char)[pswd characterAtIndex:(ft5-3)]);
        }else if (ft5<3+pswd.length+3){
            [self sendOnePackageByLen:SMTV30_BASELEN+SMTV30_STOPCODE];
        }else if (ft5< 3+pswd.length+6){
            [self sendOnePackageByLen:SMTV30_BASELEN+pswd.length+256];
        }
    }
}

-(void)sendOnePackageByLen:(NSInteger)len{
    char data[len+1];
    memset(data, 5, len);
    data[len]='\0';
    [udp send:data];
}
-(void)recvNewModule{
    while (isconnnecting) {
        HFSmartLinkDeviceInfo * dev = [udp recv];
        if(dev == nil){
            continue;
        }
        
        if([deviceDic objectForKey:dev.mac] != nil){
            continue;
        }

        [deviceDic setObject:dev forKey:dev.mac];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            successBlock(dev);
        });
        
        if (self.isConfigOneDevice) {
            NSLog(@"end config once");
            isconnnecting = false;
            dispatch_async(dispatch_get_main_queue(), ^(){
                endBlock(deviceDic);
            });
            [udp close];
            return ;
        }
    }
    
    if(userStoping){
        dispatch_async(dispatch_get_main_queue(), ^(){
            stopBlock(@"stop connect ok",true);
        });
    }
    
    if(deviceDic.count <= 0&&!userStoping){
        dispatch_async(dispatch_get_main_queue(), ^(){
            failBlock(@"smartLink fail ,no device is configed");
        });
    }
    
    [udp close];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        endBlock(deviceDic);
    });
}

@end
