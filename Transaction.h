//
//  Transaction.h
//  Family Farm
//
//  Created by Axel Trajano on 5/22/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Client, Payment, Service, Worker;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * landArea;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * partingPercentage;
@property (nonatomic, retain) NSString * unitOfLand;
@property (nonatomic, retain) Client *client;
@property (nonatomic, retain) NSSet *payments;
@property (nonatomic, retain) Service *service;
@property (nonatomic, retain) NSSet *workers;
@end

@interface Transaction (CoreDataGeneratedAccessors)

- (void)addPaymentsObject:(Payment *)value;
- (void)removePaymentsObject:(Payment *)value;
- (void)addPayments:(NSSet *)values;
- (void)removePayments:(NSSet *)values;

- (void)addWorkersObject:(Worker *)value;
- (void)removeWorkersObject:(Worker *)value;
- (void)addWorkers:(NSSet *)values;
- (void)removeWorkers:(NSSet *)values;

@end
