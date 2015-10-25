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
typedef void (^PullDownRefreshBlock)(BGCollectionView *collectionView);
typedef void (^PullUpRefreshBlock)(BGCollectionView *collectionView);

@interface BGCollectionView : UICollectionView
{
    EGORefreshTableHeaderView *_refreshTableHeaderView;
    BOOL _reloading;
    UIButton *_loadMoreButton;
    UIActivityIndicatorView *_activityView;
    UILabel *_showHintDescLabel;
}

@property (nonatomic, strong)  NSMutableArray *dataList;
@property(nonatomic,copy)PullDownRefreshBlock pullDownRefreshBlock;
@property(nonatomic,copy)PullUpRefreshBlock pullUpRefreshBlock;
@property(nonatomic, assign)BOOL isPullMore;
- (void)pullDownLoadingData;
- (void)stopPullUpLoading;

@end
