//
//  WYCollectionViewFlowLayout.m
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/29.
//  Copyright © 2015年 wangyan. All rights reserved.
//

#import "WYCollectionViewFlowLayout.h"

@implementation WYCollectionViewFlowLayout

- (void)prepareLayout {
    CGFloat width = self.collectionView.bounds.size.width / 7;
    self.itemSize = CGSizeMake(width, width);
    // 这里使用0.499 是因为如果使用了0.5在iphone4s 上面只能够显示两排
    CGFloat margin = (self.collectionView.bounds.size.height - 3 * width) * 0.499;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.bounces = false;
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.pagingEnabled = true;
    self.sectionInset = UIEdgeInsetsMake(margin, 0, margin, 0);
}

@end
