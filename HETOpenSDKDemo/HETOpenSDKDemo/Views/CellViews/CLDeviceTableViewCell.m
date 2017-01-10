//
//  CLWIFIBindTableViewCell.m
//  NewBindDeviceProject
//
//  Created by mr.cao on 15/7/18.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "CLDeviceTableViewCell.h"
@interface CLDeviceTableViewCell()
{
    UIImageView *_iconImageView;
    UILabel *_deviceNameLabel;
    UILabel *_deviceMacAddrLable;
    UIImageView *_accessoryButton;
    UIImage *_image;
  
    
}

@end

@implementation CLDeviceTableViewCell

- (void)awakeFromNib {
    // Initialization code
   

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if(!_iconImageView)
        {
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,CGRectGetHeight(self.frame)/2- 32/2, 32, 32)];
            [self.contentView addSubview:_iconImageView];
        }
        if(!_deviceNameLabel)
        {
            _deviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+10, 0,CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2*0)];
            [self.contentView addSubview:_deviceNameLabel];
        }
        if(!_deviceMacAddrLable)
        {
            _deviceMacAddrLable=[[UILabel alloc] initWithFrame:CGRectMake(_deviceNameLabel.frame.origin.x, _deviceNameLabel.frame.origin.y+_deviceNameLabel.frame.size.height,CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2*2)];
            [self.contentView addSubview:_deviceMacAddrLable];
        }
        if(!_accessoryButton)
        {
            _accessoryButton=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-25-10,CGRectGetHeight(self.frame)/2.0- 25.0/2,25, 25)];
            [self.contentView addSubview:_accessoryButton];
        }

    }
    return self;
}



-(void)setCellContentWithDic:(NSDictionary *)dic
{
    
    _deviceMacAddrLable.text=dic[@"device_mac"];
    NSString *setChecked=dic[@"setChecked"];
    NSString *deviceIcon=dic[@"deviceIcon"];
    if (setChecked.integerValue==1) {
        
        _accessoryButton.image=[UIImage imageNamed:@"check_deviceBind"];
    }
    else{
        _accessoryButton.image=[UIImage imageNamed:@"uncheck_deviceBind"];
    }
    if([deviceIcon rangeOfString:@"http://"].length)
    {
        
        NSURL *url = [NSURL URLWithString:[deviceIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:imgData];
        _image=img;
    }
    else
    {
        _image=[UIImage imageNamed:deviceIcon];
    }
    if(_image)
    {
        _iconImageView.image=_image;
    }
 

}
-(void)setMacName:(NSString *)macname
{
    _deviceMacAddrLable.text=macname;
}
-(void)setIconName:(NSString *)deviceIcon
{
    if(deviceIcon)
    {
        if([deviceIcon rangeOfString:@"http://"].length)
        {
            
            NSURL *url = [NSURL URLWithString:[deviceIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *imgData = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:imgData];
            _image=img;
        }
        else
        {
            _image=[UIImage imageNamed:deviceIcon];
        }
        if(_image)
        {
            _iconImageView.image=_image;
        }
    }
}
- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        _accessoryButton.image=[UIImage imageNamed:@"check_deviceBind"];
    }
    else
    {
        _accessoryButton.image=[UIImage imageNamed:@"uncheck_deviceBind"];
    
    }
    
}

-(void)layoutSubviews {
       [super layoutSubviews];
    if(_image)
    {
       if(_image.size.height>_image.size.width)
       {
        _iconImageView.frame=CGRectMake(10,CGRectGetHeight(self.frame)/2-  32*_image.size.height/_image.size.width/2, 32, 32*_image.size.height/_image.size.width);
       }
      else
      {
        _iconImageView.frame=CGRectMake(10,CGRectGetHeight(self.frame)/2-  32/2, 32*_image.size.width/_image.size.height, 32);
       }
    }
  
        _deviceNameLabel.frame=CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+10, 0,CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2*0);
  
        _deviceMacAddrLable.frame=CGRectMake(_deviceNameLabel.frame.origin.x, _deviceNameLabel.frame.origin.y+_deviceNameLabel.frame.size.height,CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2*2);
   
        _accessoryButton.frame=CGRectMake(CGRectGetWidth(self.frame)-25-10,CGRectGetHeight(self.frame)/2.0- 25.0/2,25, 25);
    
 
}
@end
