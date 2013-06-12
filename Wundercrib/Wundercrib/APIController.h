//
//  APIController.h
//  Wundercrib
//
//  Created by Sven Straubinger on 12.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIController : NSObject

+ (APIController*)sharedInstance;
- (void)synchronize;

@end
