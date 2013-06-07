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
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    RootViewController_iPhone *rootVC = [[RootViewController_iPhone alloc]init];

    [self.window setRootViewController:rootVC];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
