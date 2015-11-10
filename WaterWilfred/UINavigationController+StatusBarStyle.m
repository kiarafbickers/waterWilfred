//
//  UINavigationController+StatusBarStyle.m
//  FoldyPaperWallet
//
//  Created by Kiara Robles on 10/21/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "UINavigationController+StatusBarStyle.h"
#import "UIColor+ColorWithHex.h"

@interface UINavigationController_StatusBarStyle ()

@end

@implementation UINavigationController_StatusBarStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    self.navigationBar.translucent = YES;
    
    return UIStatusBarStyleDefault;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
