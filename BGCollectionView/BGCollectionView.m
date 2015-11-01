//
//  BGCollectionView.m
//  BGCollectionView
//
//  Created by 杨社兵 on 15/10/25.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import "BGCollectionView.h"
#import "BGCollectionViewCell.h"

@interface BGCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, EGORefreshTableHeaderDelegate>
{
    UICollectionReusableView *_collectionHeaderView;
    UICollectionReusableView *_collectionFooterView;
}

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

- (void)initViews {
    self.dataList = [NSMutableArray array];
    self.dataSource = self;
    self.delegate = self;
    //    [self registerNib:[UINib nibWithNibName:@"WaterFlowCell" bundle:nil] forCellWithReuseIdentifier:@"waterFlowCell"];
    [self registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:@"bGCollectionViewCell"];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"bGCollectionHeaderView"];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"bGCollectionFooterView"];
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = UIColorFromHex(0xf5f5f5);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"bGCollectionViewCell";
    BGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.urlStr = self.dataList[indexPath.row];
    
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqual:UICollectionElementKindSectionHeader]) {
        _collectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"bGCollectionHeaderView" forIndexPath:indexPath];
        if (!_refreshTableHeaderView) {
            _refreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
            _refreshTableHeaderView.delegate = self;
            [_collectionHeaderView addSubview:_refreshTableHeaderView];
            _refreshTableHeaderView.backgroundColor = [UIColor clearColor];
            [_refreshTableHeaderView refreshLastUpdatedDate];
        }
        
        return _collectionHeaderView;
    } else if([kind isEqual:UICollectionElementKindSectionFooter]) {
        _collectionFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"bGCollectionFooterView" forIndexPath:indexPath];
                if (!_loadMoreButton) {
                    _loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    _loadMoreButton.backgroundColor = [UIColor clearColor];
                    _loadMoreButton.frame = CGRectMake(0, 0, bScreenWidth, 40);
                    UIFont *font1 = [UIFont systemFontOfSize:13.0];
                    [_loadMoreButton addTarget:self action:@selector(loadMoreDataAction) forControlEvents:UIControlEventTouchUpInside];
                    _showHintDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bScreenWidth, 13)];
                    _showHintDescLabel.text = @"正在加载";
                    _showHintDescLabel.font = font1;
                    _showHintDescLabel.textColor = UIColorFromHex(0xaaaaaa);
                    _showHintDescLabel.tag = 2001;
                    [_loadMoreButton addSubview:_showHintDescLabel];
                    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    _activityView.frame = CGRectMake(100, 10, 20, 20);
                    _activityView.hidden = NO;
                    [_activityView startAnimating];
                    [self refreshHintLabelFrame];
                    [_loadMoreButton addSubview:_activityView];
                    [_collectionFooterView addSubview:_loadMoreButton];
                }
        
        return _collectionFooterView;
    }
    
    return _collectionHeaderView;
}

- (void)loadMoreDataAction {
    if (!_isPullMore) {
        return;
    }
    [self loadMoreDataLoadingUI];
  
    if (self.pullUpRefreshBlock) {
        self.pullUpRefreshBlock(self);
    }
}

- (void)refreshHintLabelFrame {
    NSDictionary *showHintLabelAttDic = [NSDictionary dictionaryWithObjectsAndKeys:_showHintDescLabel.font,NSFontAttributeName, nil];
    CGSize showHintLabelRect = [_showHintDescLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesFontLeading attributes:showHintLabelAttDic context:nil].size;
    _showHintDescLabel.size = showHintLabelRect;
    _showHintDescLabel.top = (_loadMoreButton.height - _showHintDescLabel.height) / 2.0;
    _showHintDescLabel.left = (_loadMoreButton.width - _showHintDescLabel.width) / 2.0;
    _activityView.right = _showHintDescLabel.left - 5;
    _activityView.top = (_loadMoreButton.height - _activityView.height) / 2.0;
}

- (void)loadMoreDataLoadingUI {
//    [_loadMoreButton setTitle:@"正在加载中..." forState:UIControlStateNormal];
    _showHintDescLabel.text = @"正在加载中...";
    [self refreshHintLabelFrame];
    [_activityView stopAnimating];
    _loadMoreButton.enabled = NO;
    [_activityView startAnimating];
}

- (void)stopPullUpLoading {
    
    if (self.dataList.count > 0) {
        _loadMoreButton.hidden = NO;
        _loadMoreButton.enabled = YES;
//        [_loadMoreButton setTitle:@"上拉加载更多图片..." forState:UIControlStateNormal];
        _showHintDescLabel.text = @"上拉加载更多图片...";
        [self refreshHintLabelFrame];
        [_activityView stopAnimating];
        if (!_isPullMore) {
            _loadMoreButton.hidden = YES;
        }
    }else {
        _loadMoreButton.hidden = YES;
    }
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource {
    _reloading = YES;
}

- (void)pullDownLoadingData {
    _reloading = NO;
    [_refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    float sub = scrollView.contentSize.height - scrollView.contentOffset.y;
    if (scrollView.height - sub > 60) {
        [self loadMoreDataAction];
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    if (self.pullDownRefreshBlock) {
        self.pullDownRefreshBlock(self);
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section  {
    return CGSizeMake(collectionView.width, 0.1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(collectionView.width, 64);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((bScreenWidth - 30 - 33) / 3.0, (bScreenWidth - 30 - 33) / 3.0 + 15);
}


@end
