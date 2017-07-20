//
//  ChooseSubDeviceTableViewCell.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 2017/4/17.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import "ChooseSubDeviceTableViewCell.h"
#import "Masonry.h"

@interface ChooseSubDeviceTableViewCell()
@property(nonatomic,strong) UIView *cellbackgroundView;
@end

@implementation ChooseSubDeviceTableViewCell

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
        if(!_cellbackgroundView)
        {
          _cellbackgroundView=[[UIView alloc]initWithFrame:CGRectZero];
          _cellbackgroundView.layer.cornerRadius=4;
          _cellbackgroundView.backgroundColor=[UIColor colorWithRed:113/255.0 green:158/255.0 blue:219/255.0 alpha:1.0];
        [self.contentView addSubview:_cellbackgroundView];
        }
        if(!_deviceNameLabel)
        {
            _deviceNameLabel= [[UILabel alloc] initWithFrame:CGRectZero];
            [_deviceNameLabel setBackgroundColor:[UIColor clearColor]];
            [_deviceNameLabel setTextAlignment:NSTextAlignmentLeft];
            _deviceNameLabel.font=[UIFont systemFontOfSize:18];
            [_deviceNameLabel setTextColor:[UIColor whiteColor]];
            [_cellbackgroundView addSubview:_deviceNameLabel];
            
        }
        if(!_deviceModelLabel)
        {
            _deviceModelLabel= [[UILabel alloc] initWithFrame:CGRectZero];
            [_deviceModelLabel setBackgroundColor:[UIColor clearColor]];
            _deviceModelLabel.textAlignment=NSTextAlignmentLeft;
            [_deviceModelLabel setTextColor:[UIColor whiteColor]];
            _deviceModelLabel.font=[UIFont systemFontOfSize:14];
            [_cellbackgroundView addSubview:_deviceModelLabel];
            
        }
        
    }
    return self;
}
- (void)layoutSubviews
{
 
    [_cellbackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];
    [_deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cellbackgroundView.mas_left).offset(10);
        make.top.equalTo(_cellbackgroundView.mas_top).offset(5);
        make.right.equalTo(_cellbackgroundView.mas_right).offset(-10);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.5).offset(-5);
    }];
    [_deviceModelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deviceNameLabel.mas_left);
        make.top.equalTo(_deviceNameLabel.mas_bottom);
        make.right.equalTo(_deviceNameLabel.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [super layoutSubviews];
}
@end

