//
//  RootViewController_iPhoneViewController.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "RootViewController_iPhone.h"
#import "ItemCell.h"
#import "Item.h"
#import "CoreDataController.h"
#import "UIView+FindAndResignFirstResponder.h"

// Class is implementing the NSFetchedResultsControllerDelegate Methods
@interface RootViewController_iPhone () <NSFetchedResultsControllerDelegate, ItemCellDelegate>

// Create strong reference to fetchedResultsController Instance
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// Tap gesture recognizer to resign first responder
@property (nonatomic, strong) UITapGestureRecognizer *oneFingerOneTap;

- (void)addItem;

@end

@implementation RootViewController_iPhone 

// Define cell identifier as constant
NSString *const kCellIdentifier   = @"kCellIdentifier";
NSString *const kHeaderIdentifier = @"kHeaderIdentifier";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set title
    [self setTitle:@"Wundercrib"];
    
    // Register item cell
    [self.tableView registerClass:[ItemCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderIdentifier];
    
    // Remove the default seperators
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // App 'plus' button
    // * INFO * 
    // We don't use a navigation bar button item but a subview to have more control over the style.
    // Since this is an 'Single page app' this won't cause problems, because no view controller is pushed on top.
    CGSize navigationBarSize = self.navigationController.navigationBar.frame.size;
    CGSize buttonSize = CGSizeMake(46, navigationBarSize.height);
        
    // Add navigation bar buttons
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(navigationBarSize.width-buttonSize.width,
                                                                      0,
                                                                      buttonSize.width,
                                                                      buttonSize.height)];
    [plusButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:plusButton];
    
    // Setup image view background
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wood-bg.jpg"]];
    [backgroundView setContentMode:UIViewContentModeTopLeft];
    [self.tableView setBackgroundView:backgroundView];
    
#warning Can be copied to CDC
    // Data Handling
    // Get reference to CoreDataController
    CoreDataController *cdc = [CoreDataController sharedInstance];
    
    //	Create Fetch Request
    NSFetchRequest *fetchRequest = nil;
    fetchRequest = [[NSFetchRequest alloc]init];

    // Define entity description
    NSEntityDescription *entity = nil;
    entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:[cdc managedObjectContext]];
    
    // Set entitiy
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:200];
    
    // Define sort descriptors
    NSSortDescriptor *resolvedSortDescriptor = nil;
    resolvedSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"resolved" ascending:YES];
    
    NSSortDescriptor *orderSortDescriptor = nil;
    orderSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"displayOrder" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[resolvedSortDescriptor, orderSortDescriptor]];
    
    // Create sections for resolved and unresolved items
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:[cdc managedObjectContext]
                                                                         sectionNameKeyPath:@"resolved"
                                                                                  cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    
    // Start fetching
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
#warning Remove -1
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // The app contains two sections, one for open tasks and one for already resolved items/tasks
    int sectionsCount = [[self.fetchedResultsController sections]count];
    return sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

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

#warning REVIEW

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Get item for index path
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Cast cell
    ItemCell *itemCell = (ItemCell*)cell;
    
    // Configure the cell...
    [itemCell.textfield setText:item.title];
    [itemCell setResolved:item.resolved];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    DLog(@"%s",__PRETTY_FUNCTION__);
    
    NSMutableArray *things = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    
    // Grab the item we're moving.
    NSManagedObject *thing = [self.fetchedResultsController objectAtIndexPath:fromIndexPath];
    
    // Remove the object we're moving from the array.
    [things removeObject:thing];
    // Now re-insert it at the destination.
    [things insertObject:thing atIndex:[toIndexPath row]];
    
    // All of the objects are now in their correct order. Update each
    // object's displayOrder field by iterating through the array.
//    int i = 0;
//    for (NSManagedObject *mo in things)
//    {
//        [mo setValue:[NSNumber numberWithInt:i++] forKey:@"displayOrder"];
//    }
    
    things = nil;
    
    [[[CoreDataController sharedInstance]managedObjectContext] save:nil];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return YES;
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
    UITableViewHeaderFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderIdentifier];
    [view.contentView setBackgroundColor:[UIColor clearColor]];
    UIView *background = [[UIView alloc]initWithFrame:view.bounds];
    [background setBackgroundColor:[UIColor clearColor]];
    [view setBackgroundView:background];
    return view;
}


#pragma mark - Private Methods

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:self.tableView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.tableView];
    
    CGFloat diff = fabsf(self.tableView.center.x - recognizer.view.center.x);
    if(diff > 10)
    {
#warning REVIEW
        // Disallow simultanous recognizer
//        [recognizer setDelegate:nil];
    }
    
    // Animate to final positions when pan gesture ended 
    if(recognizer.state == UIGestureRecognizerStateEnded ||
       recognizer.state == UIGestureRecognizerStateCancelled ||
       recognizer.state == UIGestureRecognizerStateFailed)
    {
        // Define threshold
        CGFloat threshold = self.tableView.frame.size.width / 2.7;
        
        if(recognizer.view.center.x > (self.tableView.center.x + threshold))
        {
            // Move cell outside screen
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 // Get frame
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
    }
}

#pragma mark - NSFetchedResultsController - Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    DLog(@"TYPE %d", type);
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
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
    
    // Set the new value (resolved = selected)
    [item setTitle:title];
}

- (void)itemCellDetectedLongPressGesture:(ItemCell *)cell
{
    // Enable editing mode
    [self.tableView setEditing:YES animated:YES];
}

#pragma mark - Private Methods

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

- (void)globallyResignFirstResponder:(UITapGestureRecognizer*)recognizer
{
    DLog(@"%s", __PRETTY_FUNCTION__);    
#warning REMOVE CATEGORY
    [self.tableView findAndResignFirstResponder];
    [self.tableView setEditing:NO animated:YES];
}

#warning NEED THIS SOMEWHERE
//// Remove all gesture recognizers from table view
//for(UIGestureRecognizer *recognizer in self.tableView.gestureRecognizers)
//{
//    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
//    {
//        [self.tableView removeGestureRecognizer:recognizer];
//    }
//}
//self.oneFingerOneTap = nil;

@end
