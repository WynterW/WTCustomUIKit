//
//  UIButton+Event.h
//  WTCustomUIKit
//
//  Created by Wynter on 2017/12/6.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HandleEventBlock)(UIButton *sender);

@interface UIButton (Event)
@property(copy, nonatomic) HandleEventBlock eventBlock;
@end
