//
//  HETBaseViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETBaseViewController.h"

@interface HETBaseViewController ()
{
    UIButton *cancelButton;
}

@end

@implementation HETBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       self.view.backgroundColor =[UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:244.f/255.f alpha:1];
    [self createLeftBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)createLeftBarButtonItem {
    
    UIImage *cancelBtnImage = [UIImage imageNamed:@"gotoBack"];
    CGRect frame = CGRectMake(0, 0, 30, 30);
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = frame;
    [cancelButton setImage:cancelBtnImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:cancelButton] animated:NO];
    
    
}
-(void)setLeftBarButtonItemHide:(BOOL)hide
{
    if(hide)
    {
        cancelButton.hidden=YES;
    }
    else
    {
        cancelButton.hidden=NO;
    }
}
-(void)setNavigationBarTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = title;
    [label sizeToFit];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
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
