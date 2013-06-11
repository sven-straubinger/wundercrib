//
//  ItemCell.h
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckmarkControl.h"
#import "InteractionTextField.h"

@class ItemCell;
@protocol ItemCellDelegate <NSObject>

- (void)itemCell:(ItemCell*)cell changedCheckmarkStateTo:(BOOL)selected;
- (void)itemCell:(ItemCell*)cell changedItemTitleTo:(NSString*)title;
- (void)itemCell:(ItemCell *)cell textfieldWillBecomeFirstResponder:(InteractionTextField*)textField;
- (void)itemCell:(ItemCell *)cell textfieldWillResignFirstResponder:(InteractionTextField*)textField;

@end

@interface ItemCell : UITableViewCell

@property (nonatomic, weak) id <ItemCellDelegate> delegate;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, assign) BOOL resolved;

@property (nonatomic, strong, readonly) CheckmarkControl *checkmark;
@property (nonatomic, strong, readonly) InteractionTextField *textfield;

@end
