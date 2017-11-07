//
//  StepperView.m
//  LanXiWisdom
//
//  Created by Wynter on 2017/10/19.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "StepperView.h"

@implementation StepperView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        [self initValue];
    }
    return self;
}

#pragma mark - event response
- (IBAction)decreaseAction:(UIButton *)sender {
    self.value -= _step;

    self.increaseBtn.selected = NO;
    self.increaseBtn.userInteractionEnabled = YES;

    if (_value <= _minimum) {
        self.decreaseBtn.selected = YES;
        self.decreaseBtn.userInteractionEnabled = NO;
        self.value = _minimum;
    }
}

- (IBAction)increaseAction:(UIButton *)sender {
    self.value += _step;

    self.decreaseBtn.selected = NO;
    self.decreaseBtn.userInteractionEnabled = YES;

    if (_value >= _maximum) {
        self.increaseBtn.selected = YES;
        self.increaseBtn.userInteractionEnabled = NO;
        self.value = _maximum;
    }
}

#pragma mark - initValue
- (void)initValue {
    self.step = 1;
    self.value = 1;
    self.minimum = 1;
    self.maximum = 100;

    // 已经最小值不可操作
    self.decreaseBtn.selected = YES;
    self.decreaseBtn.userInteractionEnabled = NO;
}

#pragma mark - getters and  setters
- (void)setValue:(NSInteger)value {
    _value = value;
    
    if (_valueBlock) {
        _valueBlock(value);
    }
    
    if (value > _minimum) {
        self.decreaseBtn.selected = NO;
        self.decreaseBtn.userInteractionEnabled = YES;
    }
    
    self.valueLb.text = [NSString stringWithFormat:@"%ld", _value];
}

- (void)setMinimum:(NSInteger)minimum {
    _minimum = minimum;
    if (_value < minimum) {
        self.value = minimum;
    }
}

- (void)setMaximum:(NSInteger)maximum {
    _maximum = maximum;
    if (_value > maximum) {
        self.value = maximum;
    }
}

@end
