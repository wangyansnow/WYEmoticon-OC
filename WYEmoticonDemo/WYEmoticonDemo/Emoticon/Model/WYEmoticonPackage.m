//
//  WYEmoticonPackage.m
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/29.
//  Copyright © 2015年 wangyan. All rights reserved.
//

#import "WYEmoticonPackage.h"
#import "WYEmoticon.h"
#import <objc/runtime.h>

/// 表情包 [全局使用]
static NSArray *packages;
@interface WYEmoticonPackage ()<NSCoding>
/// 目录名
@property (nonatomic, copy) NSString *packageName;
/// 包名称
@property (nonatomic, copy) NSString *group_name_cn;

@end

@implementation WYEmoticonPackage

- (instancetype)initWithPackageName:(NSString *)packageName groupName:(NSString *)groupName {
    if (self  = [super init]) {
        self.packageName = packageName;
        self.group_name_cn = groupName;
    }
    return self;
}

/// 表情bundle文件主路径
+ (NSString *)bundlePath {
    return [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticons.bundle"];
}

/// 表情包 [全局使用]
+ (NSArray *)packages {
    if (packages == nil) {
        packages = [WYEmoticonPackage loadEmoticonPackages];
    }
    return packages;
}

/// 加载表情包数组
+ (NSArray *)loadEmoticonPackages {
    // 1.获取文件路径
    NSString *path = [[self bundlePath] stringByAppendingPathComponent:@"emoticons.plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *packagesArr = dictionary[@"packages"];
    
    // 2.从沙盒中取出常用的表情数组
    NSMutableArray *arrayM = [NSMutableArray array];
    WYEmoticonPackage *emoticonPackage = [WYEmoticonPackage unarchive];
    if (emoticonPackage) {
        [arrayM addObject:emoticonPackage];
    } else {
        WYEmoticonPackage *recentPackage = [[self alloc] initWithPackageName:@"" groupName:@"最近WY"];
        [arrayM addObject:[recentPackage addBlankEmoticon]];
    }
    
    for (NSDictionary *dict in packagesArr) {
        WYEmoticonPackage *commonPackage = [[[WYEmoticonPackage alloc] initWithPackageName:dict[@"id"] groupName:@""] loadGroup];
        [arrayM addObject:[commonPackage addBlankEmoticon]];
    }
    return arrayM;
}

/// 加载表情数组
- (instancetype)loadGroup {
    NSString *path = [[[WYEmoticonPackage bundlePath] stringByAppendingPathComponent:self.packageName] stringByAppendingPathComponent:@"info.plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    self.group_name_cn = dictionary[@"group_name_cn"];
    NSArray *emoticonsArr = dictionary[@"emoticons"];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dict in emoticonsArr) {
        WYEmoticon *emoticon = [[WYEmoticon alloc] initWithPackageName:self.packageName dict:dict];
        // 添加删除的emoticon
        if (arrM.count > 0 && arrM.count % 21 == 0) {
            [arrM insertObject:[WYEmoticon EmoticonWithPackageName:self.packageName removeFlag:true] atIndex:arrM.count - 1];
        }
        [arrM addObject:emoticon];
    }
    self.emoticons = arrM;
    return self;
}

/// 添加空白按钮
- (instancetype)addBlankEmoticon {
    if (self.emoticons == nil) {
        self.emoticons = [NSMutableArray arrayWithCapacity:21];
        [self.emoticons addObject:[WYEmoticon EmoticonWithPackageName:self.packageName removeFlag:false]];
    }
    int count = self.emoticons.count % 21;
    if (count == 0) {
        return self;
    }
    for (int i = count; i< 20; i++){    // 添加空白按钮
        [self.emoticons addObject:[WYEmoticon EmoticonWithPackageName:self.packageName removeFlag:false]];
    }
    // 添加最后一个删除按钮
    [self.emoticons addObject:[WYEmoticon EmoticonWithPackageName:self.packageName removeFlag:true]];
    return self;
}

/// 添加常用数组
+ (void)addFavoriteEmoticon:(WYEmoticon *)emoticon {
    // 1.获取常用表情包数组
    WYEmoticonPackage *emoticonPackage = packages[0];
    NSMutableArray *emoticonsM = emoticonPackage.emoticons;
    if (emoticon.isRemoveEmoticon) {
        NSLog(@"删除按钮你来捣什么乱");
        return;
    }
    // 2.删除 `删除` 按钮
    [emoticonsM removeLastObject];
    
    // 3.判断表情是否已经存在常用数组中
    if (![emoticonsM containsObject:emoticon]) {  // 不存在则添加
        [emoticonsM addObject:emoticon];
    }
    emoticon.times++;
    NSArray *sortedArr = [emoticonsM sortedArrayUsingComparator:^NSComparisonResult(WYEmoticon *obj1, WYEmoticon *obj2) {
        return [@(obj2.times) compare:@(obj1.times)];
    }];
    emoticonsM = [NSMutableArray arrayWithArray:sortedArr];
    if (emoticonsM.count > 20) {
        [emoticonsM removeLastObject];
    }
    
    // 4.添加删除按钮
    [emoticonsM addObject:[[WYEmoticon alloc] initWithPackageName:@"" removeFlag:true]];
    
    // 5.保存到沙盒中
    emoticonPackage.emoticons = emoticonsM;
    [emoticonPackage archive];
}

#pragma mark - 归档 & 反归档
/// 沙盒路径
+ (NSString *)archivePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"packageEmotion.plist"];
}

/// 保存模型到沙河
- (void)archive {
    [NSKeyedArchiver archiveRootObject:self toFile:[WYEmoticonPackage archivePath]];
}

/// 从沙河中取出模型 [按次数排序]
+ (instancetype)unarchive {
    WYEmoticonPackage *emoticonPackage = [NSKeyedUnarchiver unarchiveObjectWithFile:[WYEmoticonPackage archivePath]];
    NSArray *sortedArr = [emoticonPackage.emoticons sortedArrayUsingComparator:^NSComparisonResult(WYEmoticon *obj1, WYEmoticon *obj2) {
        return [@(obj2.times) compare:@(obj1.times)];
    }];
    emoticonPackage.emoticons = [NSMutableArray arrayWithArray:sortedArr];
    return emoticonPackage;
}

/// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.packageName forKey:@"packageName"];
    [aCoder encodeObject:self.group_name_cn forKey:@"group_name_cn"];
    [aCoder encodeObject:self.emoticons forKey:@"emoticons"];
}

/// 反归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.packageName = [aDecoder decodeObjectForKey:@"packageName"];
    self.group_name_cn = [aDecoder decodeObjectForKey:@"group_name_cn"];
    self.emoticons = [aDecoder decodeObjectForKey:@"emoticons"];
    return self;
}

/// 包名称的集合
+ (NSArray *)groupNames {
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    for (WYEmoticonPackage *emoticonPackage in [WYEmoticonPackage loadEmoticonPackages]) {
        [arrayM addObject:emoticonPackage.group_name_cn];
    }
    return arrayM.copy;
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
















