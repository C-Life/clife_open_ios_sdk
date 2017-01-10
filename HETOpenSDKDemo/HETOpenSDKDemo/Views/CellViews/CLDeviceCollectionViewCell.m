//
//  CLDeviceCollectionViewCell.m
//  NewBindDeviceProject
//
//  Created by mr.cao on 15/6/30.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "CLDeviceCollectionViewCell.h"
#import "HETUIConfig.h"

@interface CLDeviceCollectionViewCell()
{
   
    

}

@end
@implementation CLDeviceCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(!_iconImageView)
        {
            _iconImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
            _iconImageView.frame=CGRectMake(0, self.frame.size.height*0.1,self.frame.size.height*0.4, self.frame.size.height*0.4);
            _iconImageView.center=CGPointMake(self.frame.size.width/2.0, self.frame.size.height*0.6*0.5);

           
            [self.contentView addSubview:_iconImageView];
            
            _iconImageView.translatesAutoresizingMaskIntoConstraints=NO;
            //设置中心横坐标等于父view的中心横坐标
            NSLayoutConstraint *constraintCenterX=[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            //设置中心纵坐标
            NSLayoutConstraint *constraintCenterY=[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeCenterY  relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:0.6 constant:0];
            //设置宽为高的0.4倍
            NSLayoutConstraint *constraintWidth=[NSLayoutConstraint constraintWithItem:_iconImageView  attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0];
            //设置高为高的0.4倍
            NSLayoutConstraint *constraintHeight=[NSLayoutConstraint constraintWithItem:_iconImageView  attribute:NSLayoutAttributeHeight   relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0];
            //把约束添加到父视图上
            NSArray *array = [NSArray arrayWithObjects:constraintCenterX, constraintCenterY, constraintWidth, constraintHeight, nil];
            [self.contentView addConstraints:array];
            
            
        }
        if(!_deviceNameLabel)
        {
           _deviceNameLabel= [[UILabel alloc] initWithFrame:CGRectZero];
        
           _deviceNameLabel.textColor =[UIColor colorWithRed:113/255.0 green:158/255.0 blue:219/255.0 alpha:1.0];
           _deviceNameLabel.textAlignment=NSTextAlignmentCenter;
           //_deviceNameLabel.adjustsFontSizeToFitWidth=YES;
           // _deviceNameLabel.backgroundColor=[UIColor redColor];
           [self.contentView addSubview:_deviceNameLabel];
            
            
            
            _deviceNameLabel.translatesAutoresizingMaskIntoConstraints=NO;
            //设置中心横坐标等于父view的中心横坐标
            NSLayoutConstraint *constraintCenterX=[NSLayoutConstraint constraintWithItem:_deviceNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            //设置纵坐标起点
            NSLayoutConstraint *constraintTop=[NSLayoutConstraint constraintWithItem:_deviceNameLabel attribute:NSLayoutAttributeTop  relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
            //设置宽
            NSLayoutConstraint *constraintWidth=[NSLayoutConstraint constraintWithItem:_deviceNameLabel  attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
            //设置纵坐标终点
            NSLayoutConstraint *constraintBottom=[NSLayoutConstraint constraintWithItem:_deviceNameLabel  attribute:NSLayoutAttributeBottom   relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            //把约束添加到父视图上
            NSArray *array = [NSArray arrayWithObjects:constraintCenterX, constraintTop, constraintWidth, constraintBottom, nil];
            [self.contentView addConstraints:array];
            
            
           
            
        }

        
    }
    return self;
}

-(void)setCellImage:(UIImage *)image
{
    _iconImageView.image=image;
 
}
-(void)setCellTitle:(NSString *)title
{
   
    _deviceNameLabel.text=title;
}

@end
