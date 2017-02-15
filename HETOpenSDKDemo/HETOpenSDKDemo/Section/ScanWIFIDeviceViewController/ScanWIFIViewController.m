//
//  ScanViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//


#import "ScanWIFIViewController.h"
#import <HETOpenSDK/HETOpenSDK.h>
#import "ALLWIFIDeviceViewController.h"


static NSString * KWifiPasswordKey;



@interface ScanWIFIViewController ()<UITextFieldDelegate>
{
    HETWIFIBindBusiness *wifiBindManager;
    NSString *macaddr;
    NSString *lastSSIDStr;

}
@property(strong,nonatomic)UILabel *titleLable;
@property(strong,nonatomic)UILabel *firstLine;
@property(strong,nonatomic)UILabel *secondLine;
@property(strong,nonatomic)UILabel *thirdLine;
@property(strong,nonatomic)UITextField *wifiNameField;
@property(strong,nonatomic)UITextField *passwordField;

@property(strong,nonatomic)UIView      *bottomView;
@property(strong,nonatomic)UIButton    *beginBindButton;



@end

@implementation ScanWIFIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleBindSuccessNotification:) name:@"kPostBindSuccessNotification" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleBindFailNotification:) name:@"kPostBindFailNotification" object:nil];
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.firstLine];
    [self.view addSubview:self.secondLine];
    [self.view addSubview:self.thirdLine];
    [self.view addSubview:self.wifiNameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.beginBindButton];
    
    
    
    wifiBindManager=[HETWIFIBindBusiness sharedInstance];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setNavigationBarTitle:@"WiFi连接"];
    [wifiBindManager fetchSSIDInfoWithInterVal:1.0f WithTimes:0 SuccessBlock:^(NSString *ssidStr) {
        if(![lastSSIDStr isEqualToString:ssidStr])
        {
            //NSLog(@"ssidstr:%@",ssidStr);
            lastSSIDStr=ssidStr;
            self.wifiNameField.text=ssidStr;
            
            NSString *psw= [[NSUserDefaults standardUserDefaults]objectForKey:ssidStr];
            if(psw.length)
            {
                self.passwordField.text=psw;
            }
            
        }
    }];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [wifiBindManager stopFetchSSIDInfo];
}


#pragma ButtonAction进入下一个扫描所有设备界面
- (void) turnToScanDeviceVCAction
{
    
    
    [[NSUserDefaults standardUserDefaults]setObject:self.passwordField.text forKey:self.wifiNameField.text];
    [[NSUserDefaults standardUserDefaults]synchronize];
    ALLWIFIDeviceViewController *vc=[[ALLWIFIDeviceViewController alloc]init];
    vc.wifiPassword=self.passwordField.text;
    vc.ssid=self.wifiNameField.text;
    vc.bindTypeStr=self.bindTypeStr;
    vc.deviceTypeStr=self.deviceTypeStr;
    vc.deviceSubTypeStr=self.deviceSubTypeStr;
    vc.moduleIdStr=self.moduleIdStr;
    vc.productId=self.productId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void) handleBindSuccessNotification:(NSNotification*)notification
{
    //NSDictionary *dic=notification.userInfo;
    NSLog(@"绑定成功");
    
}
-(void) handleBindFailNotification:(NSNotification*)notification
{
    NSLog(@"绑定失败");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backAction{
    // [[HETWIFIBindBusiness sharedInstance]stop];
     [self.navigationController popViewControllerAnimated: YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
   // [[HETWIFIBindBusiness sharedInstance]stop];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-----UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField==self.passwordField)
    {

     [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==self.wifiNameField)
    {
        
        return NO;
    }
    return YES;

}
#pragma mark-----标题
-(UILabel *)titleLable
{
    if(!_titleLable)
    {
        _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(30*CC_scale, 34*CC_scale+(([UIScreen mainScreen].bounds.size.height==(CCViewHeight))?64:0), CCViewWidth-30*CC_scale*2, 46*CC_scale)];
        _titleLable.textColor=[self colorFromHexRGB:@"808080"];
        _titleLable.text=@"请确认您当前的WiFi或使用其他WiFi进行绑定";
        [_titleLable setFont:[UIFont systemFontOfSize:28*CC_scale]];
    }
    return _titleLable;
    
}
#pragma mark-----第一条线
-(UILabel *)firstLine
{
    if(!_firstLine)
    {
        _firstLine=[[UILabel alloc]initWithFrame:CGRectMake(0, self.titleLable.frame.size.height+self.titleLable.frame.origin.y+34*CC_scale, CCViewWidth, CC_lineHeight)];
        _firstLine.backgroundColor=[self colorFromHexRGB:@"c6c6c6"];
 
    }
    return _firstLine;

}
#pragma mark-----第二条线
-(UILabel *)secondLine
{
    if(!_secondLine)
    {
        _secondLine=[[UILabel alloc]initWithFrame:CGRectMake(0, self.titleLable.frame.size.height+self.titleLable.frame.origin.y+34*CC_scale+88*CC_scale, CCViewWidth, CC_lineHeight)];
        _secondLine.backgroundColor=[self colorFromHexRGB:@"c6c6c6"];
        
    }
    return _secondLine;
    
}
#pragma mark-----第三条线
-(UILabel *)thirdLine
{
    if(!_thirdLine)
    {
        _thirdLine=[[UILabel alloc]initWithFrame:CGRectMake(0, self.titleLable.frame.size.height+self.titleLable.frame.origin.y+34*CC_scale+88*2*CC_scale, CCViewWidth, CC_lineHeight)];
        _thirdLine.backgroundColor=[self colorFromHexRGB:@"c6c6c6"];
        
    }
    return _thirdLine;
    
}
#pragma mark-----WiFi名称输入框
-(UITextField *)wifiNameField
{
    if(!_wifiNameField)
    {
        _wifiNameField = [[UITextField alloc] initWithFrame:CGRectMake(29*CC_scale, self.firstLine.frame.origin.y+88*CC_scale/2-46*CC_scale/2,CCViewWidth-29*CC_scale*2, 46*CC_scale)];
        _wifiNameField.placeholder=@"WiFi账号";
       
        _wifiNameField.textColor = [self colorFromHexRGB:@"2E7BD3"];
        _wifiNameField.returnKeyType = UIReturnKeyNext;
        _wifiNameField.delegate = self;
        _wifiNameField.font = [UIFont systemFontOfSize:28*CC_scale];
        
    }
    return _wifiNameField;
}
#pragma mark-----WiFi密码输入框
-(UITextField *)passwordField
{
    if(!_passwordField)
    {
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(29*CC_scale, self.secondLine.frame.origin.y+88*CC_scale/2-46*CC_scale/2,CCViewWidth-29*CC_scale*2, 46*CC_scale)];
        _passwordField.placeholder=@"请输入密码";
        
        _passwordField.textColor = [self colorFromHexRGB:@"2E7BD3"];
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.delegate = self;
   
        _passwordField.font = [UIFont systemFontOfSize:28*CC_scale];
        
      

    }
    return _passwordField;
}


#pragma mark-----底部view
-(UIView *)bottomView
{
    if(!_bottomView)
    {
        _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, (CCViewHeight)-88*CC_scale, CCViewWidth, 88*CC_scale)];
        _bottomView.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
        
    }
    return _bottomView;
}
#pragma mark-----开始绑定按钮
-(UIButton *)beginBindButton
{
    if(!_beginBindButton)
    {
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        nextBtn.frame =  CGRectMake([UIScreen mainScreen].bounds.size.width/2-[UIScreen mainScreen].bounds.size.width*0.7/2, _bottomView.frame.origin.y+_bottomView.frame.size.height/2-_bottomView.frame.size.height/2, CCViewWidth*0.7, _bottomView.frame.size.height);
        [nextBtn setTitle:@"开始绑定" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(turnToScanDeviceVCAction) forControlEvents:UIControlEventTouchUpInside];
        _beginBindButton=nextBtn;
 
    }
    return _beginBindButton;
    
}
@end
