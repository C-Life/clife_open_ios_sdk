//
//  HETCommonHelp.m
//  HETPublic
//
//  Created by mr.cao on 15/4/10.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "HETCommonHelp.h"



#pragma mark ---
@implementation HETCommonHelp

#pragma mark -----loading框方法集
+(MBProgressHUD *)showCustomHudtitle:(NSString *)title {

    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].windows.lastObject] ;
    [[UIApplication sharedApplication].windows.lastObject addSubview:hud];
    hud.dimBackground = NO;
    [hud setDetailsLabelText:title];
    [hud show:YES];
    return hud;
}

+(void)showAutoDissmissAlertView:(NSString *)title msg:(NSString *)msg
{

    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].windows.lastObject] ;
    hud.mode=MBProgressHUDModeText;
    hud.dimBackground = NO;
    [[UIApplication sharedApplication].windows.lastObject addSubview:hud];
    [hud setDetailsLabelText:msg];
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}
+(void)HidHud
{
  
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].windows.lastObject animated:YES];
}

@end
