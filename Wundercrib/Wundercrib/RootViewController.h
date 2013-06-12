//
//  RootViewController.h
//  Wundercrib
//
//  Created by Sven Straubinger on 12.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "CoreDataController.h"

// This class mainly contains the logic for the NSFetchedResultController, which can be used both from iPhone and iPad
// More UI specific methods are implemented in the corresponding subclasses
@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate>

// Fetched Results Controller Property
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// Method to configure the cell and its properties
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
