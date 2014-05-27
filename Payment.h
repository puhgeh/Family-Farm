//
//  Payment.h
//  Family Farm
//
//  Created by Axel Trajano on 1/25/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface Payment : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Transaction *transaction;

@end
