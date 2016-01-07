//
//  WYEmoticonController.m
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/29.
//  Copyright © 2015年 wangyan. All rights reserved.
//

#import "WYEmoticonController.h"
#import "WYCollectionViewFlowLayout.h"
#import "WYEmoticonCell.h"
#import "WYEmoticonPackage.h"

/// 可重用标识符
static NSString *reuseId = @"emoticonCell";
@interface WYEmoticonController ()<UICollectionViewDataSource, UICollectionViewDelegate>

/// 表情包数组
@property (nonatomic, strong) NSArray *emoticonPackages;

/// 工具栏
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WYEmoticonController

+ (instancetype)emoticonControllerWithEmoticonCallBack:(EmoticonCallBack)emoticonCallBack {
    return [[self alloc] initWithEmoticonCallBack:emoticonCallBack];
}
- (instancetype)initWithEmoticonCallBack:(EmoticonCallBack)emoticonCallBack {
    if (self = [super init]) {
        self.emoticonCallBack = emoticonCallBack;
        self.view.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


/// 设置UI
- (void)setupUI {
    [self prepareCollectionView];
    [self prepareToolbar];
    [self.view addSubview:_collectionView];
    [self.view addSubview:_toolbar];
    
    // 自动布局
    _toolbar.translatesAutoresizingMaskIntoConstraints = false;
    _collectionView.translatesAutoresizingMaskIntoConstraints = false;
    NSDictionary *dict = @{@"toolbar": _toolbar, @"collectionView": _collectionView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[toolbar]-0-|" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-[toolbar]-0-|" options:0 metrics:nil views:dict]];
}

/// 准备collectionView
- (void)prepareCollectionView {
    WYCollectionViewFlowLayout *flowLayout = [[WYCollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册cell
    [_collectionView registerClass:[WYEmoticonCell class] forCellWithReuseIdentifier:reuseId];
}

/// 准备底部工具栏
- (void)prepareToolbar {
    _toolbar = [[UIToolbar alloc] init];
    
    NSMutableArray *arrM = [NSMutableArray array];
    int tag = 0;
    for (NSString *groupName in [WYEmoticonPackage groupNames]) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:groupName style:UIBarButtonItemStylePlain target:self action:@selector(toolbarItemClick:)];
        barItem.tag = tag++;
        [arrM addObject:barItem];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [arrM addObject:flexibleItem];
    }
    [arrM removeLastObject];
    _toolbar.items = arrM.copy;
    _toolbar.backgroundColor = [UIColor darkGrayColor];
    _toolbar.tintColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}

/// 监听底部工具栏按钮点击 -- 跳转到对应的表情包
- (void)toolbarItemClick:(UIBarButtonItem *)item {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:item.tag];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.emoticonPackages.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    WYEmoticonPackage *emoticonPackage = self.emoticonPackages[section];
    return emoticonPackage.emoticons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WYEmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    WYEmoticonPackage *emoticonPackage = self.emoticonPackages[indexPath.section];
    cell.emoticon = emoticonPackage.emoticons[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取当前用户点击了哪个cell
    WYEmoticonPackage *emoticonPackage = self.emoticonPackages[indexPath.section];
    WYEmoticon *emoticon = emoticonPackage.emoticons[indexPath.row];
    if (self.emoticonCallBack) {
        self.emoticonCallBack(emoticon);
    }
    // 添加到最爱表情
    if (indexPath.section > 0) {  // 最近中的不用添加
        [WYEmoticonPackage addFavoriteEmoticon:emoticon];
    }
}

#pragma mark - 懒加载
- (NSArray *)emoticonPackages {
    if (_emoticonPackages == nil) {
        _emoticonPackages = [WYEmoticonPackage packages];
    }
    return _emoticonPackages;
}


@end
