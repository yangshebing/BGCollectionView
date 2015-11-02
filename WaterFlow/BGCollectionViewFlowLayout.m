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
}

@property (nonatomic, strong) NSMutableDictionary *columnMaxYValueDic;
@property (nonatomic, strong) NSMutableDictionary *cellLayoutInfoDic;

@end

@implementation BGCollectionViewFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    self.columnMaxYValueDic = [NSMutableDictionary dictionary];
    self.cellLayoutInfoDic = [NSMutableDictionary dictionary];
    CGFloat currentColumn = 0;
    _itemWidth = (self.collectionView.frame.size.width - (self.itemSpacing * (self.columnNum + 1)) - (self.bSectionInset.left - self.itemSpacing) * 2) / self.columnNum;
    
    NSIndexPath *indexPath = nil;
    NSInteger numSections = [self.collectionView numberOfSections];
    
    for(NSInteger section = 0; section < numSections; section++)  {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItems; item++){
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat x = self.itemSpacing + (self.itemSpacing + _itemWidth) * currentColumn + (self.bSectionInset.left - self.itemSpacing);
            CGFloat y = [self.columnMaxYValueDic[@(currentColumn)] doubleValue];
            if (item < self.columnNum) {
                y = self.bSectionInset.top;
            }
            CGFloat height = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(x, y, _itemWidth, height);
            y += (height + self.itemSpacing);
            self.columnMaxYValueDic[@(currentColumn)] = @(y);
            currentColumn++;
            if(currentColumn == self.columnNum) currentColumn = 0;
            self.cellLayoutInfoDic[indexPath] = itemAttributes;
        }
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
    
    UICollectionViewLayoutAttributes *headerAtt = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (CGRectIntersectsRect(rect, headerAtt.frame)) {
        [attributesArrs addObject:headerAtt];
    }
    
    
    UICollectionViewLayoutAttributes *footerAtt = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (CGRectIntersectsRect(rect, footerAtt.frame)) {
        [attributesArrs addObject:footerAtt];
    }
    
    return attributesArrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        _footerHeight = attributes.frame.size.height;
        CGFloat maxHeight = [self getMaxHeightFromMaxYValue];
        attributes.frame = CGRectMake(0, maxHeight, attributes.frame.size.width, _footerHeight);
    }
    
    return attributes;
}

- (CGSize) collectionViewContentSize {
    CGFloat maxHeight = [self getMaxHeightFromMaxYValue];
    return CGSizeMake(self.collectionView.frame.size.width, maxHeight + _footerHeight + self.bSectionInset.bottom);
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

#pragma mark - Getter/Setter Method
- (CGFloat)itemWidth
{
    return _itemWidth;
}

@end
