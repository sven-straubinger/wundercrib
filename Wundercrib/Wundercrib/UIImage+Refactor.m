//
//  UIImage+Refactor.m
//  Wundercrib
//
//  Created by Sven Straubinger on 08.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "UIImage+Refactor.h"

@implementation UIImage (Refactor)

+ (UIImage*)imageWithCroppedStatusBar:(UIImage*)image
{
    // Get size of current image
    CGSize size = [image size];
    
    // Get the device specific scale factor
    CGFloat scale = [[UIScreen mainScreen]scale];

    // Create rectangle that represents the cropped image without status bar
    // Take care of the device specific scale factor
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect rect = CGRectMake(0, 0, size.width * scale, size.height * scale);
    rect.origin.y     = statusBarHeight * scale;
    rect.size.height -= statusBarHeight * scale;
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef
                                                scale:scale
                                          orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

@end
