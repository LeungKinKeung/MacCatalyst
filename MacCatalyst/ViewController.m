//
//  ViewController.m
//  MacCatalyst
//
//  Created by leungkinkeung on 2020/12/17.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIContextMenuInteractionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shortcutExecuted:)
                                               name:@"ShortcutExecutedNotification"
                                             object:nil];
}

- (void)shortcutExecuted:(NSNotification *)notification
{
    [self showAlertWithTitle:@"执行了快捷方式"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"1"];
        if (@available(iOS 13.0, *)) {
            UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
            [cell addInteraction:interaction];
        }
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row = %ld",indexPath.row];
    
    return cell;
}

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location API_AVAILABLE(ios(13.0)) {
    return [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        
        NSMutableArray <UIMenuElement *>*children = NSMutableArray.new;
        
        [children addObject:[UIAction actionWithTitle:@"菜单项1" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            [self showAlertWithTitle:@"点击了菜单项1"];
        }]];
        
        [children addObject:[UICommand commandWithTitle:@"菜单项2" image:nil action:@selector(menuItem2Clicked:) propertyList:nil]];
        
        return [UIMenu menuWithTitle:@"Menu" children:children];
    }];
}

- (void)menuItem2Clicked:(UICommand *)sender API_AVAILABLE(ios(13.0))
{
    // 怎么得到index？我也不知道
    [self showAlertWithTitle:@"点击了菜单项2"];
}

- (void)showAlertWithTitle:(NSString *)title
{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
