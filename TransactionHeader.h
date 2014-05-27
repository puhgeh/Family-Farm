//
//  TransactionHeader.h
//  Family Farm
//
//  Created by Axel Trajano on 5/17/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionHeader : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *landAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end
