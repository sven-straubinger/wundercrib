//
//  Item.h
//  Wundercrib
//
//  Created by Sven Straubinger on 11.06.13.
//  Copyright (c) 2013 Zeitfenster GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic) BOOL resolved;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) int32_t displayOrder;

@end
