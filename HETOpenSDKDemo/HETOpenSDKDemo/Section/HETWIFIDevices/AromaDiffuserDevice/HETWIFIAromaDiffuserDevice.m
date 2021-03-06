//
//  HETWIFIAromaDiffuserDevice.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/2/29.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETWIFIAromaDiffuserDevice.h"




@implementation AromaDiffuserDeviceConfigModel


@end



@implementation AromaDiffuserDeviceRunModel


@end






@interface HETWIFIAromaDiffuserDevice()

@property (nonatomic,strong   ) HETDeviceControlBusiness *business;








//运行数据block
@property (nonatomic,copy     ) DataBlock   runDataBlock;
//配置数据block
@property (nonatomic,copy     ) DataBlock   cfgDataBlock;
//是否需要回复
@property (nonatomic,assign   )    BOOL      needReplay;

//通信协议类型
//@property (nonatomic,assign   ) HETWIFIPROTOCOLTYPE wifiProtocolType;//WiFi产品通信协议类型

@end


@implementation HETWIFIAromaDiffuserDevice

- (instancetype)initWithHetDeviceModel:(HETDevice *)device
           deviceRunDataSuccess:(void(^)(AromaDiffuserDeviceRunModel *model))runDataSuccessBlock
              deviceRunDataFail:(void(^)(NSError *error))runDataFailBlock
           deviceCfgDataSuccess:(void(^)(AromaDiffuserDeviceConfigModel *model))cfgDataSuccessBlock
              deviceCfgDataFail:(void(^)(NSError *error))cfgDataFailBlock
{
    self =[super init];
    if(self)
    {
        
        
        _business=[[HETDeviceControlBusiness alloc]initWithHetDeviceModel:(HETDevice *)device isSupportLittleLoop:YES deviceRunData:^(id responseObject) {
            NSLog(@"----------运行数据:%@",responseObject);
            //----这里结果根据自己设备在开放平台录入的运行数据协议的字段来处理结果-----//
            AromaDiffuserDeviceRunModel *model=[[AromaDiffuserDeviceRunModel alloc]initWithDic:responseObject];
            runDataSuccessBlock(model);
           //--------------------------------------------------------------//
        } deviceCfgData:^(id responseObject) {
            NSLog(@"配置数据:%@",responseObject);
            //----这里结果根据自己设备在开放平台录入的控制数据的协议的字段来处理结果-----//
            AromaDiffuserDeviceConfigModel *model=[[AromaDiffuserDeviceConfigModel alloc]initWithDic:responseObject];
            cfgDataSuccessBlock(model);
            //--------------------------------------------------------------//
        } deviceErrorData:^(id responseObject) {
            NSLog(@"====故障数据:%@",responseObject);
        }];
        
    }
    return self;
}
//启动服务
- (void)start
{
    [_business start];
}
//停止服务
- (void)stop
{
    [_business stop];
}
-(BOOL)isLittleLoop
{
    return [_business isLittleLoop];
}

/**
 *  设备控制
 *
 *  @param jsonString   设备控制的json字符串
 *  @param successBlock 控制成功的回调
 *  @param failureBlock 控制失败的回调
 */
- (void)deviceControlRequestWithModel:(AromaDiffuserDeviceConfigModel *)model withSuccessBlock:(void(^)(id responseObject))successBlock withFailBlock:(void(^)( NSError *error))failureBlock
{
    
    
    if(!model)
    {
        NSLog(@"传入的model为nil");
        return;
    }
    NSDictionary *responseObject=[model convertModelToDic];
    NSLog(@"设备控制的数据:%@",responseObject);
    
    if(_business.isLittleLoop)
    {
        if(!model)
        {
            NSLog(@"传入的model为nil");
            return;
        }
        /*NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
   
        NSString *appointmentBootTimeH=[responseObject objectForKey:@"appointmentBootTimeH"];
        NSString *appointmentBootTimeM=[responseObject objectForKey:@"appointmentBootTimeM"];
        NSInteger appointmentBootTime=(appointmentBootTimeH.integerValue)*60+appointmentBootTimeM.integerValue;
        [dic setObject:@(appointmentBootTime) forKey:@"appointmentBootTime"];
        
        NSString *mist=[responseObject objectForKey:@"mist"];
        [dic setObject:mist forKey:@"mist"];
        
        
        NSString *light=[responseObject objectForKey:@"light"];
        [dic setObject:light forKey:@"light"];
        
        
        NSString *timeClose=[responseObject objectForKey:@"timeClose"];
        NSInteger timeCloseH=timeClose.integerValue/60;//设定加湿定时关机时间(小时)
        NSInteger timeCloseM=timeClose.integerValue%60;//设定加湿定时关机时间(分钟)
        [dic setObject:@(timeCloseH) forKey:@"timeCloseH"];
        [dic setObject:@(timeCloseM) forKey:@"timeCloseM"];
        
        NSString *presetStartupTime=[responseObject objectForKey:@"presetStartupTime"];
        
        NSInteger presetStartupTimeH=presetStartupTime.integerValue/60;//预约开机时间(小时)
        NSInteger presetStartupTimeM=presetStartupTime.integerValue%60;//预约开机时间(分钟)
        [dic setObject:@(presetStartupTimeH) forKey:@"presetStartupTimeH"];
        [dic setObject:@(presetStartupTimeM) forKey:@"presetStartupTimeM"];
        
        
        NSString *presetShutdownTime=[responseObject objectForKey:@"presetShutdownTime"];

        NSInteger presetShutdownTimeH=presetShutdownTime.integerValue/60;//预约关机时间(小时)
        NSInteger presetShutdownTimeM=presetShutdownTime.integerValue%60;//预约关机时间(分钟)
        [dic setObject:@(presetShutdownTimeH) forKey:@"presetShutdownTimeH"];
        [dic setObject:@(presetShutdownTimeM) forKey:@"presetShutdownTimeM"];
        
        
    
        NSString *colour=[responseObject objectForKey:@"color"];
        [dic setObject:colour forKey:@"color"];
        
        
        NSString *updateFlag=[responseObject objectForKey:@"updateFlag"];
        [dic setObject:updateFlag forKey:@"updateFlag"];
        
        NSString *jsonString=[_business DataTOjsonString:dic];*/
        
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        
        NSString *timeClose=[responseObject objectForKey:@"timeClose"];
        
        NSInteger timeCloseH=timeClose.integerValue/60;//设定加湿定时关机时间(小时)
        NSInteger timeCloseM=timeClose.integerValue%60;;//定时预设时间(分钟)
        
        [dic setObject:@(timeCloseH) forKey:@"timeCloseH"];
        [dic setObject:@(timeCloseM) forKey:@"timeCloseM"];
        
        
        
        
        NSString *presetStartupTime=[responseObject objectForKey:@"presetStartupTime"];
        
        NSInteger presetStartupTimeH=presetStartupTime.integerValue/60;
        NSInteger presetStartupTimeM=presetStartupTime.integerValue%60;
        
        [dic setObject:@(presetStartupTimeH) forKey:@"presetStartupTimeH"];
        [dic setObject:@(presetStartupTimeM) forKey:@"presetStartupTimeM"];
        
        
        
        
        NSString *presetShutdownTime=[responseObject objectForKey:@"presetShutdownTime"];
        
        NSInteger presetShutdownTimeH=presetShutdownTime.integerValue/60;
        NSInteger presetShutdownTimeM=presetShutdownTime.integerValue%60;
        
        [dic setObject:@(presetShutdownTimeH) forKey:@"presetShutdownTimeH"];
        [dic setObject:@(presetShutdownTimeM) forKey:@"presetShutdownTimeM"];
        
        
        
        
        
        NSString *mist=[responseObject objectForKey:@"mist"];
        [dic setObject:mist forKey:@"mist"];
        
        
        NSString *light=[responseObject objectForKey:@"light"];
        [dic setObject:light forKey:@"light"];
        
        NSString *colour=[responseObject objectForKey:@"color"];
        [dic setObject:colour forKey:@"color"];
        
        
        
        NSString *updateFlag=[responseObject objectForKey:@"updateFlag"];
        [dic setObject:updateFlag forKey:@"updateFlag"];
        
       // NSString *jsonString=[_business DataTOjsonString:dic];
        
        NSError * err;
        NSData * tempjsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
        NSString * jsonString = [[NSString alloc] initWithData:tempjsonData encoding:NSUTF8StringEncoding];
        
        
        
        //        NSError * err;
        //        NSData * tempjsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
        //        NSString * json = [[NSString alloc] initWithData:tempjsonData encoding:NSUTF8StringEncoding];
        [_business deviceControlRequestWithJson:jsonString withSuccessBlock:successBlock withFailBlock:failureBlock];
    }
    else
    {
        //NSString *jsonString=[_business DataTOjsonString:responseObject];
        NSError * err;
        NSData * tempjsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&err];
        NSString * jsonString = [[NSString alloc] initWithData:tempjsonData encoding:NSUTF8StringEncoding];
        [_business deviceControlRequestWithJson:jsonString withSuccessBlock:successBlock withFailBlock:failureBlock];
    }
}

- (void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}
@end
