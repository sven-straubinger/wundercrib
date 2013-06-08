//
//  RootViewController_iPhoneViewController.m
//  Wundercrib
//
//  Created by Sven Straubinger on 07.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "RootViewController_iPhone.h"
#import "ItemCell.h"

@interface RootViewController_iPhone ()

@end

@implementation RootViewController_iPhone

// Define cell identifier as constant
NSString *const kCellIdentifier = @"kCellIdentifier";

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
    
    // Register item cell
    [self.tableView registerClass:[ItemCell class] forCellReuseIdentifier:kCellIdentifier];
    
    // Hide UINavigationController by default
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // Remove the default seperators
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Setup image view background
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wood-bg.jpg"]];
    [backgroundView setContentMode:UIViewContentModeTopLeft];
    [self.tableView setBackgroundView:backgroundView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // The app contains two sections, one for open tasks and one for already completed tasks
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get cell from queue or create new cell (available since iOS 6)
    ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
 
    // Configure the cell...
    [cell.textLabel setText:@"Hello"];
    
    // Setup pan gesture recognizer
    if(cell.panGestureRecognizer == nil)
    {
#warning Bissi strange
        // Add to cell's UIPanGestureRecognizer
        cell.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                           action:@selector(pan:)];
        [cell addGestureRecognizer:cell.panGestureRecognizer];
    }
    
    if(cell.longPressGestureRecognizer == nil)
    {
#warning Bissi strange
        cell.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                       action:@selector(longPress:)];
        [cell addGestureRecognizer:cell.longPressGestureRecognizer];
    }
    
    // The first cell is special since it is responsible for task creation
    // Move it more to the border
    if([indexPath section] == 0 && [indexPath row] == 0)
    {
        [cell.textLabel setText:@"+"];
        
        // Thus we disable the scroll view touches when working with the first cell
        [cell.panGestureRecognizer setDelegate:nil];
    }
    else
    {
        //    [cell.panGestureRecognizer requireGestureRecognizerToFail:self.tableView.panGestureRecognizer];
        [cell.panGestureRecognizer setDelegate:self];
    }
    
    return cell;
}

#warning TESt

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Define first index path in first section
    NSIndexPath *firstRowFirstSection = [NSIndexPath indexPathForRow:0
                                                           inSection:0];
    
    // Move first cell out of screen
    ItemCell *itemCell = (ItemCell*)[self.tableView cellForRowAtIndexPath:firstRowFirstSection];
    CGRect itemCellFrame = itemCell.frame;
    itemCellFrame.origin.x = -50;
    itemCell.frame = itemCellFrame;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) // Don't move the first row in the first section
        return NO;
    
    return YES;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 10.0;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // Get last section
    if(section == ([self.tableView numberOfSections] - 1))
    {
        return 10.0;
    }
    else
    {
        return 0;
    }
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
        // Disallow simultanous recognizer
        [recognizer setDelegate:nil];
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
                                 // Do nothing yet
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

- (void)longPress:(UILongPressGestureRecognizer*)recognizer
{
    DLog(@"Long press detected");
    // Toggle editing mode
    [recognizer.view removeGestureRecognizer:recognizer];
    [self.tableView setEditing:!self.tableView.editing];
#warning VERY TEMP
    for(UIView *view in self.tableView.subviews)
    {
        for(UIGestureRecognizer *rec in view.gestureRecognizers)
        {
            [view removeGestureRecognizer:rec];
        }
    }
}

@end
