//
//  NSCalendar+Ex.h
//  HotelCalendar
//
//  Created by Wynter on 2017/10/17.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Ex)

/*
 取得日期的日
 */
+ (NSInteger)dayFromDate:(NSDate *)fromDate;

/*
 计算月有几天
 */
+ (NSInteger)daysFromDate:(NSDate *)fromDate;

/*
 计算两个日期之间的天数
 */
+ (NSInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/*
 计算两个日期总共有几个月
 */
+ (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/*
 计算日期加上 x 个月
 */
+ (NSDate *)date:(NSDate *)fromDate addMonth:(NSInteger)month;

/*
 计算日期是星期几
 0:星期一, 1:星期二, 2:星期三, 3:星期四, 4:星期五, 5:星期六, 6:星期日
 */
+ (NSInteger)weekFromDate:(NSDate *)fromDate;

/*
 计算日期「x月 1日」是星期几
 0:星期一, 1:星期二, 2:星期三, 3:星期四, 4:星期五, 5:星期六, 6:星期日
 */
+ (NSInteger)weekFromMonthFirstDate:(NSDate *)fromDate;

/*
 计算两个日期之间的天数
 */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/*
 判断日期是否在两个日期之间
 */
+ (BOOL)isOnRangeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate date:(NSDate *)date;

@end
