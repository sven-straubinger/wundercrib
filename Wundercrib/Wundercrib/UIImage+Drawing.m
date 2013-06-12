//
//  UIImage+Drawing.m
//  Wundercrib
//
//  Created by Sven Straubinger on 11.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "UIImage+Drawing.h"
#import "UIColor+CorporateDesign.h"

@implementation UIImage (Drawing)

+ (UIImage*)imageForNavigationBarBackground
{
    // Set navigation bar size
    CGSize size = CGSizeMake(320, 44);
    
    // The scale factor to apply to the bitmap.
    // If you specify a value of 0.0, the scale factor is set to the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackBackground].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // Save result to image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)selectedBackground
{
    // Set navigation bar size
    CGSize size = CGSizeMake(46, 44);
    
    // The scale factor to apply to the bitmap.
    // If you specify a value of 0.0, the scale factor is set to the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGGradientRef darkGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0};
    
    UIColor *colorOne = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    
    CGFloat components[8];
    [colorOne getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
    [colorTwo getRed:&components[4] green:&components[5] blue:&components[6] alpha:&components[7]];
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    darkGradient  = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    // Draw gradient
    CGRect currentBounds = CGRectMake(0, 0, size.width, size.height);
    CGPoint topCenter    = CGPointMake(CGRectGetMidX(currentBounds), 0.0);
    CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(context, darkGradient, topCenter, bottomCenter, 0);
    CGGradientRelease(darkGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    // Save result to image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
