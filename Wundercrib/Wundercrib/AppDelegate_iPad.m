//
//  AppDelegate_iPad.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "RootViewController_iPad.h"

@implementation AppDelegate_iPad

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    RootViewController_iPad *rootVC = [[RootViewController_iPad alloc]init];
    [self.window setRootViewController:rootVC];

    [self.window makeKeyAndVisible];
    return YES;
}

@end
