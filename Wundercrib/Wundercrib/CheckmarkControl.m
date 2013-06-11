//
//  CheckmarkControl.m
//  Wundercrib
//
//  Created by Sven Straubinger on 09.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "CheckmarkControl.h"
#import "UIColor+CorporateDesign.h"

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
    
    CGFloat radius = 0;
    // the rest is pretty much copied from Apples example
    CGFloat minx = CGRectGetMinX(drawingRect), midx = CGRectGetMidX(drawingRect), maxx = CGRectGetMaxX(drawingRect);
    CGFloat miny = CGRectGetMinY(drawingRect), midy = CGRectGetMidY(drawingRect), maxy = CGRectGetMaxY(drawingRect);
    
    // Define path for fill
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    
    // Set fill color
    [[UIColor grayBoxFill]setFill];
        
    // Fill & stroke the path
    CGContextFillPath(context);
    
    // Define path for stroke
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    
    // Set stroke color and width
    CGContextSetStrokeColorWithColor(context, [UIColor grayBoxStroke].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    // Stroke path
    CGContextStrokePath(context);
    
    if(self.selected)
    {
        // Draw checkmark
        UIImage *checkmarkImage = [UIImage imageNamed:@"check.png"];
        CGSize imageSize = checkmarkImage.size;
        CGFloat offsetX = 4.0;
        CGFloat offsetY = 3.0;
        [checkmarkImage drawAtPoint:CGPointMake(midx - (imageSize.width / 2.0) + offsetX,
                                                midy - (imageSize.height / 2.0)- offsetY)];
    }
}

@end
