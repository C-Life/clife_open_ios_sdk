//
//  MainViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "MainViewController.h"
#import "SVPullToRefresh.h"

#import "ScanWIFIViewController.h"
#import "AromaDiffuserViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_allDeviceDataSouce;
    
    int _progress;
    NSMutableArray *_selectedDevArray;
    NSInteger _realTimeFailCount;
    NSInteger _zeroRealTimeFailCount;
    UILabel *_progressLable;
    
    
    
}
@property(strong,nonatomic)UITableView *scanDeviceTableView;
@property(strong,nonatomic)UIButton    *wifiScanButton;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.scanDeviceTableView];
    [self.view addSubview:self.wifiScanButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IOS_IS_AT_LEAST_7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.translucent = NO;
    

    [self setNavigationBarTitle:@"我的设备"];
    [self setLeftBarButtonItemHide:YES];
    __weak MainViewController *weakSelf = self;

     [self.scanDeviceTableView addPullToRefreshWithActionHandler:^{
         
         //获取绑定的设备列表
         
         HETDeviceRequestBusiness *bussiness=[[HETDeviceRequestBusiness alloc]init];
         [bussiness fetchAllBindDeviceSuccess:^(NSArray<HETDevice *> *deviceArray) {
             _allDeviceDataSouce=[deviceArray copy];
             [weakSelf.scanDeviceTableView reloadData];
             [weakSelf.scanDeviceTableView.pullToRefreshView stopAnimating];
         } failure:^(NSError *error) {
             _allDeviceDataSouce=nil;
             [weakSelf.scanDeviceTableView reloadData];
             [weakSelf.scanDeviceTableView.pullToRefreshView stopAnimating];
         }];
         
     }];
    
    [self.scanDeviceTableView triggerPullToRefresh];


    
    
}
//扫描WiFi新设备
- (void)wifiBindAction
{
    
    ScanWIFIViewController *vc=[[ScanWIFIViewController alloc]init];
    vc.productId=@"1374";
    [self.navigationController pushViewController:vc animated:YES];
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
    return _allDeviceDataSouce.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_allDeviceDataSouce.count)
    {
        NSString *cellID = @"myCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell==nil)
        {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.backgroundColor=[UIColor clearColor];
        
        return cell;
    }
    else
    {
        NSString *cellID = @"myCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell==nil)
        {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
       HETDevice *deviceModel=[_allDeviceDataSouce objectAtIndex:indexPath.row];
        
        NSString *imageUrl=deviceModel.productIcon;
        UIImage *iconImage=nil;
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        if(!imageData&&imageData.length)
        {
            iconImage=[UIImage imageWithData:imageData];
        }
        else
        {
            iconImage=[UIImage imageNamed:@"bingxiang_deviceBind"];
        }
        
        NSString *deviceName=deviceModel.deviceName;
        NSString *deviceMac=deviceModel.macAddress;
        NSNumber *deviceOnOff=deviceModel.onlineStatus;
        UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 44/2.0-34/2.0, 34*iconImage.size.width/iconImage.size.height, 34)];
        iconImageView.image=iconImage;
        [cell.contentView addSubview:iconImageView];
        
        UILabel *deviceNameLable=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+10, 0, 200, 25)];
        deviceNameLable.text=deviceName;
        deviceNameLable.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:deviceNameLable];
        
        UILabel *deviceMacLable=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+10, 25, 200, 25)];
        deviceMacLable.text=deviceMac;
        deviceMacLable.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:deviceMacLable];
        
        
        UILabel *deviceOnoffLable=[[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-60, 0, 50, 50)];
        if(deviceOnOff.intValue==1)
        {
            deviceOnoffLable.text=@"在线";
            deviceOnoffLable.textColor=[UIColor blueColor];
        }
        else
        {
            deviceOnoffLable.text=@"离线";
            deviceOnoffLable.textColor=[UIColor grayColor];
        }
        
        deviceOnoffLable.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:deviceOnoffLable];
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HETDevice *deviceModel=[_allDeviceDataSouce objectAtIndex:indexPath.row];
    NSNumber *deviceBindType=deviceModel.moduleType;
    NSNumber *deviceTypeId=deviceModel.deviceTypeId;
    NSNumber *deviceOnOff=deviceModel.onlineStatus;
    if(deviceBindType.integerValue==1&&deviceTypeId.integerValue==11&&deviceOnOff.integerValue==1)//WIFI设备,香薰机设备并且在线
    {
        
            AromaDiffuserViewController *vc=[[AromaDiffuserViewController alloc]init];
            vc.hetDeviceModel=deviceModel;
            [self.navigationController pushViewController:vc animated:YES];
    }

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

#pragma mark 初始化UITableView
-(UITableView *)scanDeviceTableView
{
    if(!_scanDeviceTableView)
    {
        _scanDeviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-100) style:UITableViewStyleGrouped];
        _scanDeviceTableView.delegate = self;
        _scanDeviceTableView.dataSource = self;
        _scanDeviceTableView.backgroundColor = [UIColor clearColor];
        _scanDeviceTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _scanDeviceTableView.tableFooterView=[UIView new];
    }
    return _scanDeviceTableView;
}

#pragma mark-----扫描按钮
-(UIButton *)wifiScanButton
{
    if(!_wifiScanButton)
    {
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame =  CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-44-64, CGRectGetWidth([UIScreen mainScreen].bounds), 44);
        [nextBtn setTitle:@"扫描WIFI设备" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(wifiBindAction) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
        _wifiScanButton=nextBtn;
        
    }
    return _wifiScanButton;
    
}

@end
