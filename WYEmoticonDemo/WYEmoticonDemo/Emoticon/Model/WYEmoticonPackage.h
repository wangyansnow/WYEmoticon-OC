//
//  WYEmoticonPackage.h
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/29.
//  Copyright © 2015年 wangyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYEmoticon;
@interface WYEmoticonPackage : NSObject

/// 表情数组
@property (nonatomic, strong) NSMutableArray *emoticons;

- (instancetype)initWithPackageName:(NSString *)packageName groupName:(NSString *)groupName;

/// 包名称的集合
+ (NSArray *)groupNames;
/// 添加常用数组
+ (void)addFavoriteEmoticon:(WYEmoticon *)emoticon;
/// 表情包 [全局使用]
+ (NSArray *)packages;

@end
