//
//  ChooseMenuViewController.m
//  WTCustomUIKit
//
//  Created by Wynter on 2018/5/18.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import "ChooseMenuViewController.h"
#import "CompanySelectTypeCell.h"
#import "CompanySelectTypeItem.h"
#import "MenuToolBar.h"
#import "Masonry.h"
#import "UIView+Frame.h"
#import "MJExtension.h"

// 屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static const CGFloat kCellHeight = 45.f;

@interface ChooseMenuViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) MenuToolBar *topTabBarView;
@property (nonatomic, strong) UIView *underLine;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic, strong) NSMutableArray <NSArray *> *historyAry;
@property (nonatomic, strong) NSMutableArray <CompanySelectTypeItem *> *selectedAry;
@property (nonatomic, strong) NSMutableArray *tableViews;
@property (nonatomic, strong) NSMutableArray *topTabbarItems;

@end

@implementation ChooseMenuViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    [self initValue];
    [self setup];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self show];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = [self.tableViews indexOfObject:tableView];
    return self.historyAry[index].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanySelectTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanySelectTypeCell" forIndexPath:indexPath];
    NSInteger index = [self.tableViews indexOfObject:tableView];
    CompanySelectTypeItem *item = self.historyAry[index][indexPath.row];
    cell.item = item;
    return cell;
}

#pragma mark - TableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self.tableViews indexOfObject:tableView];
    
    CompanySelectTypeItem *item = self.historyAry[index][indexPath.row];
    if (item.child.count == 0) {
        [self setupTopBarWithItem:item];
        return indexPath;
    }
    
    NSIndexPath *selectedRowIndexPath = [tableView indexPathForSelectedRow];
    if (index == 0) {
        if (selectedRowIndexPath) {
            for (int i = 0; i <= self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
        }
    } else {
        if ([selectedRowIndexPath compare:indexPath] != NSOrderedSame && selectedRowIndexPath) {
            for (int i = 0; i < self.tableViews.count - index; i++) {
                [self removeLastItem];
            }
        } else if ([selectedRowIndexPath compare:indexPath] == NSOrderedSame && selectedRowIndexPath) {
            [self scrollToNextWithItem:item];
            return indexPath;
        }
    }
    
    [self.historyAry addObject:item.child];
    [self addTopBarItem];
    [self addTableView];
    [self scrollToNextWithItem:item];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self.tableViews indexOfObject:tableView];
    CompanySelectTypeItem *item = self.historyAry[index][indexPath.row];
    item.isSelected = YES;
    [self.selectedAry addObject:item];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    if (item.child.count == 0) {
        [self dissmiss];
        if (self.chooseFinish) {
            self.chooseFinish(self.type ,[self.selectedAry copy]);
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self.tableViews indexOfObject:tableView];
    CompanySelectTypeItem *item = self.historyAry[index][indexPath.row];
    item.isSelected = NO;
    [self.selectedAry removeObject:item];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.contentScrollView) return;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
                         UIButton *btn = weakSelf.topTabbarItems[index];
                         [weakSelf changeUnderLineFrame:btn];
                     }];
}

#pragma mark - event response
- (void)cancelAction:(id)sender {
    [self dissmiss];
}

- (void)topBarItemClick:(UIButton *)btn {
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.contentScrollView.contentOffset = CGPointMake(index * SCREEN_WIDTH, 0);
                         [self changeUnderLineFrame:btn];
                     }];
}

- (void)setupTopBarWithItem:(CompanySelectTypeItem *)item {
    NSInteger index = self.contentScrollView.contentOffset.x / SCREEN_WIDTH;
    UIButton *btn = self.topTabbarItems[index];
    [btn setTitle:item.name forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabBarView layoutIfNeeded];
    [self changeUnderLineFrame:btn];
}

#pragma mark - private methods
- (void)initValue {
    NSArray *dataAry;
    switch (self.type) {
        case CompanySelectTypeArea:
            dataAry = self.dataSource[@"area"];
            break;
        case CompanySelectTypeIndustry:
            dataAry = self.dataSource[@"industry"];
            break;
        case CompanySelectTypeCondition:
            dataAry = self.dataSource[@"condition"];
            break;
    }
    
    NSAssert(dataAry != nil, @"数据不能为空");
    
    [CompanySelectTypeItem mj_setupObjectClassInArray:^NSDictionary * {
        return @{
                 @"child": [CompanySelectTypeItem class]
                 };
    }];
    
    NSArray *tempAry = [CompanySelectTypeItem mj_objectArrayWithKeyValuesArray:dataAry];
    _historyAry = [NSMutableArray array];
    [_historyAry addObject:tempAry];
}

- (void)setup {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.topTabBarView];
    [self.topTabBarView addSubview:self.underLine];
    [self.contentView addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CompanySelectTypeCell" bundle:nil] forCellReuseIdentifier:@"CompanySelectTypeCell"];
    [self addTopBarItem];
    [self addTableView];
    [self.topTabBarView layoutIfNeeded];
    
    CGFloat btnW = 45.f;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - btnW, 0, btnW, kCellHeight);
    [cancelBtn setImage:[UIImage imageNamed:@"下一页(2)"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    [self.contentView bringSubviewToFront:cancelBtn];
}

- (void)addTableView {
    UITableView *tabbleView = [[UITableView alloc] initWithFrame:CGRectMake(self.tableViews.count * SCREEN_WIDTH, 0, SCREEN_WIDTH, _contentScrollView.height)];
    [_contentScrollView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    [tabbleView registerNib:[UINib nibWithNibName:@"CompanySelectTypeCell" bundle:nil] forCellReuseIdentifier:@"CompanySelectTypeCell"];
}

- (void)addTopBarItem {
    UIButton *topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:UIColorFromRGB(0x494949) forState:UIControlStateNormal];
    [topBarItem setTitleColor:UIColorFromRGB(0x63BCCA) forState:UIControlStateSelected];
    topBarItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [topBarItem sizeToFit];
    topBarItem.center = CGPointMake(topBarItem.center.x, _topTabBarView.height * 0.5);
    [self.topTabbarItems addObject:topBarItem];
    [_topTabBarView addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeUnderLineFrame:(UIButton *)btn {
    _selectBtn.selected = NO;
    btn.selected = YES;
    _selectBtn = btn;
    _underLine.x = btn.x;
    _underLine.width = btn.width;
}

- (void)show {
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.contentView.y = (CGRectGetHeight(self.view.frame) - kCellHeight * 5);
                     }];
}

- (void)dissmiss {
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.contentView.y = CGRectGetHeight(self.view.frame);
                     }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
}

- (void)removeLastItem {
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
    
    [self.historyAry.lastObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[CompanySelectTypeItem class]]) {
            CompanySelectTypeItem *item = (CompanySelectTypeItem *) obj;
            item.isSelected = NO;
        }
    }];
    
    [self.selectedAry removeLastObject];
    [self.historyAry removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextWithItem:(CompanySelectTypeItem *)item {
    NSInteger index = self.contentScrollView.contentOffset.x / SCREEN_WIDTH;
    UIButton *btn = self.topTabbarItems[index];
    [btn setTitle:item.name forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabBarView layoutIfNeeded];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.contentScrollView.contentSize = CGSizeMake(self.tableViews.count * SCREEN_WIDTH, 0);
                         CGPoint offset = self.contentScrollView.contentOffset;
                         self.contentScrollView.contentOffset = CGPointMake(offset.x + SCREEN_WIDTH, offset.y);
                         [self changeUnderLineFrame:[self.topTabBarView.subviews lastObject]];
                     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = [touches anyObject];
    if ([touche.view isEqual:self.view]) {
        [self dissmiss];
    }
}

#pragma mark - getters and  setters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kCellHeight * 5)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (MenuToolBar *)topTabBarView {
    if (!_topTabBarView) {
        _topTabBarView = [[MenuToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCellHeight)];
        _topTabBarView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _topTabBarView;
}

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight - 2, SCREEN_WIDTH, 2)];
        _underLine.backgroundColor = UIColorFromRGB(0x63BCCA);
    }
    return _underLine;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kCellHeight, SCREEN_WIDTH, kCellHeight * 5)];
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (NSDictionary *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CompanySelectType.plist" ofType:nil]];
    }
    return _dataSource;
}

- (NSMutableArray *)tableViews {
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems {
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}

- (NSMutableArray<CompanySelectTypeItem *> *)selectedAry {
    if (!_selectedAry) {
        _selectedAry = [NSMutableArray array];
    }
    return _selectedAry;
}

@end
