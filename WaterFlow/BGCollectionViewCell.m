//
//  BGCollectionViewCell.m
//  BGCollectionView
//
//  Created by 杨社兵 on 15/10/25.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import "BGCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation BGCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initSubviews];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initSubviews];
}

- (void)initSubviews
{
    self.picImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    self.picImgView.image = [UIImage imageNamed:@"example.png"];
    [self.contentView addSubview:self.picImgView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.picImgView.frame = CGRectMake(self.picImgView.frame.origin.x, self.picImgView.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
//    self.picImgView.size = self.bounds.size;
    NSURL *url = [NSURL URLWithString:self.urlStr];
    [self.picImgView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
}
@end
