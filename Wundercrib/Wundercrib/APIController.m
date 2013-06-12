//
//  APIController.m
//  Wundercrib
//
//  Created by Sven Straubinger on 12.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "APIController.h"
#import "CoreDataController.h"
#import "Item.h"

@interface APIController ()

- (NSData*)encodeItem:(Item*)item;
- (Item*)decodeData:(NSData*)data;

@end

@implementation APIController

#pragma mark - Singleton

+ (APIController*)sharedInstance
{
    // Create singleton with blocks
    static APIController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}

#pragma mark - Public Methods

- (void)synchronize
{
    // Send asynchronous request
    
    /*
    /
    /   Here we can start multiple network requests and handle the responses and data in one ore more
    /   NSManagedObject Contexts that can be merged. By using Core Data and a NSFetchedResultsController, every change
    /   to the data set will be forwarded to the table view. 
    /
    /   For serialization, the class "Item" should implement the protocol NSCoding (encodeWithCoder and initWithCoder).
    /   This way we can serialize all items and send to the server. 
    /
    /   Item *item = [CoreDataController sharedInstance]specificItem]; ....
    /   NSData *data = [self encodeItem:item]
    /
    /   NSURL *URL = [NSURL URLWithString:@"http://xxx.xxx.xxx.xxx"];
    /
    /   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
    /                                                          cachePolicy:NSURLRequestReloadIgnoringCacheData
    /                                                      timeoutInterval:60];
    /   [request setHTTPMethod:@"POST"];
    /   [request setHTTPBody:data];
    /
    /   NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    /   [NSURLConnection sendAsynchronousRequest:nil
    /                                      queue:queue
    /                          completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    /                   // Parse and save response to core data
    /               }];
    /
    */
    

}

// PLEASE NOTE:
// The "Item" class does not implement the NSCoding Protocol yet!
// Following methods are just for demonstration purpose.

- (NSData*)encodeItem:(Item*)item
{
    // Archive data
    NSMutableArray *rootObject = [NSMutableArray array];
    [rootObject addObject:item];
    
    return [NSKeyedArchiver archivedDataWithRootObject:rootObject];
}

- (Item*)decodeData:(NSData*)data
{
    // Unarchive data
    NSArray *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if([result count] > 0)
    {
        return [result objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

@end
