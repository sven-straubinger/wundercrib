//
//  ItemCell.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "ItemCell.h"

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
                
//        // Set the default background color
//        UIView *backgroundView = [[UIView alloc]initWithFrame:self.bounds];
//        [backgroundView setBackgroundColor:[UIColor clearColor]];
//        [self setBackgroundView:backgroundView];
    }
    return self;
}

- (void)layoutSubviews
{
    // Call super
    [super layoutSubviews];
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
    [[UIColor colorWithWhite:250.0/255.0 alpha:1.0]setFill];
    
    CGFloat radius = 5;
    // the rest is pretty much copied from Apples example
    CGFloat minx = CGRectGetMinX(drawingRect), midx = CGRectGetMidX(drawingRect), maxx = CGRectGetMaxX(drawingRect);
    CGFloat miny = CGRectGetMinY(drawingRect), midy = CGRectGetMidY(drawingRect), maxy = CGRectGetMaxY(drawingRect);
    
    //for the shadow, save the state then draw the shadow
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    
    // Define shadow color
    CGContextSetShadowWithColor(context, CGSizeMake(0,0), 3, [UIColor darkGrayColor].CGColor);
    
    // Fill & stroke the path
    CGContextFillPath(context);
}

#pragma mark - Private Methods

@end
