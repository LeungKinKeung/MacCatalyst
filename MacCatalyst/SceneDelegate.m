//
//  SceneDelegate.m
//  MacCatalyst
//
//  Created by leungkinkeung on 2020/12/17.
//

#import "SceneDelegate.h"

#if TARGET_OS_MACCATALYST
#import <AppKit/AppKit.h>
#endif


#if TARGET_OS_MACCATALYST
#import "AppKitGlue.h"
#endif


#if TARGET_OS_MACCATALYST
@interface SceneDelegate () <NSToolbarDelegate>
#else
@interface SceneDelegate ()
#endif

#if TARGET_OS_MACCATALYST
@property (nonatomic, strong) AppKitGlue *appKitGlue;
#endif

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
#if TARGET_OS_MACCATALYST
    UIWindowScene *windowScene  = self.window.windowScene;
    UITitlebar *titlebar        = windowScene.titlebar;
    //titlebar.titleVisibility    = UITitlebarTitleVisibilityHidden;
    
    // 菜单栏
    NSToolbar *toolbar          = [[NSToolbar alloc] initWithIdentifier:@"DefaultToolbar"];
    titlebar.toolbar            = toolbar;
    toolbar.delegate            = self;
    toolbar.displayMode         = NSToolbarDisplayModeIconOnly;
#endif
    
#if TARGET_OS_MACCATALYST
    NSString *plugInsPath       =
    [NSBundle.mainBundle.builtInPlugInsPath stringByAppendingPathComponent:@"AppKitGlue.bundle"];
    NSBundle *plugInsBundle     = [NSBundle bundleWithPath:plugInsPath];
    self.appKitGlue             = [plugInsBundle.principalClass new];
#endif
}

#if TARGET_OS_MACCATALYST
-(NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar{
    return @[@"ToolbarShowOtherSceneItem"];
}

-(NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar{
    return @[@"ToolbarShowOtherSceneItem"];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    
    // 根据item标识返回每个具体的NSToolbarItem对象实例（设置title或image后target需要重新设置，否则出现不能点击的问题）
    NSToolbarItem *toolbarItem  = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    toolbarItem.bordered        = YES;
    
    if ([itemIdentifier isEqualToString:@"ToolbarShowOtherSceneItem"]) {
        toolbarItem.title       = @"Show Other Scene";
        toolbarItem.target      = self;
        toolbarItem.action      = @selector(showOtherScene:);
        
    } else {
        toolbarItem             = nil;
    }
    return toolbarItem;
}

- (void)showOtherScene:(NSToolbarItem *)sender{
    if (@available(iOS 13.0, *)) {
        UIApplication *app      = [UIApplication sharedApplication];
        NSArray *openSessions   = app.openSessions.allObjects;
        for (UISceneSession *session in openSessions) {
            if ([session.configuration.name isEqualToString:@"Other Configuration"]) {
                [app requestSceneSessionActivation:session
                                      userActivity:nil
                                           options:nil
                                      errorHandler:nil];
                return;
            }
        }
        NSUserActivity *userActivity    = [[NSUserActivity alloc] initWithActivityType:@"Other Configuration"];
        [app requestSceneSessionActivation:nil
                              userActivity:userActivity
                                   options:nil
                              errorHandler:nil];
    }
}

#endif






- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
