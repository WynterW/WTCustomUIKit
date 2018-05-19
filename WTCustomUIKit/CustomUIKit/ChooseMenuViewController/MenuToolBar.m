//
//  MenuToolBar.m
//  WTCustomUIKit
//
//  Created by Wynter on 2018/5/18.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import "MenuToolBar.h"
#import "UIView+Frame.h"

static CGFloat const kBarItemMargin = 20;

@interface MenuToolBar ()

@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation MenuToolBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (NSInteger i = 0; i <= self.btnArray.count - 1; i++) {
        UIView *view = self.btnArray[i];
        if (i == 0) {
            view.x = kBarItemMargin;
        }
        if (i > 0) {
            UIView *preView = self.btnArray[i - 1];
            view.x = kBarItemMargin + preView.x + preView.width;
        }
    }
}

- (NSMutableArray *)btnArray {
    NSMutableArray *mArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    return _btnArray;
}

@end

