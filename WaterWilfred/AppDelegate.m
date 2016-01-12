//
//  AppDelegate.m
//  WaterWilfred
//
//  Created by Kiara Robles on 10/16/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "AppDelegate.h"
#import "WWAUserData.h"
#import <ACPReminder/ACPReminder.h>

#import "JVMenuRootViewController.h"
#import <JVMenuPopover/JVMenuPopover.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupCustomWindow];
    
    return YES;
}

#pragma mark - Custom Accessors

- (JVMenuRootViewController *)rootViewController
{
    if (!_rootViewController)
    {
        _rootViewController = [[JVMenuRootViewController alloc] init];
    }
    
    return _rootViewController;
}


- (JVMenuNavigationController *)navigationController
{
    if (!_navigationController)
    {
        _navigationController = [[JVMenuNavigationController alloc] initWithRootViewController:self.rootViewController transparentNavBar:YES];
    }
    
    return _navigationController;
}


#pragma mark - UIWindow Customization

- (void)setupCustomWindow
{
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"app_bg1.jpg"] imageScaledToWidth:self.window.frame.size.width]];
    
    [self.window makeKeyAndVisible];
    [self.window addSubview:self.navigationController.view];
}

@end
