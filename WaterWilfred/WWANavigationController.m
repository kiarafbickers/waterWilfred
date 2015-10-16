//
//  WWANavigationController.m
//  WaterWilfred
//
//  Created by Kiara Robles on 10/16/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "WWANavigationController.h"

@interface WWANavigationController ()

@end

@implementation WWANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // First draft font choice, more @"iosfonts.com"
    self.title = @"Water Wilfred";
    [self.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:
                                               [UIFont fontWithName:@"EuphemiaUCAS-Italic"
                                                               size:30.0f],
                                     NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
