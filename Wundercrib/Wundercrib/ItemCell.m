//
//  ItemCell.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell() <InteractionTextFieldDelegate>

- (void)changeCheckmarkState;

@end

@implementation ItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Set selection style to 'none'
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Remove the text lable's white background color
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        
        // Add checkmark and apply method to change the state on touch up inside
        _checkmark = [[CheckmarkControl alloc]initWithFrame:CGRectZero];
        [self.checkmark addTarget:self
                           action:@selector(changeCheckmarkState)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.checkmark];
        
        // Add textfield
        _textfield = [[InteractionTextField alloc]initWithFrame:CGRectZero];
        [self.textfield setDelegate:self];
        [self.contentView addSubview:self.textfield];
                
        // Set default value
        self.resolved = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    // Call super
    [super layoutSubviews];
    
    // Get bounds and define insets
    CGRect bounds  = self.contentView.bounds;
    CGFloat height = bounds.size.height;
    CGFloat width  = bounds.size.width;
    CGFloat insetX = 15.0;
    CGFloat gap    = 10.0;
    
    // Define and set checkmark control frame
    CGRect checkmarkFrame = CGRectMake(insetX,
                                       0,
                                       height,   // Width = Height
                                       height);
    [self.checkmark setFrame:checkmarkFrame];
    
    // Define and set textfield frame
    CGFloat textfieldHeight = 30.0;  // 30 points is the default textfield height
    CGFloat textfieldInsetY = (height - textfieldHeight) / 2.0;
    CGFloat textfieldOrigin = checkmarkFrame.origin.x + checkmarkFrame.size.width + gap;
    CGRect textfieldFrame   = CGRectMake(textfieldOrigin,
                                         textfieldInsetY,
                                         width - textfieldOrigin - insetX,
                                         textfieldHeight);
    [self.textfield setFrame:textfieldFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    // Define drawing rects
    CGFloat insetX = 10.0;
    CGFloat insetY = 3.0;
    CGRect drawingRect   = CGRectInset(rect, insetX, insetY);
    
    // Get current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set fill color
    if(self.resolved)
    {
        [[UIColor colorWithWhite:250.0/255.0 alpha:0.65]setFill];
    }
    else
    {
        [[UIColor colorWithWhite:250.0/255.0 alpha:1.0]setFill];
    }
    
    CGFloat radius = 5;
    // the rest is pretty much copied from Apples example
    CGFloat minx = CGRectGetMinX(drawingRect), midx = CGRectGetMidX(drawingRect), maxx = CGRectGetMaxX(drawingRect);
    CGFloat miny = CGRectGetMinY(drawingRect), midy = CGRectGetMidY(drawingRect), maxy = CGRectGetMaxY(drawingRect);
    
    // Define path
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    
    //for the shadow, save the state then draw the shadow
    CGContextSaveGState(context);
    
    // Define shadow color
    CGContextSetShadowWithColor(context, CGSizeMake(0,0), 3, [UIColor darkGrayColor].CGColor);
    
    // Fill & stroke the path
    CGContextFillPath(context);
    
    // Restore state
    CGContextRestoreGState(context);
}

#pragma mark - Resolved and 

// The 'resolved' property and the selected state of the checkmark are always corresponding

- (void)setResolved:(BOOL)resolved
{
    // Set new value
    _resolved = resolved;
    
    // Apply changes to checkmark
    [self.checkmark setSelected:resolved];
    
    // Redraw cell
    [self setNeedsDisplay];
}

- (void)changeCheckmarkState
{
    // Toggle selected/resolved state
    [self setResolved:!self.checkmark.selected];
    
    // Notifiy delegate about changes
    if([self.delegate respondsToSelector:@selector(itemCell:changedCheckmarkStateTo:)])
    {
        [self.delegate itemCell:self changedCheckmarkStateTo:self.checkmark.selected];
    }
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Notifiy delegate about changes
    if([self.delegate respondsToSelector:@selector(itemCell:changedItemTitleTo:)])
    {
        [self.delegate itemCell:self changedItemTitleTo:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // This method resigns as first responder and disallows user interaction
    [textField resignFirstResponder];
    return YES;
}

- (void)interactionTextFieldWillBecomeFirstResponder:(InteractionTextField *)textField
{   
    // Notify delegate
    if([self.delegate respondsToSelector:@selector(itemCell:textfieldWillBecomeFirstResponder:)]){
        [self.delegate itemCell:self textfieldWillBecomeFirstResponder:textField];
    }
}

- (void)interactionTextFieldWillResignFirstResponder:(InteractionTextField *)textField
{
    // Notify delegate
    if([self.delegate respondsToSelector:@selector(itemCell:textfieldWillResignFirstResponder:)]){
        [self.delegate itemCell:self textfieldWillResignFirstResponder:textField];
    }
}

@end
