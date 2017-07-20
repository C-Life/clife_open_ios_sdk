//
//  AllBindDeviceTableViewCell.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 2017/4/13.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import "AllBindDeviceTableViewCell.h"
#import "Masonry.h"
@implementation AllBindDeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
            [self.contentView addSubview:_deviceNameLabel];
            
        }
        if(!_deviceMacLabel)
        {
            _deviceMacLabel= [[UILabel alloc] initWithFrame:CGRectZero];
            
            _deviceMacLabel.textColor =[UIColor colorWithRed:113/255.0 green:158/255.0 blue:219/255.0 alpha:1.0];
            [self.contentView addSubview:_deviceMacLabel];
            
        }
        if(!_deviceOnoffLabel)
        {
            _deviceOnoffLabel= [[UILabel alloc] initWithFrame:CGRectZero];
            
            _deviceOnoffLabel.textColor =[UIColor colorWithRed:113/255.0 green:158/255.0 blue:219/255.0 alpha:1.0];
            _deviceOnoffLabel.textAlignment=NSTextAlignmentRight;
            //_deviceNameLabel.adjustsFontSizeToFitWidth=YES;
            // _deviceNameLabel.backgroundColor=[UIColor redColor];
            [self.contentView addSubview:_deviceOnoffLabel];
            
        }
        
    }
    return self;
}
- (void)layoutSubviews
{
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).mas_offset(5);
            make.top.equalTo(self.contentView.mas_top);
            make.width.and.height.equalTo(self.contentView.mas_height);
            
        }];
        [_deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).mas_offset(5);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(_deviceOnoffLabel.mas_left).mas_offset(-5);
            make.height.equalTo(self.contentView.mas_height).multipliedBy(0.5);
        }];
        [_deviceMacLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_deviceNameLabel.mas_left);
            make.top.equalTo(_deviceNameLabel.mas_bottom);
            make.right.equalTo(_deviceNameLabel.mas_right);
            make.height.equalTo(_deviceNameLabel.mas_height);
        }];
        [_deviceOnoffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.height.equalTo(self.contentView.mas_height);
            make.width.equalTo(@(50));
        }];
    
    [super layoutSubviews];
}
@end
