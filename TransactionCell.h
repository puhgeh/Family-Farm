//
//  TransactionCell.h
//  Family Farm
//
//  Created by Axel Trajano on 5/11/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceOffered;
@property (weak, nonatomic) IBOutlet UILabel *landArea;
@property (weak, nonatomic) IBOutlet UILabel *serviceFee;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *transactionDate;
@property (weak, nonatomic) IBOutlet UILabel *notes;

@end
