//
//  WYEmoticon.h
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/29.
//  Copyright © 2015年 wangyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYEmoticon : NSObject

/// 表情使用次数【依靠此排序】
@property (nonatomic, assign) NSInteger times;
/// 是否是删除按钮
@property (nonatomic, assign, getter=isRemoveEmoticon) BOOL removeEmoticon;
/// 表情图片
@property (nonatomic, strong) UIImage *image;
/// 显示图片的编码字符串
@property (nonatomic, copy) NSString *imageStr;
/// 文字形式的字符串
@property (nonatomic, copy) NSString *chs;


/// 创建表情按钮
- (instancetype)initWithPackageName:(NSString *)packageName dict:(NSDictionary *)dict;

/// 创建一个删除按钮
- (instancetype)initWithPackageName:(NSString *)packageName removeFlag:(BOOL)removeFlag;
+ (instancetype)EmoticonWithPackageName:(NSString *)packageName removeFlag:(BOOL)removeFlag;

@end
