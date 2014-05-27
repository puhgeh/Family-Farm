//
//  Person.h
//  Family Farm
//
//  Created by Axel Trajano on 1/25/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * contactNumber;

@end
