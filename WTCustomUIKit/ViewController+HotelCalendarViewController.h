//
//  ViewController+HotelCalendarViewController.h
//  WTCustomUIKit
//
//  Created by Wynter on 2017/11/7.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "ViewController.h"
#import "HotelCalendarViewController.h"
#import "NSCalendar+Ex.h"

@interface ViewController (HotelCalendarViewController)<HotelCalendarViewDelegate, HotelCalendarViewDataSource>
- (void)initCalendarViews;
@end
