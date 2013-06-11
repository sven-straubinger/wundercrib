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

#warning REVIEW
//    // Write image to disk
//    NSData* imageData = UIImagePNGRepresentation(image);
//    [imageData writeToFile:path atomically:NO];
    
    return image;
}

@end
