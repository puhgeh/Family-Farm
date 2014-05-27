//
//  PaymentType.h
//  Family Farm
//
//  Created by Axel Trajano on 5/22/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Payment;

@interface PaymentType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *payments;
@end

@interface PaymentType (CoreDataGeneratedAccessors)

- (void)addPaymentsObject:(Payment *)value;
- (void)removePaymentsObject:(Payment *)value;
- (void)addPayments:(NSSet *)values;
- (void)removePayments:(NSSet *)values;

@end
