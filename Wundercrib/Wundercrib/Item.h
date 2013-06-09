//
//  Item.h
//  Wundercrib
//
//  Created by Sven Straubinger on 09.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * resolved;

@end
