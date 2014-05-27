//
//  Worker.h
//  Family Farm
//
//  Created by Axel Trajano on 5/17/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Person.h"

@class Transaction;

@interface Worker : Person

@property (nonatomic, retain) NSDecimalNumber * totalAdvanced;
@property (nonatomic, retain) NSDecimalNumber * totalSalary;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Worker (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
