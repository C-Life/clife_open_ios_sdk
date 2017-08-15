//
//  MainViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "MainViewController.h"
#import "SVPullToRefresh.h"
#import "HETChooseDeviceViewController.h"
#import "ScanWIFIViewController.h"
#import "AromaDiffuserViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_allDeviceDataSouce;
    
}
@property(strong,nonatomic)HETAuthorize *auth;
@property(strong,nonatomic)UITableView *allBindDeviceTableView;
@property(strong,nonatomic)UIButton    *wifiScanButton;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.allBindDeviceTableView];
    [self.view addSubview:self.wifiScanButton];
    
//    //右边添加按钮
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 60, 40);
//    [rightButton setTitle:@"退出登录" forState:UIControlStateNormal];
//    rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [rightButton addTarget:self action:@selector(loginOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightButton] animated:NO];
    if(!self.auth)
    {
        self.auth = [[HETAuthorize alloc] init];
    }
    
    if ([self.auth isAuthenticated])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换账号" style:UIBarButtonItemStyleDone target:self action:@selector(loginOutBtnClick)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(loginOutBtnClick)];
    }

    
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

     [self.allBindDeviceTableView addPullToRefreshWithActionHandler:^{
         
         //获取绑定的设备列表
         
         HETDeviceRequestBusiness *bussiness=[[HETDeviceRequestBusiness alloc]init];
         [bussiness fetchAllBindDeviceSuccess:^(NSArray<HETDevice *> *deviceArray) {
             _allDeviceDataSouce=[deviceArray copy];
             dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.allBindDeviceTableView reloadData];
             [weakSelf.allBindDeviceTableView.pullToRefreshView stopAnimating];
             });
         } failure:^(NSError *error) {
             _allDeviceDataSouce=nil;
             dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.allBindDeviceTableView reloadData];
             [weakSelf.allBindDeviceTableView.pullToRefreshView stopAnimating];
             });
         }];
         
     }];
    
   

    //检查SDK是否已经授权登录，否则不能使用
    if(!self.auth)
    {
        self.auth = [[HETAuthorize alloc] init];
    }
    
    if (![self.auth isAuthenticated]) {
        [self setNavigationBarTitle:@"未登录"];
        //self.allBindDeviceTableView.hidden=YES;
        //        [self.auth authorizeWithCompleted:^(HETAccount *account, NSError *error) {
        //            NSLog(@"%@,token:%@",account,account.accessToken);
        //            [self.allBindDeviceTableView triggerPullToRefresh];
        //        }];
        
    }
    else
    {
        [self setNavigationBarTitle:@"已登录"];
        // self.allBindDeviceTableView.hidden=NO;
        [self.allBindDeviceTableView triggerPullToRefresh];
    }
    
    [self setLeftBarButtonItemHide:YES];


    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
     [self setLeftBarButtonItemHide:NO];
}
//扫描WiFi新设备
- (void)wifiBindAction
{
    
    HETChooseDeviceViewController *vc=[[HETChooseDeviceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)loginOutBtnClick
{
    HETAuthorize *auth = [[HETAuthorize alloc] init];
    self.auth = auth;
    [self.auth unauthorize];
    [self.auth authorizeWithCompleted:^(HETAccount *account, NSError *error) {
        if(!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.allBindDeviceTableView triggerPullToRefresh];
            });
        }
    }];
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
    
    if ([self.allBindDeviceTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.allBindDeviceTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.allBindDeviceTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.allBindDeviceTableView setLayoutMargins:UIEdgeInsetsZero];
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
-(UITableView *)allBindDeviceTableView
{
    if(!_allBindDeviceTableView)
    {
        _allBindDeviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-100) style:UITableViewStyleGrouped];
        _allBindDeviceTableView.delegate = self;
        _allBindDeviceTableView.dataSource = self;
        _allBindDeviceTableView.backgroundColor = [UIColor clearColor];
        _allBindDeviceTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _allBindDeviceTableView.tableFooterView=[UIView new];
    }
    return _allBindDeviceTableView;
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
