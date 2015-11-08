//
//  ViewController.m
//  BGCollectionView
//
//  Created by 杨社兵 on 15/10/25.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import "RootViewController.h"
#import "BGCollectionView.h"
#import "BGCollectionViewFlowLayout.h"
//system
#define bScreenWidth [UIScreen mainScreen].bounds.size.width
#define bScreenHeight [UIScreen mainScreen].bounds.size.height

//user
#define CHANGE_MODEL 1

static const CGFloat delayTiemSecond = 3;

@interface RootViewController () <BGCollectionViewFlowLayoutDelegate>
{
    BGCollectionView *_waterFlowCollectionView;
}
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *tempArr;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"瀑布流式布局";
    self.navigationController.navigationBar.translucent = NO;
    self.dataArr = [NSArray array];
    self.tempArr = [NSArray array];
    [self loadPicturesUrlDataFromPlistFile];
    [self initSubviews];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadPicturesUrlDataFromPlistFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pic_url.plist" ofType:nil];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *spaceArr = [NSMutableArray array];
    NSMutableArray *internalArr = nil;
    for (int i = 0; i < dataArr.count; i++) {
        if (i % 21 == 0) {
            internalArr = [NSMutableArray array];
            [spaceArr addObject:internalArr];
        }
        [internalArr addObject:dataArr[i]];
    }
    
    self.dataArr = spaceArr;
}

- (void)loadNewRefreshData {
    
    if (self.dataArr.count > 0) {
        self.tempArr = self.dataArr[0];
        [_waterFlowCollectionView.dataList removeAllObjects];
        [_waterFlowCollectionView.dataList addObjectsFromArray:self.tempArr];
    }
    if (_waterFlowCollectionView.dataList.count < 21) {
        _waterFlowCollectionView.isPullMore = NO;
    } else {
        _waterFlowCollectionView.isPullMore = YES;
    }

    [_waterFlowCollectionView reloadData];
    [_waterFlowCollectionView pullDownLoadingData];
}

- (void)loadMoreRefreshData {
    if (self.dataArr.count > 0) {
        self.tempArr = self.dataArr[1];
        [_waterFlowCollectionView.dataList addObjectsFromArray:self.tempArr];
    }
    
    if (self.tempArr.count < 21) {
        _waterFlowCollectionView.isPullMore = NO;
    } else {
        _waterFlowCollectionView.isPullMore = YES;
    }

    [_waterFlowCollectionView reloadData];
    [_waterFlowCollectionView stopPullUpLoading];
}

- (void)initSubviews {
#if CHANGE_MODEL
    BGCollectionViewFlowLayout *waterFlowLayout = [[BGCollectionViewFlowLayout alloc] init];
    waterFlowLayout.delegate = self;
    waterFlowLayout.columnNum = 4;
    waterFlowLayout.minimumInteritemSpacing = 15;
    waterFlowLayout.minimumLineSpacing = 8;
    waterFlowLayout.headerReferenceSize = CGSizeMake(bScreenWidth, 0.1);
    waterFlowLayout.footerReferenceSize = CGSizeMake(bScreenWidth, 60);
    waterFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
#else
    UICollectionViewFlowLayout *waterFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    waterFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    waterFlowLayout.sectionInset = UIEdgeInsetsMake(20, 15, 0, 15);
#endif
    
    _waterFlowCollectionView = [[BGCollectionView alloc]initWithFrame:CGRectMake(0, 0, bScreenWidth, bScreenHeight - 64) collectionViewLayout:waterFlowLayout];
    __weak __typeof(self)weakSelf = self;
    _waterFlowCollectionView.pullDownRefreshBlock = ^(UICollectionView *collectionView) {
        [weakSelf performSelector:@selector(loadNewRefreshData) withObject:nil afterDelay:delayTiemSecond];
    };
    
    _waterFlowCollectionView.pullUpRefreshBlock = ^(UICollectionView *collectionView) {
        [weakSelf performSelector:@selector(loadMoreRefreshData) withObject:nil afterDelay:delayTiemSecond];
    };
    
    [self performSelector:@selector(loadNewRefreshData) withObject:nil afterDelay:delayTiemSecond];
    [self.view addSubview:_waterFlowCollectionView];
    
}

#pragma mark - BGCollectionViewFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(BGCollectionViewFlowLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 100 + (rand() % 100);
}

- (void)loadPicturesUrlData
{
    NSArray *dataArr = @[
                         @"http://f.hiphotos.baidu.com/image/pic/item/ac4bd11373f082022707d43e49fbfbedab641b1d.jpg",
                         @"http://e.hiphotos.baidu.com/image/pic/item/c995d143ad4bd113cf55ad3c58afa40f4bfb0527.jpg",
                         @"http://f.hiphotos.baidu.com/image/pic/item/dc54564e9258d109164262aad358ccbf6c814d01.jpg",
                         @"http://b.hiphotos.baidu.com/image/pic/item/562c11dfa9ec8a139a824deef503918fa0ecc020.jpg",
                         @"http://b.hiphotos.baidu.com/image/pic/item/a2cc7cd98d1001e93069507fb90e7bec54e7976c.jpg",
                         @"http://h.hiphotos.baidu.com/image/pic/item/03087bf40ad162d9bdf6831b13dfa9ec8a13cd99.jpg",
                         @"http://c.hiphotos.baidu.com/image/pic/item/2f738bd4b31c8701f3e638eb257f9e2f0708ff6f.jpg",
                         @"http://e.hiphotos.baidu.com/image/pic/item/279759ee3d6d55fbb65d6c286f224f4a20a4dd20.jpg",
                         @"http://b.hiphotos.baidu.com/image/pic/item/8601a18b87d6277fcf69c4392a381f30e924fcbc.jpg",
                         @"http://f.hiphotos.baidu.com/image/pic/item/4034970a304e251f1836f9f2a586c9177e3e53f2.jpg",
                         @"http://g.hiphotos.baidu.com/image/pic/item/d009b3de9c82d158b27244bf820a19d8bd3e42cf.jpg",
                         @"http://d.hiphotos.baidu.com/image/pic/item/d52a2834349b033b1804d9d917ce36d3d539bd20.jpg",
                         @"http://d.hiphotos.baidu.com/image/pic/item/7dd98d1001e939019a56073379ec54e736d19663.jpg",
                         @"http://d.hiphotos.baidu.com/image/pic/item/a2cc7cd98d1001e9aa28c703ba0e7bec54e797a2.jpg",
                         @"http://e.hiphotos.baidu.com/image/pic/item/d000baa1cd11728b4321792fcafcc3cec3fd2caa.jpg",
                         @"http://e.hiphotos.baidu.com/image/pic/item/8d5494eef01f3a29f9d720c39b25bc315c607ca4.jpg",
                         @"http://a.hiphotos.baidu.com/image/pic/item/2fdda3cc7cd98d10b9c1f93c233fb80e7bec90a2.jpg",
                         @"http://c.hiphotos.baidu.com/image/pic/item/00e93901213fb80e118e465834d12f2eb83894e5.jpg",
                         @"http://e.hiphotos.baidu.com/image/pic/item/a6efce1b9d16fdfa2339f2e0b68f8c5494ee7b62.jpg",
                         @"http://e.hiphotos.baidu.com/image/pic/item/7e3e6709c93d70cf6f24f60cfadcd100bba12bd0.jpg",
                         @"http://a.hiphotos.baidu.com/image/pic/item/35a85edf8db1cb1371826c11df54564e93584bcc.jpg",
                         @"http://h.hiphotos.baidu.com/image/pic/item/8c1001e93901213f5779f7d656e736d12f2e9576.jpg",
                         @"http://f.hiphotos.baidu.com/image/pic/item/9825bc315c6034a8c305709cc9134954082376cc.jpg",
                         @"http://e.hiphotos.baidu.com/image/pic/item/cefc1e178a82b9014ecc0b2e718da9773912ef4e.jpg",
                         @"http://h.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc486067ff63bdbb6fd536633de.jpg",
                         @"http://b.hiphotos.baidu.com/image/pic/item/caef76094b36acaf3fa5c0fd7ed98d1001e99c6d.jpg",
                         @"http://a.hiphotos.baidu.com/image/pic/item/9345d688d43f87944c729b22d01b0ef41bd53a29.jpg",
                         @"http://c.hiphotos.baidu.com/image/pic/item/0df431adcbef76095951cc9d2cdda3cc7cd99e5d.jpg",
                         @"http://h.hiphotos.baidu.com/image/pic/item/5366d0160924ab182842ca3937fae6cd7b890b63.jpg",
                         @"http://b.hiphotos.baidu.com/image/pic/item/8ad4b31c8701a18b7ed83e4c9c2f07082838fe86.jpg",
                         @"http://d.hiphotos.baidu.com/image/pic/item/1f178a82b9014a90b571ccb0ab773912b31bee74.jpg",
                         @"http://h.hiphotos.baidu.com/image/pic/item/5fdf8db1cb134954fe727a6a544e9258d1094a54.jpg",
                         @"http://d.hiphotos.baidu.com/image/pic/item/a50f4bfbfbedab6428c0bfc1f536afc379311e04.jpg"
                         ];
    self.dataArr = dataArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
