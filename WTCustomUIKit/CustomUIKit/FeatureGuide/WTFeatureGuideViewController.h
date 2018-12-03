//
//  WTFeatureGuideViewController.h
//  WTFeatureGuide
//
//  Created by Wynter on 2018/11/30.
//  Copyright © 2018 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WTMarkStyle) {
    WTMarkStyleOval, // 椭圆
    WTMarkStyleRound, // 圆形
    WTMarkStyleRect  // 矩形
};

@interface WTFeatureGuideViewController : UIViewController

@property (nonatomic, strong) UIButton *iKnowBtn;

@property (nonatomic, assign) WTMarkStyle markStyle;
@property (nonatomic, strong) NSArray *msgImageNames;
@property (nonatomic, strong) NSArray <NSValue *>*guideContentFrames; /**< 引导的位置*/
@property (nonatomic, strong) NSArray *roundRadius; /**< WTMarkStyleRound状态下使用*/
@property (nonatomic, strong) NSArray *skipImgNames;

@end

NS_ASSUME_NONNULL_END
