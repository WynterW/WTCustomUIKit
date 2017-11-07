//
//  MenuSelectViewController.h
//  Menu
//
//  Created by Wynter on 16/7/21.
//  Copyright © 2016年 wynter. All rights reserved.
//  选择菜单

#import <UIKit/UIKit.h>
#import "MenuSelectItem.h"

typedef void(^MenuSelectBlock)(NSInteger selectIndex);

@interface MenuSelectViewController : UIViewController

@property (nonatomic,assign) CGFloat alphaComponent;  /**< 默认0.25*/
@property (nonatomic,strong) NSArray <MenuSelectItem *> *items;  /**< 展示的数组*/
@property (nonatomic,strong) UIViewController *showListViewControl;
@property (nonatomic,copy) MenuSelectBlock clickBlock;

/**
 *  初始化
 *
 *  @param items 选项
 *
 *  @return return value description
 */
- (instancetype)initWithItems:(NSArray <MenuSelectItem *> *)items;

- (void)show;

- (void)dismissWithAnimate:(BOOL)animate;
@end
