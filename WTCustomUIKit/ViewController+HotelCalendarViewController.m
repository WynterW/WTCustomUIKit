//
//  ViewController+HotelCalendarViewController.m
//  WTCustomUIKit
//
//  Created by Wynter on 2017/11/7.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "ViewController+HotelCalendarViewController.h"


@implementation ViewController (HotelCalendarViewController)
#pragma mark - HotelCalendarViewDataSource
- (NSDate *)minimumDateForHotelCalendar {
    NSDate *nowDate = [NSDate new];
    NSDate *lastDate = [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:nowDate];
    return lastDate;
}

- (NSDate *)maximumDateForHotelCalendar {
    return [NSCalendar date:[NSDate new] addMonth:2];
}

- (NSDate *)defaultSelectFromDate {
    return [NSDate new];
}

- (NSDate *)defaultSelectToDate {
    NSDate *nowDate = [NSDate new];
    NSDate *nextDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:nowDate];
    return nextDate;
}

#pragma mark - HotelCalendarViewDelegate
- (NSInteger)rangeDaysForHotelCalendar {
    return 365;
}

- (void)selectNSStringFromDate:(NSString *)fromDate toDate:(NSString *)toDate {
    if (!fromDate) {
        NSLog(@"未完成日期选择");
        return;
    }
    NSLog(@"fromDate: %@, toDate: %@", fromDate, toDate);
}

- (NSInteger)itemWidthForHotelCalendar{
    return 50;
}

#pragma mark - private instance method
- (void)initCalendarViews {
    HotelCalendarViewController *vc = [[HotelCalendarViewController alloc]init];
    vc.delegate = self;
    vc.dataSource = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:NO completion:nil];
}

@end
