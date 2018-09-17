//
//  TopSheetViewController.h
//  WTCustomUIKit
//
//  Created by Wynter on 2018/9/4.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TopSheetSelectBlock) (NSInteger selectIndex, NSString *selectTitle);

@interface TopSheetViewController : UIViewController

// required
@property (nonatomic, copy) TopSheetSelectBlock selecBlock;
@property (nonatomic, copy) NSString *selectTitle; /**< 选中的标题*/
@property (nonatomic, copy) NSArray *dataSource; /**< 数据源*/
@property (nonatomic, strong) UIButton *showBtn; /**< 外部启动本控制器的展示项按钮*/

// optional
@property (nonatomic, assign) CGFloat topH; /**< 顶部距离*/
@property (nonatomic, assign) CGFloat tableViewH; /**< tableView的高度*/
@property (nonatomic, strong) UIColor *titleColor; /**< 未选中标题颜色*/
@property (nonatomic, strong) UIColor *selectedTitleColor; /**< 选中标题颜色*/
@property (nonatomic, strong) UIFont *titleFont; /**< 未选中标题字体*/
@property (nonatomic, strong) UIFont *selectedTitleFont; /**< 选中标题字体*/
@property (nonatomic, strong) UIImage *selectedIconImage; /**< 选中cell左侧的标记icon*/
@property (nonatomic, assign) BOOL isShowBtnTransform; /**< 展示按钮的icon是否旋转，默认NO，不旋转*/


@end
