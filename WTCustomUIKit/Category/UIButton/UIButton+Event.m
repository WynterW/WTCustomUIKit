//
//  UIButton+Event.m
//  WTCustomUIKit
//
//  Created by Wynter on 2017/12/6.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "UIButton+Event.h"
#import <objc/runtime.h>

static NSString * kEventBlock = @"eventBlock";

@implementation UIButton (Event)

-(void)eventHandler {
    if (self.eventBlock) {
        self.eventBlock(self);
    }
}

-(void)setEventBlock:(HandleEventBlock)eventBlock {
    objc_setAssociatedObject(self, (__bridge const void *)kEventBlock, eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (eventBlock) {
        [self addTarget:self action:@selector(eventHandler) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(HandleEventBlock) eventBlock {
    return objc_getAssociatedObject(self, (__bridge const void *)kEventBlock);
}
@end
