//
//  AppDelegate.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImage+Drawing.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Get image
    UIImage *background = [UIImage imageForNavigationBarBackground];
    
    // Set appearance
    [[UINavigationBar appearance]setBackgroundImage:background forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setBackgroundImage:background forBarMetrics:UIBarMetricsLandscapePhone];
        
    // Device specific implementations are set in AppDelegate_iPhone and AppDelegate_iPad
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"%s",__PRETTY_FUNCTION__);

    // Search for updates, synchronize with Core Data
    [[APIController sharedInstance]synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLog(@"%s",__PRETTY_FUNCTION__);
    
    // Saves changes in the application's managed object context before the application terminates.
    [[CoreDataController sharedInstance] saveContext];
}

@end
