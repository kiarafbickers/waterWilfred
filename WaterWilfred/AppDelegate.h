//
//  AppDelegate.h
//  WaterWilfred
//
//  Created by Kiara Robles on 10/16/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JVMenuRootViewController, JVMenuNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) JVMenuRootViewController *rootViewController;

@property (strong, nonatomic) JVMenuNavigationController *navigationController;

@property (strong, nonatomic) UIWindow *window;

@end

