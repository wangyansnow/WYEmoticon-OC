//
//  WYEmoticonController.h
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/29.
//  Copyright © 2015年 wangyan. All rights reserved.
//


#import <UIKit/UIKit.h>

@class WYEmoticon;
typedef void(^EmoticonCallBack)(WYEmoticon *emoticon);

@interface WYEmoticonController : UIViewController

/// 选择完表情后的回调
@property (nonatomic, copy) EmoticonCallBack emoticonCallBack;

+ (instancetype)emoticonControllerWithEmoticonCallBack:(EmoticonCallBack)emoticonCallBack;
- (instancetype)initWithEmoticonCallBack:(EmoticonCallBack)emoticonCallBack;

@end
