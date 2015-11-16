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
#import "WWAUserData.h"



@interface AppDelegate ()

@property (nonatomic, strong) NSArray* messages;
@property (nonatomic, strong) NSArray* timePeriods;//time periods is in seconds we need to change it
@property (nonatomic, assign) BOOL randomMessage;
@property (nonatomic, assign) BOOL circularTimePeriod;
@property (nonatomic, strong) NSString* appDomain; // prevent collision

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"Hey, working?");
    // Override point for customization after application launch.
    
    return YES;
}


//-(void)applicationDidEnterBackground:(UIApplication *)application
//{
//    
//    WWAUserData *notificationFrequency = [[WWAUserData alloc]init];
//    
//    NSUInteger frequency = [notificationFrequency calculateWaterIntake:128];
//    NSLog(@" you will be reminded %lu times",frequency);
//    NSUInteger delay = frequency/2;
//    NSLog(@"you will be reminded every %lu seconds",delay);
//    
//    // Hydrate Notification Code
//    ACPReminder *localNotifications = [ACPReminder sharedManager];
//    
//    //Making circularTimePeriods TRUE when last element is taken, the next one will be first
//    localNotifications.circularTimePeriod = YES;
//    localNotifications.testFlagInSeconds = YES; // default is NO (days), this makes it seconds.
//    
//    localNotifications.messages = @[@"Hey - Time to hydrate!"];
//    localNotifications.timePeriods = @[@(2),@(8)];
//
//    // can find appDomain in project settings / info
//    localNotifications.appDomain = @"com.KiaraRobles.WaterWilfred";
//    
//    //Making randomMessages TRUE will randomly select messages from array/ not what we want need OFF
//    localNotifications.randomMessage = NO;
//    
//    //Making circularTimePeriods TRUE when last element is taken, the next one will be first
//    localNotifications.circularTimePeriod = YES;
//    localNotifications.testFlagInSeconds = YES; // default is NO (days), this makes it seconds.
//    
//    [localNotifications createLocalNotification];
//}
//
//-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    NSLog(@"did receive notification");
//    ACPReminder *localNotifications = [ACPReminder sharedManager];
//    [localNotifications createLocalNotification];
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//   
//    [[ACPReminder sharedManager] checkIfLocalNotificationHasBeenTriggered];
//}


@end
