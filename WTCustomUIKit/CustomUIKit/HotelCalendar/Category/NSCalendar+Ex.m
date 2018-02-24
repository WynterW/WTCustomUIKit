//
//  NSCalendar+Ex.m
//  HotelCalendar
//
//  Created by Wynter on 2017/10/17.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "NSCalendar+Ex.h"

@implementation NSCalendar (Ex)

+ (NSInteger)dayFromDate:(NSDate *)fromDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate];
    return dateComponents.day;
}

+ (NSInteger)daysFromDate:(NSDate *)fromDate {
    NSCalendarUnit rangeOfUnit = NSCalendarUnitDay;
    NSCalendarUnit inUnit = NSCalendarUnitMonth;
    NSRange rangeDays = [[NSCalendar currentCalendar] rangeOfUnit:rangeOfUnit inUnit:inUnit forDate:fromDate];
    return rangeDays.length;
}

+ (NSInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return dateComponents.day;
}

+ (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *fromDateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate];
    NSDateComponents *toDateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:toDate];
    NSInteger yaer = labs(fromDateComponents.year - toDateComponents.year);
    NSInteger month = (yaer * 12) - (fromDateComponents.month - 1) + toDateComponents.month;
    return month;
}

+ (NSDate *)date:(NSDate *)fromDate addMonth:(NSInteger)month {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:fromDate options:0];
}

+ (NSInteger)weekFromDate:(NSDate *)fromDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate];
    NSArray *weeks = @[@0, @0, @1, @2, @3, @4, @5, @6];
    return [weeks[dateComponents.weekday] integerValue];
}

+ (NSInteger)weekFromMonthFirstDate:(NSDate *)fromDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate];
    dateComponents.day = 1;
    NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    NSCalendarUnit calendarUnit2 = NSCalendarUnitWeekday;
    NSDateComponents *dateComponents2 = [[NSCalendar currentCalendar] components:calendarUnit2 fromDate:firstDayOfMonthDate];
    NSArray *weeks = @[@0, @0, @1, @2, @3, @4, @5, @6];
    return [weeks[dateComponents2.weekday] integerValue];
}

+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendarUnit calendarUnit = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return dateComponents.day;
}

+ (BOOL)isOnRangeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate date:(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    return [date compare:fromDate] != NSOrderedAscending && [date compare:toDate] == NSOrderedAscending;
}

@end
