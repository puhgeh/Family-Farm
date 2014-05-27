//
//  Service.h
//  Axelerate
//
//  Created by Axel Trajano on 5/22/14.
//  Copyright (c) 2014 AxElite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface Service : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * baseCost;
@property (nonatomic, retain) NSNumber * baseLandArea;
@property (nonatomic, retain) NSNumber * defaultPercentage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * unitOfLand;
@property (nonatomic, retain) NSString * unitOfCost;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Service (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
