//
//  AppDelegate_iPhone.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "RootViewController_iPhone.h"

@implementation AppDelegate_iPhone

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Call super
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    // The root view controller is a subclass of UITableViewController
    // Initialize root view controller and wrap it in UINavigationController
    // Thus, we are more flexible to push view controller on top (if necessary)
    RootViewController_iPhone *rootVC = [[RootViewController_iPhone alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:rootVC];
    
    // Set the root view controller
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
