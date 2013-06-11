//
//  UIView+FindAndResignFirstResponder.m
//  Wundercrib
//
//  Created by Sven Straubinger on 11.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "UIView+FindAndResignFirstResponder.h"

@implementation UIView (FindAndResignFirstResponder)

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder)
    {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews)
    {
        if ([subView findAndResignFirstResponder])
        {
            return YES;            
        }
    }
    return NO;
}

@end
