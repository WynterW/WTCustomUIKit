//
//  HotelCalendarCollectionViewFlowLayout.h
//  HotelCalendar
//
//  Created by Wynter on 2017/10/17.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelCalendarCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (strong, nonatomic) NSArray *sectionRows;
@property (assign, nonatomic) NSInteger itemWidth;
@property (nonatomic, assign) CGFloat naviHeight; /**< header偏移量  默认为64.0*/
@end
