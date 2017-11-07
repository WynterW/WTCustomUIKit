//
//  HotelCalendarViewController.m
//  HotelCalendar
//
//  Created by Wynter on 2017/10/17.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "HotelCalendarViewController.h"
#import "NSCalendar+Ex.h"
#import "HotelCalendarCell.h"
#import "HotelCalendarHeaderReusableView.h"
#import "HotelCalendarCollectionViewFlowLayout.h"

// 周一到周日 标题栏字体颜色
#define itemTexTColor [UIColor colorWithRed:153.f / 255.f green:153.f / 255.f blue:153.f / 255.f alpha:1]
// 未选中正常显示日历字体显示深黑色
#define dayTexTColor [UIColor colorWithRed:44.0 / 255.0 green:49.0 / 255.0 blue:53.0 / 255.0 alpha:1]
// 超出最大天数日历字体显示暗灰色
#define dayOutTexTColor [UIColor colorWithRed:65.0 / 255.0 green:65.0 / 255.0 blue:65.0 / 255.0 alpha:0.3]
// 当前日期字体颜色显示浅黑色
#define dayCurrentTexTColor [UIColor colorWithRed:44.0 / 255.0 green:49.0 / 255.0 blue:53.0 / 255.0 alpha:1]
// 选中后日历字体颜色为白色
#define daySelectTexTColor [UIColor whiteColor]

#define kBlueColor [UIColor colorWithRed:59.0 / 255.0 green:213.0 / 255.0 blue:175.0 / 255.0 alpha:1]

static const CGFloat kHeaderViewH = 70.f;
static const CGFloat kFooterViewH = 50.f;
static const CGFloat kCalendarViewH = 470.f; // 70 + 50 + 50 * 6 + 50

@interface HotelCalendarViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UIView *calendarView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *footerFinishView;

@property (strong, nonatomic) NSMutableArray *sectionRows;
@property (strong, nonatomic) NSMutableDictionary *gradientViewInfos;
@property (strong, nonatomic) NSDate *selectFromDate;
@property (strong, nonatomic) NSDate *selectToDate;
@property (assign, nonatomic) NSInteger rangeDays;
@property (assign, nonatomic) NSInteger months;
@property (assign, nonatomic) NSInteger itemWidth;
@end

@implementation HotelCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithRed:73.f / 255.f green:73.f / 255.f blue:73.f / 255.f alpha:1] colorWithAlphaComponent:.5];
    [self.view addSubview:self.calendarView];
    [self setupInitValues];
    [self setupHeaderViews];
    [self setupCollectionViews];
    [self setupFooterViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showCalendarView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.months;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sectionRows[section] integerValue];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotelCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotelCalendarCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.isFromDate = NO;
    cell.isToDate = NO;
    cell.isCurrentDate = NO;
    cell.itemWidth = self.itemWidth;
    
    // 依照 section index 计算日期
    NSDate *fromDate = [self.dataSource minimumDateForHotelCalendar];
    NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    
    // 包含前一个月天数
    NSInteger containPreDays = [NSCalendar weekFromMonthFirstDate:sectionDate];
    NSInteger shiftIndex = indexPath.row;
    if (shiftIndex >= containPreDays) { // 本月不包含前一个月天数
        shiftIndex -= containPreDays;
        cell.dayLabel.text = [NSString stringWithFormat:@"%td", shiftIndex + 1];
        
        NSDate *yyMMDDDate = [self dateYYMMConvertToYYMMDD:sectionDate withDay:shiftIndex + 1];
        if ([yyMMDDDate compare:fromDate] == NSOrderedAscending) {
            cell.dayLabel.textColor = dayOutTexTColor;
        } else {
            cell.dayLabel.textColor = dayTexTColor;
        }
        
        NSDateFormatter *currentDateFormat = [[NSDateFormatter alloc] init];
        currentDateFormat.dateFormat = self.formatString;
        NSString *currentDateString = [currentDateFormat stringFromDate:[NSDate date]];
        
        // 当天
        if ([yyMMDDDate compare:[currentDateFormat dateFromString:currentDateString]] == NSOrderedSame) {
            cell.isCurrentDate = YES;
            cell.dayLabel.text = @"今天";
        }
        
        BOOL isOnRangeDate = [NSCalendar isOnRangeFromDate:self.selectFromDate toDate:self.selectToDate date:yyMMDDDate];
        
        if (isOnRangeDate) { // 如果当前日期在两个选择日期中间
            cell.dayLabel.textColor = daySelectTexTColor;
            [self recordGradientInfo:yyMMDDDate frame:cell.frame];
        }
        
        NSString *selectFromDateString = [self yyMMDDStringConvertFromDate:self.selectFromDate];
        NSString *selectToDateString = [self yyMMDDStringConvertFromDate:self.selectToDate];
        NSString *yyMMDDDateString = [self yyMMDDStringConvertFromDate:yyMMDDDate];
        if ([selectFromDateString isEqualToString:yyMMDDDateString]) {
            cell.dayLabel.textColor = [UIColor whiteColor];
            cell.isFromDate = YES;
            [self recordGradientInfo:yyMMDDDate frame:cell.frame];
        }
        
        if ([selectToDateString isEqualToString:yyMMDDDateString]) {
            cell.dayLabel.textColor = [UIColor whiteColor];
            cell.isToDate = YES;
            [self recordGradientInfo:yyMMDDDate frame:cell.frame];
        }
        
        // 选择第一个日期，则把大于 rangeDays 的日期关闭
        if (self.selectFromDate && !self.selectToDate) {
            NSInteger days = [NSCalendar daysFromDate:self.selectFromDate toDate:yyMMDDDate];
            if (labs(days) >= self.rangeDays) {
                cell.dayLabel.textColor = dayOutTexTColor;
            }
        }
        
        // 最大日期
        if (indexPath.section == self.sectionRows.count - 1) {
            NSDate *toDate = [self.dataSource maximumDateForHotelCalendar];
            NSInteger day = [NSCalendar dayFromDate:toDate];
            
            // 超过最大日期的日数则改变颜色
            if (shiftIndex + 1 > day) {
                cell.dayLabel.textColor = dayOutTexTColor;
            }
        }
    } else {
        // 本月包含前一个月的天数，设置为空
        cell.dayLabel.text = @"";
        cell.dayLabel.textColor = dayTexTColor;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSDate *fromDate = [self.dataSource minimumDateForHotelCalendar];
        
        // 计算开始日期加上 x 数字后的日期
        NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
        
        // 转换日期格式 yyyy年MM月
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年MM月";
        NSString *dateString = [dateFormatter stringFromDate:sectionDate];
        
        HotelCalendarHeaderReusableView *HotelCalendarHeaderReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HotelCalendarHeaderReusableView" forIndexPath:indexPath];
        HotelCalendarHeaderReusableView.dateLabel.text = dateString;
        return HotelCalendarHeaderReusableView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 依照 section index 计算日期
    NSDate *fromDate = [self.dataSource minimumDateForHotelCalendar];
    NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
    
    // 包含前一个月天数
    NSInteger containPreDays = [NSCalendar weekFromMonthFirstDate:sectionDate];
    
    NSInteger shiftIndex = indexPath.row;
    // 项目 一、二 ... 日以外的点击
    if (shiftIndex >= containPreDays) {
        shiftIndex -= containPreDays;
        
        // 判断是否超过当天日期
        if (indexPath.section == self.sectionRows.count - 1) {
            NSDate *toDate = [self.dataSource maximumDateForHotelCalendar];
            NSInteger day = [NSCalendar dayFromDate:toDate];
            
            // 超过最大日期的日数
            if (shiftIndex + 1 > day) {
                return;
            }
        }
        
        // 当前选中的日期
        NSDate *yyMMDDDate = [self dateYYMMConvertToYYMMDD:sectionDate withDay:shiftIndex + 1];
        // 日历的最小日期
        NSDate *yyMMDDFromDate = [self dateFormatter:fromDate];
        // 选中日期小于日历最小日期
        if ([yyMMDDDate compare:yyMMDDFromDate] == NSOrderedAscending ||[yyMMDDDate compare:yyMMDDFromDate] == NSOrderedSame) {
            return;
        }
        
        if (self.selectFromDate) {
            // 重新选择日期区域范围
            if (self.selectToDate) {
                self.selectFromDate = yyMMDDDate;
                self.selectToDate = nil;
                
                [self removeAllgradientView];
            } else {
                NSInteger days = [NSCalendar daysFromDate:self.selectFromDate toDate:yyMMDDDate];
                // 选择日期天数大于0 && 天数不超出最大可选日期范围  反向选择
                if (days > 0 && days < self.rangeDays) {
                    self.selectToDate = yyMMDDDate;
                } else if (days < 0 && labs(days) < self.rangeDays) {
                    self.selectToDate = self.selectFromDate;
                    self.selectFromDate = yyMMDDDate;
                } else if (days == 0) {
                    self.selectFromDate = nil;
                    [self removeAllgradientView];
                }
            }
        } else {
            self.selectFromDate = yyMMDDDate;
            [self removeAllgradientView];
        }
        
        [self.collectionView reloadData];
    }
}

#pragma mark - event response
- (void)cancelAction:(id)sender {
    NSLog(@"取消");
    [self dissmiss];
}

- (void)finishAction:(id)sender {
    NSLog(@"完成");
    [self postDelegateData];
    [self dissmiss];
}

#pragma mark - private methods
- (void)showCalendarView {
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGFloat calendarViewY = (CGRectGetHeight(self.view.frame) - kCalendarViewH);
                         self.calendarView.frame = CGRectMake(0, calendarViewY, CGRectGetWidth(self.view.frame), kCalendarViewH);
                     }];
}

- (void)reloadDelegateDataSource {
    if ([self.dataSource respondsToSelector:@selector(defaultSelectFromDate)]) {
        self.selectFromDate = [self.dataSource defaultSelectFromDate];
    }
    
    if ([self.dataSource respondsToSelector:@selector(defaultSelectToDate)]) {
        self.selectToDate = [self.dataSource defaultSelectToDate];
    }
    
    if ([self.delegate respondsToSelector:@selector(rangeDaysForHotelCalendar)]) {
        self.rangeDays = [self.delegate rangeDaysForHotelCalendar];
    }
    
    if ([self.delegate respondsToSelector:@selector(itemWidthForHotelCalendar)]) {
        self.itemWidth = [self.delegate itemWidthForHotelCalendar];
    } else {
        self.itemWidth = 30;
    }
}

- (void)postDelegateData {
    if ([self.delegate respondsToSelector:@selector(selectNSStringFromDate:toDate:)]) {
        NSDateFormatter *selectFormatter = [[NSDateFormatter alloc] init];
        selectFormatter.dateFormat = self.formatString;
        NSString *cacheFromDate = [selectFormatter stringFromDate:self.selectFromDate];
        NSString *cacheToDate = [selectFormatter stringFromDate:self.selectToDate];
        
        if (self.selectFromDate && self.selectToDate) {
            [self.delegate selectNSStringFromDate:cacheFromDate toDate:cacheToDate];
        } else {
            [self.delegate selectNSStringFromDate:nil toDate:nil];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(selectNSDateFromDate:toDate:)]) {
        if (self.selectFromDate && self.selectToDate) {
            [self.delegate selectNSDateFromDate:self.selectFromDate toDate:self.selectToDate];
        } else {
            [self.delegate selectNSDateFromDate:nil toDate:nil];
        }
    }
}

- (void)reloadData {
    [self reloadDelegateDataSource];
    [self.collectionView reloadData];
}

- (void)recordGradientInfo:(NSDate *)date frame:(CGRect)frame {
    NSString *key = [NSString stringWithFormat:@"%f", CGRectGetMinY(frame)];
    if (self.gradientViewInfos[key]) {
        UIView *gradientView = self.gradientViewInfos[key][@"view"];
        [self.collectionView sendSubviewToBack:gradientView];
        CGRect cacheFrame = gradientView.frame;
        CGRect convertFrame = gradientView.frame;
        
        if (CGRectGetMinX(cacheFrame) > CGRectGetMinX(frame)) {
            convertFrame.origin.x = CGRectGetMinX(frame);
            convertFrame.size.width = CGRectGetMaxX(cacheFrame) - CGRectGetMinX(frame);
        } else if (CGRectGetMinX(cacheFrame) < CGRectGetMinX(frame)) {
            convertFrame.size.width = CGRectGetMaxX(frame) - CGRectGetMinX(cacheFrame);
        }
        
        if (CGRectGetWidth(cacheFrame) < CGRectGetWidth(convertFrame)) {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 gradientView.frame = convertFrame;
                             }];
        }
    } else {
        CGRect convertFrame = [self.collectionView convertRect:frame toView:self.collectionView];
        UIView *gradientView = [self gradientView:convertFrame.origin];
        [self.collectionView insertSubview:gradientView atIndex:0];
        self.gradientViewInfos[key] = @{ @"view": gradientView };
    }
}

- (void)dissmiss {
     [UIView animateWithDuration:0.5
      
                      animations:^{
                           self.calendarView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), kCalendarViewH);
                       }
                       completion:^(BOOL finished) {
                           [self dismissViewControllerAnimated:NO completion:nil];
                       }];
}

- (void)clear {
    self.selectFromDate = nil;
    self.selectToDate = nil;
    [self removeAllgradientView];
    [self.collectionView reloadData];
}

- (void)removeAllgradientView {
    for (NSString *key in self.gradientViewInfos.allKeys) {
        UIView *view = self.gradientViewInfos[key][@"view"];
        [view removeFromSuperview];
    }
    [self.gradientViewInfos removeAllObjects];
}

- (NSString *)yyMMDDStringConvertFromDate:(NSDate *)date {
    NSDateFormatter *yyMMDDDateFormatter = [[NSDateFormatter alloc] init];
    yyMMDDDateFormatter.dateFormat = @"yyyy年MM月dd日";
    return [yyMMDDDateFormatter stringFromDate:date];
}

- (NSDate *)dateFormatter:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [dateFormatter dateFromString:dateString];
}

// 转换日期格式 yyyy年MM月 to yyyy年MM月DD日
- (NSDate *)dateYYMMConvertToYYMMDD:(NSDate *)date withDay:(NSInteger)day {
    NSDateFormatter *yyMMDateFormatter = [[NSDateFormatter alloc] init];
    yyMMDateFormatter.dateFormat = @"yyyy年MM月";
    NSString *yyMMString = [yyMMDateFormatter stringFromDate:date];
    NSString *yyMMDDString = [NSString stringWithFormat:@"%@%02ld日", yyMMString, day];
    
    NSDateFormatter *yyMMDDDateFormatter = [[NSDateFormatter alloc] init];
    yyMMDDDateFormatter.dateFormat = @"yyyy年MM月dd日";
    return [yyMMDDDateFormatter dateFromString:yyMMDDString];
}

#pragma mark - getters and  setters
- (UIView *)calendarView {
    if (!_calendarView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), kCalendarViewH)];
        view.backgroundColor = [UIColor whiteColor];
        _calendarView = view;
    }
    return _calendarView;
}

- (NSString *)formatString {
    if (_formatString.length == 0) {
        _formatString = @"yyyy-MM-dd";
    }
    return _formatString;
}

- (NSArray *)itemStringDays {
    return @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
}

- (UIView *)gradientView:(CGPoint)point {
    CGRect frame = CGRectMake(point.x, point.y, self.itemWidth, self.itemWidth);
    UIView *gradientView = [[UIView alloc] initWithFrame:frame];
    gradientView.backgroundColor = kBlueColor;
    gradientView.clipsToBounds = YES;
    gradientView.layer.cornerRadius = 5;
    return gradientView;
}

#pragma mark * init values
- (void)setupInitValues {
    [self reloadDelegateDataSource];
    
    self.gradientViewInfos = [[NSMutableDictionary alloc] init];
    
    // 计算有几个月份
    NSDate *fromDate = [self.dataSource minimumDateForHotelCalendar];
    NSDate *toDate = [self.dataSource maximumDateForHotelCalendar];
    self.months = [NSCalendar monthsFromDate:fromDate toDate:toDate];
    
    // 计算月份的天数
    self.sectionRows = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.months; index++) {
        // 依照 section index 计算日期
        NSDate *fromDate = [self.dataSource minimumDateForHotelCalendar];
        NSDate *sectionDate = [NSCalendar date:fromDate addMonth:index];
        
        // 当月天数
        NSInteger days = [NSCalendar daysFromDate:sectionDate];
        
        // 包含前一个月天数
        NSInteger containPreDays = [NSCalendar weekFromMonthFirstDate:sectionDate];
        
        [self.sectionRows addObject:@(containPreDays + days)];
    }
}

- (void)setupHeaderViews {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderViewH)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderViewH / 2)];
    titleLb.textColor = [UIColor colorWithRed:73.f / 255.f green:73.f / 255.f blue:73.f / 255.f alpha:1];
    titleLb.font = [UIFont boldSystemFontOfSize:15.f];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.text = @"请选择入住离店日期";
    [headerView addSubview:titleLb];
    
    CGFloat btnW = 50.f;
    CGFloat space = (CGRectGetWidth(self.view.frame) - (self.itemStringDays.count * self.itemWidth)) / (self.itemStringDays.count + 1);
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - btnW - space, 0, btnW, kHeaderViewH / 2);
    [cancelBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelBtn];
    
    // 周日...周六
    for (int i = 0; i < self.itemStringDays.count; i++) {
        CGFloat weekX = space + (i * (self.itemWidth + space));
        UILabel *weekLb = [[UILabel alloc] initWithFrame:CGRectMake(weekX, kHeaderViewH / 2, self.itemWidth, kHeaderViewH / 2)];
        weekLb.textColor = itemTexTColor;
        weekLb.font = [UIFont systemFontOfSize:15.f];
        weekLb.textAlignment = NSTextAlignmentCenter;
        weekLb.text = self.itemStringDays[i];
        if (i == 0 || i == 6) {
            weekLb.textColor = kBlueColor;
        }
        [headerView addSubview:weekLb];
    }
    
    // 添加分割线
    for (int i = 1; i <= 2; i++) {
        CGFloat lineY = (kHeaderViewH / 2 * i) - 0.5;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, lineY, CGRectGetWidth(self.view.frame), 0.5)];
        line.backgroundColor = [UIColor colorWithRed:253.f / 255.f green:253.f / 253.f blue:253.f / 255.f alpha:1];
        [headerView addSubview:line];
        [headerView bringSubviewToFront:line];
    }
    
    [self.calendarView addSubview:headerView];
}

- (void)setupFooterViews {
    _footerFinishView = [[UIView alloc] initWithFrame:CGRectMake(0, kCalendarViewH - 50, CGRectGetWidth(self.view.frame), kFooterViewH)];
    _footerFinishView.backgroundColor = [UIColor whiteColor];
    [self.calendarView addSubview:_footerFinishView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5)];
    line.backgroundColor = [UIColor colorWithRed:253.f / 255.f green:253.f / 253.f blue:253.f / 255.f alpha:1];
    [_footerFinishView addSubview:line];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(15, 5, CGRectGetWidth(self.view.frame) - 30, 40);
    [finishBtn setBackgroundColor:kBlueColor];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [finishBtn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.clipsToBounds = YES;
    finishBtn.layer.cornerRadius = 5.f;
    [_footerFinishView addSubview:finishBtn];
}

- (void)setupCollectionViews {
    CGFloat calendarViewWidth = CGRectGetWidth(self.view.frame);
    CGFloat calendarViewHeight = kCalendarViewH - kHeaderViewH - kFooterViewH;
    CGRect collectionViewFrame = CGRectMake(0, kHeaderViewH, calendarViewWidth, calendarViewHeight);
    
    CGFloat items = 7;                  // 一、二 ... 日
    CGFloat itemWidth = self.itemWidth; // 项目的宽度
    CGFloat interitem = items + 1;      // 项目间距数量
    CGFloat collectionViewWidth = CGRectGetWidth(collectionViewFrame);
    CGFloat space = (collectionViewWidth - (items * itemWidth)) / interitem;
    CGFloat headerWidth = calendarViewWidth;
    
    HotelCalendarCollectionViewFlowLayout *flowLayout = [[HotelCalendarCollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 12;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.headerReferenceSize = CGSizeMake(headerWidth, 50);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionRows = self.sectionRows;
    flowLayout.itemWidth = self.itemWidth;
    flowLayout.naviHeight = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[HotelCalendarCell class] forCellWithReuseIdentifier:@"HotelCalendarCell"];
    [self.collectionView registerClass:[HotelCalendarHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HotelCalendarHeaderReusableView"];
    [self.calendarView addSubview:self.collectionView];
    
    // 移动到当天的月份
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

#pragma mark - life cycle
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = [touches anyObject];
    if ([touche.view isEqual:self.view]) {
        [self dissmiss];
    }
}

@end

