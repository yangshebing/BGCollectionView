//
//  BGCollectionView.m
//  BGCollectionView
//
//  Created by 杨社兵 on 15/10/25.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import "BGCollectionView.h"
#import "BGCollectionViewCell.h"

@interface BGCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@end

@implementation BGCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self != nil) {
        [self initViews];
        
    }
    return self;
}

- (void)initViews
{
    self.dataList = [NSMutableArray array];
    self.dataSource = self;
    self.delegate = self;
    //    [self registerNib:[UINib nibWithNibName:@"WaterFlowCell" bundle:nil] forCellWithReuseIdentifier:@"waterFlowCell"];
    [self registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:@"bGCollectionViewCell"];
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = UIColorFromHex(0xf5f5f5);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"bGCollectionViewCell";
    BGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.urlStr = self.dataList[indexPath.row];
    
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    FavoriteCollectionViewCell *cell = (FavoriteCollectionViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    //    NSLog(@"点击%ld \ue407 %@",indexPath.row, [self replaceUnicode:[mutavleDataArrays objectAtIndex:indexPath.row]]);
    //
    //    [mutavleDataArrays removeObjectAtIndex:indexPath.item];
    //
    //    [collectionView performBatchUpdates:^{
    //        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    //    } completion:nil];
    //    NSLog(@"%@",[cell subviews]);
}
#pragma mark - UICollectionViewDelegateFlowLayout
//设置组间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 1.0f;
//}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((bScreenWidth - 30 - 33) / 3.0, (bScreenWidth - 30 - 33) / 3.0 + 15);
}


@end
