//
//  HotelCalendarCollectionViewFlowLayout.m
//  HotelCalendar
//
//  Created by Wynter on 2017/10/17.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "HotelCalendarCollectionViewFlowLayout.h"

@interface HotelCalendarCollectionViewFlowLayout ()

@property (assign, nonatomic) CGFloat height;

@end

@implementation HotelCalendarCollectionViewFlowLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        _naviHeight = 64.0;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [noneHeaderSections addIndex:attributes.indexPath.section];
        }
    }
    
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [noneHeaderSections removeIndex:attributes.indexPath.section];
        }
    }

    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        if (attributes) {
            [superArray addObject:attributes];
        }
    }];
    
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection - 1) inSection:attributes.indexPath.section];
            UICollectionViewLayoutAttributes *firstItemAttributes, *lastItemAttributes;
            if (numberOfItemsInSection > 0) {
                firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
                lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
            } else {
                firstItemAttributes = [UICollectionViewLayoutAttributes new];
                CGFloat y = CGRectGetMaxY(attributes.frame) + self.sectionInset.top;
                firstItemAttributes.frame = CGRectMake(0, y, 0, 0);
                lastItemAttributes = firstItemAttributes;
            }
            
            //获取当前header的frame
            CGRect rect = attributes.frame;
            CGFloat offset = self.collectionView.contentOffset.y + _naviHeight;
            CGFloat headerY = firstItemAttributes.frame.origin.y - rect.size.height - self.sectionInset.top;
            CGFloat maxY = MAX(offset, headerY);
            CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - rect.size.height;
            rect.origin.y = MIN(maxY, headerMissingY);
            attributes.frame = rect;
            attributes.zIndex = 7;
        }
    }
    return [superArray copy];
    
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

#pragma mark - override
- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    [super setSectionInset:sectionInset];
    self.minimumInteritemSpacing = sectionInset.left;
}

- (CGSize)collectionViewContentSize {
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    return CGSizeMake(collectionViewWidth, self.height);
}

- (void)prepareLayout {
    [super prepareLayout];
    [self caculateContentSizeHeight];
}

- (void)caculateContentSizeHeight {
    NSInteger rowCount = 0;
    NSInteger lineSpacingCount = 0;
    for (NSNumber *rows in self.sectionRows) {
        rowCount += ceil(rows.floatValue / 7.0);
        lineSpacingCount += ceil(rows.floatValue / 7.0) - 1;
    }
    
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    self.height = (rowCount * self.itemWidth) + (numberOfSections * 50) + (self.minimumLineSpacing * lineSpacingCount);
}

@end
