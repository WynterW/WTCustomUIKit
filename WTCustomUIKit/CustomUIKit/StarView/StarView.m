//
//  StarView.m
//  LanXiWisdomTour
//
//  Created by Wynter on 2017/3/16.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "StarView.h"

@interface StarView () {
    //星星的高度
    CGFloat starHeight;

    //宽度间距
    CGFloat spaceWidth;

    //星星总个数
    NSInteger totalNumber;

    //单个代表的评分
    CGFloat singlePoint;

    //最大分数
    NSInteger maxPoints;

    //星星的tag
    NSInteger starBaseTag;

    //填充的视图
    UIView *foregroundStarView;

    //填充星星的偏移量
    CGFloat starOffset;
}
@end
@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame withTotalStar:(NSInteger)totalStar withTotalPoint:(CGFloat)totalPoint starSpace:(NSInteger)space {
    self = [super initWithFrame:frame];
    if (self) {

        //对传进来的frame进行处理，取合适的星星的高度

        //传进来的高度
        CGFloat height = frame.size.height;
        //减去间距后的平均的宽度（我设置的星星 高度＝宽度）
        CGFloat averageHeight = (frame.size.width - space * (totalStar - 1)) / totalStar;

        if (height > averageHeight) {
            starHeight = averageHeight;
        } else {
            starHeight = height;
        }

        starBaseTag = 6666;
        spaceWidth = space;
        totalNumber = totalStar;
        singlePoint = totalPoint / totalStar;
        maxPoints = totalPoint;

        [self loadCustomViewWithTotal:totalStar];
    }
    return self;
}

- (void)loadCustomViewWithTotal:(NSInteger)totalStar {
    //先铺背景图片（空的星星）
    for (int i = 0; i < totalStar; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * starHeight + i * spaceWidth, self.frame.size.height - starHeight, starHeight, starHeight)];
        imageView.tag = starBaseTag + i;
        imageView.image = self.unselectedImage?self.unselectedImage:[UIImage imageNamed:@"comments_star_gray"];
        [self addSubview:imageView];
    }
}

//当你设置评分时 开始填充整颗星星
- (void)setCommentPoint:(CGFloat)commentPoint {
    _commentPoint = commentPoint;

    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *theButton = (UIButton *) obj;
            [theButton removeFromSuperview];
        }
    }

    for (id obj in foregroundStarView.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *view = (UIImageView *) obj;
            [view removeFromSuperview];
        }
    }

    if (commentPoint > maxPoints) {
        commentPoint = maxPoints;
    }

    CGFloat showNumber = commentPoint / singlePoint;

    //覆盖的长图
    if (!foregroundStarView) {
        foregroundStarView = [[UIView alloc] init];
    }

    foregroundStarView.frame = CGRectZero;
    //整颗星星
    NSInteger fullNumber = showNumber / 1;

    if (starOffset > 0) {
        foregroundStarView.frame = CGRectMake(starOffset, self.frame.size.height - starHeight, starHeight * showNumber + spaceWidth * fullNumber, starHeight);

    } else {
        foregroundStarView.frame = CGRectMake(0, self.frame.size.height - starHeight, starHeight * showNumber + spaceWidth * fullNumber, starHeight);
    }
    foregroundStarView.clipsToBounds = YES;

    //在长图上填充完整的星星
    for (int j = 0; j < fullNumber; j++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.image = self.selectedImage?self.selectedImage:[UIImage imageNamed:@"comments_star_green"];
        starImageView.frame = CGRectMake(j * starHeight + j * spaceWidth, 0, starHeight, starHeight);
        [foregroundStarView addSubview:starImageView];
    }

    CGFloat part = showNumber - fullNumber;
    //如果有残缺的星星 则添加
    if (part > 0) {
        UIImageView *partImage = [[UIImageView alloc] initWithFrame:CGRectMake(fullNumber * starHeight + fullNumber * spaceWidth, 0, starHeight, starHeight)];
        partImage.image = self.selectedImage?self.selectedImage:[UIImage imageNamed:@"comments_star_green"];
        [foregroundStarView addSubview:partImage];
    }

    [self addSubview:foregroundStarView];

    if (self.type == StarTypeComment) {
        for (int i = 0; i < totalNumber; i++) {

            UIImageView *starImageView = (UIImageView *) [self viewWithTag:i + starBaseTag];
            [self addCommentBtn:starImageView.frame];
        }
    }
}

//设置星星的对齐方式
- (void)setStarAliment:(StarAliment)starAliment {
    _starAliment = starAliment;

    switch (starAliment) {
        //居中对齐
        case StarAlimentCenter: {
            CGFloat starRealWidth = totalNumber * starHeight + (totalNumber - 1) * spaceWidth;
            CGFloat leftWidth = self.frame.size.width - starRealWidth;

            for (int i = 0; i < totalNumber; i++) {
                UIImageView *starImageView = (UIImageView *) [self viewWithTag:i + starBaseTag];
                starImageView.frame = CGRectMake(leftWidth / 2 + starImageView.frame.origin.x, starImageView.frame.origin.y, starImageView.frame.size.width, starImageView.frame.size.height);
            }
            starOffset = leftWidth / 2;
            foregroundStarView.frame = CGRectMake(leftWidth / 2 + foregroundStarView.frame.origin.x, foregroundStarView.frame.origin.y, foregroundStarView.frame.size.width, foregroundStarView.frame.size.height);

        } break;
        //右对齐
        case StarAlimentRight: {
            CGFloat starRealWidth = totalNumber * starHeight + (totalNumber - 1) * spaceWidth;
            CGFloat leftWidth = self.frame.size.width - starRealWidth;

            for (int i = 0; i < totalNumber; i++) {
                UIImageView *starImageView = (UIImageView *) [self viewWithTag:i + starBaseTag];
                starImageView.frame = CGRectMake(leftWidth + starImageView.frame.origin.x, starImageView.frame.origin.y, starImageView.frame.size.width, starImageView.frame.size.height);
            }
            starOffset = leftWidth;
            foregroundStarView.frame = CGRectMake(leftWidth + foregroundStarView.frame.origin.x, foregroundStarView.frame.origin.y, foregroundStarView.frame.size.width, foregroundStarView.frame.size.height);

        } break;
        //默认的左对齐
        case StarAlimentDefault: {

            for (int i = 0; i < totalNumber; i++) {
                UIImageView *starImageView = (UIImageView *) [self viewWithTag:i + starBaseTag];
                starImageView.frame = CGRectMake(i * starHeight + i * spaceWidth, self.frame.size.height - starHeight, starHeight, starHeight);
            }


            CGFloat showNumber = self.commentPoint / singlePoint;

            //整颗星星
            NSInteger fullNumber = showNumber / 1;
            starOffset = 0;
            foregroundStarView.frame = CGRectMake(0, self.frame.size.height - starHeight, starHeight * showNumber + spaceWidth * fullNumber, starHeight);
        } break;
        default: {

        } break;
    }
}

- (void)addCommentBtn:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:self action:@selector(clickStarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [self bringSubviewToFront:btn];
}

- (void)clickStarAction:(UIButton *)btn {
    CGRect frame = btn.frame;
    
    UIImageView *starImageView = (UIImageView*)[self viewWithTag:starBaseTag];
    self.commentPoint = round((frame.origin.x - starImageView.frame.origin.x + starHeight) / (starHeight+spaceWidth));
}

- (void)setUnselectedImage:(UIImage *)unselectedImage {
    _unselectedImage = unselectedImage;
    for (int i = 0; i < totalNumber; i++) {
        UIImageView *imageView = [self viewWithTag:starBaseTag + i];
        imageView.image = self.unselectedImage?self.unselectedImage:[UIImage imageNamed:@"comments_star_gray"];
    }
}

@end
