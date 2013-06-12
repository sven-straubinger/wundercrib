//
//  CheckmarkControl.m
//  Wundercrib
//
//  Created by Sven Straubinger on 09.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "CheckmarkControl.h"
#import "UIColor+CorporateDesign.h"

@interface CheckmarkControl()

- (void)addPathToContext:(CGContextRef)context withRectangle:(CGRect)rect radius:(CGFloat)radius;

@end

@implementation CheckmarkControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Clear background 
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
        
    // Redraw control
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Define drawing rects
    CGFloat insetX = 14.0;
    CGFloat insetY = 14.0;
    CGRect drawingRect   = CGRectInset(rect, insetX, insetY);
    
    // Get current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Define radius
    CGFloat radius = 2;
    
    // Get fill path
    [self addPathToContext:context withRectangle:drawingRect radius:radius];
    
    // Set fill color
    [[UIColor grayBoxFill]setFill];
        
    // Fill & stroke the path
    CGContextFillPath(context);
        
    // Set stroke color and width
    CGContextSetStrokeColorWithColor(context, [UIColor grayBoxStroke].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    //for the shadow, save the state then draw the shadow
    CGContextSaveGState(context);
    
    // Get clipping path and clip
    [self addPathToContext:context withRectangle:drawingRect radius:radius];
    CGContextClip(context);
    
    // Get stroke path
    [self addPathToContext:context withRectangle:drawingRect radius:radius];
    
    // Define shadow color
    CGContextSetShadowWithColor(context, CGSizeMake(0,0), 3, [UIColor colorWithWhite:60.0/255.0 alpha:1.0].CGColor);
    
    // Stroke path
    CGContextStrokePath(context);
    
    // Restore state
    CGContextRestoreGState(context);
    
    if(self.selected)
    {
        // Draw checkmark
        UIImage *checkmarkImage = [UIImage imageNamed:@"check.png"];
        CGSize imageSize = checkmarkImage.size;
        CGFloat offsetX = 4.0;
        CGFloat offsetY = 3.0;
        CGFloat midx = CGRectGetMidX(drawingRect);
        CGFloat midy = CGRectGetMidY(drawingRect);
        [checkmarkImage drawAtPoint:CGPointMake(midx - (imageSize.width / 2.0) + offsetX,
                                                midy - (imageSize.height / 2.0)- offsetY)];
    }
}

- (void)addPathToContext:(CGContextRef)context withRectangle:(CGRect)rect radius:(CGFloat)radius
{
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    
    // Define path for fill
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
}

@end
