//
//  SegmentedController.h
//  ShowManyProducts
//
//  Created by Wynter on 16/4/6.
//  Copyright © 2016年 Wynter. All rights reserved.
//  分段视图控制器

#import <UIKit/UIKit.h>

@interface SegmentedController : UIViewController
@property (nonatomic, strong) NSArray *childViewControllerAry;  /**< 要添加的子视图数组*/

// 可选项
@property (nonatomic, assign) BOOL scrollEnabled; /**< 禁止scrollView滑动*/
@property (nonatomic, assign) CGSize tagViewSize; /**< 选中标签的大小*/

@property (nonatomic, strong) UIColor *normalColor; /**< 正常颜色*/
@property (nonatomic, strong) UIColor *selectedColor; /**< 选中颜色*/

@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;
@end
