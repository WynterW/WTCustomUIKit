//
//  TopSheetViewController.m
//  WTCustomUIKit
//
//  Created by Wynter on 2018/9/4.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import "TopSheetViewController.h"
#import "UIView+Frame.h"
#import "UIView+BorderLine.h"
#import "WTPublicCell.h"

static const CGFloat kTableViewH = 300.f;
static const CGFloat kCellH = 48.f;

@interface TopSheetViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TopSheetViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.tableView registerClass:[WTPublicCell class] forCellReuseIdentifier:@"WTPublicCell"];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topH, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - self.topH)];
    bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self.view addSubview:bgView];
    [bgView addSubview:self.tableView];
    [self.tableView borderForColor:[UIColor colorWithRed:241/255.0 green:243/255.0 blue:243/255.0 alpha:1] borderWidth:0.5 borderType:UIBorderSideTypeTop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.height = self.tableViewH > 0 ? self.tableViewH : kTableViewH;
    }];
    if (self.isShowBtnTransform) {
        self.showBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    self.showBtn.selected = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isShowBtnTransform) {
        self.showBtn.imageView.transform = CGAffineTransformIdentity;
    }
    self.showBtn.selected = NO;
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTPublicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WTPublicCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.customCellStyle = WTTableViewCellStyleChecked;
    NSString *title = self.dataSource[indexPath.row];
    cell.titleLb.text = title;
    if ([self.selectTitle isEqualToString:title]) {
        cell.titleLb.textColor = self.selectedTitleColor ?: [UIColor colorWithRed:11/255.0 green:176/255.0 blue:123/255.0 alpha:1];
        cell.titleLb.font = self.selectedTitleFont ?: [UIFont systemFontOfSize:14.f];
        cell.rightImgView.image = [UIImage imageNamed:@"selected_btn"];
    } else {
        cell.titleLb.font = self.titleFont ?: [UIFont systemFontOfSize:14.f];
        cell.titleLb.textColor = self.titleColor ?: [UIColor colorWithRed:12/255.0 green:14/255.0 blue:14/255.0 alpha:1];
        cell.rightImgView.image = [UIImage imageNamed:@""];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.selecBlock) {
        self.selecBlock(indexPath.row,self.dataSource[indexPath.row]);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self pop];
    });
}

- (void)pop {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self pop];
}

#pragma mark - getters and  setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0) style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    
    return _tableView;
}

@end
