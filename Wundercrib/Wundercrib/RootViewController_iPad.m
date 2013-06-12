//
//  RootViewController_iPad.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "RootViewController_iPad.h"

@interface RootViewController_iPad()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation RootViewController_iPad

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Hide image view
    [self.imageView setAlpha:0.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fade in image view
    [UIView animateWithDuration:1.3
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.imageView setAlpha:1.0];
                     } completion:nil];
}

@end
