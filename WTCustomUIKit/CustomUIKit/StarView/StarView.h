//
//  StarView.h
//  LanXiWisdomTour
//
//  Created by Wynter on 2017/3/16.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,StarAliment) {
    StarAlimentDefault,
    StarAlimentCenter,
    StarAlimentRight
};

typedef NS_ENUM(NSInteger, StarType) {
    StarTypeDefault = 1, // 展示功能不可选择
    StarTypeComment     // 评分可选择
};

@interface StarView : UIView

@property (nonatomic,assign) CGFloat commentPoint; /**< 评分*/
@property (nonatomic,assign) StarAliment starAliment; /**< 对齐方式*/
@property (nonatomic,assign) StarType type; /**< 评分类型*/
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *unselectedImage;

/**
 *  初始化方法
 *
 *  @param frame      整个星星视图的frame
 *  @param totalStar  总的星星的个数
 *  @param totalPoint 星星表示的总分数
 *  @param space      星星之间的间距
 *
 *  @return StarView
 */
- (instancetype)initWithFrame:(CGRect)frame withTotalStar:(NSInteger)totalStar withTotalPoint:(CGFloat)totalPoint starSpace:(NSInteger)space;

@end
