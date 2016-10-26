//
//  UIConfig.m
//  IDOIAP2
//
//  Created by wady on 6/3/13.
//  Copyright (c) 2013 damai_mini. All rights reserved.
//

#import "HETUIConfig.h"

@implementation HETUIConfig






+ (CGSize) getScreenSize
{
    CGRect rect = [ UIScreen mainScreen ].applicationFrame;
    CGSize size_app_screen = rect.size;
    return size_app_screen;
}

+(CGSize)labelShadow
{
    return CGSizeMake(0,1);
}

//table cell shadow color
+ (UIColor *)getCellShadowColor
{
    return [UIColor colorWithRed:0
                           green:0
                            blue:0
                           alpha:0.4f];
}

//table footer shadow color
+ (UIColor *)getFooterCellShadowColor
{
    return [UIColor colorWithRed:1.0f
                           green:1.0f
                            blue:1.0f
                           alpha:0.1f];
}

+ (UIColor *) getContentTextColor
{
    return [UIColor colorWithRed:178/255.0f
                           green:190/255.0f
                            blue:197/255.0f
                           alpha:1.0f];
}

//label shadow color
+ (UIColor *) getContentShadowTextColor
{
    return [UIColor colorWithRed:0
                           green:0
                            blue:0
                           alpha:0.3f];
}

+ (UIColor *) underLineColor
{
    return [UIColor colorWithRed:107/255.0f
                    green:175/255.0f
                     blue:216/255.0f
                    alpha:1.0f];
}

+ (UIColor *) getContentNumberTextColor
{
    return [self colorFromHexRGB:@"828f98"];
}

+ (UIColor *) getTitleTextColor
{
    return [self colorFromHexRGB:@"eff2f4"];
}

+ (UIColor *) getBtnClockTextColor
{
    //return [self colorFromHexRGB:@"d1ac7f"];
    //return [self colorFromHexRGB:@"a79879"];
    return [UIColor whiteColor];
}

+ (UIColor *) getBtnTextColor
{
    return [self colorFromHexRGB:@"adb7be"];
}

+ (UIFont *) getDialogWarnSize
{
//    return [UIFont systemFontOfSize:18];
    return [UIFont boldSystemFontOfSize:18];
}

+ (UIFont *) getTitleSize
{
     return [UIFont boldSystemFontOfSize:20];
}

+ (UIFont *) getSettingSize
{
    return [UIFont boldSystemFontOfSize:18];
}

+ (UIFont *) getSubTitleNumSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
}

+ (UIFont *) getSubTitleSize
{
    return [UIFont systemFontOfSize:15];
}

+ (UIFont *) getContentSize
{
    return [UIFont systemFontOfSize:14];
}
+ (UIFont *) getBtnNumSize
{
    return [UIFont fontWithName:@"HelveticaNeueLTPro-Th" size:20];
}

+ (int) getDialogWarnHeight:(int)size
{
    return 18 * size + (size -1) * 5;
}

+ (int) getContentHeight:(int)size
{
    return 14 * size + (size -1) * 5;
}

+ (int) getSubTitleHeight:(int)size
{
    return 16 * size + (size -1) * 2;
}
// 获取行间距，段落尖间距
+ (int) getParagraphLineSeparator
{
    return 8;
}

+ (int) getTitleHeight
{
    return 20;
}

+ (int) getTitleY
{
//    if([self getScreenSize].height > 480)
//    {
//       return 88;
//    }
//    else
//    {
//       return 68;
//    }
    
    return 68;
}

+ (int) getBgPanelY
{
    /*
    if([self getScreenSize].height > 480)
    {
        return 50;
    }
    else
    {
        return 40;
    }
    */
    return 40;
}

+ (int) getMutiBtnButtomHeight
{
    if([self getScreenSize].height > 480)
    {
        return 40;
    }
    else
    {
        return 25;
    }
}

+ (int) getButtomHeight
{
    if([self getScreenSize].height > 480)
    {
        return 70;
    }
    else
    {
        return 25;
    }
}

+ (int) getPhoneInfoHeight
{
    return 20;
}

+ (int) getTitleSeparator
{
    if([self getScreenSize].height > 480)
    {
        return 25;
    }
    else
    {
        return 20;
    }
}
// 段落间间距
+ (int) getParagraphSeparator
{
    return 13;
}

+ (int) getParagraphAndImageSeparator
{
    if([self getScreenSize].height > 480)
    {
        return 35;
    }
    else
    {
        return 25;
    }
}

+ (int) getParagraphAndImageLargeSeparator
{
    return 40;
}

+ (int) getBtnAndBtnSeparator
{
    return 15;
}

+ (int) getAnimalCircleSeparator
{
    return 25;
}

+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

//%15黑
+ (UIColor *)tableCellSelectedColor
{
    return [UIColor colorWithRed:0
                           green:0
                            blue:0
                           alpha:0.15f];
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
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

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)colorAlpha {
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
              alpha:colorAlpha];
    return result;
}

+(CGFloat)frontViewLeftShowDistance
{
    return 320-80;
}

+(CGFloat)frontViewRightShowDistance
{
    return 320-50;
}

+(CGFloat)frontViewMinFactory
{
//    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
//        return 1;
//    }
//    return 484/568.0f;
    return 1;
}


+(UIColor*)menuCellTitleColor
{
    return [self colorFromHexRGB:@"ffffff"];
}

+(UIColor*)menuCellDetailTitleColor
{
    return [self colorFromHexRGB:@"999999"];
}

+(UIFont*)menuCellTitleFont
{
    return [UIFont systemFontOfSize:18];
}

+(UIFont*)menuCellDetailTitleFont
{
    return [UIFont systemFontOfSize:12];
}

//右边菜单Cell左边的边距
+(CGFloat)rightMenuCellLeftEdge
{
    return 18.0f;
}

//右边菜单Cell右边的边距
+(CGFloat)rightMenuCellRightEdge
{
    return 15.0f;
}

+ (UIColor *)appNormalTextColor
{
    return [HETUIConfig colorFromHexRGB:@"999999"];
}

+(UIColor*)textPlaceHolderColor
{
    return [HETUIConfig colorFromHexRGB:@"bcbcbc"];
}


+(UIColor*)LoginBgColor
{
    return [HETUIConfig colorFromHexRGB:@"f8fafa"];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
