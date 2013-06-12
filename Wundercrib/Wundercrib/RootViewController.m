//
//  RootViewController.m
//  Wundercrib
//
//  Created by Sven Straubinger on 12.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
	if (![[self fetchedResultsController] performFetch:&error])
    {
		// Update to handle the error appropriately.
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"This is an abstract method and should be overridden in a subclass.");
}

#pragma mark - NSFetchedResultsController - Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
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
    switch(type)
    {
            
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (NSIndexPath*)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    // This method is used to set the allowed index paths
    if(sourceIndexPath.section != proposedDestinationIndexPath.section)
    {
        // Back to the origin index path
        return sourceIndexPath;
    }
    else
    {
        // Set the new index  path
        return proposedDestinationIndexPath;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
