//
//  CLALLWIFIDeviceViewController.m
//  NewBindDeviceProject
//
//  Created by mr.cao on 15/6/25.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "ALLWIFIDeviceViewController.h"
#import "CLDeviceTableViewCell.h"
#import "HETDeviceObject.h"
#import "MainViewController.h"
#import "HETCommonHelp.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ALLWIFIDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
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
//    [self.view addSubview:self.scanDeviceTableView];
//    [self.view addSubview:self.bottomView];
//    [self.view addSubview:self.beginBindButton];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //HF WiFi模块接入路由
    smtlk =[[HFSmartLink alloc]init];
    smtlk.isConfigOneDevice = false;
    
    smtlk.waitTimers = 30;
    [smtlk startWithKey:self.wifiPassword processblock:^(NSInteger process) {
        
    } successBlock:^(HFSmartLinkDeviceInfo *dev) {
        //[self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
    } failBlock:^(NSString *failmsg) {
        //[self  showAlertWithMsg:failmsg title:@"error"];
    } endBlock:^(NSDictionary *deviceDic) {
        
        
    }];
    

    [HETCommonHelp showCustomHudtitle:@"开始绑定设备"];
    manager=[HETWIFIBindBusiness sharedInstance];
    [manager startBindDeviceWithProductId:self.productId withTimeOut:100 completionHandler:^(HETWIFICommonReform *deviceObj, NSError *error) {
        NSLog(@"设备mac地址:%@,%@",deviceObj.device_mac,error);
        [smtlk closeWithBlock:^(NSString *closeMsg, BOOL isOK) {
            
        }];
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            
        }];
        smtlk=nil;
       if(error)
       {
           [HETCommonHelp HidHud];
           [self.navigationController popViewControllerAnimated:YES];
       }
        else
        {
            [HETCommonHelp HidHud];
            MainViewController *vc=[[MainViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止扫描
    [manager stop];
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
