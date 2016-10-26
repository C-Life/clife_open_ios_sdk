//
//  DMString.m
//  IDOIAP
//
//  Created by wady on 12/24/12.
//  Copyright (c) 2012 ccc. All rights reserved.
//

#import "DMString.h"

#import <CommonCrypto/CommonDigest.h>

@implementation DMString

+ (int)unicodeStringLength:(NSString*)string
{
    if (!string)
    {
        return 0;
    }
    
    int strlength = 0;
    char* p = (char*)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (NSString *)sizeString:(NSString*)string width:(NSInteger)width font:(UIFont*)font
{
    NSString* newString = @"";
    if (string)
    {
        CGSize size = [string sizeWithFont:font];
        if (size.width <= width)
        {
//            newString = [[string copy] autorelease];
            newString = [string copy];
        }
        else
        {
            for (NSInteger i = (string.length-1) ; i >= 1; i--)
            {
                NSString* tempString = [[string substringToIndex:i] stringByAppendingString:@"..."];
                CGSize newSize = [tempString sizeWithFont:font];
                if (newSize.width <= width)
                {
                    newString = tempString;
                    break;
                }
            }
            
        }
        
    }
    
    return newString;
}

+ (NSString *) stringFromMD5:(NSString *)str{
    
    if(self == nil || [str length] == 0)
        return nil;
    
    const char *value = [str UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

+ (NSString *) trimString:(NSString *)source
{
    // NSString * dest = [source stringByReplacingOccurrencesOfString:@"\n"
    //                                                    withString:@""];
    NSString *dest = nil;
    if(source != nil)
    {
        dest = [source
                      stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return dest;
}

+(BOOL)isValidPassword:(NSString *)passwordStr
{
    NSString * regex = @"^[A-Za-z0-9]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:passwordStr];
    return isMatch;
}

+ (bool) isMail:(NSString *)mail
{
    bool bRet = false;
    
    NSString * MAIL_MATCH =
             @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *regextestct =
         [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MAIL_MATCH];
    
    bRet = [regextestct evaluateWithObject:mail];
    
    return bRet;
}

+ (bool) isDate:(NSString *)date
{
    bool bRet = false;
    bool bRet2 = false;
    
    NSString * MAIL_MATCH =
    @"\\d{4}-\\d{2}-\\d{2}";
    NSString * MAIL_MATCH2 =
    @"\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}";
    NSPredicate *regextestct =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MAIL_MATCH];
    NSPredicate *regextestct2 =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MAIL_MATCH2];
    
    bRet = [regextestct evaluateWithObject:date];
    bRet2 = [regextestct2 evaluateWithObject:date];
    
    return (bRet || bRet2);
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,184,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0125-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,147,150,151,157,158,159,182,187,188,178,1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[7]|5[017-9]|8[23478]|78)\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,176,1709
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|76)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181,177,1700
     22         */
    NSString * CT = @"^1((33|53|8[019]|77)[0-9]|349|70[059])\\d{7}$";
    //178 1705 1709 176  177 1700
    NSString *newMobile = @"^17(8[0-9]|0[059]|6[0-9]|7[0-9])\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextesnewMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", newMobile];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextesnewMobile evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//检查邮箱是否有效
+(BOOL)isValidEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

+(NSString *)divdeStringWithValue:(int)valInt
{
    NSString *valStr = [NSString stringWithFormat:@"%d",valInt];
    if(valInt<1000)//3位数
    {
        
    }
    else if(valInt<10000) //4位数
    {
        valStr = [NSString stringWithFormat:@"%@,%@",
                  [valStr substringToIndex:1],
                   [valStr substringWithRange: NSMakeRange(1,3)]];
    }
    else if(valInt<100000)//5位数
    {
        valStr = [NSString stringWithFormat:@"%@,%@",
                  [valStr substringToIndex:2],
                   [valStr substringWithRange: NSMakeRange(2,3)]];
    }
    else if(valInt<1000000)//6位数
    {
        valStr = [NSString stringWithFormat:@"%@,%@",
                  [valStr substringToIndex:3],
                   [valStr substringWithRange: NSMakeRange(3,3)]];
    }
    else if(valInt<10000000)//7位数
    {
        valStr = [NSString stringWithFormat:@"%@,%@,%@",
                  [valStr substringToIndex:1],
                   [valStr substringWithRange: NSMakeRange(1,3)],
                   [valStr substringWithRange: NSMakeRange(4,3)]];
    }
    else if(valInt<100000000)//8位数
    {
        valStr = [NSString stringWithFormat:@"%@,%@,%@",
                  [valStr substringToIndex:2],
                   [valStr substringWithRange: NSMakeRange(2,3)],
                   [valStr substringWithRange: NSMakeRange(5,3)]];
    }
    else if(valInt<1000000000)//9位数
    {
        valStr = [NSString stringWithFormat:@"%@,%@,%@",
                  [valStr substringToIndex:3],
                   [valStr substringWithRange: NSMakeRange(3,3)],
                   [valStr substringWithRange: NSMakeRange(6,3)]];
    }
    return valStr;
}

+(NSString *)divdeStringWithStringValue:(NSString *)val
{
    NSString *valStr = @"";
    int num = 0;
    
    num = [val intValue];
    while(num > 0)
    {
        if(![valStr isEqualToString:@""])
        {
            valStr = [NSString stringWithFormat:@"%d.%@",num % 10, valStr];
        }
        else
        {
            valStr = [NSString stringWithFormat:@"%d",num % 10];
        }
        num = num / 10;
    }
    
    return valStr;
}

@end
