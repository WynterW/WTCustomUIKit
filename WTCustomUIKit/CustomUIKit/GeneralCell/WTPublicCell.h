//
//  WTPublicCell.h
//  WTCustomUIKit
//
//  Created by Wynter on 2018/9/4.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WTTableViewCellStyle) {
    WTTableViewCellStyleDefault, // 左边一张图，一个标题
    WTTableViewCellStyleCenterText, // 文本垂直水平居中
    WTTableViewCellStyleChecked, // 左边一个标题，右边一张图片（选中效果）
    WTTableViewCellStyleValue1, // 左边一张图 一个主题，右边一张图(默认隐藏),一个副标题(默认隐藏)
    WTTableViewCellStyleValue2, // 左边一个主题，右边一个副标题
};

@interface WTPublicCell : UITableViewCell

@property (nonatomic, assign) WTTableViewCellStyle customCellStyle;

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *subtitleLb;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UIImageView *accessoryImgView; /**< 右侧箭头*/
@property (nonatomic, assign) BOOL isHiddenAccessory;/**< 是否隐藏箭头（默认显示）*/

@property (nonatomic, strong) UILabel *bottomLineLb;/**< cell底部分割线，默认隐藏*/

@end
