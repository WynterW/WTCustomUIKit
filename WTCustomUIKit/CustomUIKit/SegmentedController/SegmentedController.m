//
//  SegmentedController.m
//  ShowManyProducts
//
//  Created by Wynter on 16/4/6.
//  Copyright © 2016年 Wynter. All rights reserved.
//

#import "SegmentedController.h"
#import "UIView+Frame.h"

@interface SegmentedController () <UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *tabarView;
@property (nonatomic, strong) UIScrollView *bodyScrollView;
@property (nonatomic, strong) UIButton *selectedBtn;     /**< 选中的btn*/
@property (nonatomic, strong) UIView *tagView; /**< 标记选中*/

@end

@implementation SegmentedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController];

    [self initMianView];

    _bodyScrollView.scrollEnabled = !_scrollEnabled;
}

#pragma mark - 初始化主视图
- (void)initMianView {

    _tabarView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height, CGRectGetWidth(self.view.frame), 45)];
    _tabarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabarView];

    NSInteger count = [_childViewControllerAry count];

    _tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, (CGRectGetWidth(self.view.frame) / count), 3)];
    _tagView.size = _tagViewSize.width ? _tagViewSize : _tagView.size;
    _tagView.backgroundColor = _selectedColor ?: [UIColor cyanColor];
    [_tabarView addSubview:_tagView];

    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * (CGRectGetWidth(self.view.frame) / count), 0, (CGRectGetWidth(self.view.frame) / count), 45);
        btn.titleLabel.font = _normalFont ?: [UIFont systemFontOfSize:15];
        [btn setTitleColor:_normalColor ?: [UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:_selectedColor ?: [UIColor cyanColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        [_tabarView addSubview:btn];
    }

    _bodyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_tabarView.frame))];
    _bodyScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * self.childViewControllers.count, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _bodyScrollView.showsHorizontalScrollIndicator = NO;
    _bodyScrollView.showsVerticalScrollIndicator = NO;
    _bodyScrollView.pagingEnabled = YES;
    _bodyScrollView.bounces = NO;
    _bodyScrollView.delegate = self;
    [self.view addSubview:_bodyScrollView];

    // 设置第一个展示视图
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = _bodyScrollView.bounds;
    [_bodyScrollView addSubview:vc.view];

    // 设置第一个按钮颜色
    for (UIView *view in _tabarView.subviews) {
        if (view.tag == 1000) {
            _selectedBtn = (UIButton *) view;
            _selectedBtn.selected = YES;
            _selectedBtn.titleLabel.font = _selectedFont ?: [UIFont systemFontOfSize:15.f];
            _tagView.centerX = _selectedBtn.centerX;
        }
    }
}

- (void)clickTitle:(UIButton *)sender {
    if (_selectedBtn == sender) {
        return;
    }

    UIButton *btn = (UIButton *) sender;
    _selectedBtn.selected = NO;
    btn.selected = YES;
    [UIView animateWithDuration:0.5
        animations:^{
            self.tagView.centerX = btn.centerX;
        }
        completion:^(BOOL finished) {
            self.selectedBtn = btn;
        }];

    CGFloat offsetX = (btn.tag - 1000) * _bodyScrollView.frame.size.width;
    CGFloat offsetY = _bodyScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [_bodyScrollView setContentOffset:offset animated:YES];
}

#pragma mark -
- (void)addChildViewController {
    for (UIViewController *VC in self.childViewControllerAry) {
        [self addChildViewController:VC];
    }
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    int autualIndex = scrollView.contentOffset.x / _bodyScrollView.bounds.size.width;
    //设置当前下标
    self.currentIndex = autualIndex;

    [self setBtnState];

    UIViewController *Vc = self.childViewControllers[autualIndex];
    Vc.view.frame = scrollView.bounds;
    [_bodyScrollView addSubview:Vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - 设置按钮状体
- (void)setBtnState {
    _selectedBtn.selected = NO;
    _selectedBtn.titleLabel.font = _normalFont ?: [UIFont systemFontOfSize:14.f];
    for (UIView *view in _tabarView.subviews) {
        NSInteger btnTag = self.currentIndex + 1000;
        if (view.tag == btnTag) {
            UIButton *btn = (UIButton *) view;
            btn.selected = YES;
            [UIView animateWithDuration:0.5
                animations:^{
                    self.tagView.centerX = btn.centerX;
                }
                completion:^(BOOL finished) {
                    self.selectedBtn = btn;
                    self.selectedBtn.titleLabel.font = self.selectedFont ?: [UIFont systemFontOfSize:15.f];
                }];
        } else {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *) view;
                btn.selected = NO;
                btn.titleLabel.font = _normalFont ?: [UIFont systemFontOfSize:14.f];
            }
        }
    }
}

- (void)setTagViewSize:(CGSize)tagViewSize {
    _tagViewSize = tagViewSize;
    if (_tagView) {
        _tagView.size = tagViewSize;
        _tagView.centerX = _selectedBtn.centerX;
    }
}

@end
