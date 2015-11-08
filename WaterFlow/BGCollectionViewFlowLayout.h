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
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(BGCollectionViewFlowLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BGCollectionViewFlowLayout : UICollectionViewLayout
@property (nonatomic, assign) NSUInteger columnNum;
@property (nonatomic, assign, readonly) CGFloat itemWidth;
@property (nonatomic, weak) id<BGCollectionViewFlowLayoutDelegate> delegate;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) UIEdgeInsets sectionInset;

@end
