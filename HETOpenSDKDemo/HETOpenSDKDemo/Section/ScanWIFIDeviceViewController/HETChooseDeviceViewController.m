//
//  HETChooseDeviceViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/8/8.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETChooseDeviceViewController.h"
#import "HETDeviceCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "HETChooseSubDeviceViewController.h"
#import "SVPullToRefresh.h"



#define kImageIcon @"deviceTypeIcon"
#define kTitle     @"deviceTypeName"

#define kCellHeight 44


@interface HETChooseDeviceViewController()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *_allDeviceDataSouce;
    NSMutableArray *_showData;
    
}

@property(strong,nonatomic)UICollectionView *deviceCollectionView;
@end

@implementation HETChooseDeviceViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarTitle:@"添加设备"];
    [self.view addSubview:self.deviceCollectionView];
    [self.deviceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    
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
        STRONGSELF;
        [strongSelf loadNewData];
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
    HETDeviceRequestBusiness *bussiness=[[HETDeviceRequestBusiness alloc]init];
    [bussiness fetchDeviceTypeListSuccess:^(id responseObject) {
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
            
        }
        [self.deviceCollectionView.pullToRefreshView stopAnimating];
        
    } failure:^(NSError *error) {
        [self.deviceCollectionView.pullToRefreshView stopAnimating];

    }];
    
  
    
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
         [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.backgroundColor =[UIColor whiteColor];
        UIImage *pullTipsImage=[UIImage imageNamed:@"pulltips"];
        UIImageView *pullTipsImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        pullTipsImageView.image=pullTipsImage;
        [cell.contentView addSubview:pullTipsImageView];
        [pullTipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.centerY.equalTo(cell.contentView.mas_centerY).offset(-pullTipsImage.size.height/2)
            ;
            make.width.equalTo(@(pullTipsImage.size.width));
            make.height.equalTo(@(pullTipsImage.size.height));
        }];
        
        UIImage *pullImage=[UIImage imageNamed:@"pull"];
        UIImageView *pullImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        pullImageView.image=pullImage;
        [cell.contentView addSubview:pullImageView];
        [pullImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.centerY.equalTo(cell.contentView.mas_centerY).offset(pullImage.size.height/2.0)
            ;
            make.width.equalTo(@(pullImage.size.width));
            make.height.equalTo(@(pullImage.size.height));
        }];

        cell.backgroundColor =[UIColor whiteColor];
        return cell;
    }
    else
    {
        static NSString * CellIdentifier = @"HETDeviceCollectionViewCell";
        HETDeviceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        NSDictionary *dic=[_showData objectAtIndex:indexPath.row];
        NSString *imageName=[dic objectForKey:kImageIcon];
        [cell setCellTitle:[dic objectForKey:kTitle]];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageName]
                              placeholderImage:[UIImage imageNamed:@"refrigerator"]];
     
        return cell;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_showData.count)
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width,collectionView.frame.size.height);
    }
    //四行三列
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-2)/3.0,(collectionView.frame.size.height-4)/4.0);
    
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
            HETDeviceCollectionViewCell *everyCell = (HETDeviceCollectionViewCell *)[self.deviceCollectionView cellForItemAtIndexPath:index];
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
        [_deviceCollectionView registerClass:[HETDeviceCollectionViewCell class] forCellWithReuseIdentifier:@"HETDeviceCollectionViewCell"];
        [_deviceCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_deviceCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHead"];
    }
    return _deviceCollectionView;

}

@end
