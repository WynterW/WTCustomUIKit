//
//  HotelCalendarHeaderReusableView.m
//  HotelCalendar
//
//  Created by Wynter on 2017/10/17.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "HotelCalendarHeaderReusableView.h"

@implementation HotelCalendarHeaderReusableView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
