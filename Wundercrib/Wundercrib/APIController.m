//
//  APIController.m
//  Wundercrib
//
//  Created by Sven Straubinger on 12.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import "APIController.h"
#import "CoreDataController.h"

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
}

@end
