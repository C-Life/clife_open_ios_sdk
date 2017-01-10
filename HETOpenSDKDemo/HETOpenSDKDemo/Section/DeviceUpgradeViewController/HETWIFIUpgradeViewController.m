//
//  HETWIFIUpgradeViewController.m
//  CLife
//
//  Created by Newman on 15/8/10.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETWIFIUpgradeViewController.h"
#import "HETUIConfig.h"
#import <HETOpenSDK/HETOpenSDK.h>
#import "HETCommonHelp.h"
static int checkProgressFailCount = 0; //when check upgrade progress fail , this value plus 1 , if checkProgressFailCount greater than 60 , then consider upgrade fail



#define TrailOfView(view) (view.frame.origin.x+view.frame.size.width)
#define BottomOfView(view) (view.frame.origin.y+view.frame.size.height)

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;


@interface HETWIFIUpgradeViewController ()
{
    NSTimer * getProgressTime;
    NSTimer * simulateProgressTime;
    
    HETDeviceUpgradeBusiness *_upgradeBusiness;
    
}
@property (nonatomic,strong) UIImageView    * mainImageView;
@property (nonatomic,strong) UIProgressView * upgradeProgress;

@end

@implementation HETWIFIUpgradeViewController
static dispatch_once_t onceToken;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"固件升级"];

}

- (void)viewDidLoad {
    checkProgressFailCount = 0;
    onceToken = 0;
    _upgradeBusiness=[[HETDeviceUpgradeBusiness alloc]init];
    
    [super viewDidLoad];
    [self confirmUpgrade];
    [self.view setBackgroundColor:[HETUIConfig colorFromHexRGB:@"f2f2f2"]];
    [self.view addSubview:self.mainImageView];
    [self createOtherView];
    [self.view addSubview:self.upgradeProgress];
}
-(void)createOtherView{
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, BottomOfView(self.mainImageView) + 50, ScreenWidth, 30)];
    [title setText:@"固件升级中"];
    [title setTextColor:[HETUIConfig colorFromHexRGB:@"393939"]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont systemFontOfSize:21]];
    [self.view addSubview:title];
    
    UILabel * patient = [[UILabel alloc] initWithFrame:CGRectMake(0, BottomOfView(title) + 10, ScreenWidth, 30)];
    [patient setFont:[UIFont systemFontOfSize:14]];
    [patient setText:@"可能时间较长,请耐心等待..."];
    [patient setTextAlignment:NSTextAlignmentCenter];
    [patient setTextColor:[HETUIConfig colorFromHexRGB:@"383838"]];
    [self.view addSubview:patient];
    
    UILabel * remind = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 30)];
    [remind setFont:[UIFont systemFontOfSize:13]];
    [remind setTextColor:[HETUIConfig colorFromHexRGB:@"757575"]];
    [remind setTextAlignment:NSTextAlignmentCenter];
    [remind setText:@"温馨提示:升级过程中设备请勿断电"];
    [self.view addSubview:remind];
    
    if (self.whichPacke != 0) {
        UILabel *whichPakeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight-100, ScreenWidth, 30)];
        whichPakeLabel.text = [NSString stringWithFormat:@"第%@个固件正在升级",@(self.whichPacke)];
        [whichPakeLabel setFont:[UIFont systemFontOfSize:13]];
        [whichPakeLabel setTextColor:[HETUIConfig colorFromHexRGB:@"757575"]];
        [whichPakeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:whichPakeLabel];
    }
}
#pragma mark setter getter
-(UIImageView *)mainImageView{
    if (!_mainImageView) {
        UIImage * mainIcon = [UIImage imageNamed:@"upgradeMainIcon"];
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - mainIcon.size.width)/2, 55, mainIcon.size.width,mainIcon.size.height)];
        [_mainImageView setImage:mainIcon];
    }
    return _mainImageView;
}

-(UIProgressView *)upgradeProgress{
    if (!_upgradeProgress) {
        _upgradeProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(30, BottomOfView(self.mainImageView) + 154, ScreenWidth - 60, 8)];
        _upgradeProgress.trackImage = [UIImage imageNamed:@"upgradeUndone"];
        _upgradeProgress.progressImage = [UIImage imageNamed:@"upgradeDone"];
    }
    return _upgradeProgress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络接口

-(void)confirmUpgrade{
   
    
    [_upgradeBusiness deviceUpgradeConfirmWithDeviceId:self.deviceId deviceVersionType:@"2" deviceVersionId:[NSString stringWithFormat:@"%ld",(long)self.deviceVersionId] success:^(id responseObject) {
        
        NSLog(@"确认升级");
        if (self.deviceTypeId == 27) {
            getProgressTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(simulateUpgradeProgress) userInfo:nil repeats:YES];
        }else{
            getProgressTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getUpgradeProgress) userInfo:nil repeats:YES];
        }

        
    } failure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示" message:@"您的网络有问题,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        });
        NSLog(@"%@ ",error);
    }];
    
   
}

- (void)simulateProgress
{
    self.upgradeProgress.progress += 0.0087;
    
    if (self.upgradeProgress.progress >= 0.87) {
        [simulateProgressTime invalidate];
        simulateProgressTime = nil;
    }
}

- (void)simulateUpgradeProgress{
    
    WEAKSELF;
    [_upgradeBusiness fetchDeviceUpgradeProgress:self.deviceId deviceVersionId:[NSString stringWithFormat:@"%d",(int)self.deviceVersionId] success:^(id responseObject)
    {
        
        
        
        HETWIFIUpgradeViewController* localSelf = weakSelf;
        NSLog(@"%@",responseObject);
        int upgradeStatus = [responseObject[@"upgradeStatus"] intValue];
        
        dispatch_once(&onceToken, ^{
            simulateProgressTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(simulateProgress) userInfo:nil repeats:YES];
            
        });
        
        if (upgradeStatus  == 2) {
            dispatch_once(&onceToken, ^{
                weakSelf.upgradeProgress.progress = 1.0;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示" message:@"升级成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            });
            
            [localSelf->getProgressTime invalidate];
            localSelf->getProgressTime = nil;
        }else if(upgradeStatus == 3){
            dispatch_once(&onceToken, ^{
                weakSelf.upgradeProgress.progress = 0.0;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示" message:@"升级失败,请重试" delegate:self cancelButtonTitle: @"确定" otherButtonTitles:nil];
                [alert show];
            });
            [localSelf->getProgressTime invalidate];
            localSelf->getProgressTime = nil;
        }

        
    } failure:^(NSError *error) {
      
        checkProgressFailCount++;
        HETWIFIUpgradeViewController* localSelf = weakSelf;
        if (checkProgressFailCount > 60) {
            dispatch_once(&onceToken, ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示" message:@"您的网络有问题,请重试" delegate:self cancelButtonTitle: @"确定" otherButtonTitles:nil];
                [alert show];
                
            });
            [localSelf->getProgressTime invalidate];
            localSelf->getProgressTime = nil;
        }
        if (error.code == 100022006) {//设备不在线直接退回
            NSString * result = error.userInfo[@"msg"];
            [localSelf->getProgressTime invalidate];
            localSelf->getProgressTime = nil;
            [HETCommonHelp showAutoDissmissAlertView:nil msg:result];
            //[HETMBProgressHUD showHudAutoHidenWithMessage:result];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        NSLog(@"%@",error);

    }];

   
}

-(void)getUpgradeProgress{
    WEAKSELF;
    [_upgradeBusiness fetchDeviceUpgradeProgress:self.deviceId deviceVersionId:[NSString stringWithFormat:@"%d",(int)self.deviceVersionId] success:^(id responseObject)
     {
        HETWIFIUpgradeViewController* localSelf = weakSelf;
        NSLog(@"%@",responseObject);
        int upgradeStatus = [responseObject[@"upgradeStatus"] intValue];
        self.upgradeProgress.progress = [responseObject[@"progress"] intValue]/100.;
        if (upgradeStatus  == 2) {
//            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"升级提示" message: @"升级成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            });
            [localSelf->getProgressTime invalidate];
            localSelf->getProgressTime = nil;
        }else if(upgradeStatus == 3){
//            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示" message:@"升级失败,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            });
            [localSelf->getProgressTime invalidate];
            localSelf->getProgressTime = nil;
        }
       
    } failure:^(NSError *error) {
        checkProgressFailCount++;
        if (checkProgressFailCount > 60) {
            HETWIFIUpgradeViewController* localSelf = weakSelf;
//            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示" message:@"您的网络有问题,请重试" delegate:self cancelButtonTitle: @"确定" otherButtonTitles:nil];
                [alert show];
                
            });
            [localSelf->getProgressTime invalidate];
            localSelf->getProgressTime = nil;
        }
        if (error.code == 100022006) {//设备不在线直接退回
            NSString * result = error.userInfo[@"msg"];
           // [HETMBProgressHUD showHudAutoHidenWithMessage:result];
              [HETCommonHelp showAutoDissmissAlertView:nil msg:result];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        NSLog(@"%@",error);
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     switch (buttonIndex) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
             [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (void)backAction: (id)sender{
    //[HETMBProgressHUD showHudWithMessage:@"亲,正在升级,不能退出" hiddenAfterDelay:2];
    
    [HETCommonHelp showAutoDissmissAlertView:nil msg:@"亲,正在升级,不能退出"];
}
@end
