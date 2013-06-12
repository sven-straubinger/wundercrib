//
//  RootViewController_iPhoneViewController.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "RootViewController_iPhone.h"
#import "ItemCell.h"
#import "UIView+FindAndResignFirstResponder.h"
#import "UIImage+Drawing.h"

// Class is implementing the NSFetchedResultsControllerDelegate Methods
@interface RootViewController_iPhone () <ItemCellDelegate>

@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *addButton;

- (void)edit;
- (void)addItem;
- (void)globallyResignFirstResponder:(UITapGestureRecognizer*)recognizer;

@end

@implementation RootViewController_iPhone 

// Define cell identifier as constant
NSString *const kCellIdentifier   = @"kCellIdentifier";
NSString *const kHeaderIdentifier = @"kHeaderIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set title
    [self setTitle:@"Wundercrib"];
    
    // Remove the default seperators
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Register item cell
    [self.tableView registerClass:[ItemCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderIdentifier];
        
    // Add 'plus' button
    // INFO: We don't use a navigation bar button item but a subview to have more control over the style.
    // Since this is an 'Single page app' this won't cause problems, because no view controller is pushed on top.
    CGSize navigationBarSize = self.navigationController.navigationBar.frame.size;
    CGSize buttonSize = CGSizeMake(46, navigationBarSize.height);

    // Add navigation bar edit button
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 buttonSize.width,
                                                                 buttonSize.height)];
    [self.editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:[UIImage selectedBackground] forState:UIControlStateSelected];
    [self.editButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.editButton];
    
    // Add navigation bar plus button
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(navigationBarSize.width-buttonSize.width,
                                                                0,
                                                                buttonSize.width,
                                                                buttonSize.height)];
    [self.addButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.addButton];
    
    // Setup image view background
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wood-bg.jpg"]];
    [backgroundView setContentMode:UIViewContentModeTopLeft];
    [self.tableView setBackgroundView:backgroundView];
    
    // Get notfication, when keyboard is visible to add a tap gesture recognizer to the background
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove observer
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get cell from queue or create new cell (available since iOS 6)
    ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    // Configure cell
    [self configureCell:cell atIndexPath:indexPath];
    
    // Set cell delegate
    [cell setDelegate:self];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Get item for index path
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Cast cell
    ItemCell *itemCell = (ItemCell*)cell;
    
    // Configure the cell...
    [itemCell.textfield setText:item.title];
    [itemCell setResolved:item.resolved];
    
    if(self.tableView.isEditing)
    {
        [itemCell setGestureRecognizersEnabled:NO];
        [itemCell.checkmark setUserInteractionEnabled:NO];
    }
    else
    {
        [itemCell setGestureRecognizersEnabled:YES];
        [itemCell.checkmark setUserInteractionEnabled:YES];
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Get header view from queue
    UITableViewHeaderFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderIdentifier];

    // Clear the background color
    [view.contentView setBackgroundColor:[UIColor clearColor]];

    // Assign a new background view to remove the current gray view
    UIView *background = [[UIView alloc]initWithFrame:view.bounds];
    
    // We only want a gap betweent the sections -> clear the background color
    [background setBackgroundColor:[UIColor clearColor]];
    [view setBackgroundView:background];

    // Return view
    return view;
}

#pragma mark - Item Cell Delegate Methods

- (void)itemCell:(ItemCell *)cell changedCheckmarkStateTo:(BOOL)selected
{
    // Get mapped index path for cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    // Get item for index path
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Set the new value (resolved = selected)
    [item setResolved:selected];
}

- (void)itemCell:(ItemCell *)cell changedItemTitleTo:(NSString *)title
{
    // Get mapped index path for cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];   
    
    // Get item for index path
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Delete item if length = 0
    if([cell.textfield.text length] == 0)
    {
        // Delete the item from Core Data
        [[CoreDataController sharedInstance]deleteItem:item];
    }
    else
    {
        // Set the new value (resolved = selected)
        [item setTitle:title];
    }
}

- (void)itemCell:(ItemCell *)cell detectedPanGestureWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    // The pan gesture is used to delete a cell by moving it outside the screen on the x-axis
    
    // Calculate translation
    CGPoint translation = [recognizer translationInView:self.tableView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.tableView];
    
    // Calculate current translation 
    CGFloat diff = fabsf(self.tableView.center.x - recognizer.view.center.x);
    if(diff > 15)
    {
        // Disallow simultanous recognizer - this disables the scroll view of the table view
        [cell setGestureRecognizersAllowedSimultaneously:NO];
    }
    
    // Animate to final positions when pan gesture ended
    if(recognizer.state == UIGestureRecognizerStateEnded ||
       recognizer.state == UIGestureRecognizerStateCancelled ||
       recognizer.state == UIGestureRecognizerStateFailed)
    {
        // Define threshold you have to exceed that a cell will be deleted
        CGFloat threshold = self.tableView.frame.size.width / 2.7;
        
        if(recognizer.view.center.x > (self.tableView.center.x + threshold))
        {
            // Move cell outside screen
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 
                                 // Get current frame
                                 CGRect frame = recognizer.view.frame;
                                 // Set new origin, thus the view will be animated outside the window
                                 frame.origin.x = self.tableView.frame.size.width;
                                 recognizer.view.frame = frame;
                             } completion:^(BOOL finished) {
                                 
                                 // Get Item Cell and hide it
                                 ItemCell *itemCell     = (ItemCell*)recognizer.view;
                                 [itemCell setHidden:YES];
                                 
                                 // Get mapped index path
                                 NSIndexPath *indexPath = [self.tableView indexPathForCell:itemCell];
                                 
                                 // Get item
                                 Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
                                 [[CoreDataController sharedInstance]deleteItem:item];
                             }];
        }
        else
        {
            // Move cell back to it's origin position
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 
                                 // Get current center
                                 CGPoint center = recognizer.view.center;
                                 // Set new center
                                 center.x = self.tableView.center.x;
                                 recognizer.view.center = center;
                             } completion:^(BOOL finished) {
                                 // Do nothing yet
                             }];
        }
        
        // Allow recognizer simultaneously
        [cell setGestureRecognizersAllowedSimultaneously:YES];
    }
}

#pragma mark - Private Methods

- (void)edit
{
    // Toggle editing mode
    [self.tableView setEditing:!self.tableView.editing animated:NO];
    
    // Select or deselect edit button
    [self.editButton setSelected:!self.editButton.selected];
    
    // Disable add button
    if(self.tableView.editing)
    {
        [self.addButton setUserInteractionEnabled:NO];
        [self.addButton setAlpha:0.35];
    }
    else
    {
        [self.addButton setUserInteractionEnabled:YES];
        [self.addButton setAlpha:1.0];
    }
    
    // Refresh table view to display changes
    [self.tableView reloadData];
}

- (void)addItem
{
    // Create new item
    [[CoreDataController sharedInstance]createItem];
    
    // Select newest cell
    NSIndexPath *firstCell = [NSIndexPath indexPathForRow:0 inSection:0];
    ItemCell *itemCell     = (ItemCell*)[self.tableView cellForRowAtIndexPath:firstCell];
    
    // Allow user interaction and focus as first responder
    [itemCell.textfield becomeFirstResponder];
}

#pragma mark - Notifications

- (void)keyboardDidShow
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    // Setup Tap gesture recognizer to resign first responder
    UITapGestureRecognizer *oneFingerOneTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                     action:@selector(globallyResignFirstResponder:)];
    [self.tableView addGestureRecognizer:oneFingerOneTap];
}

- (void)keyboardDidHide
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    // Remove all gesture recognizers from table view
    for(UIGestureRecognizer *recognizer in self.tableView.gestureRecognizers)
    {
        if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        {
            [self.tableView removeGestureRecognizer:recognizer];
        }
    }
}

- (void)globallyResignFirstResponder:(UITapGestureRecognizer*)recognizer
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    [self.tableView findAndResignFirstResponder];
}

// Realign the order handle
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(UIView* view in cell.subviews)
    {
        if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"])
        {
            for (UIView * subview in view.subviews)
            {
                if ([subview isKindOfClass: [UIImageView class]])
                {
                    // Set new frame
                    CGRect frame = subview.frame;
                    frame.origin.x -= 15.0;
                    subview.frame = frame;
                }
            }
        }
    }
}

@end
