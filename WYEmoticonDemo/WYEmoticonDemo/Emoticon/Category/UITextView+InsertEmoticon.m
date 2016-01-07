//
//  UITextView+InsertEmoticon.m
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/30.
//  Copyright © 2015年 wangyan. All rights reserved.
//

#import "UITextView+InsertEmoticon.h"
#import "WYTextAttachment.h"
#import "WYEmoticon.h"

@implementation UITextView (InsertEmoticon)

- (void)insertEmoticon:(WYEmoticon *)emoticon {
    NSString *imageStr = emoticon.imageStr;
    if (imageStr) {
        [self replaceRange:self.selectedTextRange withText:imageStr];
        return;
    }
    // png图片处理
    if (emoticon.image == nil) {
        return;
    }
    WYTextAttachment *attachment = [[WYTextAttachment alloc] init];
    attachment.image = emoticon.image;
    attachment.chs = emoticon.chs;
    
    // 1.对输入图片的高度做处理,保持和字体大小一样
    CGFloat emoticonH = self.font.lineHeight;
    attachment.bounds = CGRectMake(0, -4, emoticonH, emoticonH);
    // 2.获取可变输入文本,并且设置属性
    NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    [strM addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, 1)];
    
    // 3.获取文本框中可变属性
    NSMutableAttributedString *textM = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange lastRange = self.selectedRange;
    NSRange replaceRange = NSMakeRange(lastRange.location + 1, 0);
    [textM replaceCharactersInRange:replaceRange withAttributedString:strM];
    self.attributedText = textM;
    self.selectedRange = replaceRange;
}

- (NSString *)attrStr {
    // 1.获取textView的属性文本
    NSAttributedString *textAttr = self.attributedText;
    NSMutableString *strM = [NSMutableString string];
    
    // 2.因为textView的属性文本是分段存储的,所以遍历该文本
    [textAttr enumerateAttributesInRange:NSMakeRange(0, textAttr.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        // 2.1.如果是图片,字典中会有NSAttachment这个键值对
        WYTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment) {
            [strM appendString:attachment.chs];
        } else {  // 使用range获取字符串(包括emoji也算是字符串)
            NSString *str = [textAttr.string substringWithRange:range];
            [strM appendString:str];
        }
    }];
    return strM;
}

@end
