//
//  HETDeviceInfoViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/7/12.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETDeviceInfoViewController.h"

#import "HETWIFIUpgradeViewController.h"
#import "HETScanViewController.h"
#import "HETDeviceAuthInviteViewController.h"
#import "HETDeviceShareViewController.h"

@interface HETDeviceInfoViewController ()



@property (nonatomic,copy  ) NSString       * oldDeviceVersion;
@property (nonatomic,copy)   NSString       * bleBinUrl;         //delivery to upgrade VC , push version dictory is better method
@property (nonatomic)        NSInteger        deviceVersionId;



/**
 *  当升级的设备中有WiFi和蓝牙需要升级时，蓝牙的
 *  固件ID用bleDeviceVersionId字段表示
 */
@property (nonatomic)        NSInteger        bleDeviceVersionId;

@property (nonatomic,copy  ) NSString       * devNewVersion;


@property (nonatomic,strong) UIAlertView    * startUpGradeAler;



@end

@implementation HETDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    int btnHeight=44;
    int btnWidth=250;
    int btnGap=(CGRectGetHeight([UIScreen mainScreen].bounds)-btnHeight*5)/7;
    UIButton *upgradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upgradeBtn.frame =  CGRectMake(self.view.bounds.size.width/2.0-btnWidth/2.0, btnGap, btnWidth, btnHeight);
    [upgradeBtn setTitle:@"设备升级" forState:UIControlStateNormal];
    [upgradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upgradeBtn addTarget:self action:@selector(upgradeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    upgradeBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
    [self.view addSubview:upgradeBtn];
    
    
    UIButton *runDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    runDataBtn.frame =  CGRectMake(self.view.bounds.size.width/2.0-btnWidth/2.0, btnGap*2+btnHeight, btnWidth, btnHeight);
    [runDataBtn setTitle:@"设备历史运行数据" forState:UIControlStateNormal];
    [runDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [runDataBtn addTarget:self action:@selector(runBtnAction) forControlEvents:UIControlEventTouchUpInside];
    runDataBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
    [self.view addSubview:runDataBtn];
    
    
    UIButton *modifyDeviceInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyDeviceInfoBtn.frame =  CGRectMake(self.view.bounds.size.width/2.0-btnWidth/2.0, btnGap*3+btnHeight*2, btnWidth, btnHeight);
    [modifyDeviceInfoBtn setTitle:@"修改设备信息" forState:UIControlStateNormal];
    [modifyDeviceInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [modifyDeviceInfoBtn addTarget:self action:@selector(modifyDeviceInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    modifyDeviceInfoBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
    [self.view addSubview:modifyDeviceInfoBtn];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame =   CGRectMake(self.view.bounds.size.width/2.0-btnWidth/2.0, btnGap*4+btnHeight*3, btnWidth, btnHeight);
    [shareBtn setTitle:@"设备分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
    [self.view addSubview:shareBtn];
    
    
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame =  CGRectMake(self.view.bounds.size.width/2.0-btnWidth/2.0, btnGap*5+btnHeight*4, btnWidth, btnHeight);
    [agreeBtn setTitle:@"同意分享" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    agreeBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
    [self.view addSubview:agreeBtn];

    
   
    
    
    
}
-(void)upgradeBtnAction
{
    NSString *deviceId=self.hetDeviceModel.deviceId;
    HETDeviceUpgradeBusiness *upgradeBusiness=[[HETDeviceUpgradeBusiness alloc]init];
    [upgradeBusiness deviceUpgradeCheckWithDeviceId:deviceId success:^(id dictValue) {
        
        
        NSLog(@"%@",dictValue);
        if ([[dictValue allKeys] containsObject:@"newDeviceVersion"]) {
            self.oldDeviceVersion = dictValue[@"oldDeviceVersion"];
            self.devNewVersion = dictValue[@"newDeviceVersion"];
            self.bleBinUrl = dictValue[@"filePath"];
            self.deviceVersionId = [dictValue[@"deviceVersionId"] integerValue];
            self.bleDeviceVersionId = [dictValue[@"deviceBleFirmId"] integerValue];
            
        }else{
            self.oldDeviceVersion = dictValue[@"oldDeviceVersion"];
            self.devNewVersion = nil;
        }
        
        [self.startUpGradeAler show];
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"获取硬件版本信息错误:%@",error);
    }];

    
    
}


-(void)runBtnAction
{
    HETDeviceRequestBusiness *request=[[HETDeviceRequestBusiness alloc]init];
    NSString *deviceId=self.hetDeviceModel.deviceId;
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@", locationString);
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    
    NSString *lastlocationString = [dateformatter stringFromDate:yesterday];
    NSLog(@"locationString:%@", lastlocationString);
    
    
    [request fetchDeviceRundataListWithDeviceId:deviceId startDate:lastlocationString endDate:nil pageRows:nil pageIndex:nil success:^(id responseObject) {
        NSLog(@"历史运行数据:%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
    
    
//    [request fetchDeviceConfigDataListWithDeviceId:deviceId startDate:lastlocationString endDate:nil pageRows:nil pageIndex:nil success:^(id responseObject) {
//        NSLog(@"历史控制数据:%@",responseObject);
//    } failure:^(NSError *error) {
//        
//    }];

    
//    [request fetchDeviceErrorDataListWithDeviceId:deviceId startDate:lastlocationString endDate:nil pageRows:nil pageIndex:nil success:^(id responseObject) {
//        NSLog(@"历史故障数据:%@",responseObject);
//    } failure:^(NSError *error) {
//        
//    }];
//    
}
-(void) modifyDeviceInfoBtnAction
{
    HETDeviceRequestBusiness *request=[[HETDeviceRequestBusiness alloc]init];
     NSString *deviceId=self.hetDeviceModel.deviceId;
    
    
    [request updateDeviceInfoWithDeviceId:deviceId deviceName:@"123fsdg" roomId:@"12" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
 
}
-(void)shareBtnAction
{
    HETDeviceShareViewController *vc=[[HETDeviceShareViewController alloc]init];
    vc.deviceId=self.hetDeviceModel.deviceId;
    [self.navigationController pushViewController:vc animated:YES];
    
}



-(void)agreeBtnAction
{
    
    HETScanViewController *vc=[[HETScanViewController alloc]init];
    [vc finishingBlock:^(NSString *string) {
        
        HETDeviceAuthInviteViewController *vc=[[HETDeviceAuthInviteViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark   UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return ;
    }
    if (self.oldDeviceVersion && self.devNewVersion && ![self.devNewVersion isEqualToString:self.oldDeviceVersion]){
        if (self.hetDeviceModel) {
            HETWIFIUpgradeViewController * wifiUpgrade = [[HETWIFIUpgradeViewController alloc] init];
            wifiUpgrade.deviceId =self.hetDeviceModel.deviceId;
            wifiUpgrade.versionType = self.devNewVersion;
            wifiUpgrade.deviceVersionId = self.deviceVersionId;
            [self.navigationController pushViewController:wifiUpgrade animated:YES];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIAlertView *)startUpGradeAler{
    if (!_startUpGradeAler) {
        if (self.oldDeviceVersion && self.devNewVersion && ![self.devNewVersion isEqualToString:self.oldDeviceVersion]) {
            _startUpGradeAler = [[UIAlertView alloc] initWithTitle: @"升级固件" message:[NSString stringWithFormat:@"当前版本:%@\n最新版本:%@ \n 确认进行固件升级？",self.oldDeviceVersion,self.devNewVersion] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认升级", nil];
        }else{
            _startUpGradeAler = [[UIAlertView alloc] initWithTitle:@"升级固件" message:@"当前已是最新版本!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        }
    }
    return _startUpGradeAler;
}
@end
