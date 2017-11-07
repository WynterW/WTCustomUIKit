//
//  HotelCalendarCell.h
//  HotelCalendar
//
//  Created by Wynter on 2017/10/17.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelCalendarCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *inOutLb;

@property (assign, nonatomic) NSInteger itemWidth;
@property (assign, nonatomic) BOOL isCurrentDate;
@property (assign, nonatomic) BOOL isFromDate;
@property (assign, nonatomic) BOOL isToDate;
@end
