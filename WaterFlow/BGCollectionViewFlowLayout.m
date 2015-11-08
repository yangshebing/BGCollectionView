//
//  BGCollectionViewFlowLayout.m
//  BGCollectionView
//
//  Created by 杨社兵 on 15/10/25.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import "BGCollectionViewFlowLayout.h"
@interface BGCollectionViewFlowLayout ()
{
    CGFloat _itemWidth;
    CGFloat _footerHeight;
    CGFloat _maxHeight;
}

@property (nonatomic, strong) NSMutableDictionary *columnMaxYValueDic;
@property (nonatomic, strong) NSMutableDictionary *cellLayoutInfoDic;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerLayoutAttributes;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *footerLayoutAttributes;
@end

@implementation BGCollectionViewFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    self.columnMaxYValueDic = [NSMutableDictionary dictionary];
    self.cellLayoutInfoDic = [NSMutableDictionary dictionary];
    self.headerLayoutAttributes = nil;
    self.footerLayoutAttributes = nil;
    if (self.headerReferenceSize.height > 0) {
        self.headerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.headerLayoutAttributes.frame = CGRectMake(0, 0, self.headerReferenceSize.width, self.headerReferenceSize.height);
    }
    
    CGFloat currentColumn = 0;
    _itemWidth = (self.collectionView.frame.size.width - (self.sectionInset.left + self.sectionInset.right) - ((self.columnNum - 1) * self.minimumInteritemSpacing)) / self.columnNum;
    
    NSIndexPath *indexPath = nil;
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++)  {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItems; item++){
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
             UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat x = self.sectionInset.left + (self.minimumInteritemSpacing + self.itemWidth) * currentColumn;
            CGFloat y = [self.columnMaxYValueDic[@(currentColumn)] doubleValue];
            CGFloat height = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(x, self.sectionInset.top + y, _itemWidth, height);
            y += (height + self.minimumLineSpacing);
            self.columnMaxYValueDic[@(currentColumn)] = @(y);
            currentColumn++;
            if(currentColumn == self.columnNum) currentColumn = 0;
            self.cellLayoutInfoDic[indexPath] = itemAttributes;
        }
    }
    
    _maxHeight = [self getMaxHeightFromMaxYValue];
    if (self.footerReferenceSize.height > 0) {
        self.footerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.footerLayoutAttributes.frame = CGRectMake(0, _maxHeight, self.footerReferenceSize.width, self.footerReferenceSize.height);
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArrs = [NSMutableArray array];
    [self.cellLayoutInfoDic enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                         UICollectionViewLayoutAttributes *attributes,
                                                         BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArrs addObject:attributes];
        }
    }];
    
    
    if (self.headerLayoutAttributes && CGRectIntersectsRect(rect, self.headerLayoutAttributes.frame)) {
        [attributesArrs addObject:self.headerLayoutAttributes];
    }
    
    if (self.footerLayoutAttributes && CGRectIntersectsRect(rect, self.footerLayoutAttributes.frame)) {
        [attributesArrs addObject:self.footerLayoutAttributes];
    }
    
    return attributesArrs;
}

- (CGSize) collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, _maxHeight + self.footerReferenceSize.height + self.sectionInset.bottom);
}

- (CGFloat)getMaxHeightFromMaxYValue
{
    NSUInteger currentColumn = 0;
    CGFloat maxHeight = 0;
    while (self.columnNum >= currentColumn) {
        CGFloat heigth = [self.columnMaxYValueDic[@(currentColumn)] doubleValue];
        if (heigth > maxHeight) {
            maxHeight = heigth;
        }
        currentColumn++;
    }
    
    return maxHeight;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

#pragma mark - Getter/Setter Method
- (CGFloat)itemWidth
{
    return _itemWidth;
}

@end
