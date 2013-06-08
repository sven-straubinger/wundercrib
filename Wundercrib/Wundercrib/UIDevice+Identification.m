//
//  UIDevice+Identification.m
//  Wundercrib
//
//  Created by Sven Straubinger on 08.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "UIDevice+Identification.h"

@implementation UIDevice (Identification)

+ (BOOL)isRetina
{
    BOOL result = NO;
    
    // Get the scale factor 
    if([[UIScreen mainScreen] scale] >= 2.0)
    {
        result = YES;
    }
    
    return result;
}

+ (BOOL)isIPhone4Inch
{
    BOOL result = NO;
    
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    if(screenBounds.size.height > 480)
    {
        result = YES;
    }
    
    return result;
}

@end
