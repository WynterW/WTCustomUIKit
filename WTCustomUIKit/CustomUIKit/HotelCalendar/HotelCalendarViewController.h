//
//  HotelCalendarViewController.h
//  HotelCalendar
//
//  Created by Wynter on 2017/10/17.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelCalendarViewDataSource <NSObject>

@required

/**
 *  日历的最小日期
 */
- (NSDate *)minimumDateForHotelCalendar;

/**
 *  日历的最大日期
 */
- (NSDate *)maximumDateForHotelCalendar;

@optional

/**
 *  默认选择起始日期
 */
- (NSDate *)defaultSelectFromDate;

/**
 *  默认选择結束日期
 */
- (NSDate *)defaultSelectToDate;

@end

@protocol HotelCalendarViewDelegate <NSObject>

@optional

/**
 *  返回选择日期为 NSDate 型別
 */
- (void)selectNSDateFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 *  返回选择日期为 NSString 型別
 */
- (void)selectNSStringFromDate:(NSString *)fromDate toDate:(NSString *)toDate;

/**
 *  返回选择日期为 NSString 型別
 */
- (NSInteger)rangeDaysForHotelCalendar;

/**
 *  item的宽度，默认 30
 */
- (NSInteger)itemWidthForHotelCalendar;

@end

@interface HotelCalendarViewController : UIViewController
@property (weak, nonatomic) id<HotelCalendarViewDataSource> dataSource;
@property (weak, nonatomic) id<HotelCalendarViewDelegate> delegate;

/**
 *  delagate 返回的日期格式，默认格式： yyyy-MM-dd
 */
@property (strong, nonatomic) NSString *formatString;

/**
 *  展示日历选择器
 */
- (void)showCalendarView;

/**
 *  取消日历选择器
 */
- (void)dissmiss;

/**
 *  清除所有选择的日期
 */
- (void)clear;

/**
 *  刷新日历
 */
- (void)reloadData;
@end
