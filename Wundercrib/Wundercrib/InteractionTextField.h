//
//  InteractionTextField.h
//  Wundercrib
//
//  Created by Sven Straubinger on 11.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InteractionTextField;
@protocol InteractionTextFieldDelegate <UITextFieldDelegate>

- (void)interactionTextFieldWillBecomeFirstResponder:(InteractionTextField*)textField;
- (void)interactionTextFieldWillResignFirstResponder:(InteractionTextField*)textField;

@end

@interface InteractionTextField : UITextField

@property (nonatomic, weak) id <InteractionTextFieldDelegate> delegate;

@end
