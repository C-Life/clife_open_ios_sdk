//
//  CLALLWIFIDeviceViewController.m
//  NewBindDeviceProject
//
//  Created by mr.cao on 15/6/25.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "ALLWIFIDeviceViewController.h"
#import <HETOpenSDK/HETOpenSDK.h>
#import "CLDeviceTableViewCell.h"
#import "HETDeviceObject.h"
#import "MainViewController.h"
#import "HETCommonHelp.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ALLWIFIDeviceViewController ()<HETWIFIBindBusinessDelegate,UITableViewDelegate,UITableViewDataSource>
{
     NSMutableArray *selectedDevArray;
    HETWIFIBindBusiness *manager;
     HFSmartLink * smtlk;
    int _progress;
    NSMutableArray *_selectedDevArray;
    UILabel *_progressLable;
    NSInteger currentIndex;
}
@property(strong,nonatomic)UITableView *scanDeviceTableView;
@property(strong,nonatomic)UIView      *bottomView;
@property(strong,nonatomic)UIButton    *beginBindButton;
@property(strong,nonatomic)NSMutableArray     *devicesDataSource;


@end

@implementation ALLWIFIDeviceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scanDeviceTableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.beginBindButton];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  _devicesDataSource=[[NSMutableArray alloc]initWithCapacity:1];
    
    //HF WiFi模块接入路由
    smtlk =[[HFSmartLink alloc]init];// [HFSmartLink shareInstence];
    smtlk.isConfigOneDevice = false;
    
    smtlk.waitTimers = 30;//15;
    [smtlk startWithKey:self.wifiPassword processblock:^(NSInteger process) {
        
    } successBlock:^(HFSmartLinkDeviceInfo *dev) {
        //[self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
    } failBlock:^(NSString *failmsg) {
        //[self  showAlertWithMsg:failmsg title:@"error"];
    } endBlock:^(NSDictionary *deviceDic) {
        
        
    }];
    

 
    manager=[HETWIFIBindBusiness sharedInstance];

    manager.delegate=self;
    [manager startScanDevicewithDeviceType:0];//扫描所有设备
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(checkScanWIFIDevice) withObject:nil afterDelay:100];
    });
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止扫描
    [manager stop];
    manager.delegate=nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkScanWIFIDevice) object:nil];
        
    });
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)bindAction
{
    if(selectedDevArray)
    {
        
        [manager bindDevices:selectedDevArray withProductId:self.productId withDeviceId:nil withTimeOut:100];
          [HETCommonHelp showCustomHudtitle:@"绑定中"];
    }
    
}
-(void)checkScanWIFIDevice
{
    if(_devicesDataSource.count)
    {
     
        
        
    }
    else
    {
        manager.delegate=nil;
        [manager stop];
        NSLog(@"没有扫描到设备");
        [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _devicesDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,CCViewWidth, 44)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CCViewWidth * 0.05, 15, CCViewWidth * 0.9, 20)];
    titleLabel.text = @"查找到可绑定的设备";
    titleLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:titleLabel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellID = @"myCell";
    CLDeviceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell= [[CLDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    HETWIFICommonReform *obj=_devicesDataSource[indexPath.row];
    [cell setChecked:NO];
    [cell setMacName:obj.device_mac];
    if(indexPath.row==currentIndex)
    {
        selectedDevArray = [[NSMutableArray alloc] init];
        [_devicesDataSource replaceObjectAtIndex:indexPath.row withObject:obj];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedDevArray addObject:obj];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndex=indexPath.row;
    [tableView reloadData];
    
    
}
-(void)viewDidLayoutSubviews {
    
    if ([self.scanDeviceTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.scanDeviceTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.scanDeviceTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.scanDeviceTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


#pragma mark WIFIBindBusinessDelegate
/**
 *  绑定失败代理
 */
-(void)HETWIFIBindBusinessFail:(HETWIFICommonReform *)obj
{
     [HETCommonHelp HidHud];
    [self.navigationController popViewControllerAnimated:YES];
    return;
    NSString *reason = [NSString stringWithFormat:@"设备%@绑定失败",obj.device_mac];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

/**
 *  绑定成功代理
 *
 *  @param obj  绑定成功的设备信息HETWIFICommonReform对象
 */
-(void)HETWIFIBindBusinessSuccess:(HETWIFICommonReform *)obj
{
    [HETCommonHelp HidHud];
    MainViewController *vc=[[MainViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   
    return;
    NSString *reason = [NSString stringWithFormat:@"设备%@绑定成功",obj.device_mac];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
}


/**
 *  扫描到设备代理
 *
 *  @param HETWIFIBindBusiness HETWIFIBindBusiness对象
 *  @param obj                 设备信息HETWIFICommonReform对象
 */
- (void)scanWIFIDevice:(id)HETWIFIBindBusiness bindDeviceInfo:(HETWIFICommonReform *)obj
{
    NSLog(@"obj:%@,%@",obj,obj.device_mac);
    if(!obj)
    {
        return;
    }
    if(![_devicesDataSource containsObject:obj])
    {
        [_devicesDataSource addObject:obj];
        [self.scanDeviceTableView reloadData];
    }
    
}

#pragma mark 初始化UITableView
-(UITableView *)scanDeviceTableView
{
    if(!_scanDeviceTableView)
    {
        _scanDeviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,CCViewWidth, (CCViewHeight)-88*CC_scale) style:UITableViewStyleGrouped];
        _scanDeviceTableView.delegate = self;
        _scanDeviceTableView.dataSource = self;
        _scanDeviceTableView.backgroundColor = [UIColor clearColor];
        _scanDeviceTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _scanDeviceTableView.tableFooterView=[UIView new];
    }
    return _scanDeviceTableView;
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
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(bindAction) forControlEvents:UIControlEventTouchUpInside];
        _beginBindButton=nextBtn;
        
    }
    return _beginBindButton;
    
}


@end