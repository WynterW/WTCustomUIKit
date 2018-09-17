//
//  DatePickerViewController.h
//  DatePickerView
//
//  Created by Wynter on 2017/11/7.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DateBlock)(NSDate *date);

@interface DatePickerViewController : UIViewController

@property (strong, nonatomic) NSString *titleName; /**< 标题名字*/
@property (copy, nonatomic) DateBlock  dateBlock; /**< block返回最终值*/
@property (strong, nonatomic) NSDate *selectedDate; /**< 选中的日期*/
@property (strong, nonatomic) NSDate *minDate; /**< 最小可选日期  默认最小值为前一天*/
@property (strong, nonatomic) NSDate *maxDate; /**< 最大可选日期*/
@property (assign, nonatomic) UIDatePickerMode datePickerMode; /**< 日期类型 默认：UIDatePickerModeDate*/
@property (nonatomic, assign) CGFloat pickerViewHeight; /**< 选择器高度，默认160*/


@end
