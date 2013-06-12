//
//  CoreDataController.h
//  Wundercrib
//
//  Created by Sven Straubinger on 09.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface CoreDataController : NSObject

+ (CoreDataController*)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (void)createItem;
- (void)deleteItem:(Item*)item;

@end
