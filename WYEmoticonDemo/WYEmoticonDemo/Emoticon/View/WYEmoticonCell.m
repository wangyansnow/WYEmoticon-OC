//
//  WYEmoticonCell.m
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/29.
//  Copyright © 2015年 wangyan. All rights reserved.
//

#import "WYEmoticonCell.h"
#import "WYEmoticon.h"

@interface WYEmoticonCell ()

/// 表情按钮
@property (nonatomic, strong) UIButton *emoticonBtn;

@end

@implementation WYEmoticonCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _emoticonBtn = [[UIButton alloc] init];
    _emoticonBtn.frame = CGRectInset(self.contentView.bounds, 4, 4);
    [self.contentView addSubview:_emoticonBtn];
    // 禁止按钮和用户交互
    _emoticonBtn.userInteractionEnabled = NO;
    // 设置按钮标题文字的大小
    _emoticonBtn.titleLabel.font = [UIFont systemFontOfSize:32];
    
    _emoticonBtn.backgroundColor = [UIColor orangeColor];
}

- (void)setEmoticon:(WYEmoticon *)emoticon {
    _emoticon = emoticon;
    
    [_emoticonBtn setImage:emoticon.image forState:UIControlStateNormal];
    [_emoticonBtn setTitle:emoticon.imageStr forState:UIControlStateNormal];
    if (emoticon.isRemoveEmoticon) {
        [_emoticonBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [_emoticonBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateNormal];
    }
}


@end
