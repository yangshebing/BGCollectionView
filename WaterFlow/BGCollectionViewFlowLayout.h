//
//  BGCollectionViewFlowLayout.h
//  BGCollectionView
//
//  Created by 杨社兵 on 15/10/25.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BGCollectionViewFlowLayout;
@protocol BGCollectionViewFlowLayoutDelegate <NSObject>
@required
/**
 *  返回Item高度协议方法
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(BGCollectionViewFlowLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BGCollectionViewFlowLayout : UICollectionViewLayout
/**
 *  列数
 */
@property (nonatomic, assign) NSUInteger columnNum;
/**
 *  Item宽度
 */
@property (nonatomic, assign, readonly) CGFloat itemWidth;
@property (nonatomic, weak) id<BGCollectionViewFlowLayoutDelegate> delegate;
/**
 *  行距
 */
@property (nonatomic) CGFloat minimumLineSpacing;
/**
 *  列距
 */
@property (nonatomic) CGFloat minimumInteritemSpacing;
/**
 *  组头大小
 */
@property (nonatomic) CGSize headerReferenceSize;
/**
 *   组尾大小
 */
@property (nonatomic) CGSize footerReferenceSize;
/**
 *  设置内填充
 */
@property (nonatomic) UIEdgeInsets sectionInset;

@end
