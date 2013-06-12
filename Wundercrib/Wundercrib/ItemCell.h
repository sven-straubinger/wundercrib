//
//  ItemCell.h
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckmarkControl.h"

@class ItemCell;
@protocol ItemCellDelegate <NSObject>

- (void)itemCell:(ItemCell*)cell changedCheckmarkStateTo:(BOOL)selected;
- (void)itemCell:(ItemCell*)cell changedItemTitleTo:(NSString*)title;
- (void)itemCell:(ItemCell*)cell detectedPanGestureWithRecognizer:(UIPanGestureRecognizer*)recognizer;

@end

@interface ItemCell : UITableViewCell

// Reference to delegate
@property (nonatomic, weak) id <ItemCellDelegate> delegate;

// Variable to determine a Item/Task as resolved or unresolved
@property (nonatomic, assign) BOOL resolved;

// Enable or disable gesture recognizeres
@property (nonatomic, assign) BOOL gestureRecognizersEnabled;
@property (nonatomic, assign) BOOL gestureRecognizersAllowedSimultaneously;

// Subview for checkmark and textfield
@property (nonatomic, strong, readonly) CheckmarkControl *checkmark;
@property (nonatomic, strong, readonly) UITextField *textfield;

@end
