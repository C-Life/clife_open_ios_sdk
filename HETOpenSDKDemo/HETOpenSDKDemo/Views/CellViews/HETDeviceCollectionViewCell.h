//
//  HETDeviceCollectionViewCell.h
//
//
//  Created by mr.cao on 15/6/30.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETDeviceCollectionViewCell : UICollectionViewCell
{
    
}
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *deviceNameLabel;

-(void)setCellImage:(UIImage *)image;
-(void)setCellTitle:(NSString *)title;
@end
