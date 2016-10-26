//
//  NSDate+SSToolkitAdditions.h
//  SSToolkit
//
//  Created by Sam Soffes on 5/26/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//
#import <Foundation/Foundation.h>
/**
 Provides extensions to `NSDate` for various common tasks.
 */
@interface NSDate (SSToolkitAdditions)

///---------------
/// @name ISO 8601
///---------------

/**
 Returns a new date represented by an ISO8601 string.
 
 @param iso8601String An ISO8601 string
 
 @return Date represented by the ISO8601 string
 */
+ (NSDate *)dateFromISO8601String:(NSString *)iso8601String;


/**
 Returns a string representation of the receiver in ISO8601 format.
 
 UTC Time
 
 @return A string representation of the receiver in ISO8601 format.
 */
-(NSString *)ISO8601String;

/**
 Returns a string representation of the receiver in ISO8601 format.
 
 Local Time
 
 @return A string representation of the receiver in ISO8601 format.
 */

-(NSString*)LocalTimeISO8601String;

-(NSString*)GMTDayISO8601String;

-(NSString*)LocalDayISO8601String;

- (NSString *)LocalTimeISO8601StringByAddDays:(int)addDay;

- (NSString *)LocalTimeISO8601StringFromDate:(NSString *)beginDate addDays:(int)addDay;

-(NSString*)getAddTime:(NSString*)preTime AddDays:(int)addDay;

-(int)dayCountFrom:(NSString*)fromDay toDay:(NSString*)toDay;

-(time_t)GMTSecond;

+(NSString*)chinesDayStringByDateString:(NSString*)inputString;

+ (NSDate *)gmtDateFromISO8601String:(NSString *)iso8601 ;

+(NSString*)localTimeToGMTString:(NSString*)localTimeString;
+(NSString*)GMTTimeToLocalTimeString:(NSString*)gmtTimeString;
+(NSString*)ChineseWeekString:(NSString*)inputString;

+(NSString*)getDayOfCurrentDay;

+ (NSString *)ISO8601String_Withobliqueline;

+(NSString *)changeMonthValueToMonthStr:(int)monthValue withCapital:(BOOL)cap;

+(NSString*)LastDayOfMonth:(int)iMonth year:(int)iYear;

+(NSString*)firstDayOfMonth:(int)iMonth year:(int)iYear;

+(NSDictionary*)getFirstAndLastDayOfMonth:(NSString*)monthDate;
+(NSDictionary*)getFirstAndLastDayOfWeek:(NSString *)weekDate;
///--------------------
/// @name Time In Words
///--------------------

/**
 Returns a string representing the time interval from now in words (including seconds).
 
 The strings produced by this method will be similar to produced by Twitter for iPhone or Tweetbot in the top right of
 the tweet cells.
 
 Internally, this does not use `timeInWordsFromTimeInterval:includingSeconds:`.
 
 @return A string representing the time interval from now in words
 */
+ (NSString *)briefUpdateTimeInWords:(NSString*)updateString isV1:(BOOL)isV1;

/**
 Returns a string representing the time interval from now in words (including seconds).
 
 The strings produced by this method will be similar to produced by ActiveSupport's `time_ago_in_words` helper method.
 
 @return A string representing the time interval from now in words
 
 @see timeInWordsIncludingSeconds:
 @see timeInWordsFromTimeInterval:includingSeconds:
 */
- (NSString *)timeInWords;

/**
 Returns a string representing the time interval from now in words.
 
 The strings produced by this method will be similar to produced by ActiveSupport's `time_ago_in_words` helper method.
 
 @param includeSeconds `YES` if seconds should be included. `NO` if they should not.
 
 @return A string representing the time interval from now in words
 
 @see timeInWordsIncludingSeconds:
 @see timeInWordsFromTimeInterval:includingSeconds:
 */
- (NSString *)timeInWordsIncludingSeconds:(BOOL)includeSeconds;

/**
 Returns a string representing a time interval in words.
 
 The strings produced by this method will be similar to produced by ActiveSupport's `time_ago_in_words` helper method.
 
 @param intervalInSeconds The time interval to convert to a string
 
 @param includeSeconds `YES` if seconds should be included. `NO` if they should not.
 
 @return A string representing the time interval in words
 
 @see timeInWords
 @see timeInWordsIncludingSeconds:
 */
+ (NSString *)timeInWordsFromTimeInterval:(NSTimeInterval)intervalInSeconds includingSeconds:(BOOL)includeSeconds;

//- (NSString *)getMonthEndTimeWithMonthStart:(NSString *)startTime;
//周几
-(int) dayOfWeek:(NSString *)startTime;
//周几(大写)
+(NSString *)myCapWeekday:(NSString *)startTime;
//卡片页日期显示
+(NSString *)dayOfWeekStr:(NSString *)startTime;
// 返回间隔多少分钟
-(int)minutesCountFrom:(NSString*)fromDay toDay:(NSString*)toDay;

+(NSString*)getLoadingTitleFromTime:(NSString*)startLoadTime;

/**
 *  获取一个时间对应的小时
 *
 *  @param dateString 需要获取的时间字符
 *
 *  @return 返回小时的值
 */
+(int)getDateHour:(NSString*)dateString;

/**
 *  获取一个时间对应的分钟
 *
 *  @param dateString 需要获取的时间字符
 *
 *  @return 返回分钟的值
 */
+(int)getDateMitune:(NSString*)dateString;


/**
 *  获取一个时间对应的秒
 *
 *  @param dateString 需要获取的时间字符
 *
 *  @return 返回秒的值
 */
+(int)getDateSecond:(NSString*)dateString;

//获取当前时间
+(NSString *)getCurrentTime;
+(NSArray*)getBetweenHourByBeginTime:(NSString*)beginTime EndTime:(NSString*)endTime;
+(NSArray*)getBetweenDayByBeginTime:(NSString*)beginTime EndTime:(NSString*)endTime;

+(NSString *)currentTimeOffset;

+(int)betweenSecondWithStartTime:(NSString*)startTime EndTime:(NSString*)endTime;
@end
