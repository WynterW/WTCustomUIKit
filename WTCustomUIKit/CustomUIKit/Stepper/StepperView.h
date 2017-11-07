//
//  StepperView.h
//  LanXiWisdom
//
//  Created by Wynter on 2017/10/19.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ValueBlock)(NSInteger value);

@interface StepperView : UIView

@property (strong, nonatomic) IBOutlet UIButton *decreaseBtn;
@property (strong, nonatomic) IBOutlet UIButton *increaseBtn;
@property (strong, nonatomic) IBOutlet UILabel *valueLb;

@property (assign, nonatomic) NSInteger step; /**< 递增值 默认1*/
@property (assign, nonatomic) NSInteger value; /**< 当前值*/
@property (assign, nonatomic) NSInteger minimum; /**< 最小值 默认0*/
@property (assign, nonatomic) NSInteger maximum; /**< 最大值 默认100*/
@property (copy, nonatomic) ValueBlock  valueBlock; /**< block返回最终值*/


@end
