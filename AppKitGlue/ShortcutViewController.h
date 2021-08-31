//
//  ShortcutViewController.h
//  AppKitGlue
//
//  Created by leungkinkeung on 2021/3/5.
//

#import <Cocoa/Cocoa.h>
#import <MASShortcut/Shortcut.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShortcutViewController : NSViewController

@property (weak) IBOutlet MASShortcutView *shortcutView;

@end

NS_ASSUME_NONNULL_END
