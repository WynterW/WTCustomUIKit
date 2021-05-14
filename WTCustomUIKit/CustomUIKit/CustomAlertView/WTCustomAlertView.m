//
//  WTCustomAlertView.m
//  WTCustomUIKit
//
//  Created by Wynter on 2021/5/14.
//  Copyright © 2021 Wynter. All rights reserved.
//

#import "WTCustomAlertView.h"
#import "Masonry.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kTitleColor UIColorFromRGB(0x0A1F44) // 标题黑
#define kLineColor UIColorFromRGB(0xF1F2F4) // 分割线颜色
#define kFontBlueColor UIColorFromRGB(0x0C66FF) // 字体蓝色

@interface WTCustomAlertView()

@property (nonatomic, strong) UIView        *lineView;
@property (nonatomic, strong) UIView        *backView;
@property (nonatomic, strong) UILabel       *title;
@property (nonatomic, strong) UILabel       *message;

@end
@implementation WTCustomAlertView

+ (WTCustomAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message style:(WTAlertStyle)style {
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title];
    NSAttributedString *attMessage = [self attStringWithString:message];
    WTCustomAlertView *alert = [[WTCustomAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds attTitle:attTitle attMessage:attMessage style:style];
    return alert;
}

+ (WTCustomAlertView *)alertWithAttTitle:(NSAttributedString *)attTitle attMessage:(NSAttributedString *)attMessage style:(WTAlertStyle)style {
    WTCustomAlertView *alert = [[WTCustomAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds attTitle:attTitle attMessage:attMessage style:style];
    return alert;
}

+ (NSAttributedString *)attStringWithString:(NSString *)str {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    NSDictionary *attr = @{
        NSFontAttributeName: [UIFont systemFontOfSize:14],
        NSParagraphStyleAttributeName: style,
        NSForegroundColorAttributeName: kTitleColor
    };
    return [[NSAttributedString alloc] initWithString:str attributes:attr];
}

- (instancetype)initWithFrame:(CGRect)frame attTitle:(NSAttributedString *)attTitle attMessage:(NSAttributedString *)attMessage style:(WTAlertStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:10/255.0 green:31/255.0 blue:68/255.0 alpha:0.5];
        [self addSubview:self.backView];
        [self.backView addSubview:self.title];
        [self.backView addSubview:self.message];
        [self.backView addSubview:self.lineView];
        [self.backView addSubview:self.sureButton];
  
        self.title.attributedText = attTitle;
        self.message.attributedText = attMessage;
        self.title.textAlignment = NSTextAlignmentCenter;
        self.message.textAlignment = NSTextAlignmentCenter;
             
        NSInteger backViewPadding = 38;
        NSInteger backViewW = [UIScreen mainScreen].bounds.size.width - (backViewPadding * 2);
        NSInteger titlePadding = 24;
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backViewPadding);
            make.right.mas_equalTo(-backViewPadding);
            make.centerY.equalTo(self);
            make.height.greaterThanOrEqualTo(@150);
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titlePadding);
            make.right.mas_equalTo(-titlePadding);
            make.top.mas_equalTo(24);
        }];
        
        [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titlePadding);
            make.right.mas_equalTo(-titlePadding);
            make.top.equalTo(self.title.mas_bottom).offset(12);
            make.bottom.equalTo(self.lineView.mas_top).offset(-24);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.sureButton.mas_top);
            make.height.mas_equalTo(1);
        }];
        
        if (style == WTAlertStyleTwoBtn) {
            CGFloat btnWidth = backViewW/2;
            [self.backView addSubview:self.cancelButton];
            [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.bottom.mas_equalTo(0);
                make.height.mas_equalTo(48);
                make.width.offset(btnWidth-0.5);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = kLineColor;
            [self.backView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(self.cancelButton.mas_right);
                make.centerY.equalTo(self.cancelButton);
                make.height.offset(32);
                make.width.offset(1);
            }];

            [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make){
                make.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(48);
                make.width.offset(btnWidth-0.5);
            }];
            
        } else {
            [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(48);
            }];
        }
        
    }
    return self;
}

#pragma mark - 交互
- (void)clickedBtn {
    __weak typeof(_sureCallback) weakSelf = _sureCallback;
    [self disMiss:^{
        if (weakSelf) {
            weakSelf();
        }
    }];
}

- (void)cancelBtn {
    __weak typeof(_cancelCallback) weakSelf = _cancelCallback;
    [self disMiss:^{
        if (weakSelf) {
            weakSelf();
        }
    }];
}

#pragma mark - getter & setter
- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _backView.translatesAutoresizingMaskIntoConstraints = false;
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 8;
    }
    return _backView;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.translatesAutoresizingMaskIntoConstraints = false;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont boldSystemFontOfSize:18];
        _title.textColor = kTitleColor;
    }
    return _title;
}

- (UILabel *)message {
    if (_message == nil) {
        _message = [[UILabel alloc] initWithFrame:CGRectZero];
        _message.translatesAutoresizingMaskIntoConstraints = false;
        _message.font = [UIFont systemFontOfSize:14];
        _message.textColor = kTitleColor;
        _message.numberOfLines = 0;
        _message.textAlignment = NSTextAlignmentCenter;
    }
    return _message;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.translatesAutoresizingMaskIntoConstraints = false;
        //        _lineView.backgroundColor = [UIColor colorWithHex:@"cccccc"];
        _lineView.backgroundColor = kLineColor;
    }
    return _lineView;
}

- (UIButton *)sureButton {
    if (_sureButton == nil) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.translatesAutoresizingMaskIntoConstraints = false;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        //        [_button setTitleColor:[UIColor colorWithHex:@"18a74f"] forState:UIControlStateNormal];
        [_sureButton setTitleColor:kFontBlueColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureButton addTarget:self action:@selector(clickedBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = false;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        //        [_button setTitleColor:[UIColor colorWithHex:@"18a74f"] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kFontBlueColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark - 对外
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.alpha = 0;
//    self.backView.transform = CGAffineTransformMakeTranslation(0, 400);
    [window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        //self.backView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [self disMiss:nil];
//}

- (void)disMiss:(void(^)(void))hander {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        //self.backView.transform = CGAffineTransformMakeTranslation(0, 400);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (hander) {
            hander();
        }
    }];
}


@end
