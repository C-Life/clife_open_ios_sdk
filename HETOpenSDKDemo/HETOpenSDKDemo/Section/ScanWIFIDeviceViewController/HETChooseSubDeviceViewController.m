//
//  HETChooseSubDeviceViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/8/8.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETChooseSubDeviceViewController.h"
#import  <HETOpenSDK/HETOpenSDK.h>
#import "SVPullToRefresh.h"
#import "ScanWIFIViewController.h"
#import "UIImage+hetbundle.h"

#define kCellLeftMargin 16
#define kCellTopMargin 14
#define kCellHeight  70



@interface HETChooseSubDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSArray *_arData;
    
}

@property(strong,nonatomic) UITableView *tableView;

@end

@implementation HETChooseSubDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:[self.deviceDic objectForKey:@"deviceTypeName"]];
    [self.view addSubview:self.tableView];
    
    
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    //距离上边0像素
    NSLayoutConstraint *constraintTop=[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    // NSLayoutConstraint *constraintTop=[NSLayoutConstraint constraintWithItem:self.deviceCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    //距离左边0像素
    NSLayoutConstraint *constraintLeft=[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    //距离右边0像素
    NSLayoutConstraint *constraintRight=[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    //距离底部kUICollectionViewBottomGap像素
    NSLayoutConstraint *constraintBottom=[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    //把约束添加到父视图上
    NSArray *array = [NSArray arrayWithObjects:constraintTop, constraintLeft, constraintRight, constraintBottom, nil];
    [self.view addConstraints:array];
    
    
    WEAKSELF;
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        [weakSelf loadNewData];
    }];
    
    [self.tableView triggerPullToRefresh];

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)loadNewData
{
    NSString *deviceTypeId=[NSString stringWithFormat:@"%@",self.deviceDic[@"deviceTypeId"]];
    HETDeviceRequestBusiness *request=[[HETDeviceRequestBusiness alloc]init];
    [request fetchDeviceProductListWithDeviceTypeId:deviceTypeId success:^(id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code=[responseObject objectForKey:@"code"];
            NSArray *arrayValue=[responseObject objectForKey:@"data"];
            if(code.intValue==0)
            {
                _arData=arrayValue;
                [self.tableView reloadData];
            }
            else
            {
                
                
                
            }
            
        }
        else
        {
            
        }
        [self.tableView.pullToRefreshView stopAnimating];
 
    } failure:^(NSError *error) {
        [self.tableView.pullToRefreshView stopAnimating];

    }];
    /*
    if ([[HETNetWorkRequest shared].appKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"appKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    NSString *timezone=[HETURLRequestHelper currentTimeOffset] ;
    //获取时间戳
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *_timestamp = [NSString stringWithFormat: @"%lld", (long long)(time * 1000)];
  
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[HETNetWorkRequest shared].appKey,@"appId",_timestamp,@"timestamp",deviceTypeId,@"deviceTypeId",@"2",@"appType", nil];
    
    
    NSString * fullURL = [[HETNetWorkRequest shared].kHETAPIBaseUrl stringByAppendingString:@"/device/product/list"];
    [[HETNetWorkRequest shared]startRequestWithHTTPMethod:HETRequestMethodGet withRequestUrl:fullURL processParams:params needSign:NO BlockWithSuccess:^(HETNetWorkRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code=[responseObject objectForKey:@"code"];
            NSArray *arrayValue=[responseObject objectForKey:@"data"];
            if(code.intValue==0)
            {
                _arData=arrayValue;
                 [self.tableView reloadData];
            }
            else
            {
                
                
                
            }
            
        }
        else
        {
            
        }
        [self.tableView.pullToRefreshView stopAnimating];
        
    } failure:^(HETNetWorkRequestOperation *operation, NSError *error) {
       
             [self.tableView.pullToRefreshView stopAnimating];
        
    }];
   */

}
//#pragma mark ---system method
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    ![HETPublicUIConfig start_het_viewInteractivePopDisabled]?:[HETPublicUIConfig start_het_viewInteractivePopDisabled](self);
//
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(!_arData.count)
    {
        return 1;
    }
    
    return _arData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!_arData.count)
    {
        static NSString * CellIdentifier = @"UITableViewCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        cell.backgroundColor =[UIColor whiteColor];
        /*UIImage *xialatishiimage=[UIImage imageWithFileName:@"xialatishi_deviceBind"];
         UIImageView *xialatishiImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, xialatishiimage.size.width, xialatishiimage.size.height)];
         xialatishiImageView.center=CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CCViewHeight/2-xialatishiimage.size.height);
         xialatishiImageView.image=xialatishiimage;
         [cell.contentView addSubview:xialatishiImageView];
         
         UIImage *xialaimage=[UIImage imageWithFileName:@"xiala_deviceBind"];
         UIImageView *xialaImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, xialaimage.size.width, xialaimage.size.height)];
         xialaImageView.center=CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CCViewHeight/2+xialaimage.size.height/2);
         xialaImageView.image=xialaimage;
         [cell.contentView addSubview:xialaImageView];*/
        cell.backgroundColor =[UIColor whiteColor];
        UIImage *xialatishiimage=[UIImage hetimageWithFileName:@"xialatishi_deviceBind"];
        /*UIImageView *xialatishiImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, xialatishiimage.size.width, xialatishiimage.size.height)];*/
        UIImageView *xialatishiImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        //xialatishiImageView.center=CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), cell.frame.size.height/2-xialatishiimage.size.height);
        xialatishiImageView.image=xialatishiimage;
        [cell.contentView addSubview:xialatishiImageView];
        
        xialatishiImageView.translatesAutoresizingMaskIntoConstraints=NO;
        //设置中心横坐标等于父view的中心横坐标
        NSLayoutConstraint *constraintCenterX=[NSLayoutConstraint constraintWithItem:xialatishiImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        //设置中心纵坐标
        NSLayoutConstraint *constraintCenterY=[NSLayoutConstraint constraintWithItem:xialatishiImageView attribute:NSLayoutAttributeCenterY  relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-xialatishiimage.size.height];
        //设置宽为图片的宽
        NSLayoutConstraint *constraintWidth=[NSLayoutConstraint constraintWithItem:xialatishiImageView  attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:xialatishiimage.size.width];
        //设置高为图片的高
        NSLayoutConstraint *constraintHeight=[NSLayoutConstraint constraintWithItem:xialatishiImageView  attribute:NSLayoutAttributeHeight   relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:xialatishiimage.size.height];
        //把约束添加到父视图上
        NSArray *array = [NSArray arrayWithObjects:constraintCenterX, constraintCenterY, constraintWidth, constraintHeight, nil];
        [cell.contentView addConstraints:array];
        
        
        
        UIImage *xialaimage=[UIImage hetimageWithFileName:@"xiala_deviceBind"];
        //UIImageView *xialaImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, xialaimage.size.width, xialaimage.size.height)];
        UIImageView *xialaImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        //xialaImageView.center=CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), cell.frame.size.height/2+xialaimage.size.height/2);
        xialaImageView.image=xialaimage;
        [cell.contentView addSubview:xialaImageView];
        
        
        
        xialaImageView.translatesAutoresizingMaskIntoConstraints=NO;
        //设置中心横坐标等于xialatishiImageViewview的中心横坐标
        NSLayoutConstraint *constraintCenterX1=[NSLayoutConstraint constraintWithItem:xialaImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:xialatishiImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        //设置中心纵坐标
        NSLayoutConstraint *constraintCenterY1=[NSLayoutConstraint constraintWithItem:xialaImageView attribute:NSLayoutAttributeCenterY  relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:xialaimage.size.height/2.0];
        //设置宽为图片的宽
        NSLayoutConstraint *constraintWidth1=[NSLayoutConstraint constraintWithItem:xialaImageView  attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:xialaimage.size.width];
        //设置高为图片的高
        NSLayoutConstraint *constraintHeight1=[NSLayoutConstraint constraintWithItem:xialaImageView  attribute:NSLayoutAttributeHeight   relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:xialaimage.size.height];
        //把约束添加到父视图上
        NSArray *array1 = [NSArray arrayWithObjects:constraintCenterX1, constraintCenterY1, constraintWidth1, constraintHeight1, nil];
        [cell.contentView addConstraints:array1];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        
        
        NSString *reuseIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(kCellLeftMargin,kCellTopMargin, tableView.frame.size.width-kCellLeftMargin*2, kCellHeight-kCellTopMargin)];
        backgroundView.layer.cornerRadius=4;
        
        backgroundView.backgroundColor=[UIColor colorWithRed:113/255.0 green:158/255.0 blue:219/255.0 alpha:1.0];
        [cell.contentView addSubview:backgroundView];
        
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, backgroundView.frame.size.width-10, backgroundView.frame.size.height*0.5-5)];
        // UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, backgroundView.frame.size.width-10, backgroundView.frame.size.height)];
        [nameL setBackgroundColor:[UIColor clearColor]];
        [nameL setTextAlignment:NSTextAlignmentCenter];
        nameL.font=[UIFont systemFontOfSize:18];
        [nameL setTextColor:[UIColor whiteColor]];
        [backgroundView addSubview:nameL];
        
        UILabel *xinghaoL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.frame.origin.x, nameL.frame.origin.y+nameL.frame.size.height, nameL.frame.size.width, backgroundView.frame.size.height*0.5-5)];
        [xinghaoL setBackgroundColor:[UIColor clearColor]];
        xinghaoL.textAlignment=NSTextAlignmentLeft;
        [xinghaoL setTextColor:[UIColor whiteColor]];
        xinghaoL.font=[UIFont systemFontOfSize:14];
        [backgroundView addSubview:xinghaoL];
        
        NSDictionary *dic=[_arData objectAtIndex:indexPath.row];
        xinghaoL.text=[dic objectForKey:@"deviceSubtypeName"];
        //xinghaoL.text=[dic objectForKey:@"deviceModel"];
        NSString *str=[dic objectForKey:@"productCode"];
        if([str isKindOfClass:[NSNull class]])
        {
            nameL.text=[dic objectForKey:@"deviceSubtypeName"];
        }
        else
        {
        if(!str.length)
        {
            if([str isEqualToString:@"CC-1001"])
            {
            NSString *productNameStr=[dic objectForKey:@"productName"];
            if(productNameStr.length)
            {
                nameL.text=productNameStr;
            }
            else
            {
                nameL.text=[dic objectForKey:@"deviceSubtypeName"];
            }
            }
        }
        else
        {
            nameL.text=[dic objectForKey:@"productCode"];
        }
        }
        CGSize maxsize = CGSizeMake(backgroundView.frame.size.width, MAXFLOAT);
        // CGSize labelSize1  = [nameL.text sizeWithFont:nameL.font constrainedToSize:maxsize lineBreakMode:NSLineBreakByWordWrapping];
        
        //CGSize labelSize2  = [xinghaoL.text sizeWithFont:xinghaoL.font constrainedToSize:maxsize lineBreakMode:NSLineBreakByWordWrapping];
        
        
        
        
        CGSize labelSize1 = [nameL.text boundingRectWithSize:maxsize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:nameL.font} context:nil].size;
        
        CGSize labelSize2 = [xinghaoL.text boundingRectWithSize:maxsize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: xinghaoL.font} context:nil].size;
        
        float gap=(backgroundView.frame.size.height-labelSize1.height-labelSize2.height-2)/2.0;
        
        nameL.frame=CGRectMake(10, 0+gap,labelSize1.width, labelSize1.height);
        
        xinghaoL.frame=CGRectMake(nameL.frame.origin.x, nameL.frame.origin.y+nameL.frame.size.height+2, labelSize2.width, labelSize2.height);
        cell.backgroundColor=self.view.backgroundColor;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_arData.count)
    {
        return tableView.frame.size.height;
    }
    
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!_arData.count){
        return;
    }
    
    NSDictionary *dic=[_arData objectAtIndex:indexPath.row];
    NSLog(@"dic:%@",dic);
    if(!dic)
    {
        return;
    }
    
    /* NSString *bindTypeStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"bindType"]];
     NSString *deviceTypeStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"deviceTypeId"]];
     NSString *deviceSubTypeStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"deviceSubtypeId"]];
     HETDeviceObject *obj=[[HETDeviceObject alloc]init];
     obj.deviceTypeId=deviceTypeStr;
     obj.deviceSubtypeId=deviceSubTypeStr;
     
     NSString *str=[dic objectForKey:@"deviceIcon"];
     NSMutableString *mutStr=[[NSMutableString alloc]init];
     [mutStr appendString:str];
     [mutStr appendString:[NSString stringWithFormat:@"/%@/%@/%@/ios/%@/4.png",[dic objectForKey:@"deviceBrandId"],[dic objectForKey:@"deviceTypeId"],[dic objectForKey:@"deviceSubtypeId"],isiPhone6s?(@"1242x2208"):(@"640x1136")]];
     NSLog(@"%@,%@",dic,mutStr);
     obj.deviceIcon=mutStr;//[dic objectForKey:@"deviceIcon"];*/
    
    
    
    
    NSString *bindTypeStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"moduleType"]];
    NSString *deviceTypeStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"deviceTypeId"]];
    NSString *deviceSubTypeStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"deviceSubtypeId"]];
    NSString *moduleIdStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"moduleId"]];
    NSString *productId=[NSString stringWithFormat:@"%@", [dic objectForKey:@"productId"]];
 
    

    
    
    if(bindTypeStr.intValue==1)//wifi绑定
    {
        
        ScanWIFIViewController *vc=[[ScanWIFIViewController alloc]init];
        vc.bindTypeStr=bindTypeStr;
        vc.deviceTypeStr=deviceTypeStr;
        vc.deviceSubTypeStr=deviceSubTypeStr;
        vc.moduleIdStr=moduleIdStr;
        vc.productId=productId;
      
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }

    
    
}
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
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

#pragma mark tableView
-(UITableView *)tableView
{
    if(!_tableView)
    {
        //_tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, CCViewWidth, (CCViewHeight)) style:UITableViewStylePlain];
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor=self.view.backgroundColor;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
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
