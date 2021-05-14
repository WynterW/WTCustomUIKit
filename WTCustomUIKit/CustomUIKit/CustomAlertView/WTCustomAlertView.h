//
//  WTCustomAlertView.h
//  WTCustomUIKit
//
//  Created by Wynter on 2021/5/14.
//  Copyright © 2021 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, WTAlertStyle) {
    WTAlertStyleOnlySure = 1, // 只有确定按钮
    WTAlertStyleTwoBtn // 两个按钮都存在
};


@interface WTCustomAlertView : UIView

@property (nonatomic, strong) UIButton      *cancelButton;
@property (nonatomic, strong) UIButton      *sureButton;

/**
 *  确定键的回调
 */
@property (nonatomic, copy) void(^sureCallback)(void);
/**
 *  取消回调
 */
@property (nonatomic, copy) void(^cancelCallback)(void);


/// 默认样式，message自带行间距
/// @param title 标题
/// @param message 内容
/// @param style 按钮样式
+ (WTCustomAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message style:(WTAlertStyle)style;

/// 富文本样式
/// @param attTitle 富文本标题
/// @param attMessage 富文本内容
/// @param style 按钮样式
+ (WTCustomAlertView *)alertWithAttTitle:(NSAttributedString *)attTitle attMessage:(NSAttributedString *)attMessage style:(WTAlertStyle)style;

// msg富文本默认样式
+ (NSAttributedString *)attStringWithString:(NSString *)str;

- (void)show;

@end


NS_ASSUME_NONNULL_END
