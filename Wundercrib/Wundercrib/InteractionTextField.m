//
//  InteractionTextField.m
//  Wundercrib
//
//  Created by Sven Straubinger on 11.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "InteractionTextField.h"

@implementation InteractionTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderStyle = UITextBorderStyleNone;
        self.textAlignment = NSTextAlignmentLeft;
        [self setFont:[UIFont boldSystemFontOfSize:18.0]];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // Disallow user interaction by default
//        [self setUserInteractionEnabled:NO];

    }
    return self;
}

- (BOOL)becomeFirstResponder
{
//    [self setUserInteractionEnabled:YES];
    
    // Notify delegate
    if([self.delegate respondsToSelector:@selector(interactionTextFieldWillBecomeFirstResponder:)]){
        [self.delegate interactionTextFieldWillBecomeFirstResponder:self];
    }
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
//    [self setUserInteractionEnabled:NO];
    
    // Notify delegate
    if([self.delegate respondsToSelector:@selector(interactionTextFieldWillResignFirstResponder:)]){
        [self.delegate interactionTextFieldWillResignFirstResponder:self];
    }
    
    return [super resignFirstResponder];
}



@end
