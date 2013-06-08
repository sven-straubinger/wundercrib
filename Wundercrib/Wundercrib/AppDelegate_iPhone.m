//
//  AppDelegate_iPhone.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "SplashscreenViewController_iPhone.h"
#import "RootViewController_iPhone.h"

@interface AppDelegate_iPhone () <SplashscreenViewControllerDelegate>

@property (nonatomic, strong) UIWindow *splashscreenWindow;

@end

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
    
    // Add second window containing the splashscreen view controller and animations
    self.splashscreenWindow = [[UIWindow alloc]initWithFrame:self.window.bounds];
    [self.splashscreenWindow setHidden:NO];
    [self.splashscreenWindow setWindowLevel:UIWindowLevelNormal];
    
    // Add splash screen view controller to splash screen window
    SplashscreenViewController_iPhone *splash = [[SplashscreenViewController_iPhone alloc]init];
    [splash setDelegate:self];
    [self.splashscreenWindow setRootViewController:splash];
    
    return YES;
}

#pragma mark - Splashscreen View Controller Delegate Methods

- (void)splashscreenFinishedAnimation:(SplashscreenViewController_iPhone *)splashscreen
{
    DLog(@"Finished splashscreen animation");
    
    // Remove splashscreen window from screen
    [self.splashscreenWindow setHidden:YES];
    self.splashscreenWindow = nil;
}

@end
