# BGCollectionView
BGCollectionView是基于UICollectionView实现上下拉刷新加载数据的瀑布流式（waterFlow）布局。
其中下拉刷新采用的是EGORefreshTableHeaderView。

使用方法：
（1）创建自定义布局
BGCollectionViewFlowLayout *waterFlowLayout = [[BGCollectionViewFlowLayout alloc] init];
    waterFlowLayout.delegate = self;
    //设置列数
    waterFlowLayout.columnNum = 4;
    //设置间距
    waterFlowLayout.itemSpacing = 15;
    //设置组上下左右间距
    waterFlowLayout.bSectionInset = BGEdgeInsetsMake(10, 10, 10, 10);
（2）创建BGCollectionView
   BGCollectionView *waterFlowCollectionView = [[BGCollectionView alloc]initWithFrame:CGRectMake(0, 0, bScreenWidth, bScreenHeight - 64) collectionViewLayout:waterFlowLayout];
    waterFlowCollectionView.pullDownRefreshBlock = ^(UICollectionView *collectionView) {
        //下拉取最新数据
    };
    
    waterFlowCollectionView.pullUpRefreshBlock = ^(UICollectionView *collectionView) {
        //上拉取更多数据
    };
    [self.view addSubview:waterFlowCollectionView];
    
}
（3）实现BGCollectionViewFlowLayoutDelegate代理方法
#pragma mark - BGCollectionViewFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(BGCollectionViewFlowLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //返回指定的高度
    return 100 + (rand() % 100);
}
