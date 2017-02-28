//
//  WYEmoticon.m
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/29.
//  Copyright © 2015年 wangyan. All rights reserved.
//  表情模型

#import "WYEmoticon.h"
#import <objc/runtime.h>

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@interface WYEmoticon ()<NSCoding>

/// 所在包得名称
@property (nonatomic, copy) NSString *packageName;
/// 图片名称
@property (nonatomic, copy) NSString *png;
/// 图片的16进制编码
@property (nonatomic, copy) NSString *code;

@end

@implementation WYEmoticon

/// 创建表情按钮
- (instancetype)initWithPackageName:(NSString *)packageName dict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.packageName = packageName;
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

/// 创建一个删除按钮
- (instancetype)initWithPackageName:(NSString *)packageName removeFlag:(BOOL)removeFlag {
    if (self = [super init]) {
        self.packageName = self.packageName;
        self.removeEmoticon = removeFlag;
    }
    return self;
}
+ (instancetype)EmoticonWithPackageName:(NSString *)packageName removeFlag:(BOOL)removeFlag {
    return [[self alloc] initWithPackageName:packageName removeFlag:removeFlag];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.packageName = value;
        return;
    }
    return [super setValue:value forKey:key];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

#pragma mark - setter
- (void)setCode:(NSString *)code {
    _code = code;
    // 1.读取16进制字符串
    NSScanner *scanner = [NSScanner scannerWithString:code];
    // 2.定义一个UInt32的整型接收字符串长度
    unsigned int count = 0;
    [scanner scanHexInt:&count];
//    unsigned long count = strtoul([code UTF8String], 0, 16);
    
    int sym = EMOJI_CODE_TO_SYMBOL((int)count);
    NSLog(@"sym = %d", sym);
    NSString *str = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
    NSLog(@"str = %@", str);

    _imageStr = str;
}

- (void)setPng:(NSString *)png {
    _png = png;
    
    NSString *path = [[[[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticons.bundle"] stringByAppendingPathComponent:self.packageName] stringByAppendingPathComponent:png];
    _image = [UIImage imageWithContentsOfFile:path];
}

#pragma mark - 归档 & 返归档
/// 沙盒存储路径
+ (NSString *)emoticonPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"emoticon.plist"];
}

/// 保存数据到沙河
- (void)archive {
    [NSKeyedArchiver archiveRootObject:self toFile:[WYEmoticon emoticonPath]];
}
/// 从沙盒获取数据
+ (void)unarchive {
    [NSKeyedUnarchiver unarchiveObjectWithFile:[WYEmoticon emoticonPath]];
}

/// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.packageName forKey:@"packageName"];
    [aCoder encodeObject:self.chs forKey:@"chs"];
    [aCoder encodeObject:self.png forKey:@"png"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.imageStr forKey:@"imageStr"];
    [aCoder encodeBool:self.isRemoveEmoticon forKey:@"removeEmoticon"];
    [aCoder encodeInteger:self.times forKey:@"times"];
}

/// 返归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.packageName = [aDecoder decodeObjectForKey:@"packageName"];
    self.chs = [aDecoder decodeObjectForKey:@"chs"];
    self.png = [aDecoder decodeObjectForKey:@"png"];
    self.code = [aDecoder decodeObjectForKey:@"code"];
    self.image = [aDecoder decodeObjectForKey:@"image"];
    self.imageStr = [aDecoder decodeObjectForKey:@"imageStr"];
    self.removeEmoticon = [aDecoder decodeBoolForKey:@"removeEmoticon"];
    self.times = [aDecoder decodeIntegerForKey:@"times"];
    return self;
}

- (NSString *)description
{
    //定义整型数据接收属性个数
    unsigned int propertyCount;
    //1.获取当前对象的所有属性
    objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
    NSMutableString *descriptionString = [NSMutableString string];
    [descriptionString appendFormat:@"<%@: %p>", self.class, self];
    if (propertyCount) {
        [descriptionString appendString:@"{"];
        for (int i = 0; i< propertyCount; i++){
            //2.获取对象的一个属性
            objc_property_t property = properties[i];
            //3.获取属性名称(c语言字符串)
            const char *name = property_getName(property);
            //转换成oc字符串
            NSString *propertyName = [NSString stringWithUTF8String:name];
            if (i == propertyCount - 1) {
                [descriptionString appendFormat:@"%@ = %@", propertyName, [self valueForKey:propertyName]];
            }else {
                [descriptionString appendFormat:@"%@ = %@, ", propertyName, [self valueForKey:propertyName]];
            }
        }
        [descriptionString appendString:@"}"];
    }
    return descriptionString;
}

@end




















