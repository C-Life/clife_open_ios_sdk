//
//  ALLWIFIDeviceViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 15/6/25.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "ALLWIFIDeviceViewController.h"
#import "MainViewController.h"
#import "HETCommonHelp.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "HFBroadcast_SSID_Password.h"
#import "ELIANBroadcast_SSID_Password.h"
#import "ESPBroadcast_SSID_Password.h"
#import "HETCircleLoader.h"
#import "CYAlertView.h"
@interface ALLWIFIDeviceViewController ()
{
    int                 _progress;
    HFBroadcast_SSID_Password * hfsmtlk;
    
    ELIANBroadcast_SSID_Password *mtksmtlk;
    ESPBroadcast_SSID_Password *espsmtlk;
    
}


@property(strong,nonatomic) HETCircleLoader         *hub;
@end

@implementation ALLWIFIDeviceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _progress=0;
    self.hub = [[HETCircleLoader alloc]init];
    [self.hub showInView:self.view];
    WEAKSELF;
    weakSelf.hub.cancelBind= ^{
        STRONGSELF;
        CYAlertView * _alerViewtFail=[[CYAlertView alloc]initWithTitle:@"取消绑定" message:@"您确定要取消绑定?" clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            if(buttonIndex==1)
            {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
            
        } cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        
        [_alerViewtFail show];
        
    };
    
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.productId.integerValue==1374)//汉风模块的设备
    {
        //HF WiFi模块接入路由
        hfsmtlk =[[HFBroadcast_SSID_Password alloc]init];
        [hfsmtlk startBroadcast_SSID:self.wifiSsid Password:self.wifiPassword];
    }
    else if(self.productId.integerValue==2159)//MTK芯片的设备
    {
        mtksmtlk=[[ELIANBroadcast_SSID_Password alloc]init];
        [mtksmtlk startBroadcast_SSID:self.wifiSsid Password:self.wifiPassword];
    }
    
    else if (self.productId.integerValue==2100)//该产品采用的乐鑫ESP模组
    {
        espsmtlk=[[ESPBroadcast_SSID_Password alloc]init];
        [espsmtlk startBroadcast_SSID:self.wifiSsid Password:self.wifiPassword];
    }
    
    _progress=0;
    
    [self updataProgress];
    // [HETCommonHelp showCustomHudtitle:@"开始绑定设备(100s超时)"];
    
    [[HETWIFIBindBusiness sharedInstance] startBindDeviceWithProductId:self.productId withTimeOut:100 completionHandler:^(HETDevice *deviceObj, NSError *error) {
        NSLog(@"设备mac地址:%@,%@",deviceObj.macAddress,error);
        if(hfsmtlk)
        {
            [hfsmtlk stopBroadcast];
        }
        hfsmtlk=nil;
        if(mtksmtlk)
        {
            [mtksmtlk stopBroadcast];
        }
        mtksmtlk=nil;
        if(espsmtlk)
        {
            [espsmtlk stopBroadcast];
        }
        espsmtlk=nil;
        if(error)
        {
            
            NSLog(@"绑定失败");
            // 绑定失败
            CYAlertView * _alerViewtFail=[[CYAlertView alloc]initWithTitle:@"绑定失败" message:@"绑定失败,是否重新绑定?" clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
            } cancelButtonTitle:@"退出" otherButtonTitles:@"重新绑定", nil];
            
            [_alerViewtFail show];
            
        }
        else
        {
            for (UIViewController *tempCon in self.navigationController.viewControllers) {
                if([tempCon isKindOfClass:[MainViewController class]])
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToViewController:tempCon animated:YES];
                    });
                    
                }
            }
            
        }
    }];
    
    
}
-(void)updataProgress
{
    _progress++;
    
    if(_progress<=100)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.hub.progressStr = [NSString stringWithFormat:@"绑定中...%d%@",_progress,@"%"];
            [self performSelector:@selector(updataProgress) withObject:nil afterDelay:1];
            
        });
    }
    else
    {
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止扫描
    [[HETWIFIBindBusiness sharedInstance] stop];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)bindAction
{
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
