//
//  AppKitGlue.m
//  AppKitGlue
//
//  Created by leungkinkeung on 2021/3/4.
//

#import "AppKitGlue.h"
#import <Cocoa/Cocoa.h>

@interface AppKitGlue () <NSApplicationDelegate ,NSWindowDelegate>

@property (nonatomic, strong) NSWindow *mainWindow;
@property (nonatomic, strong) NSStatusItem *statusBarItem;
@property (nonatomic, strong) NSWindowController *shortcutPanel;

@end

@implementation AppKitGlue

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 重置APP代理
        NSApplication.sharedApplication.delegate = self;
        
        // 引用主窗口，一般此时NSApplication.sharedApplication.mainWindow为nil，视具体初始化时机而不同
        if (self.mainWindow == nil) {
            self.mainWindow = NSApplication.sharedApplication.mainWindow;
        }
        
        // 用于防止本对象初始化时机不对导致APP代理被系统重置，假如使用了多窗口且在SceneDelegate里初始化，就不需要此监听
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(applicationDidBecomeActive:)
                                                   name:NSApplicationDidBecomeActiveNotification
                                                 object:nil];
        // 用于获取主窗口
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(windowDidBecomeMain:)
                                                   name:NSWindowDidBecomeMainNotification
                                                 object:nil];
        
        // 状态栏按钮，用于激活应用程序窗口
        NSStatusItem *item  = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
        item.button.action  = @selector(makeKeyAndOrderFrontMainWindow);
        item.button.target  = self;
        item.button.imageScaling = NSImageScaleProportionallyUpOrDown;
        item.button.image   = [NSImage imageNamed:NSImageNameApplicationIcon];
        self.statusBarItem  = item;
        
        [self shortcutPanel];
        
        // 如果要显示快捷键面板，就发出此通知
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(orderFrontShortcutPanel)
                                                   name:@"OrderFrontShortcutPanelNotification"
                                                 object:nil];
    }
    return self;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    NSApplication.sharedApplication.delegate = self;
    
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:NSApplicationDidBecomeActiveNotification
                                                object:nil];
}

- (void)windowDidBecomeMain:(NSNotification *)notification
{
    NSWindow *mainWindow    = NSApplication.sharedApplication.mainWindow;
    if (self.mainWindow != nil || mainWindow == nil) {
        return;
    }
    self.mainWindow         = mainWindow;
    mainWindow.delegate     = self;
    
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:NSWindowDidBecomeMainNotification
                                                object:nil];
}

- (BOOL)windowShouldClose:(NSWindow *)sender
{
    // 主窗口不允许被关闭，只能后台（隐藏）
    if (sender != self.mainWindow) {
        [sender orderOut:nil];
        return NO;
    }
    return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    // 点击程序坞上的应用程序图标时，前置主窗口
    [self makeKeyAndOrderFrontMainWindow];
    return YES;
}

- (void)makeKeyAndOrderFrontMainWindow
{
    NSApplication *app = NSApplication.sharedApplication;
    if (app.isHidden) {
        [app unhide:nil];
    }
    if (app.isActive == NO) {
        // 激活窗口，否则窗口会出现无法响应事件的问题
        [app activateIgnoringOtherApps:YES];
        [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateAllWindows];
    }
    // 主窗口前置
    [self.mainWindow makeKeyAndOrderFront:nil];
}

- (NSWindowController *)shortcutPanel
{
    if (_shortcutPanel == nil) {
        NSString *plugInsPath       =
        [NSBundle.mainBundle.builtInPlugInsPath stringByAppendingPathComponent:@"AppKitGlue.bundle"];
        NSBundle *plugInsBundle     = [NSBundle bundleWithPath:plugInsPath];
        NSStoryboard *storyboard    =
        [NSStoryboard storyboardWithName:@"ShortcutPanel" bundle:plugInsBundle];
        NSWindowController *windowController = [storyboard instantiateInitialController];
        NSWindow *window            = windowController.window;
        [window standardWindowButton:NSWindowMiniaturizeButton].hidden  = YES;
        [window standardWindowButton:NSWindowZoomButton].hidden         = YES;
        window.movableByWindowBackground                                = YES;
        window.titlebarAppearsTransparent                               = YES;
        window.styleMask            |= NSWindowStyleMaskFullSizeContentView;
        window.collectionBehavior   |= NSWindowCollectionBehaviorFullScreenNone;
        window.title                = @"Shortcut";
        _shortcutPanel              = windowController;
    }
    return _shortcutPanel;
}

- (void)orderFrontShortcutPanel
{
    [self.shortcutPanel showWindow:nil];
}


@end
