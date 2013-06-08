//
//  SplashscreenViewController_iPhone.h
//  Wundercrib
//
//  Created by Sven Straubinger on 08.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SplashscreenViewController_iPhone;
@protocol SplashscreenViewControllerDelegate <NSObject>

- (void)splashscreenFinishedAnimation:(SplashscreenViewController_iPhone*)splashscreen;

@end

@interface SplashscreenViewController_iPhone : UIViewController

@property (nonatomic, weak) id <SplashscreenViewControllerDelegate> delegate;

@end
