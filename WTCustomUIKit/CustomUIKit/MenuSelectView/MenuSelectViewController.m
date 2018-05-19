//
//  MenuSelectViewController.m
//  Menu
//
//  Created by Wynter on 16/7/21.
//  Copyright © 2016年 wynter. All rights reserved.
//

#import "MenuSelectViewController.h"
#import "MenuSelectTableViewCell.h"

static const CGFloat kTableViewW = 100.f;
static const CGFloat kCellH = 40.f;

@interface MenuSelectViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *selectListView;
@property (nonatomic, strong) UITableView *selectListTableView;

@end

@implementation MenuSelectViewController
- (instancetype)initWithItems:(NSArray<MenuSelectItem *> *)items {
    if (self = [super init]) {
        self.alphaComponent = 0.25;
        self.items = items;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.alphaComponent];

    [self createSelectListView];
}

- (void)createSelectListView {
    self.selectListView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - kTableViewW - 15, 64 + 5, kTableViewW, 5 + kCellH * _items.count)];
    [self.view addSubview:self.selectListView];

    UIImage *bgImage = [UIImage imageNamed:@"menu_bg"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 10, 10, 22)];

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _selectListView.frame.size.width, _selectListView.frame.size.height)];
    bgImageView.image = bgImage;
    [_selectListView addSubview:bgImageView];

    self.selectListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, _selectListView.frame.size.width, _selectListView.frame.size.height) style:UITableViewStylePlain];
    _selectListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selectListTableView.delegate = self;
    _selectListTableView.dataSource = self;
    _selectListTableView.scrollEnabled = NO;
    _selectListTableView.backgroundColor = [UIColor clearColor];
    [_selectListView addSubview:_selectListTableView];

    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    dismissTap.delegate = self;
    [self.view addGestureRecognizer:dismissTap];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuSelectTableViewCell"];
    if (!cell) {
        cell = [[MenuSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MenuSelectTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
    }

    MenuSelectItem *item = [_items objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:item.iconImage];
    cell.textLabel.text = item.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self dismissWithAnimate:NO];

    if (self.clickBlock) {
        self.clickBlock(indexPath.row);
    }
}

#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.selectListView]) {
        return NO;
    }
    return YES;
}

- (void)dismiss {
    [self dismissWithAnimate:YES];
}

#pragma mark - public method

- (void)show {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [_showListViewControl presentViewController:self animated:YES completion:nil];
}

- (void)dismissWithAnimate:(BOOL)animate {
    if (animate) {
        //设置缩放的原点(必须配置)
        //这个point，应该是按照比例来的。0是最左边，1是最右边
        [self setAnchorPoint:CGPointMake(0.9, 0) forView:_selectListView];

        [UIView animateWithDuration:0.3
            animations:^{

                self.selectListView.transform = CGAffineTransformMakeScale(0.01, 0.01);

            }
            completion:^(BOOL finished) {

                [self dismissViewControllerAnimated:YES completion:nil];

            }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;

    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;

    view.center = CGPointMake(view.center.x - transition.x, view.center.y - transition.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
