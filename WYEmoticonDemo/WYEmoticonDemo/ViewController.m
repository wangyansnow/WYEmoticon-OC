//
//  ViewController.m
//  WYEmoticonDemo
//
//  Created by 王俨 on 15/11/29.
//  Copyright © 2015年 wangyan. All rights reserved.
//

#import "ViewController.h"
#import "WYEmoticonController.h"
#import "UITextView+InsertEmoticon.h"

@interface ViewController ()

/// 表情控制器
@property (nonatomic, strong) WYEmoticonController *emoticonController;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.inputView = self.emoticonController.view;
}

#pragma mark - 懒加载
- (WYEmoticonController *)emoticonController {
    if (_emoticonController == nil) {
        _emoticonController = [WYEmoticonController emoticonControllerWithEmoticonCallBack:^(WYEmoticon *emoticon) {
            [self.textView insertEmoticon:emoticon];
        }];
    }
    return _emoticonController;
}

@end
