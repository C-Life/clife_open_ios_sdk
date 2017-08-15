//
//  HETDeviceSearchUserController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/7/11.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETDeviceShareViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <HETOpenSDK/HETOpenSDK.h>
#import "HETCommonHelp.h"
#import "HETUIConfig.h"
@interface HETDeviceShareViewController ()<ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    
    
    NSArray *_allDeviceDataSouce;
}

@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIView *aboveBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property(strong,nonatomic)UITableView *sharedDeviceTableView;

@end

@implementation HETDeviceShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self configViews];
    
    __weak HETDeviceShareViewController *weakSelf = self;
    [HETDeviceShareBusiness deviceGetAuthSuccess:^(id responseObject) {
        _allDeviceDataSouce=responseObject;
        [weakSelf.sharedDeviceTableView reloadData];

    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)configViews{
    self.navigationItem.title = @"设备分享";
    [self.view addSubview:self.sharedDeviceTableView];
    
    [self.textfield addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    self.aboveBackgroundView.layer.borderWidth = 0.5f;
    self.aboveBackgroundView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    
    self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.icon.tintColor =[HETUIConfig colorFromHexRGB:@"3285ff"];
    self.addBtn.enabled=NO;
    [self.addBtn setBackgroundColor:[UIColor grayColor]];
}
- (IBAction)addressBtnClick:(id)sender {
    ABPeoplePickerNavigationController *peoplePickerNC = [ABPeoplePickerNavigationController new];
    peoplePickerNC.peoplePickerDelegate = self;
    
    [self presentViewController:peoplePickerNC animated:YES completion:nil];
}

- (IBAction)inviteBtnClick:(id)sender{
    
    
    
//    if ([self.textfield.text isEqualToString:[HETUserInfo userInfo].userAccount]) {
//        [CCCommonHelp showAutoDissmissAlertView:nil msg: @"不能邀请自己控制"];
//        return ;
//    }
//    [self GetUserByAccount:self.textfield.text];
    
    
    [HETCommonHelp showCustomHudtitle:@"邀请中"];
    [HETDeviceShareBusiness deviceInviteWithDeviceId:self.deviceId account:self.textfield.text success:^(id responseObject) {
        
          [HETCommonHelp HidHud];
          [HETCommonHelp showAutoDissmissAlertView:nil msg: @"分享请求发送成功"];
        
         [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
        [HETCommonHelp HidHud];
        [HETCommonHelp showAutoDissmissAlertView:nil msg:error.userInfo[@"msg"]];

        
    }];

}

- (void)textFieldDidChange:(UITextField *)textfield {
   // NSLog(@"Catch -> %@", textfield.text);
    
    self.addBtn.enabled = [self checkAccountAndSendVerifycode];
    if(self.addBtn.enabled)
    {
        [self.addBtn setBackgroundColor:[self colorFromHexRGB:@"2E7BD3"]];
    }
    else
    {
        [self.addBtn setBackgroundColor:[UIColor grayColor]];
    }

}

- (BOOL)checkAccountAndSendVerifycode {
  
    return [self isValidEmail:self.textfield.text] || [self isMobileNumber:self.textfield.text];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //    for (int k = 0; k<ABMultiValueGetCount(phone); k++){
    NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
    [self chooseComplete:personPhone];
    //        break;
    //    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //    for (int k = 0; k<ABMultiValueGetCount(phone); k++){
    NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
    [self chooseComplete:personPhone];
    //        break;
    //    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)chooseComplete:(NSString *)phone{
    NSMutableString *tempPhone = [phone mutableCopy];
    [tempPhone stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    self.textfield.text = tempPhone;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        //[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        NSDictionary *dic=[_allDeviceDataSouce objectAtIndex:indexPath.row];
   
        NSString *deviceName=[dic objectForKey:@"deviceName"];
        NSString *deviceMac=[dic objectForKey:@"macAddress"];
        NSString *deviceId=[dic objectForKey:@"deviceId"];
     
        
        UILabel *deviceNameLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        deviceNameLable.text=deviceName;
        deviceNameLable.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:deviceNameLable];
        
        UILabel *deviceMacLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, 100, 25)];
        deviceMacLable.text=deviceMac;
        deviceMacLable.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:deviceMacLable];
        
        
        UILabel *deviceIdLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-100, 50)];
        deviceIdLable.text=deviceId;
        deviceIdLable.textAlignment=NSTextAlignmentRight;
        deviceIdLable.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:deviceIdLable];
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth([[UIScreen mainScreen]bounds]), 44)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth([[UIScreen mainScreen]bounds]) * 0.9, 20)];
    titleLabel.text = @"已分享的设备";
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:titleLabel];
    return view;
}


-(void)viewDidLayoutSubviews {
    
    if ([self.sharedDeviceTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.sharedDeviceTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.sharedDeviceTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.sharedDeviceTableView setLayoutMargins:UIEdgeInsetsZero];
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
-(UITableView *)sharedDeviceTableView
{
    if(!_sharedDeviceTableView)
    {
        _sharedDeviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(1,self.addBtn.frame.origin.y+self.addBtn.frame.size.height+20,CGRectGetWidth([UIScreen mainScreen].bounds)-2, CGRectGetHeight([UIScreen mainScreen].bounds)-(self.addBtn.frame.origin.y+self.addBtn.frame.size.height+20)-2) style:UITableViewStyleGrouped];
        _sharedDeviceTableView.delegate = self;
        _sharedDeviceTableView.dataSource = self;
        _sharedDeviceTableView.backgroundColor = [UIColor clearColor];
        _sharedDeviceTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _sharedDeviceTableView.tableFooterView=[UIView new];
        _sharedDeviceTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _sharedDeviceTableView.layer.borderWidth=1.0f;
    }
    return _sharedDeviceTableView;
}



- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,184,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0125-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,147,150,151,157,158,159,182,187,188,178,1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[7]|5[017-9]|8[23478]|78)\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,176,1709
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|76)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181,177,1700
     22         */
    NSString * CT = @"^1((33|53|8[019]|77)[0-9]|349|70[059])\\d{7}$";
    //178 1705 1709 176  177 1700
    NSString *newMobile = @"^17(8[0-9]|0[059]|6[0-9]|7[0-9])\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextesnewMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", newMobile];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextesnewMobile evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//检查邮箱是否有效
-(BOOL)isValidEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

@end
