//
//  BGCollectionView.h
//  BGCollectionView
//
//  Created by 杨社兵 on 15/10/25.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@class BGCollectionView;
typedef void (^PullDownRefreshBlock)(UICollectionView *collectionView);
typedef void (^PullUpRefreshBlock)(UICollectionView *collectionView);

@interface BGCollectionView : UICollectionView
/**
 *  数据源
 */
@property (nonatomic, strong)  NSMutableArray *dataList;
/**
 *  下拉刷新
 */
@property (nonatomic,copy)     PullDownRefreshBlock pullDownRefreshBlock;
/**
 *  上拉刷新
 */
@property (nonatomic,copy)     PullUpRefreshBlock pullUpRefreshBlock;
@property (nonatomic, assign)  BOOL isPullMore;
/**
 *  下拉刷新加载完数据，重置UI
 */
- (void)pullDownLoadingData;
/**
 *  上拉刷新加载完数据，重置UI
 */
- (void)stopPullUpLoading;
@end
