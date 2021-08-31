//
//  AppDelegate.m
//  MacCatalyst
//
//  Created by leungkinkeung on 2020/12/17.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 兼容iOS13之前版本
    if (@available(iOS 13.0, *)) { } else {
        UIStoryboard *storyboard            = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController    = [storyboard instantiateInitialViewController];
        self.window.rootViewController      = viewController;
    }
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    
    NSUserActivity *userActivity    = options.userActivities.anyObject;
    NSString *activityType          = userActivity.activityType;
    UISceneSessionRole role         = connectingSceneSession.role;
    
    if (activityType == nil) {
        activityType                = @"Default Configuration";
        role                        = UIWindowSceneSessionRoleApplication;
    }
    if ([activityType isEqualToString:@"Default Configuration"]) {
        for (UISceneSession *session in application.openSessions) {
            if ([session.configuration.name isEqualToString:@"Default Configuration"]) {
                // 存在重复的主窗口
                return nil;
            }
        }
    }
    return [[UISceneConfiguration alloc] initWithName:activityType sessionRole:role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0)) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
