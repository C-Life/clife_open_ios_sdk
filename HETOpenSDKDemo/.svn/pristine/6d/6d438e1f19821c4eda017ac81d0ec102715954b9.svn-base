//
//  DMString.h
//  IDOIAP
//
//  Created by wady on 12/24/12.
//  Copyright (c) 2012 ccc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DMString : NSObject

+ (NSString *)sizeString:(NSString*)string width:(NSInteger)width font:(UIFont*)font;

+ (int)unicodeStringLength:(NSString*)string;

+ (NSString *) trimString:(NSString *)source;

+ (bool) isDate:(NSString *)date;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;//手机号验证

+ (bool) isMail:(NSString *)mail;

+ (NSString *) stringFromMD5:(NSString *)str;

+(BOOL)isValidEmail:(NSString *)emailStr;//检查邮箱是否有效

//用逗号将字符分开000,000,000
+(NSString *)divdeStringWithValue:(int)strInt;

//用逗号将字符分开0,0,0
+(NSString *)divdeStringWithStringValue:(NSString *)val;

+(BOOL)isValidPassword:(NSString *)passwordStr;//检查密码格式是否正确
@end
