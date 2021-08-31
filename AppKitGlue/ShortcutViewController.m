//
//  ShortcutViewController.m
//  AppKitGlue
//
//  Created by leungkinkeung on 2021/3/5.
//

#import "ShortcutViewController.h"

@implementation ShortcutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shortcutView.associatedUserDefaultsKey = @"GlobalShortcutKey";
    
    // 假如没初始化过，就初始化快捷键
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"ShortcutDidInitializationKey"] == NO) {
        
        // 默认全局快捷键为：Shift + Control + Command + A
        NSEventModifierFlags modifierFlags  =
        NSEventModifierFlagShift | NSEventModifierFlagControl | NSEventModifierFlagCommand;
        self.shortcutView.shortcutValue     =
        [MASShortcut shortcutWithKeyCode:kVK_ANSI_A modifierFlags:modifierFlags];
        
        [userDefaults setBool:YES forKey:@"ShortcutDidInitializationKey"];
        [userDefaults synchronize];
    }
    
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:self.shortcutView.associatedUserDefaultsKey toAction:^{
        
        [NSNotificationCenter.defaultCenter postNotificationName:@"ShortcutExecutedNotification" object:nil];
    }];
}

@end
