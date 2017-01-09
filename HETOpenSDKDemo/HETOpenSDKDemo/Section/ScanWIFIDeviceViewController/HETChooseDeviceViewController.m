//
//  HETChooseDeviceViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/8/8.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETChooseDeviceViewController.h"
#import "CLDeviceCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "HETChooseSubDeviceViewController.h"
//#import "HETNetWorkRequest.h"
//#import "HETURLRequestHelper.h"
#import  <HETOpenSDK/HETOpenSDK.h>
#import "SVPullToRefresh.h"
//#import "HETDeviceRequestBusiness.h"


#define kImageIcon @"deviceTypeIcon"
#define kTitle     @"deviceTypeName"

#define kCellHeight 44
#define kSearchBarHeight 44
#define kUICollectionViewBottomGap 0

@interface HETChooseDeviceViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
{
    NSArray *_allDeviceDataSouce;
    NSMutableArray *_showData;
    
}
@property(strong,nonatomic)UIView *headView;
@property(strong,nonatomic)UIButton *blueToothBtn;
@property(strong,nonatomic)UIButton *saoyisaoBtn;
@property(strong,nonatomic)UICollectionView *deviceCollectionView;
@property(strong,nonatomic)UISearchBar *searchBar;
@end

@implementation HETChooseDeviceViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarTitle:@"设备添加"];
    UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    [self.view addSubview:self.deviceCollectionView];
    
        //隐藏导航栏的发髻线
    for (UIView *view in [[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews])
    {
        
        if ([view isKindOfClass:[UIImageView class]])
        {
            view.hidden = YES;
            break;
        }
        
    }
    
   

    
    WEAKSELF;
    [self.deviceCollectionView addPullToRefreshWithActionHandler:^{
        
        [weakSelf loadNewData];
    }];
    
    [self.deviceCollectionView triggerPullToRefresh];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


//获取大类列表
-(void)loadNewData
{

    HETDeviceRequestBusiness *request=[[HETDeviceRequestBusiness alloc]init];
    [request fetchDeviceTypeListSuccess:^(id responseObject) {
        
        
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code=[responseObject objectForKey:@"code"];
            NSArray *arrayValue=[responseObject objectForKey:@"data"];
            if(code.intValue==0)
            {
                _allDeviceDataSouce=arrayValue;
                _showData= [[NSMutableArray alloc]initWithArray:arrayValue];
                
                [_deviceCollectionView reloadData];
                
            }
            else
            {
                
                
                
            }
            
        }
        else
        {
            
        }
        [self.deviceCollectionView.pullToRefreshView stopAnimating];
        
    } failure:^(NSError *error) {
        [self.deviceCollectionView.pullToRefreshView stopAnimating];

    }];
    
  
    
}

#pragma mark  action


-(void)handleSingleTap:(id)sender{
    [_searchBar resignFirstResponder];
    
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(!_showData.count)
    {
        return 1;
    }
    
    return _showData.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_showData.count)
    {
        static NSString * CellIdentifier = @"UICollectionViewCell";
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        cell.backgroundColor =[UIColor whiteColor];
       /* UIImage *xialatishiimage=[UIImage hetimageWithFileName:@"xialatishi_deviceBind"];
        /*UIImageView *xialatishiImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, xialatishiimage.size.width, xialatishiimage.size.height)];*/
       /* UIImageView *xialatishiImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
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
        [cell.contentView addConstraints:array1];*/
        
       
        return cell;
    }
    else
    {
        static NSString * CellIdentifier = @"CLDeviceCollectionViewCell";
        CLDeviceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSDictionary *dic=nil;
        dic=[_showData objectAtIndex:indexPath.row];
        
        
        NSString *imageName=[dic objectForKey:kImageIcon];
        [cell setCellTitle:[dic objectForKey:kTitle]];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageName]
                              placeholderImage:[UIImage hetimageWithFileName:@"bingxiang_deviceBind"]];
     
        return cell;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_showData.count)
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width,collectionView.frame.size.height-kSearchBarHeight-kUICollectionViewBottomGap);
    }
    //四行三列
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-2)/3.0,(collectionView.frame.size.height-kSearchBarHeight-4)/4.0);
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_showData.count)
    {
        
        for (NSIndexPath *index in [self indexPathForTableView:self.deviceCollectionView]) {
            CLDeviceCollectionViewCell *everyCell = (CLDeviceCollectionViewCell *)[self.deviceCollectionView cellForItemAtIndexPath:index];
            everyCell.backgroundColor=[UIColor whiteColor];
            
        }
        
       HETChooseSubDeviceViewController *vc=[[HETChooseSubDeviceViewController alloc]init];
       NSDictionary *dic=[_showData objectAtIndex:indexPath.row];
       vc.deviceDic=dic;
       [self.navigationController pushViewController:vc animated:YES];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSArray *)indexPathForTableView:(UICollectionView *)table
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<[table numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [array addObject:indexPath];
    }
    return array;
}

#pragma mark deviceCollectionView
-(UICollectionView *)deviceCollectionView
{
    if(!_deviceCollectionView)
    {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing=1;
        flowLayout.minimumInteritemSpacing=1;
   
        _deviceCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) collectionViewLayout:flowLayout];
        

        _deviceCollectionView.dataSource=self;
        _deviceCollectionView.delegate=self;
        [_deviceCollectionView setBackgroundColor:[UIColor whiteColor]];
        _deviceCollectionView.showsVerticalScrollIndicator=NO;
        _deviceCollectionView.alwaysBounceVertical=YES;
        //注册Cell，必须要有
        [_deviceCollectionView registerClass:[CLDeviceCollectionViewCell class] forCellWithReuseIdentifier:@"CLDeviceCollectionViewCell"];
        [_deviceCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_deviceCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHead"];
    }
    return _deviceCollectionView;

}

@end
