//
//  SplashscreenViewController_iPhone.m
//  Wundercrib
//
//  Created by Sven Straubinger on 08.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "SplashscreenViewController_iPhone.h"
#import "UIDevice+Identification.h"
#import "UIImage+Refactor.h"

@interface SplashscreenViewController_iPhone ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation SplashscreenViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *splashscreenImage = nil;

    // Set image
    if([UIDevice isIPhone4Inch])
    {
        // Check for iPhone 5 first
        DLog(@"Is iPhone 4 Inch");
        splashscreenImage = [UIImage imageNamed:@"Default-568h.png"];
    }
    else if([UIDevice isRetina])
    {
        // Check for Retina Display
        DLog(@"Is iPhone with Retina Display");
        splashscreenImage = [UIImage imageNamed:@"Default.png"];
    }
    else
    {
        // Must be iPhone up to 3GS with no retina display
        DLog(@"Is iPhone without Retina Display");
        splashscreenImage = [UIImage imageNamed:@"Default.png"];
    }
    
    // Set the splash screen image
    splashscreenImage = [UIImage imageWithCroppedStatusBar:splashscreenImage];
    [self.imageView setImage:splashscreenImage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Animate alpha value
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view setAlpha:0.0];
                     } completion:^(BOOL finished) {

                         // Notifiy delegate
                         if([self.delegate respondsToSelector:@selector(splashscreenFinishedAnimation:)])
                         {
                             [self.delegate splashscreenFinishedAnimation:self];
                         }
                     }];
}

@end
