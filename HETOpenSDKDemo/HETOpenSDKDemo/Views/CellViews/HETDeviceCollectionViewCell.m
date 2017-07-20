//
//  HETDeviceCollectionViewCell.m
//  NewBindDeviceProject
//
//  Created by mr.cao on 15/6/30.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "HETDeviceCollectionViewCell.h"
#import "HETUIConfig.h"
#import "Masonry.h"
@interface HETDeviceCollectionViewCell()
{
   
}

@end
@implementation HETDeviceCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(!_iconImageView)
        {
            _iconImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:_iconImageView];
        }
        if(!_deviceNameLabel)
        {
           _deviceNameLabel= [[UILabel alloc] initWithFrame:CGRectZero];
        
           _deviceNameLabel.textColor =[UIColor colorWithRed:113/255.0 green:158/255.0 blue:219/255.0 alpha:1.0];
           _deviceNameLabel.textAlignment=NSTextAlignmentCenter;
           //_deviceNameLabel.adjustsFontSizeToFitWidth=YES;
           // _deviceNameLabel.backgroundColor=[UIColor redColor];
           [self.contentView addSubview:_deviceNameLabel];
            
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
- (void)layoutSubviews
{
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).multipliedBy(1.0);
        make.centerY.equalTo(self.contentView).multipliedBy(0.6);
        make.width.and.height.equalTo(self.contentView.mas_height).multipliedBy(0.4);
    }];
    [_deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_iconImageView.mas_bottom).mas_offset(5);
        make.width.equalTo(self.contentView.mas_width);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    [super layoutSubviews];
}
@end
