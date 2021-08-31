//
//  OtherViewController.m
//  MacCatalyst
//
//  Created by leungkinkeung on 2021/2/22.
//

#import "OtherViewController.h"

@interface OtherViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
