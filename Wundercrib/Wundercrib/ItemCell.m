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
        
        // Set the default background color
        UIView *backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        [backgroundView setBackgroundColor:[UIColor redColor]];
        [self setBackgroundView:backgroundView];
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

#pragma mark - Private Methods

@end
