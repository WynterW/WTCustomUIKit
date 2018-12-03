//
//  WTFeatureGuideViewController.m
//  WTFeatureGuide
//
//  Created by Wynter on 2018/11/30.
//  Copyright © 2018 Wynter. All rights reserved.
//

#import "WTFeatureGuideViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height


@interface WTFeatureGuideViewController ()

@property (nonatomic, strong) UIImageView *msgImageView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIButton *skipBtn;

@end

@implementation WTFeatureGuideViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.msgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.msgImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.msgImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextPage:)];
    [self.view addGestureRecognizer:tap];
    
    self.iKnowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iKnowBtn.frame = CGRectMake(kScreenWidth / 2 - 90, kScreenHeight - 200, 180, 48);
    [self.iKnowBtn addTarget:self action:@selector(knowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.iKnowBtn setImage:[UIImage imageNamed:@"iKnow_btn"] forState:UIControlStateNormal];
    self.iKnowBtn.hidden = YES;
    [self.view addSubview:self.iKnowBtn];
    
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.frame = CGRectMake(kScreenWidth - 59 - 20, kStatusBarHeight, 59, 32);
    [self.skipBtn setImage:[UIImage imageNamed:self.skipImgNames[0]] forState:UIControlStateNormal];
    [self.skipBtn addTarget:self action:@selector(knowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipBtn];
    
    self.msgImageView.image = [UIImage imageNamed:self.msgImageNames[0]];
    CGRect rect = [self.guideContentFrames[0] CGRectValue];
    [self updateViewWithFrame:rect];
}

#pragma mark - event response
- (void)nextPage:(UITapGestureRecognizer *)pan {
    NSInteger page = self.currentPage + 1;
    if (page < self.msgImageNames.count) {
        self.currentPage = page;
        self.msgImageView.image = [UIImage imageNamed:self.msgImageNames[page]];
        [self.skipBtn setImage:[UIImage imageNamed:self.skipImgNames[page]] forState:UIControlStateNormal];
        CGRect rect = [self.guideContentFrames[page] CGRectValue];
        [self updateViewWithFrame:rect];
    } else if (page == self.msgImageNames.count) {
        self.iKnowBtn.hidden = NO;
    }
}

- (void)knowAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - private methods
- (CAShapeLayer *)addTransparencyViewWith:(UIBezierPath *)tempPath {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    [path appendPath:tempPath];
    path.usesEvenOddFillRule = YES;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor blackColor].CGColor;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    return shapeLayer;
}

- (void)updateViewWithFrame:(CGRect)rect {
    self.msgImageView.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) - self.msgImageView.image.size.height, self.msgImageView.image.size.width, self.msgImageView.image.size.height);
    
    // 如果右侧超出则右对齐
    if ((CGRectGetMinX(rect) + self.msgImageView.image.size.width) > kScreenWidth) {
        CGRect frame = self.msgImageView.frame;
        frame.origin.x = kScreenWidth - self.msgImageView.image.size.width - 20;
        self.msgImageView.frame = frame;
    }
    
    UIBezierPath *tempPath = nil;
    switch (self.markStyle) {
        case WTMarkStyleOval: {
            tempPath = [UIBezierPath bezierPathWithOvalInRect:rect];
            break;
        }
        case WTMarkStyleRound: {
            CGFloat redius = [self.roundRadius[self.currentPage] floatValue];
            tempPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(redius, redius)];
            break;
        }
        case WTMarkStyleRect: {
            tempPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft) cornerRadii:CGSizeZero];
            break;
        }
    }
        
    self.view.layer.mask = [self addTransparencyViewWith:tempPath];
}

#pragma mark - getters and  setters
- (NSArray *)skipImgNames {
    return @[@"skip_guide_1", @"skip_guide_2", @"skip_guide_3", @"skip_guide_4"];
}

@end
