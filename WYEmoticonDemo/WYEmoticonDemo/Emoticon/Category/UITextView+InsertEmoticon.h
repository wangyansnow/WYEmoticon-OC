//
//  UITextView+InsertEmoticon.h
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/30.
//  Copyright © 2015年 wangyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYEmoticon;
@interface UITextView (InsertEmoticon)

/// 插入表情
- (void)insertEmoticon:(WYEmoticon *)emoticon;

/// textView的attributedText的属性字符串
- (NSString *)attrStr;

@end