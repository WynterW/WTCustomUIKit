//
//  TitlePickerViewController.h
//  WTCustomUIKit
//
//  Created by Wynter on 2018/9/14.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^finishBlock)(NSString *name, NSInteger index);

@interface TitlePickerViewController : UIViewController

@property (strong, nonatomic) NSString *titleName; /**< toolView标题名字*/
@property (nonatomic, copy) NSArray <NSString *>*dataAry;
@property (copy, nonatomic) finishBlock finishBlock; /**< block返回最终值*/
@property (nonatomic, strong) NSString *selectedName; /**< 选中内容，设置后直接滚动到选中标题*/

@property (nonatomic, assign) CGFloat pickerViewHeight; /**< 选择器高度，默认160*/

@end
