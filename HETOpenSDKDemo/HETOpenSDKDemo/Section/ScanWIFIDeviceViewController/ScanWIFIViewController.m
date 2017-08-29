//
//  ScanViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//


#import "ScanWIFIViewController.h"
#import "ALLWIFIDeviceViewController.h"


static NSString * KWifiPasswordKey;



@interface ScanWIFIViewController ()<UITextFieldDelegate>
{
    
    NSString *lastSSIDStr;
     BOOL                _isNext;
    
}
@property(strong,nonatomic)UILabel *titleLable;
@property(strong,nonatomic)UILabel *firstLine;
@property(strong,nonatomic)UILabel *secondLine;
@property(strong,nonatomic)UILabel *thirdLine;
@property(strong,nonatomic)UITextField *wifiNameField;
@property(strong,nonatomic)UITextField *passwordField;
@property(strong,nonatomic)UIButton    *beginBindButton;

@end

@implementation ScanWIFIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.firstLine];
    [self.view addSubview:self.secondLine];
    [self.view addSubview:self.thirdLine];
    [self.view addSubview:self.wifiNameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.beginBindButton];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.view.mas_top).offset(17);
        make.height.mas_equalTo(@46);
    }];
    
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.titleLable.mas_bottom).offset(17);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.wifiNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.titleLable.mas_left);
        make.right.mas_equalTo(self.titleLable.mas_right);
        make.top.mas_equalTo(self.firstLine.mas_bottom);
        make.height.mas_equalTo(@46);
    }];
    
    
    [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.wifiNameField.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.titleLable.mas_left);
        make.right.mas_equalTo(self.titleLable.mas_right);
        make.top.mas_equalTo(self.secondLine.mas_bottom);
        make.height.mas_equalTo(@46);
    }];
    
    [self.thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.passwordField.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    [self.beginBindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(@44);
        
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setNavigationBarTitle:@"WiFi连接"];
    [[HETWIFIBindBusiness sharedInstance] fetchSSIDInfoWithInterVal:1.0f WithTimes:0 SuccessBlock:^(NSString *ssidStr) {
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
    
    [[HETWIFIBindBusiness sharedInstance] stopFetchSSIDInfo];
}
#pragma ButtonAction进入下一个扫描所有设备界面
- (void) turnToScanDeviceVCAction
{
    if(!self.passwordField.text.length||!self.wifiNameField.text.length)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"请先输入设备需要连接的路由器的名称与密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:self.passwordField.text forKey:self.wifiNameField.text];
    [[NSUserDefaults standardUserDefaults]synchronize];
   
    ALLWIFIDeviceViewController *vc=[[ALLWIFIDeviceViewController alloc]init];
    vc.wifiPassword=self.passwordField.text;
    vc.wifiSsid=self.wifiNameField.text;
    vc.bindTypeStr=self.bindTypeStr;
    vc.deviceTypeStr=self.deviceTypeStr;
    vc.deviceSubTypeStr=self.deviceSubTypeStr;
    vc.moduleIdStr=self.moduleIdStr;
    vc.productId=self.productIdStr;
    vc.radiocastName=self.radiocastName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated: YES];
}


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
        _titleLable=[[UILabel alloc]initWithFrame:CGRectZero];
        _titleLable.textColor=[self colorFromHexRGB:@"808080"];
        _titleLable.text=@"请确认您当前的WiFi或使用其他WiFi进行绑定";
        [_titleLable setFont:[UIFont systemFontOfSize:14]];
    }
    return _titleLable;
    
}
#pragma mark-----第一条线
-(UILabel *)firstLine
{
    if(!_firstLine)
    {
        _firstLine=[[UILabel alloc]initWithFrame:CGRectZero];
        _firstLine.backgroundColor=[self colorFromHexRGB:@"c6c6c6"];
        
    }
    return _firstLine;
    
}
#pragma mark-----第二条线
-(UILabel *)secondLine
{
    if(!_secondLine)
    {
        _secondLine=[[UILabel alloc]initWithFrame:CGRectZero];
        _secondLine.backgroundColor=[self colorFromHexRGB:@"c6c6c6"];
        
    }
    return _secondLine;
    
}
#pragma mark-----第三条线
-(UILabel *)thirdLine
{
    if(!_thirdLine)
    {
        _thirdLine=[[UILabel alloc]initWithFrame:CGRectZero];
        _thirdLine.backgroundColor=[self colorFromHexRGB:@"c6c6c6"];
        
    }
    return _thirdLine;
    
}
#pragma mark-----WiFi名称输入框
-(UITextField *)wifiNameField
{
    if(!_wifiNameField)
    {
        _wifiNameField = [[UITextField alloc] initWithFrame:CGRectZero];
        _wifiNameField.placeholder=@"WiFi账号";
        
        _wifiNameField.textColor = [self colorFromHexRGB:@"2E7BD3"];
        _wifiNameField.returnKeyType = UIReturnKeyNext;
        _wifiNameField.delegate = self;
        _wifiNameField.font = [UIFont systemFontOfSize:14];
        
    }
    return _wifiNameField;
}
#pragma mark-----WiFi密码输入框
-(UITextField *)passwordField
{
    if(!_passwordField)
    {
        _passwordField = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordField.placeholder=@"请输入密码";
        _passwordField.textColor = [self colorFromHexRGB:@"2E7BD3"];
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.delegate = self;
        _passwordField.font = [UIFont systemFontOfSize:14];
        
    }
    return _passwordField;
}


#pragma mark-----开始绑定按钮
-(UIButton *)beginBindButton
{
    if(!_beginBindButton)
    {
        _beginBindButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_beginBindButton setTitle:@"开始绑定" forState:UIControlStateNormal];
        [_beginBindButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        [_beginBindButton addTarget:self action:@selector(turnToScanDeviceVCAction) forControlEvents:UIControlEventTouchUpInside];
        _beginBindButton.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
        
    }
    return _beginBindButton;
    
}
@end
